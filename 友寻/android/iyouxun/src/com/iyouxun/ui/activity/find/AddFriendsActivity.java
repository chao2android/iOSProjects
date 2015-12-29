package com.iyouxun.ui.activity.find;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
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
import cn.sharesdk.wechat.moments.WechatMoments;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.FindFriendsBean;
import com.iyouxun.data.beans.OpenPlatformBeans;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.BindOpenPlatformRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.open.J_OpenManager;
import com.iyouxun.open.J_ShareParams;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.FriendListAdapter;
import com.iyouxun.ui.dialog.UploadContactsDialog;
import com.iyouxun.ui.dialog.WeChatShareDialog;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.OpenPlatformUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: AddFriendsActivity
 * @Description: 添加好友页面
 * @author donglizhi
 * @date 2015年3月24日 上午10:42:36
 * 
 */
public class AddFriendsActivity extends CommTitleActivity {
	private Context mContext;
	private ListView addFriendsList;// 添加好友的列表
	private FriendListAdapter mAdapter;
	private final short GET_SINA_WEIBO_FRIENDS_ACTION = 123;// 判断动作种类位微博
	/**
	 * @Fields textId : 展示的文本
	 */
	private final int[] textId = { R.string.add_contact_friends, R.string.scan_qr_code_title, R.string.add_wechat_friends,
			R.string.add_weibo_friends, R.string.add_qq_friends };
	/**
	 * @Fields icnId : 展示的图标
	 */
	private final int[] icnId = { R.drawable.icn_contact, R.drawable.icn_qr_code, R.drawable.icn_wechat,
			R.drawable.icn_sina_weibo, R.drawable.icn_qq };
	private final ArrayList<FindFriendsBean> array = new ArrayList<FindFriendsBean>();// 展示的数据
	private UploadContactsDialog dialog;// 上传通讯录对话框
	private boolean updateContact = false; // 更新通讯录

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.str_add_friends);
		titleLeftButton.setText(R.string.str_find);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_add_friends, null);
	}

	@Override
	protected void initViews() {
		mContext = AddFriendsActivity.this;
		updateContact = false;
		addFriendsList = (ListView) findViewById(R.id.add_friends_list);
		dialog = new UploadContactsDialog(mContext, R.style.dialog);
		dialog.setCallBack(callBack);
		for (int i = 0; i < textId.length; i++) {
			FindFriendsBean bean = new FindFriendsBean();
			bean.setTextId(textId[i]);
			bean.setImageId(icnId[i]);
			array.add(bean);
		}
		mAdapter = new FriendListAdapter(mContext, array);
		addFriendsList.setAdapter(mAdapter);
		addFriendsList.setOnItemClickListener(onItemClickListener);
	}

	private final OnSelectCallBack callBack = new OnSelectCallBack() {

		@Override
		public void onCallBack(String value1, String value2, String value3) {
			if ("1".equals(value1)) {
				DialogUtils.showProgressDialog(mContext, getString(R.string.str_waiting));
				UtilRequest.uploadUserContacts(mContext, mHandler);
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_UPLOAD_USER_CONTACTS:
				// 上传联系人
				dialog.dismiss();
				DialogUtils.dismissDialog();
				DialogUtils.showProgressDialog(mContext, getString(R.string.str_waiting));
				UtilRequest.getFriendsNums(J_Cache.sLoginUser.uid + "", 1, 0, mHandler, mContext);
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS:// 好友数量
				int friendsNums = Util.getInteger(msg.obj.toString());
				if (friendsNums > 0) {
					UtilRequest.getFriends(J_Cache.sLoginUser.uid + "", 0, 0, friendsNums, mHandler, mContext);
				} else {
					DialogUtils.dismissDialog();
					if (updateContact) {// 更新过后发现还是没有新好友
						ToastUtil.showToast(mContext, getString(R.string.upload_contact_complete_no_new_friend));
					} else {// 需要更新通讯录邀请新好友
						updateContact = true;
						dialog.show();
						dialog.setAutoUpload(false);
						dialog.setTitleVisiblity(View.GONE);
						dialog.setDesc(getString(R.string.no_firends_should_upload_contact));
						dialog.setBtnText(getString(R.string.upload_now));
					}
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS:// 未注册的好友
				String noRegisteredFriends = msg.obj.toString();
				DialogUtils.dismissDialog();
				Intent intent = new Intent();
				intent.setClass(mContext, ContactActivity.class);
				intent.putExtra(JsonParser.RESPONSE_DATA, noRegisteredFriends);
				startActivity(intent);
				break;
			case R.id.third_platform_is_valid:// 第三方平台已经验证登录
				Platform pf = (Platform) msg.obj;
				if (pf.getName().equals(SinaWeibo.NAME)) {
					getSinaWeiboFriendList(pf, pf.getDb().getUserId());
				} else {
					addFriendByPlatform(pf.getName());
				}
				break;
			}
		};
	};

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			switch (position) {
			case 0:// 添加通讯录好友
				if (J_Cache.sLoginUser.callno_upload == 1) {
					updateContact = false;
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.getFriendsNums(J_Cache.sLoginUser.uid + "", 1, 0, mHandler, mContext);
				} else {
					// 弹出导入通讯录的弹层更新通讯录
					updateContact = true;
					dialog.show();
					dialog.setAutoUpload(false);
					dialog.setTitleVisiblity(View.GONE);
					dialog.setDesc(getString(R.string.add_contact_friends_tip));
					dialog.setBtnText(getString(R.string.find_contact_friends));
				}
				break;
			case 3:// 添加微博好友
				DialogUtils.showProgressDialog(mContext, getString(R.string.str_waiting));
				J_OpenManager.getInstance().login(mHandler, SinaWeibo.NAME, actionListener);
				break;
			case 4:// 添加QQ好友
				loginByThirdPlatform(QQ.NAME);
				break;
			case 2:// 添加微信好友
					// 弹出上传图片dialog
				new WeChatShareDialog(mContext, R.style.dialog).setCallBack(new DialogUtils.OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if (value1.equals("1")) {
							// 微信好友
							loginByThirdPlatform(Wechat.NAME);
						} else if (value1.equals("2")) {
							// 微信朋友圈
							loginByThirdPlatform(WechatMoments.NAME);
						}
					}
				}).show();
				break;

			case 1:// 扫一扫
				Intent intent = new Intent(mContext, CaptureActivity.class);
				startActivity(intent);
				break;
			}
		}

	};

	/**
	 * @Title: getSinaWeiboFriendList
	 * @Description: 获得新浪微博好友列表
	 * @return void 返回类型
	 * @param @param sinaWeibo
	 * @param @param userid 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void getSinaWeiboFriendList(Platform sinaWeibo, String userid) {
		String url = "https://api.weibo.com/2/friendships/friends/bilateral.json";
		String method = "GET";

		HashMap<String, Object> values = new HashMap<String, Object>();
		values.put("uid", userid);
		values.put("count", 100);
		values.put("page", 1);
		sinaWeibo.customerProtocol(url, method, GET_SINA_WEIBO_FRIENDS_ACTION, values, null);
	}

	/**
	 * @Title: addFriendByPlatform
	 * @Description:要求 qq 微信好友
	 * @return void 返回类型
	 * @param @param plaform 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void addFriendByPlatform(String platform) {
		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		J_ShareParams params = OpenPlatformUtil.inviteNewFriend("");
		if (WechatMoments.NAME.equals(platform)) {
			params.setTitle(params.getTitle() + "\n" + params.getText());
		}
		J_OpenManager.getInstance().share(this, platform, params, new PlatformActionListener() {

			@Override
			public void onError(Platform arg0, int arg1, Throwable arg2) {
				if (!arg0.isClientValid() && (arg0.getName().equals(WechatMoments.NAME) || arg0.getName().equals(Wechat.NAME))) {
					mHandler.post(new Runnable() {

						@Override
						public void run() {
							ToastUtil.showToast(mContext, "目前您的微信版本过低或未安装微信，需要安装微信才能使用");
						}
					});
				} else {
					mHandler.post(new Runnable() {

						@Override
						public void run() {
							ToastUtil.showToast(mContext, getString(R.string.platform_send_fail));
						}
					});
				}
				DialogUtils.dismissDialog();
			}

			@Override
			public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
				ToastUtil.showToast(mContext, getString(R.string.platform_send_success));
				DialogUtils.dismissDialog();
			}

			@Override
			public void onCancel(Platform arg0, int arg1) {
				ToastUtil.showToast(mContext, getString(R.string.platform_send_cancel));
				DialogUtils.dismissDialog();
			}
		}, true);
	}

	/**
	 * @Fields actionListener : 监听授权状态获得第三方平台用户信息
	 */
	private final PlatformActionListener actionListener = new PlatformActionListener() {
		@Override
		public void onError(Platform arg0, final int arg1, Throwable arg2) {
			DialogUtils.dismissDialog();
			mHandler.post(new Runnable() {

				@Override
				public void run() {
					if ((arg1 & Platform.CUSTOMER_ACTION_MASK) == GET_SINA_WEIBO_FRIENDS_ACTION) {
						ToastUtil.showToast(mContext, "获取微博好友数据失败");
					} else {
						ToastUtil.showToast(mContext, "授权失败");
					}
				}
			});
		}

		@Override
		public void onComplete(final Platform arg0, int arg1, HashMap<String, Object> arg2) {
			DialogUtils.dismissDialog();
			if (arg0.getName().equals(SinaWeibo.NAME)) {
				if ((arg1 & Platform.CUSTOMER_ACTION_MASK) == GET_SINA_WEIBO_FRIENDS_ACTION) {
					ArrayList<HashMap<String, Object>> users = (ArrayList<HashMap<String, Object>>) arg2.get("users");
					ArrayList<OpenPlatformBeans> arrayList = new ArrayList<OpenPlatformBeans>();
					final JSONObject sinaDataObject = new JSONObject();
					for (HashMap<String, Object> user : users) {
						OpenPlatformBeans beans = new OpenPlatformBeans();
						String name = String.valueOf(user.get("name"));
						String userIcon = String.valueOf(user.get("avatar_large"));
						String userid = String.valueOf(user.get("id"));
						try {
							sinaDataObject.put(userid, name);
						} catch (JSONException e) {
							e.printStackTrace();
						}
						beans.setUserNick(name);
						beans.setUserIcon(userIcon);
						arrayList.add(beans);
					}
					if (arrayList.size() <= 0) {
						mHandler.post(new Runnable() {

							@Override
							public void run() {
								arg0.getDb().removeAccount();
								ToastUtil.showToast(mContext, getString(R.string.no_sina_friends));
							}
						});
					} else {
						Intent intent = new Intent(mContext, SinaWeiboFriendListActivity.class);
						intent.putExtra("sinaWeiboFriends", arrayList);
						startActivity(intent);
					}
				} else {
					gotoBind(arg0);
					Message msg = new Message();
					msg.what = R.id.third_platform_is_valid;
					msg.obj = arg0;
					mHandler.sendMessage(msg);
					// getSinaWeiboFriendList(arg0, arg0.getDb().getUserId());
				}
			}
		}

		@Override
		public void onCancel(Platform arg0, int arg1) {
			DialogUtils.dismissDialog();
		}
	};

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 返回
				finish();
				break;
			}
		}
	};

	private void gotoBind(final Platform pf) {
		OpenPlatformBeans currentBeans = new OpenPlatformBeans();
		PlatformDb platformDb = pf.getDb();
		final String userId = platformDb.getUserId();
		if (Util.isBlankString(userId)) {
			return;
		}
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
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int Error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
			}
		}).execute(currentBeans.getUserId(), currentBeans.getOpenType(), currentBeans.getAccessToken(),
				currentBeans.getExpiresIn());
		runOnUiThread(new Runnable() {

			@Override
			public void run() {
				if (!SinaWeibo.NAME.equals(pfName)) {
					addFriendByPlatform(pfName);
				}
			}
		});
	}

	@Override
	protected void onResume() {
		super.onResume();
		DialogUtils.dismissDialog();
	}

	private void loginByThirdPlatform(final String platform) {
		ShareSDK.initSDK(mContext);
		ShareSDK.getPlatform(platform).getDb().removeAccount();

		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		J_OpenManager.getInstance().login(mHandler, platform, new PlatformActionListener() {
			@Override
			public void onError(Platform arg0, int arg1, Throwable arg2) {
				DialogUtils.dismissDialog();
				if (!arg0.isClientValid() && (arg0.getName().equals(WechatMoments.NAME) || arg0.getName().equals(Wechat.NAME))) {
					mHandler.post(new Runnable() {

						@Override
						public void run() {
							ToastUtil.showToast(mContext, "目前您的微信版本过低或未安装微信，需要安装微信才能使用");
						}
					});
				}
				arg0.removeAccount();
				arg2.printStackTrace();
			}

			@Override
			public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
				gotoBind(arg0);
			}

			@Override
			public void onCancel(Platform arg0, int arg1) {
				DialogUtils.dismissDialog();
				arg0.removeAccount();
			}
		});
	}
}
