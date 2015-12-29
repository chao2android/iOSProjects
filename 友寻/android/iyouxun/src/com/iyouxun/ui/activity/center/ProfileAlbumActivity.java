package com.iyouxun.ui.activity.center;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Intent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.GridView;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshGridView;
import com.iyouxun.R;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.GetPhotoListRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.ProfileAlbumListAdapter;
import com.iyouxun.utils.ToastUtil;

/**
 * 相册图片列表
 * 
 * @author likai
 * @date 2015-3-11 下午1:38:46
 * 
 */
public class ProfileAlbumActivity extends CommTitleActivity {
	/** 查看相册用户的uid */
	private long currentUid = 0;
	private PullToRefreshGridView profileAlbumGv;
	private ProfileAlbumListAdapter adapter;
	private final ArrayList<PhotoInfoBean> datas = new ArrayList<PhotoInfoBean>();
	/** 每页加载图片数量 */
	private static int PAGE_NUM = 32;
	/** 用来分页的pid */
	private String PAGE_PID = "0";

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("相册");
		titleLeftButton.setText("个人资料");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_profile_album, null);
	}

	@Override
	protected void initViews() {
		currentUid = getIntent().getLongExtra("uid", 0);

		profileAlbumGv = (PullToRefreshGridView) findViewById(R.id.profileAlbumGv);

		adapter = new ProfileAlbumListAdapter(mContext, datas);
		profileAlbumGv.setAdapter(adapter);
		profileAlbumGv.setMode(Mode.PULL_FROM_END);
		profileAlbumGv.setOnRefreshListener(new OnRefreshListener<GridView>() {
			@Override
			public void onRefresh(PullToRefreshBase<GridView> refreshView) {
				getUserAlbumPhotoInfo();
			}
		});
		profileAlbumGv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				Intent photoViewIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
				photoViewIntent.putExtra("uid", currentUid);
				photoViewIntent.putExtra("index", position);
				photoViewIntent.putExtra("photoInfo", datas);
				photoViewIntent.putExtra("viewType", 2);
				startActivity(photoViewIntent);
			}
		});

		// 获取相册列表
		showLoading();
		getUserAlbumPhotoInfo();

		// 注册监听事件，用于查看大图页面删除图片，该页面进行刷新操作
		J_Cache.pageListener.put("profile_album_activity", this);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		// 移除监听
		J_Cache.pageListener.remove("profile_album_activity");
	}

	/**
	 * 刷新列表
	 * 
	 * @Title: refreshList
	 * @return void 返回类型
	 * @param @param pid 参数类型
	 * @author likai
	 * @throws
	 */
	public void delForRefreshList(String pid) {
		for (int i = 0; i < datas.size(); i++) {
			PhotoInfoBean bean = datas.get(i);
			if (bean.pid.equals(pid)) {
				datas.remove(i);
			}
		}
		adapter.notifyDataSetChanged();
	}

	/**
	 * 通过uid，获取该用户的相册列表
	 * 
	 * @Title: getUserAlbumPhotoInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getUserAlbumPhotoInfo() {
		new GetPhotoListRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					// 加载成功
					try {
						JSONArray allPhotos = new JSONArray(response.data);
						if (allPhotos.length() > 0) {
							for (int i = 0; i < allPhotos.length(); i++) {
								JSONObject json = allPhotos.getJSONObject(i);
								PhotoInfoBean bean = new PhotoInfoBean();
								bean.pid = json.optString("pid");
								bean.url_small = json.optString("pic300");
								bean.url = json.optString("pic800");
								bean.uid = json.optLong("uid");
								bean.nick = json.optString("nick");
								bean.isLike = json.optInt("like");
								datas.add(bean);
								if (allPhotos.length() - 1 == i) {
									PAGE_PID = json.optString("pid");
								}
							}
						} else {
							ToastUtil.showToast(mContext, "没有更多了");
							profileAlbumGv.onRefreshComplete(Mode.DISABLED);
						}
						// 刷新列表
						adapter.notifyDataSetChanged();
						profileAlbumGv.onRefreshComplete();
						dismissLoading();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				dismissLoading();
				ToastUtil.showToast(mContext, getString(R.string.network_error));
			}
		}).execute(currentUid, PAGE_PID, PAGE_NUM);
	}
}
