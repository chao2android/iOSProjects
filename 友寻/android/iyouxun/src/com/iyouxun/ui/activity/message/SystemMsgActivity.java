package com.iyouxun.ui.activity.message;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
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
import com.iyouxun.ui.activity.BaseActivity;
import com.iyouxun.ui.activity.MainBoxActivity;
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
public class SystemMsgActivity extends BaseActivity {
	private PullToRefreshListView messageList;// 系统消息列表
	private SystemMessageAdapter adapter;
	private final ArrayList<SystemMsgInfoBean> datas = new ArrayList<SystemMsgInfoBean>();// 系统消息数据
	private int page = 1;
	private TextView noData;// 无消息提示
	private Button titleLeftButton;// 左侧按钮
	private TextView titleRightButton;// 右侧按钮
	private TextView ignoreButton;// 忽略按钮

	@Override
	protected void onCreate(Bundle arg0) {
		super.onCreate(arg0);
		setContentView(R.layout.activity_unread_system_msg);
		mContext = SystemMsgActivity.this;
		messageList = (PullToRefreshListView) findViewById(R.id.system_message_list);
		noData = (TextView) findViewById(R.id.system_message_no_data);
		titleLeftButton = (Button) findViewById(R.id.unread_system_msg_left_btn);
		titleRightButton = (TextView) findViewById(R.id.unread_system_msg_right_btn);
		ignoreButton = (TextView) findViewById(R.id.unread_system_msg_ignore_btn);
		messageList.setMode(Mode.PULL_FROM_END);// 设置只能从底部上拉
		messageList.setScrollingWhileRefreshingEnabled(false);// 加载的时候不允许滑动
		messageList.setPullToRefreshOverScrollEnabled(false);// 滑动到底部的时候的缓冲提示
		adapter = new SystemMessageAdapter(mContext, datas, listener);
		titleLeftButton.setOnClickListener(listener);
		titleRightButton.setOnClickListener(listener);
		ignoreButton.setOnClickListener(listener);
		titleRightButton.setVisibility(View.VISIBLE);
		messageList.setAdapter(adapter);
		messageList.setOnRefreshListener(new OnRefreshListener<ListView>() {

			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				getMsgInfo();
			}
		});
		messageList.setOnItemClickListener(onItemClickListener);
		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		getMsgInfo();
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		Intent finishReadSysMsgIntent = new Intent();
		finishReadSysMsgIntent.setAction(UtilRequest.BROADCAST_ACTION_FINISH_READ_SYSTEM_MSG);
		sendBroadcast(finishReadSysMsgIntent);
		page = 1;
		datas.clear();
		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		getMsgInfo();
	}

	private void getMsgInfo() {
		UtilRequest.getSystemList("sys", page, J_Consts.MESSAGE_LIST_PAGE_SIZE, 100, 0, 0, mHandler, mContext);
	}

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
				ignoreButton.setVisibility(View.VISIBLE);
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
								if (bean.type != 11 && bean.type != 23) {
									setOnRead(bean.type, bean.iid);
								}
								if (bean.type == 15) {// 群主踢人
									Intent exitIntent = new Intent(UtilRequest.BROADCAST_ACTION_EXIT_GROUP);
									exitIntent.putExtra(UtilRequest.FORM_GROUP_ID, bean.groupId + "");
									Util.sendBroadcast(exitIntent);
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
								ignoreButton.setVisibility(View.GONE);
							} else {
								ToastUtil.showToast(mContext, getString(R.string.no_new_system_msg));
							}
						}
					} catch (JSONException e) {
						e.printStackTrace();
						if (datas.size() <= 0) {
							noData.setVisibility(View.VISIBLE);
							ignoreButton.setVisibility(View.GONE);
						}
						messageList.onRefreshComplete(Mode.DISABLED);
					}
				}
				break;
			case NetTaskIDs.TASKID_SET_ONREAD_ALLSYSMSG:// 全部忽略
				DialogUtils.dismissDialog();
				if (msg.obj == null) {
					ToastUtil.showToast(mContext, getString(R.string.network_error));
				} else {
					J_Response response = (J_Response) msg.obj;
					if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
						if (!Util.isRunning(mContext)) {
							Intent intent = new Intent(mContext, MainBoxActivity.class);
							startActivity(intent);
						}
						finish();
					} else {
						ToastUtil.showToast(mContext, "操作失败，请再次尝试");
					}
				}
				break;
			case NetTaskIDs.TASKID_ACCEPT_FRIEND_JOIN_GROUP:// 接受或拒绝好友加入群(只有群主操作)
				DialogUtils.dismissDialog();
				int position = msg.arg1;
				int type = msg.arg2;
				datas.get(position).acceptType = type;
				// for (int i = 0; i < datas.size(); i++) {
				// if (datas.get(i).type == datas.get(position).type &&
				// datas.get(i).uid == datas.get(position).uid
				// && datas.get(position).groupId.equals(datas.get(i).groupId))
				// {// 更新同一种申请
				// datas.get(i).acceptType = type;
				// setOnRead(datas.get(i).type, datas.get(i).iid);
				// }
				// }
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
				// for (int i = 0; i < datas.size(); i++) {
				// if (datas.get(i).type == datas.get(positionFriend).type &&
				// datas.get(i).uid == datas.get(positionFriend).uid
				// &&
				// datas.get(positionFriend).groupId.equals(datas.get(i).groupId))
				// {// 更新同一种申请
				// datas.get(i).acceptType = typeFriend;
				// setOnRead(datas.get(i).type, datas.get(i).iid);
				// }
				// }
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

	private void setOnRead(int type, String iid) {
		String typeString = "";
		switch (type) {
		case 11:
			typeString = "addgroup";
			break;
		case 12:
			typeString = "qtgroup";
			break;
		case 13:
			typeString = "accept";
			break;
		case 14:
			typeString = "reject";
			break;
		case 15:
			typeString = "del";
			break;
		case 21:
			typeString = "friendaddtags";
			break;
		case 22:
			typeString = "ownaddtags";
			break;
		case 23:
			typeString = "addfriend";
			break;
		case 24:
			typeString = "newfriend";
			break;
		case 25:
			typeString = "likepic";
			break;
		}
		if (!Util.isBlankString(typeString)) {
			UtilRequest.systemMsgSetOnread(iid, typeString);
		}
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.unread_system_msg_left_btn:// 返回按钮
				if (!Util.isRunning(mContext)) {
					Intent intent = new Intent(mContext, MainBoxActivity.class);
					startActivity(intent);
				}
				finish();
				break;
			case R.id.unread_system_msg_ignore_btn:// 全部忽略
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.setOnreadAll("sys", mHandler);
				break;
			case R.id.unread_system_msg_right_btn:// 查看已读数据
				Intent hasReadIntent = new Intent(mContext, SystemReadMsgActivity.class);
				startActivity(hasReadIntent);
				break;
			case R.id.system_message_btn_agree:// 添加按钮
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				int agreePosition = (Integer) v.getTag();
				int type = datas.get(agreePosition).type;
				setOnRead(type, datas.get(agreePosition).iid);
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
				setOnRead(datas.get(refusePosition).type, datas.get(refusePosition).iid);
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
	public boolean onKeyDown(int keyCode, android.view.KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if (!Util.isRunning(mContext)) {
				Intent intent = new Intent(mContext, MainBoxActivity.class);
				startActivity(intent);
			}
			finish();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	};
}
