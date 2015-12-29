package com.iyouxun.ui.activity.message;

import java.util.ArrayList;
import java.util.Collections;

import android.content.Intent;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.comparator.FriendsPinyinComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.find.NoFriendsActivity;
import com.iyouxun.ui.adapter.GroupMembersAdapter;
import com.iyouxun.ui.views.SideBar;
import com.iyouxun.ui.views.SideBar.OnTouchingLetterChangedListener;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

public class GroupMembersActivity extends CommTitleActivity {
	private TextView btnAll;// 全选按钮
	private TextView selectCount;// 选择数量
	private ListView friendsList;// 好友列表
	private GroupMembersAdapter adapter;
	/** 好友数据 */
	private ArrayList<ManageFriendsBean> arrayList = new ArrayList<ManageFriendsBean>();
	private SideBar sideBar;
	/** 根据拼音来排列ListView里面的数据类 */
	private FriendsPinyinComparator pinyinComparator;
	private boolean firstLoad = false;// 首次加载页面
	private String groupId = "";// 群组id
	private int delPosition = -1;// 删除用户的下标
	private long masterId = 0;// 群主id
	private final int REQUSET_CODE_ADD_MEMBERS = 1000;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.message_group_members);
		titleLeftButton.setText(R.string.go_back);
		titleRightButton.setText(R.string.add_members);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleRightButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_add_group_members, null);
	}

	@Override
	protected void initViews() {
		mContext = GroupMembersActivity.this;
		firstLoad = true;
		btnAll = (TextView) findViewById(R.id.add_group_members_btn_all);
		selectCount = (TextView) findViewById(R.id.add_group_members_selected_count);
		sideBar = (SideBar) findViewById(R.id.add_group_members_select_friends_sidebar);
		friendsList = (ListView) findViewById(R.id.add_group_members_select_friends_list);
		btnAll.setVisibility(View.GONE);
		if (getIntent().hasExtra(JsonParser.RESPONSE_DATA)) {
			arrayList = (ArrayList<ManageFriendsBean>) getIntent().getSerializableExtra(JsonParser.RESPONSE_DATA);
			// 根据a-z进行排序源数据
			pinyinComparator = new FriendsPinyinComparator();
			Collections.sort(arrayList, pinyinComparator);
		}
		if (getIntent().hasExtra(UtilRequest.FORM_GROUP_ID)) {
			groupId = getIntent().getStringExtra(UtilRequest.FORM_GROUP_ID);
		}
		if (getIntent().hasExtra(UtilRequest.FORM_UID)) {
			masterId = getIntent().getLongExtra(UtilRequest.FORM_UID, 0);
		}
		adapter = new GroupMembersAdapter(mContext, arrayList);
		friendsList.setAdapter(adapter);
		friendsList.setOnItemLongClickListener(onItemLongClickListener);
		btnAll.setOnClickListener(listener);
		// 设置右侧触摸监听
		sideBar.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {
			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = adapter.getPositionForSection(s.charAt(0));
				if (position != -1) {
					friendsList.setSelection(position);
				}
			}
		});
		setCount();
	}

	private final OnItemLongClickListener onItemLongClickListener = new OnItemLongClickListener() {

		@Override
		public boolean onItemLongClick(AdapterView<?> parent, View view, final int position, long id) {
			if (masterId == J_Cache.sLoginUser.uid && !arrayList.get(position).getUid().equals(J_Cache.sLoginUser.uid + "")) {// 群主可以踢人
				DialogUtils.showPromptDialog(mContext, "删除成员", "确定删除该成员?", new OnSelectCallBack() {

					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if ("0".equals(value1)) {
							DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
							delPosition = position;
							UtilRequest.groupMasterDelPerson(arrayList.get(position).getUid(), groupId, mHandler, mContext);
						}
					}
				});
			}

			return true;
		}
	};

	private void setCount() {
		String text = String.format(getResources().getString(R.string.message_group_members_limit),
				UtilRequest.GROUP_MEMBERS_LIMIT_COUNT)
				+ "（"
				+ arrayList.size()
				+ "/"
				+ UtilRequest.GROUP_MEMBERS_LIMIT_COUNT
				+ "）";
		selectCount.setText(text);
	}

	/**
	 * @Title: goToAddFriends
	 * @Description: 添加群组成员
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void goToAddFriends() {
		Intent intent = new Intent(mContext, AddGroupMemebersActivity.class);
		ArrayList<String> uids = new ArrayList<String>();
		for (int i = 0; i < arrayList.size(); i++) {
			uids.add(arrayList.get(i).getUid());
		}
		intent.putStringArrayListExtra(UtilRequest.FORM_OIDS, uids);
		intent.putExtra(UtilRequest.FORM_GROUP_ID, groupId);
		intent.putExtra(UtilRequest.FORM_NUMS, arrayList.size());
		intent.putExtra(UtilRequest.FROM_ACTIVITY, GroupMembersActivity.class.toString());
		startActivityForResult(intent, REQUSET_CODE_ADD_MEMBERS);
	}

	/**
	 * @Title: goBack
	 * @Description: 返回到群组设置
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void goBack() {
		Intent intent = new Intent();
		intent.putExtra(JsonParser.RESPONSE_DATA, arrayList);
		setResult(RESULT_OK, intent);
		finish();
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:// 添加成员
				if (firstLoad) {
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.getFriendsNums(J_Cache.sLoginUser.uid + "", 1, 1, mHandler, mContext);
				} else {
					goToAddFriends();
				}
				break;
			case R.id.titleLeftButton:// 返回
				goBack();
				break;
			default:
				break;
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS:// 好友数量
				int friendsNums = Util.getInteger(msg.obj.toString());
				if (friendsNums <= 0) {
					DialogUtils.dismissDialog();
					Intent noFriendsIntent = new Intent(mContext, NoFriendsActivity.class);
					startActivity(noFriendsIntent);
				} else {
					UtilRequest.getFriendsList(J_Cache.sLoginUser.uid + "", mHandler, mContext, 0, friendsNums);
					SharedPreUtil.setMyfriendsNums(friendsNums);
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL:// 所用好友
				DialogUtils.dismissDialog();
				firstLoad = false;
				goToAddFriends();
				break;
			case NetTaskIDs.TASKID_GROUP_MASTER_DEL_PERSON:// 群组踢人
				arrayList.remove(delPosition);
				adapter.notifyDataSetChanged();
				ArrayList<String> avatarList = new ArrayList<String>();
				for (int i = 0; i < arrayList.size(); i++) {
					if (i < 4) {
						avatarList.add(arrayList.get(i).getAvatar());
					}
				}
				String newPath = Util.createNewAvatar(avatarList, mContext);
				if (!Util.isBlankString(newPath)) {
					UtilRequest.updateGroupPic(newPath, groupId + "");
				}
				DialogUtils.dismissDialog();
				setCount();
				break;
			default:
				break;
			}
		};
	};

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (data == null) {
			return;
		}
		if (requestCode == REQUSET_CODE_ADD_MEMBERS) {// 添加新的好友
			if (data.hasExtra(JsonParser.RESPONSE_DATA)) {
				ArrayList<ManageFriendsBean> newMembers = (ArrayList<ManageFriendsBean>) data
						.getSerializableExtra(JsonParser.RESPONSE_DATA);
				for (int i = 0; i < newMembers.size(); i++) {
					newMembers.get(i).setChecked(false);
					newMembers.get(i).setJoinTime(System.currentTimeMillis() / 1000);
				}
				arrayList.addAll(newMembers);
				Collections.sort(arrayList, pinyinComparator);
				adapter.notifyDataSetChanged();
				setCount();
			}
		}
	};

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			goBack();
			return true;
		} else {
			return super.onKeyDown(keyCode, event);
		}
	}
}
