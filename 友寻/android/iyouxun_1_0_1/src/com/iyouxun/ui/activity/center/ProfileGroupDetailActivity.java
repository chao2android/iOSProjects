package com.iyouxun.ui.activity.center;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.beans.users.GroupUser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.GroupUserListAdapter;
import com.iyouxun.ui.views.NotScollGridView;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.Util;

/**
 * 从他人资料页群组进入后浏览的群组详细内容页面
 * 
 * @ClassName: ProfileGroupDetailActivity
 * @author likai
 * @date 2015-3-19 上午11:17:44
 * 
 */
public class ProfileGroupDetailActivity extends CommTitleActivity {
	// 当前浏览的群组id
	private int groupId;
	private long currentUid;

	private TextView profile_group_name;// 群组名称
	private TextView profile_group_intro;// 群组简介
	private TextView profile_group_auth;// 群组权限
	private TextView profile_group_member_count;// 成员数量
	private ImageButton profile_group_member_status;// 展开，隐藏指示按钮
	private NotScollGridView profile_group_member_gv;// 成员列表
	private Button profile_group_apply;// 申请加入按钮
	private TextView profile_group_num;// 群组数字
	// 群组详细信息bean
	private final GroupsInfoBean groupBean = new GroupsInfoBean();

	private GroupUserListAdapter adapter;
	// 标记是否展开用户列表:false:未展开，true：展开
	private boolean isExpand = false;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("TA的群组");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_profile_group_detail, null);
	}

	@Override
	protected void initViews() {
		groupId = getIntent().getIntExtra("groupId", 0);
		currentUid = getIntent().getLongExtra("uid", 0);

		profile_group_name = (TextView) findViewById(R.id.profile_group_name);
		profile_group_intro = (TextView) findViewById(R.id.profile_group_intro);
		profile_group_auth = (TextView) findViewById(R.id.profile_group_auth);
		profile_group_member_count = (TextView) findViewById(R.id.profile_group_member_count);
		profile_group_member_status = (ImageButton) findViewById(R.id.profile_group_member_status);
		profile_group_member_gv = (NotScollGridView) findViewById(R.id.profile_group_member_gv);
		profile_group_apply = (Button) findViewById(R.id.profile_group_apply);
		profile_group_num = (TextView) findViewById(R.id.profile_group_num);

		// 设置用户列表adapter数据
		adapter = new GroupUserListAdapter(mContext);
		adapter.setDatas(groupBean.userList);
		profile_group_member_gv.setAdapter(adapter);
		profile_group_member_gv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				GroupUser user = groupBean.userList.get(position);
				Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
				profileIntent.putExtra("uid", user.uid);
				startActivity(profileIntent);
			}
		});

		// 申请按钮点击
		profile_group_apply.setOnClickListener(listener);
		profile_group_member_status.setOnClickListener(listener);

		// 获取群组成员列表
		showLoading();
		UtilRequest.getGroupUserList(groupId, mHandler, mContext);
	}

	/**
	 * 设置页面显示内容
	 * 
	 * @Title: setContent
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContent() {
		// 群组名称
		profile_group_name.setText(StringUtils.getLimitSubstringWithMore(groupBean.name, 10));
		// 群组数字
		profile_group_num.setText("(" + groupBean.userList.size() + "人)");
		// 群组简介
		if (!Util.isBlankString(groupBean.intro)) {
			profile_group_intro.setText(groupBean.intro);
		} else {
			profile_group_intro.setText("暂无介绍内容");
		}
		// 群组权限
		if (groupBean.privilege == 0) {
			profile_group_auth.setText("允许所有人加入");
			profile_group_apply.setEnabled(true);
		} else if (groupBean.privilege == 1) {
			profile_group_auth.setText("需要申请加入");
			profile_group_apply.setEnabled(true);
		} else if (groupBean.privilege == 2) {
			profile_group_auth.setText("只允许一度好友和二度好友直接加入");
			profile_group_apply.setEnabled(true);
		} else if (groupBean.privilege == 3) {
			profile_group_auth.setText("只允许一度好友和二度好友申请加入");
			profile_group_apply.setEnabled(true);
		} else {
			profile_group_auth.setText("禁止任何人加入");
			profile_group_apply.setEnabled(false);
		}

		// 已经加入该群组，不显示“加入”按钮
		if (groupBean.isJoin == 1) {
			profile_group_apply.setVisibility(View.GONE);
		} else {
			profile_group_apply.setVisibility(View.VISIBLE);
		}

		// 成员列表
		if (groupBean.userList.size() > 18) {
			// 大于三行的时候，展示收起、展开按钮
			isExpand = false;
			profile_group_member_status.setVisibility(View.VISIBLE);
			for (int i = 0; i < groupBean.userList.size(); i++) {
				if (i >= 18) {
					groupBean.userList.get(i).isVisiable = false;
				} else {
					groupBean.userList.get(i).isVisiable = true;
				}
			}
		} else {
			// 小于三行的时候，不展示
			isExpand = true;
			profile_group_member_status.setVisibility(View.GONE);
		}
		profile_group_member_count.setText("成员(" + groupBean.count + ")");

		adapter.setDatas(groupBean.userList);
		adapter.notifyDataSetChanged();
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.profile_group_apply:
				// 申请加群
				// 未申请过
				showLoading();
				UtilRequest.addGroup(groupId, currentUid + "", mHandler, mContext);
				break;
			case R.id.profile_group_member_status:
				// 展开收起按钮
				if (isExpand) {
					// 当前为展开状态，执行收缩操作
					isExpand = false;
					profile_group_member_status.setImageResource(R.drawable.icon_down);
					for (int i = 0; i < groupBean.userList.size(); i++) {
						GroupUser user = groupBean.userList.get(i);
						if (i >= 18) {
							user.isVisiable = false;
						} else {
							user.isVisiable = true;
						}
						groupBean.userList.set(i, user);
					}
				} else {
					// 当前为收缩状态，执行展开操作
					isExpand = true;
					profile_group_member_status.setImageResource(R.drawable.icon_up);
					for (int i = 0; i < groupBean.userList.size(); i++) {
						GroupUser user = groupBean.userList.get(i);
						user.isVisiable = true;
						groupBean.userList.set(i, user);
					}
				}
				// 刷新列表
				adapter.setDatas(groupBean.userList);
				adapter.notifyDataSetChanged();
				break;
			default:
				break;
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_ADD_GROUP:
				// 申请加入该群
				try {
					// 获取申请结果
					JSONObject groupDataInfo = new JSONObject(msg.obj.toString());
					int resultInfo = groupDataInfo.optInt("result");
					String warmInfo = "";
					switch (resultInfo) {
					case -1:// 禁止加入
						warmInfo = "该群组禁止加入！";
						// 申请发送成功
						DialogUtils.showPromptDialog(mContext, "提醒", warmInfo, new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
							}
						});
						break;
					case 1:// 加入成功
						warmInfo = "群组加入成功！";
						// 申请发送成功
						DialogUtils.showPromptDialog(mContext, "提醒", warmInfo, new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
							}
						});
						profile_group_apply.setVisibility(View.GONE);
						break;
					case 2:// 等待群主审核
						warmInfo = "等待群主审核，审核通过后即可加入！";
						// 申请发送成功
						DialogUtils.showPromptDialog(mContext, "申请已发送", warmInfo, new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
							}
						});
						break;
					case 3:
						// 已经申请过，再次申请的情况
						warmInfo = "您已经申请过，请等待群主审核！";
						// 申请发送成功
						DialogUtils.showPromptDialog(mContext, "提醒", warmInfo, new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
							}
						});
						break;
					default:
						break;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				dismissLoading();
				break;
			case NetTaskIDs.TASKID_GROUP_USER_LIST:
				// 获取群组内成员列表
				try {
					JSONObject dataObj = new JSONObject(msg.obj.toString());
					groupBean.id = groupId;
					groupBean.uid = dataObj.optLong("uid");
					groupBean.name = dataObj.optString("title");
					groupBean.privilege = dataObj.optInt("privilege");
					groupBean.intro = dataObj.optString("intro");
					groupBean.isJoin = dataObj.optInt("join");

					JSONArray userData = dataObj.optJSONArray("userlist");
					if (userData.length() > 0) {
						groupBean.count = userData.length();
						for (int i = 0; i < userData.length(); i++) {
							JSONObject singleUser = userData.optJSONObject(i);
							GroupUser user = new GroupUser();
							user.uid = singleUser.optLong("uid");
							user.nickName = singleUser.optString("nick");
							if (Util.isBlankString(user.nickName)) {
								user.nickName = "没有昵称";
							}
							user.sex = singleUser.optInt("sex");
							user.mfriend_num = singleUser.optInt("mfriend_num");
							JSONObject avatarData = singleUser.optJSONObject("avatars");
							user.avatarUrl = avatarData.optString("200");
							if (user.uid == groupBean.uid) {
								user.isAdmin = true;
							}
							groupBean.userList.add(user);
						}
					}
					// 刷新显示数据
					setContent();
				} catch (Exception e) {
					e.printStackTrace();
				}
				dismissLoading();
				break;
			default:
				break;
			}
		}
	};
}
