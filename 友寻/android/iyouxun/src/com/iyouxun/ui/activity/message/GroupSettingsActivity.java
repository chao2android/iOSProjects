package com.iyouxun.ui.activity.message;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.data.beans.users.GroupUser;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.parser.CharacterParser;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: GroupSettingsActivity
 * @Description: 群组设置页面
 * @author donglizhi
 * @date 2015年3月31日 下午8:13:45
 * 
 */
public class GroupSettingsActivity extends CommTitleActivity {
	private TextView groupName;// 群组名称
	private TextView groupIntroduction;// 群组简介
	private TextView groupMembers;// 群组成员
	private TextView groupPrivilege;// 权限设置
	private RelativeLayout showNickBox;// 昵称显示
	private CheckBox showNick;// 昵称显示
	private CheckBox groupStatus;// 群组状态
	private RelativeLayout statusBox;// 群组状态
	private CheckBox messageRemind;// 消息提醒
	private RelativeLayout remindBox;// 消息提醒
	private CheckBox groupShow;// 是否展示
	private RelativeLayout showBox;// 是否展示
	private RelativeLayout privilegeBox;// 权限设置模块
	private Button btnLeave;// 退出群组
	private GroupsInfoBean groupBean = new GroupsInfoBean();
	private int groupId = 0;// 群组id
	private String[] privilegeList;// 权限设置数据
	private int groupStatusChecked = -1;// 群组状态选中状态
	private int groupShowChecked = -1;// 在资料页是否显示选中状态
	private int messageRemindChecked = -1;// 消息提醒选中状态
	private int groupShowNick = -1;// 群聊展示昵称
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	private final int REQUEST_CODE_EDIT_NAME = 10000;
	private final int REQUEST_CODE_EDIT_INTRODUCTION = 10001;
	private final int REQUEST_CODE_EDIT_PRIVILEGE = 10002;
	private final int REQUEST_CODE_EDIT_MEMBERS = 10003;
	private ChatDBHelper helper;
	private boolean showGroupMemebers = false;// 查看群组成员
	private LinearLayout membersAvatar;// 成员头像
	private TextView membersArrow;// 箭头图标

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.group_settings);
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_group_settings, null);
	}

	@Override
	protected void initViews() {
		helper = ChatContactRepository.getDBHelperInstance();
		J_NetManager.getInstance().loadIMG(null, J_Cache.sLoginUser.avatarUrl150, new ImageView(mContext), 0, 0);
		groupName = (TextView) findViewById(R.id.group_settings_group_name);
		groupIntroduction = (TextView) findViewById(R.id.group_settings_group_introduction);
		groupMembers = (TextView) findViewById(R.id.group_settings_group_members);
		groupPrivilege = (TextView) findViewById(R.id.group_settings_group_privilege);
		groupStatus = (CheckBox) findViewById(R.id.group_settings_group_status_check);
		groupShow = (CheckBox) findViewById(R.id.group_settings_group_show_check);
		messageRemind = (CheckBox) findViewById(R.id.group_settings_group_remind_check);
		btnLeave = (Button) findViewById(R.id.group_settings_group_leave);
		statusBox = (RelativeLayout) findViewById(R.id.group_settings_group_status_box);
		remindBox = (RelativeLayout) findViewById(R.id.group_settings_group_remind_box);
		showBox = (RelativeLayout) findViewById(R.id.group_settings_group_show_box);
		privilegeBox = (RelativeLayout) findViewById(R.id.group_settings_group_privilege_box);
		membersAvatar = (LinearLayout) findViewById(R.id.group_settings_group_members_avatars);
		membersArrow = (TextView) findViewById(R.id.group_settings_group_members_icon_arrow);
		showNickBox = (RelativeLayout) findViewById(R.id.group_settings_group_show_nick_box);
		showNick = (CheckBox) findViewById(R.id.group_settings_group_show_nick_check);
		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		statusBox.setOnClickListener(listener);
		remindBox.setOnClickListener(listener);
		showBox.setOnClickListener(listener);
		btnLeave.setOnClickListener(listener);
		groupName.setOnClickListener(listener);
		groupIntroduction.setOnClickListener(listener);
		groupMembers.setOnClickListener(listener);
		groupPrivilege.setOnClickListener(listener);
		membersArrow.setOnClickListener(listener);
		showNickBox.setOnClickListener(listener);
		if (getIntent().hasExtra(UtilRequest.FORM_GROUP_ID)) {
			DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
			groupId = getIntent().getIntExtra(UtilRequest.FORM_GROUP_ID, 0);
			privilegeList = getResources().getStringArray(R.array.group_privilege);
			UtilRequest.getGroupUserList(groupId, mHandler, mContext);
		} else {
			finish();
		}
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 返回按钮
				finish();
				break;
			case R.id.group_settings_group_name:// 群组名称
				Intent nameIntent = new Intent(mContext, EditGroupNameActivity.class);
				nameIntent.putExtra(JsonParser.RESPONSE_DATA, groupBean);
				startActivityForResult(nameIntent, REQUEST_CODE_EDIT_NAME);
				break;
			case R.id.group_settings_group_introduction:// 群组简介
				Intent introIntent = new Intent(mContext, EditGroupIntroductionActivity.class);
				introIntent.putExtra(JsonParser.RESPONSE_DATA, groupBean);
				startActivityForResult(introIntent, REQUEST_CODE_EDIT_INTRODUCTION);
				break;
			case R.id.group_settings_group_members:// 群组成员
			case R.id.group_member_icon:
			case R.id.group_settings_group_members_icon_arrow:
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				showGroupMemebers = true;
				UtilRequest.getGroupUserList(groupId, mHandler, mContext);
				break;
			case R.id.group_settings_group_privilege:// 权限设置
				if (groupBean.masterId == J_Cache.sLoginUser.uid) {// 群主可以修改权限
					Intent privilegeIntent = new Intent(mContext, EditGroupPrivilegeActivity.class);
					privilegeIntent.putExtra(JsonParser.RESPONSE_DATA, groupBean);
					startActivityForResult(privilegeIntent, REQUEST_CODE_EDIT_PRIVILEGE);
				}
				break;
			case R.id.group_settings_group_leave:// 退出群组
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.exitGroup(groupId, mHandler, mContext);
				break;
			case R.id.group_settings_group_status_box:// 群组状态
				if (groupBean.masterId == J_Cache.sLoginUser.uid) {// 群主可以修改是否公开
					if (groupStatus.isChecked()) {// 0不公开，1公开（将推荐给好友）
						groupStatusChecked = 0;
					} else {
						groupStatusChecked = 1;
					}
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.updateGroupStatus(groupBean.id + "", groupStatusChecked, mHandler, mContext);
				}
				break;
			case R.id.group_settings_group_remind_box:// 消息提醒
				if (messageRemind.isChecked()) {// 提醒 0 接受 1 不接受
					messageRemindChecked = 0;
				} else {
					messageRemindChecked = 1;
				}
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.updateUserGroup(J_Cache.sLoginUser.uid, groupId, groupBean.show, messageRemindChecked, mHandler,
						mContext);

				break;
			case R.id.group_settings_group_show_box:// 是否展示
				if (groupBean.masterId == J_Cache.sLoginUser.uid || groupBean.status == 1) {// 群主设置是否可以展示
					if (groupShow.isChecked()) {// 在资料页是否显示 0显示 1不显示
						groupShowChecked = 1;
					} else {
						groupShowChecked = 0;
					}
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.updateGroupShow(groupBean.id + "", groupShowChecked, mHandler, mContext);

				}
				break;
			case R.id.group_settings_group_show_nick_box:// 展示群聊昵称
				if (showNick.isChecked()) {// 群聊是否展示昵称0展示1不显示
					groupShowNick = 1;
				} else {
					groupShowNick = 0;
				}
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.updateUserGroupShowNick(groupBean.id + "", groupShowNick, mHandler, mContext);
				break;
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_GROUP_USER_LIST:// 获得群组信息
				// 获取群组内成员列表
				try {
					JSONObject dataObj = new JSONObject(msg.obj.toString());
					groupBean.id = groupId;
					groupBean.masterId = dataObj.optLong(UtilRequest.FORM_UID);
					groupBean.name = dataObj.optString(UtilRequest.FORM_TITLE);
					groupBean.privilege = dataObj.optInt(UtilRequest.FORM_PRIVILEGE);
					groupBean.intro = dataObj.optString(UtilRequest.FORM_INTRO);
					groupBean.show = dataObj.optInt(UtilRequest.FORM_SHOW);
					groupBean.hint = dataObj.optInt(UtilRequest.FORM_HINT);
					groupBean.status = dataObj.optInt(UtilRequest.FORM_STATUS);
					groupBean.showNick = dataObj.optInt(UtilRequest.FORM_SHOW_NICK);
					JSONArray userData = dataObj.optJSONArray(UtilRequest.FORM_USER_LIST);

					if (userData.length() > 0) {
						groupBean.count = userData.length();
						groupBean.userList.clear();
						for (int i = 0; i < userData.length(); i++) {
							JSONObject singleUser = userData.optJSONObject(i);
							GroupUser user = new GroupUser();
							user.uid = singleUser.optLong(UtilRequest.FORM_UID);
							user.nickName = singleUser.optString(UtilRequest.FORM_NICK);
							user.sex = singleUser.optInt(UtilRequest.FORM_SEX);
							user.marriage = singleUser.optInt(UtilRequest.FORM_MARRIAGE);
							JSONObject avatarData = singleUser.optJSONObject(UtilRequest.FORM_AVATARS);
							user.avatarUrl = avatarData.optString(UtilRequest.FORM_200);
							user.relation = singleUser.optInt(UtilRequest.FORM_RELATION);
							if (!Util.isBlankString(user.avatarUrl) && i < 4) {
								J_NetManager.getInstance().loadIMG(null, user.avatarUrl, new ImageView(mContext), 0, 0);
							}
							user.mfriend_num = singleUser.optInt(UtilRequest.FORM_MFRIEND_NUM);
							user.joinTime = singleUser.optLong(UtilRequest.FORM_JOIN_TIME, 0);
							groupBean.userList.add(user);
						}
					}
					refreshView();
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (showGroupMemebers) {// 查看群组成员列表
					showGroupMemebers = false;
					ArrayList<ManageFriendsBean> beans = new ArrayList<ManageFriendsBean>();
					for (int i = 0; i < groupBean.userList.size(); i++) {
						ManageFriendsBean bean = new ManageFriendsBean();
						bean.setAvatar(groupBean.userList.get(i).avatarUrl);
						bean.setName(groupBean.userList.get(i).nickName);
						bean.setUid(groupBean.userList.get(i).uid + "");
						bean.setSex(groupBean.userList.get(i).sex);
						bean.setMutualFriendsCount(groupBean.userList.get(i).mfriend_num);
						bean.setHasRegistered(true);
						bean.setChecked(false);
						bean.setMarriage(groupBean.userList.get(i).marriage);
						bean.setRelation(groupBean.userList.get(i).relation);
						bean.setJoinTime(groupBean.userList.get(i).joinTime);
						if (Util.isBlankString(bean.getName())) {
							bean.setSortLetter("#");
						} else {
							String pinyin = characterParser.getSelling(bean.getName());
							String sortString = pinyin.substring(0, 1).toUpperCase();

							// 正则表达式，判断首字母是否是英文字母
							if (sortString.matches("[A-Z]")) {
								bean.setSortLetter(sortString.toUpperCase());
							} else {
								bean.setSortLetter("#");
							}
						}
						beans.add(bean);
					}
					Intent membersIntent = new Intent(mContext, GroupMembersActivity.class);
					membersIntent.putExtra(JsonParser.RESPONSE_DATA, beans);
					membersIntent.putExtra(UtilRequest.FORM_UID, groupBean.masterId);
					membersIntent.putExtra(UtilRequest.FORM_GROUP_ID, groupId + "");
					startActivityForResult(membersIntent, REQUEST_CODE_EDIT_MEMBERS);
				}
				DialogUtils.dismissDialog();
				break;
			case NetTaskIDs.TASKID_UPDATE_GROUP_STATUS:// 更新群组状态
				DialogUtils.dismissDialog();
				if (groupStatusChecked != -1) {// 更新公开状态
					groupBean.status = groupStatusChecked;
					groupStatusChecked = -1;
				}
				refreshView();
				break;
			case NetTaskIDs.TASKID_UPDATE_GROUP_SHOW:// 修改用户群在资料页显示状态
				DialogUtils.dismissDialog();
				try {
					JSONObject showObject = new JSONObject(msg.obj.toString());
					int result = showObject.optInt(UtilRequest.FORM_RESULT);
					if (result == 1) {
						groupStatus.setChecked(false);
						groupShow.setChecked(false);
						groupBean.show = 1;
						groupBean.status = 0;
						ToastUtil.showToast(mContext, "群主已经修改群组状态为不公开，修改失败！");
					} else {// 修改成功
						if (groupShowChecked != -1) {// 更新公开状态
							groupBean.show = groupShowChecked;
							groupShowChecked = -1;
						}
						refreshView();
					}
				} catch (JSONException e) {
					ToastUtil.showToast(mContext, "群组状态更新失败，请再次尝试！");
					e.printStackTrace();
				}
				break;
			case NetTaskIDs.TASKID_UPDATE_USER_GROUP:// 更新用户群信息
				DialogUtils.dismissDialog();
				if (messageRemindChecked != -1) {// 更新提醒状态
					groupBean.hint = messageRemindChecked;
					updateHint(groupBean.hint);
					messageRemindChecked = -1;
				}
				refreshView();
				break;
			case NetTaskIDs.TASKID_EXIT_GROUP:// 退出群组
				ArrayList<String> avatarList = new ArrayList<String>();
				for (int i = 0; i < groupBean.userList.size(); i++) {
					if (avatarList.size() < 4 && groupBean.userList.get(i).uid != J_Cache.sLoginUser.uid) {
						avatarList.add(groupBean.userList.get(i).avatarUrl);
					}
				}
				String newPath = Util.createNewAvatar(avatarList, mContext);
				if (!Util.isBlankString(newPath)) {// 修改新群组头像
					UtilRequest.updateGroupPic(newPath, groupId + "");
				}
				Intent exitIntent = new Intent(UtilRequest.BROADCAST_ACTION_EXIT_GROUP);
				exitIntent.putExtra(UtilRequest.FORM_GROUP_ID, groupId + "");
				Util.sendBroadcast(exitIntent);
				DialogUtils.dismissDialog();
				finish();
				break;
			case NetTaskIDs.TASKID_UPDATE_USER_GROUP_SHOW_NICK:// 群聊显示昵称
				DialogUtils.dismissDialog();
				if (groupShowNick != -1) {// 更新公开状态
					groupBean.showNick = groupShowNick;
					groupStatusChecked = -1;
					Intent showNickIntent = new Intent();
					showNickIntent.putExtra(UtilRequest.FORM_SHOW_NICK, groupShowNick);
					showNickIntent.putExtra(UtilRequest.FORM_GROUP_ID, groupBean.id);
					showNickIntent.setAction(UtilRequest.BROADCAST_ACTION_UPDATE_SHOW_NICK);
					sendBroadcast(showNickIntent);
				}
				refreshView();
				break;
			}
		};
	};

	/**
	 * @Title: refreshView
	 * @Description: 刷新页面数据
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void refreshView() {
		groupName.setText(groupBean.name);
		groupIntroduction.setText(groupBean.intro);
		if (groupBean.privilege < privilegeList.length) {
			groupPrivilege.setText(privilegeList[groupBean.privilege]);
		}
		if (groupBean.masterId == J_Cache.sLoginUser.uid) {
			privilegeBox.setVisibility(View.VISIBLE);
		}
		groupMembers.setText((groupBean.userList.size()) + " 人");
		if (groupBean.hint == 1) {// 提醒" 0 接受 1 不接受
			messageRemind.setChecked(true);
		} else {
			messageRemind.setChecked(false);
		}
		if (groupBean.status == 1) {// 0不公开，1公开（将推荐给好友）
			groupStatus.setChecked(true);
		} else {
			groupStatus.setChecked(false);
		}
		if (groupBean.show == 0) {// 在资料页是否显示"(类型int) 0显示 1不显示
			groupShow.setChecked(true);
		} else {
			groupShow.setChecked(false);
		}
		if (groupBean.showNick == 0) {// 群聊是否展示昵称0显示1不显示
			showNick.setChecked(true);
		} else {
			showNick.setChecked(false);
		}
		Collections.sort(groupBean.userList, new JoinTimeComparator());
		int length = 5;
		if (groupBean.userList.size() <= length) {
			length = groupBean.userList.size();
		}
		membersAvatar.removeAllViews();
		for (int i = 0; i < length; i++) {
			View view = View.inflate(mContext, R.layout.item_group_member_avatar, null);
			CircularImage circularImage = (CircularImage) view.findViewById(R.id.group_member_icon);
			J_NetManager.getInstance().loadIMG(null, groupBean.userList.get(i).avatarUrl, circularImage, R.drawable.icon_avatar,
					R.drawable.icon_avatar);
			circularImage.setOnClickListener(listener);
			membersAvatar.addView(view);
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		switch (requestCode) {
		case REQUEST_CODE_EDIT_NAME:// 编辑组名返回
			if (data != null && data.hasExtra(JsonParser.RESPONSE_DATA)) {
				groupBean = (GroupsInfoBean) data.getSerializableExtra(JsonParser.RESPONSE_DATA);
				groupName.setText(groupBean.name);
			}
			break;
		case REQUEST_CODE_EDIT_INTRODUCTION:// 编辑个人简介
			if (data != null && data.hasExtra(JsonParser.RESPONSE_DATA)) {
				groupBean = (GroupsInfoBean) data.getSerializableExtra(JsonParser.RESPONSE_DATA);
				groupIntroduction.setText(groupBean.intro);
			}
			break;
		case REQUEST_CODE_EDIT_PRIVILEGE:// 权限设置
			if (data != null && data.hasExtra(JsonParser.RESPONSE_DATA)) {
				groupBean = (GroupsInfoBean) data.getSerializableExtra(JsonParser.RESPONSE_DATA);
				groupPrivilege.setText(privilegeList[groupBean.privilege]);
			}
			break;
		case REQUEST_CODE_EDIT_MEMBERS:// 群组成员
			if (data != null && data.hasExtra(JsonParser.RESPONSE_DATA)) {
				ArrayList<ManageFriendsBean> beans = (ArrayList<ManageFriendsBean>) data
						.getSerializableExtra(JsonParser.RESPONSE_DATA);
				groupBean.userList.clear();
				for (int i = 0; i < beans.size(); i++) {
					GroupUser user = new GroupUser();
					if (!Util.isBlankString(beans.get(i).getUid())) {
						user.uid = Long.valueOf(beans.get(i).getUid());
					}
					user.nickName = beans.get(i).getName();
					user.sex = beans.get(i).getSex();
					user.marriage = beans.get(i).getMarriage();
					user.avatarUrl = beans.get(i).getAvatar();
					user.mfriend_num = beans.get(i).getMutualFriendsCount();
					user.joinTime = beans.get(i).getJoinTime();
					groupBean.userList.add(user);
				}
				refreshView();
			}
			break;
		default:
			break;
		}
	}

	public void updateHint(int hint) {
		helper.updateMessageHint(groupId + "", hint);
	}

	private class JoinTimeComparator implements Comparator<GroupUser> {

		@Override
		public int compare(GroupUser lhs, GroupUser rhs) {
			if (lhs.joinTime > rhs.joinTime) {
				return -1;
			} else if (lhs.joinTime < rhs.joinTime) {
				return 1;
			}
			return 0;
		}

	}
}
