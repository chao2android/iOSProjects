package com.iyouxun.ui.activity.setting;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.PlatformDb;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.OpenPlatformBeans;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.BindOpenPlatformRequest;
import com.iyouxun.net.request.DeleteOpenPlatformBindRequest;
import com.iyouxun.net.request.GetUserOauthsRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.open.J_OpenManager;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.SettingOpenPlatformAdapter;
import com.iyouxun.ui.dialog.DeleteBindSelectDialog;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 第三方帐号管理
 * 
 * @ClassName: SettingOpenPlatformActivity
 * @author likai
 * @date 2015-3-11 下午8:16:11
 * 
 */
public class SettingOpenPlatformActivity extends CommTitleActivity {
	private ListView settingOpenPlatformLv;
	private SettingOpenPlatformAdapter adapter;
	private final ArrayList<OpenPlatformBeans> datas = new ArrayList<OpenPlatformBeans>();
	private final String[] platformNames = { "微信", "新浪微博", "腾讯QQ" };
	private final int[] platformOpenTypes = { 1, 2, 3 };
	private OpenPlatformBeans currentBeans = new OpenPlatformBeans();

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("第三方帐号");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_open_platform, null);
	}

	@Override
	protected void initViews() {
		settingOpenPlatformLv = (ListView) findViewById(R.id.settingOpenPlatformLv);

		adapter = new SettingOpenPlatformAdapter(mContext, datas);
		settingOpenPlatformLv.setAdapter(adapter);
		settingOpenPlatformLv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				final OpenPlatformBeans beans = datas.get(position);
				if (beans.getStatus() == 1) {
					// 已绑定，解除绑定
					new DeleteBindSelectDialog(mContext, R.style.dialog).setCallBack(new OnSelectCallBack() {
						@Override
						public void onCallBack(String value1, String value2, String value3) {
							if (value1.equals("1")) {
								deleteOpenUnbind(beans.getOpenType());
							}
						}
					}).show();
				} else {
					currentBeans = beans;
					// 未绑定，去进行绑定
					if (beans.getOpenType() == 3) {
						// QQ
						loginByThirdPlatform(QQ.NAME);
					} else if (beans.getOpenType() == 2) {
						// 新浪微博
						loginByThirdPlatform(SinaWeibo.NAME);
					} else if (beans.getOpenType() == 1) {
						// 微信
						loginByThirdPlatform(Wechat.NAME);
					}
				}
			}
		});

		// 设置平台列表
		for (int i = 0; i < platformNames.length; i++) {
			OpenPlatformBeans bean = new OpenPlatformBeans();
			bean.setOpenType(platformOpenTypes[i]);
			bean.setUid(J_Cache.sLoginUser.uid);
			datas.add(bean);
		}

		showLoading();
		getPlatformInfo();
	}

	/**
	 * 获取平台信息列表
	 * 
	 * @Title: getPlatformInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getPlatformInfo() {
		new GetUserOauthsRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					try {
						JSONArray array = new JSONArray(response.data);
						if (array.length() > 0) {
							for (int i = 0; i < array.length(); i++) {
								JSONObject json = array.optJSONObject(i);
								int openType = json.optInt("type");
								for (int j = 0; j < datas.size(); j++) {
									OpenPlatformBeans bean = datas.get(j);
									if (bean.getOpenType() == openType) {
										bean.setUserId(json.optString("openid"));
										bean.setAccessToken(json.optString("token"));
										bean.setStatus(1);
										datas.set(j, bean);
									}
								}
							}
							adapter.notifyDataSetChanged();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				dismissLoading();
				UtilRequest.showNetworkError(mContext);
			}
		}).execute(J_Cache.sLoginUser.uid);
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void dispatchMessage(final android.os.Message msg) {
			switch (msg.what) {
			case R.id.third_platform_is_valid:// 已经授权
				DialogUtils.dismissDialog();

				Platform pf = (Platform) msg.obj;

				// TODO 检查该openid是否已经绑定
				PlatformDb platformDb = pf.getDb();
				final String userId = platformDb.getUserId();
				currentBeans.setPlatform(pf);
				UtilRequest.vaildBindOpenid(userId, currentBeans.getOpenType(), mHandler, mContext);
				break;
			case NetTaskIDs.TASKID_VAILD_BIND_OPENID:
				// 检查是否绑定过该帐号
				J_Response responseValid = (J_Response) msg.obj;
				if (responseValid.retcode == 1) {
					try {
						JSONObject validObj = new JSONObject(responseValid.data);
						int success = validObj.optInt("success");
						if (success == 0) {
							// 未绑定
							gotoBind(currentBeans.getPlatform());
						} else {
							// 已绑定过其他帐号
							ToastUtil.showToast(mContext, "绑定失败:该账号已绑定其他友寻账号，请重新填写");
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				break;
			default:
				DialogUtils.dismissDialog();
				break;
			}
		};
	};

	/**
	 * @Title: loginByThirdPlatform
	 * @Description: 第三方平台登录
	 * @return void 返回类型
	 * @param @param platform 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void loginByThirdPlatform(final String platform) {
		ShareSDK.initSDK(mContext);
		ShareSDK.getPlatform(platform).getDb().removeAccount();

		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		J_OpenManager.getInstance().login(mHandler, platform, new PlatformActionListener() {
			@Override
			public void onError(Platform arg0, int arg1, Throwable arg2) {
				mHandler.sendEmptyMessage(0x100);
				arg0.removeAccount();
				arg2.printStackTrace();
			}

			@Override
			public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
				Message msg = new Message();
				msg.what = R.id.third_platform_is_valid;
				msg.obj = arg0;
				mHandler.sendMessage(msg);
			}

			@Override
			public void onCancel(Platform arg0, int arg1) {
				mHandler.sendEmptyMessage(0x100);
				arg0.removeAccount();
			}
		});
	}

	/**
	 * 执行绑定操作
	 * 
	 * @return void 返回类型
	 * @param @param pf 平台数据
	 * @author likai
	 * @throws
	 */
	private void gotoBind(Platform pf) {
		showLoading();

		PlatformDb platformDb = pf.getDb();
		final String userId = platformDb.getUserId();
		final String userNick = platformDb.getUserName();
		String userIcon = platformDb.getUserIcon();
		String userGender = platformDb.getUserGender();
		final String pfName = pf.getName();
		String accessToken = platformDb.getToken();
		long expiresIn = platformDb.getExpiresIn();
		if (QQ.NAME.equals(pfName)) {// 微信1 新浪微博2 QQ3
			if (!Util.isBlankString(userIcon)) {
				userIcon = userIcon.substring(0, userIcon.length() - 2) + "100";
				currentBeans.setOpenType(3);
			}
		} else if (SinaWeibo.NAME.equals(pfName)) {
			currentBeans.setOpenType(2);
		} else if (Wechat.NAME.equals(pfName)) {
			currentBeans.setOpenType(1);
		}
		currentBeans.setUserGender(userGender);
		currentBeans.setUserIcon(userIcon);
		currentBeans.setUserId(userId);
		currentBeans.setUserNick(userNick);
		currentBeans.setAccessToken(accessToken);
		currentBeans.setExpiresIn(expiresIn);
		new BindOpenPlatformRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					// 绑定成功
					for (int i = 0; i < datas.size(); i++) {
						OpenPlatformBeans bean = datas.get(i);
						if (bean.getOpenType() == currentBeans.getOpenType()) {
							bean.setStatus(1);// 设置状态为已绑定
							datas.set(i, bean);
						}
					}
					adapter.notifyDataSetChanged();
					dismissLoading();
					ToastUtil.showToast(mContext, "绑定成功");
				} else {
					dismissLoading();
					// 绑定失败
					ToastUtil.showToast(mContext, "绑定失败");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int Error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				dismissLoading();
			}
		}).execute(currentBeans.getUserId(), currentBeans.getOpenType(), currentBeans.getAccessToken(),
				currentBeans.getExpiresIn());
	}

	/**
	 * 解除绑定
	 * 
	 * @Title: deleteOpenUnbind
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void deleteOpenUnbind(final int openType) {
		showLoading();

		new DeleteOpenPlatformBindRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					// 解除成功
					for (int i = 0; i < datas.size(); i++) {
						OpenPlatformBeans bean = datas.get(i);
						if (bean.getOpenType() == openType) {
							bean.setStatus(0);
							ShareSDK.initSDK(mContext);
							switch (openType) {
							case 1:
								// 微信
								ShareSDK.getPlatform(Wechat.NAME).getDb().removeAccount();
								break;
							case 2:
								// 新浪微博
								ShareSDK.getPlatform(SinaWeibo.NAME).getDb().removeAccount();
								break;
							case 3:
								// qq
								ShareSDK.getPlatform(QQ.NAME).getDb().removeAccount();
								break;
							default:
								break;
							}
						}
						datas.set(i, bean);
					}
					adapter.notifyDataSetChanged();
					dismissLoading();
					ToastUtil.showToast(mContext, "解绑成功");
				} else {
					dismissLoading();
					ToastUtil.showToast(mContext, "解绑失败");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int Error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				dismissLoading();
			}
		}).execute(openType);
	}
}
