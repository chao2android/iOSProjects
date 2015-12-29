package com.iyouxun.ui.activity.message;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.SystemMsgInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.center.ProfilePhotoViewActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.adapter.SystemMessageAdapter;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * @ClassName: SystemMsgActivity
 * @Description: 系统消息页面
 * @author donglizhi
 * @date 2015年4月16日 下午4:21:52
 * 
 */
public class SystemReadMsgActivity extends CommTitleActivity {
	private PullToRefreshListView messageList;// 系统消息列表
	private SystemMessageAdapter adapter;
	private final ArrayList<SystemMsgInfoBean> datas = new ArrayList<SystemMsgInfoBean>();// 系统消息数据
	private int page = 1;
	private TextView noData;// 无消息提示

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleLeftButton.setOnClickListener(listener);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setText(R.string.go_back);
		titleCenter.setText(R.string.has_read_msg);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_system_msg, null);
	}

	@Override
	protected void initViews() {
		mContext = SystemReadMsgActivity.this;
		messageList = (PullToRefreshListView) findViewById(R.id.system_message_list);
		noData = (TextView) findViewById(R.id.system_message_no_data);
		messageList.setMode(Mode.PULL_FROM_END);// 设置只能从底部上拉
		messageList.setScrollingWhileRefreshingEnabled(false);// 加载的时候不允许滑动
		messageList.setPullToRefreshOverScrollEnabled(false);// 滑动到底部的时候的缓冲提示
		adapter = new SystemMessageAdapter(mContext, datas, listener);
		messageList.setAdapter(adapter);
		noData.setText(R.string.no_has_read_system_msg);
		messageList.setOnRefreshListener(new OnRefreshListener<ListView>() {

			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				getReadMsgInfo();
			}
		});
		messageList.setOnItemClickListener(onItemClickListener);
		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		getReadMsgInfo();
		IntentFilter filter = new IntentFilter();
		filter.addAction(UtilRequest.BROADCAST_ACTION_FINISH_READ_SYSTEM_MSG);
		registerReceiver(mBroadcastReceiver, filter);
	};

	private void getReadMsgInfo() {
		UtilRequest.getSystemList("sys", page, J_Consts.MESSAGE_LIST_PAGE_SIZE, 100, 1, 0, mHandler, mContext);
	}

	private final BroadcastReceiver mBroadcastReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			if (UtilRequest.BROADCAST_ACTION_FINISH_READ_SYSTEM_MSG.equals(action)) {// 系统消息页面从notification刷新后关闭当前页面
				finish();
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_IS_EXIST_PHOTO:// 照片存在跳转到大图页
				if (msg.obj != null) {
					int index = (Integer) msg.obj;
					final ArrayList<PhotoInfoBean> photoInfoBeans = new ArrayList<PhotoInfoBean>();
					PhotoInfoBean photoInfoBean = new PhotoInfoBean();
					photoInfoBean.nick = J_Cache.sLoginUser.nickName;
					photoInfoBean.url = datas.get(index).photoUrl;
					photoInfoBean.url_small = datas.get(index).photoUrl;
					photoInfoBean.pid = datas.get(index).pid;
					photoInfoBean.uid = J_Cache.sLoginUser.uid;
					photoInfoBeans.add(photoInfoBean);
					Intent photoViewIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
					photoViewIntent.putExtra("photoInfo", photoInfoBeans);
					photoViewIntent.putExtra("index", 0);
					photoViewIntent.putExtra("viewType", 2);
					startActivity(photoViewIntent);
				} else {// 图片不存在删除该条数据
					int index = msg.arg1;
					datas.remove(index);
					adapter.notifyDataSetChanged();
				}
				break;
			case NetTaskIDs.TASKID_LIST_SYSTEM:// 系统消息
				DialogUtils.dismissDialog();
				J_Response allResponse = (J_Response) msg.obj;
				if (allResponse.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(allResponse.retmean)) {
					try {
						JSONArray array = new JSONArray(allResponse.data);
						if (array.length() > 0) {
							for (int i = 0; i < array.length(); i++) {
								SystemMsgInfoBean bean = new SystemMsgInfoBean();
								JSONObject itemObject = array.optJSONObject(i);
								bean.uid = itemObject.optLong(UtilRequest.FORM_UID);
								bean.iid = itemObject.optString(UtilRequest.FORM_IID);
								bean.type = itemObject.optInt(UtilRequest.FORM_TYPE);
								if (bean.type == 10 || bean.type == 16) {
									continue;
								}
								bean.avatar = itemObject.optString(UtilRequest.FORM_AVATARS);
								bean.nick = itemObject.optString(UtilRequest.FORM_NICK);
								bean.groupName = itemObject.optString(UtilRequest.FORM_TITLE);
								bean.time = itemObject.optString(UtilRequest.FORM_SEND_TIME) + "000";
								bean.privonce = itemObject.optString(UtilRequest.FORM_PRIVONCE);
								bean.city = itemObject.optString(UtilRequest.FORM_CITY);
								bean.relation = itemObject.optInt(UtilRequest.FORM_RELATION, 0);
								bean.friendnick = itemObject.optString(UtilRequest.FORM_FRIEND_NICK);
								bean.groupId = itemObject.optString(UtilRequest.FORM_GROUP_ID);
								bean.tagName = itemObject.optString(UtilRequest.FORM_NAME);
								bean.friendlists = itemObject.optString(UtilRequest.FORM_FRIEND_LISTS);
								bean.uname = itemObject.optString(UtilRequest.FORM_UNAME);
								bean.sysytemMsgStatus = itemObject.optInt(UtilRequest.FORM_STATUS, 0);
								bean.pid = itemObject.optString(UtilRequest.FORM_PID);
								JSONObject photoLists = itemObject.optJSONObject(UtilRequest.FORM_PHOTO_LISTS);
								if (photoLists != null) {
									JSONObject photo = photoLists.optJSONObject(bean.pid);
									if (photo != null) {
										bean.photoUrl = photo.optString("800");
										bean.photoThumbnail = photo.optString("100");
									}
								}
								if (bean.type == 22 && Util.isBlankString(bean.tagName)) {// 标签不能为空
									continue;
								}
								datas.add(bean);
							}
							page++;
							messageList.onRefreshComplete(Mode.PULL_FROM_END);
							adapter.notifyDataSetChanged();
						} else {
							messageList.onRefreshComplete(Mode.DISABLED);
							if (datas.size() <= 0) {
								noData.setVisibility(View.VISIBLE);
							} else {
								ToastUtil.showToast(mContext, getString(R.string.no_has_read_system_msg));
							}
						}
					} catch (JSONException e) {
						e.printStackTrace();
						if (datas.size() <= 0) {
							noData.setVisibility(View.VISIBLE);
						}
						messageList.onRefreshComplete(Mode.DISABLED);
					}
				}
				break;
			case NetTaskIDs.TASKID_ACCEPT_FRIEND_JOIN_GROUP:// 接受或拒绝好友加入群(只有群主操作)
				DialogUtils.dismissDialog();
				int position = msg.arg1;
				int type = msg.arg2;
				datas.get(position).acceptType = type;
				int operate = 0;
				if (type == 1) {
					operate = 3;
				} else {
					operate = 4;
				}
				UtilRequest.setHandled(datas.get(position).iid, operate);
				adapter.notifyDataSetChanged();
				break;
			case NetTaskIDs.TASKID_FRIENDS_ACCEPT_REQ:// 接受好友申请
				DialogUtils.dismissDialog();
				int positionFriend = msg.arg1;
				int typeFriend = msg.arg2;
				datas.get(positionFriend).acceptType = typeFriend;
				UtilRequest.setHandled(datas.get(positionFriend).iid, 3);
				adapter.notifyDataSetChanged();
				break;
			case NetTaskIDs.TASKID_FRIENDS_REM_REQ:// 忽略好友申请
				DialogUtils.dismissDialog();
				int refusePosition = msg.arg1;
				datas.get(refusePosition).acceptType = 2;
				adapter.notifyDataSetChanged();
				UtilRequest.setHandled(datas.get(refusePosition).iid, 4);
				break;
			case NetTaskIDs.TASKID_IS_GROUP_MEMBER:// 是否是群组成员
				if (msg.obj != null) {
					int index = (Integer) msg.obj;
					Intent intent = new Intent();
					intent.setClass(mContext, ChatMainActivity.class);
					int groupId = Util.getInteger(datas.get(index).groupId);
					intent.putExtra(UtilRequest.FORM_GROUP_ID, groupId);
					intent.putExtra(UtilRequest.FORM_NICK, datas.get(index).groupName);
					startActivity(intent);
				}
				break;
			}
		};
	};

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 返回按钮
				finish();
				break;
			case R.id.system_message_btn_agree:// 添加按钮
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				int agreePosition = (Integer) v.getTag();
				int type = datas.get(agreePosition).type;
				if (type == 11) {// 申请加入群消息
					UtilRequest.acceptFriendsJoinGroup(datas.get(agreePosition).groupId, datas.get(agreePosition).uid + "", 1,
							agreePosition, mHandler, mContext);
				} else if (type == 23) {// 好友申请
					UtilRequest.friendsAcceptReq(SharedPreUtil.getLoginInfo().uid + "", datas.get(agreePosition).uid + "",
							mHandler, mContext, agreePosition);
				}
				break;
			case R.id.system_message_btn_refuse:// 谢绝按钮
				int refusePosition = (Integer) v.getTag();
				int refuseType = datas.get(refusePosition).type;
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				if (refuseType == 11) {// 申请加入群组
					UtilRequest.acceptFriendsJoinGroup(datas.get(refusePosition).groupId, datas.get(refusePosition).uid + "", 2,
							refusePosition, mHandler, mContext);
				} else if (refuseType == 23) {// 忽略好友申请
					UtilRequest.friendsRemReq(datas.get(refusePosition).uid + "", SharedPreUtil.getLoginInfo().uid + "",
							mHandler, mContext, refusePosition);
				}
				break;
				case R.id.system_message_nick://用户昵称
				case R.id.system_message_user_avatar://用户头像
					int clickPositon = (Integer)v.getTag();
					int clikckType = datas.get(clickPositon).type;
					if (clikckType == 25){
						Intent profileIntent = new Intent(mContext,ProfileViewActivity.class);
						profileIntent.putExtra(UtilRequest.FORM_UID,datas.get(clickPositon).uid);
						startActivity(profileIntent);
					}
					break;
			default:
				break;
			}
		}
	};

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			int index = position - 1;
			Intent intent = new Intent();
			switch (datas.get(index).type) {
			case 11:// 申请加入群消息
			case 12:// 退群消息
			case 23:// 好友申请
			case 24:// 新好友加入
				long uid = datas.get(index).uid;
				if (uid > 0) {
					intent.setClass(mContext, ProfileViewActivity.class);
					intent.putExtra(UtilRequest.FORM_UID, uid);
				} else {
					return;
				}
				break;
			case 13:// 同意加入群
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.isGroupMember(datas.get(index).groupId, mContext, mHandler, index);
				return;
			case 22:// 别人给我打标签
				intent.setClass(mContext, ProfileViewActivity.class);
				intent.putExtra(UtilRequest.FORM_UID, J_Cache.sLoginUser.uid);
				break;
			case 25:// 赞照片
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.isExistPhoto(mHandler, mContext, datas.get(index).pid, index);
				return;
			default:
				return;
			}
			startActivity(intent);
		}
	};

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(mBroadcastReceiver);
	};
}
