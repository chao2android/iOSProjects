package com.iyouxun.service;

import java.util.HashMap;

import org.json.JSONObject;

import android.app.IntentService;
import android.content.Intent;

import com.iyouxun.J_Application;
import com.iyouxun.consts.NetConstans;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.UploadNewsInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.managers.J_NetManager.OnLoadingListener;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.CreateNewNewsRequest;
import com.iyouxun.ui.activity.news.AddNewNewsActivity;
import com.iyouxun.ui.activity.news.NewsMainActivity;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * 发布新动态
 * 
 * @ClassName: UploadNewsService
 * @author likai
 * @date 2015-3-7 下午2:36:29
 * 
 */
public class UploadNewsService extends IntentService {
	private UploadNewsInfoBean uploadData;

	public UploadNewsService() {
		super("com.iyouxun.service.UploadNewsService");
	}

	@Override
	protected void onHandleIntent(Intent intent) {
		uploadData = (UploadNewsInfoBean) intent.getSerializableExtra("uploadData");

		// 上传图片-检查是否存在图片
		startUpload();
	}

	/**
	 * 开始执行发布
	 * 
	 * @Title: startUpload
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void startUpload() {
		final String photoPath = getOneUploadPhotoPath();
		if (!Util.isBlankString(photoPath)) {
			// 获取到待上传的图片，首先上传图片
			HashMap<String, String> params = new HashMap<String, String>();
			params.put("uid", SharedPreUtil.getLoginInfo().uid + "'");
			J_NetManager.getInstance().uploadFile(NetConstans.PICTURE_UPLOAD_PHOTO_URL, params, photoPath,
					new OnLoadingListener() {
						@Override
						public void startLoading() {
						}

						@Override
						public void onfinishLoading(String result) {
							try {
								JSONObject json = new JSONObject(result);
								int retcode = json.optInt("retcode");
								if (retcode == 1) {
									// 上传成功
									// 从临时数组中删除该图片
									for (int i = 0; i < uploadData.photos.size(); i++) {
										PhotoInfoBean bean = uploadData.photos.get(i);
										if (bean.picPath.equals(photoPath)) {
											uploadData.photos.get(i).isUploaded = 1;
											uploadData.photos.get(i).pid = json.optJSONObject("data").optString("pid");
											break;
										}
									}
								}
								// 继续执行发布操作
								startUpload();
							} catch (Exception e) {
								e.printStackTrace();
							}
						}

						@Override
						public void onLoading(long total, long current, boolean isUploading) {
						}

						@Override
						public void onError() {
						}
					});
		} else {
			// 开始发布动态
			new CreateNewNewsRequest(new OnDataBack() {
				@Override
				public void onResponse(Object result) {
					J_Response response = (J_Response) result;
					if (response.retcode == 1) {
						// 回调发布页
						String keyAdd = "AddNewNewsActivity";
						if (J_Application.pushActiviy.containsKey(keyAdd)) {
							AddNewNewsActivity addActivity = (AddNewNewsActivity) J_Application.pushActiviy.get(keyAdd);
							addActivity.finish();
						}

						// 调用页面
						String keyMy = "NewsMainActivityRefreshListener_" + J_Cache.sLoginUser.uid;
						if (J_Application.pushActiviy.containsKey(keyMy)) {
							NewsMainActivity activity = (NewsMainActivity) J_Application.pushActiviy.get(keyMy);
							activity.receiveRefresh();
						}
					}
				}

				@Override
				public void onError(HashMap<String, Object> errMap) {
				}
			}).execute(uploadData);
		}
	}

	/**
	 * 获取一个待上传的图片信息
	 * 
	 * @Title: getOneUploadPhoto
	 * @return String 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	private String getOneUploadPhotoPath() {
		String photoPath = "";
		for (int i = 0; i < uploadData.photos.size(); i++) {
			PhotoInfoBean bean = uploadData.photos.get(i);
			if (!Util.isBlankString(bean.picPath) && bean.isUploaded == 0) {
				photoPath = bean.picPath;
				break;
			}
		}
		return photoPath;
	}

}
