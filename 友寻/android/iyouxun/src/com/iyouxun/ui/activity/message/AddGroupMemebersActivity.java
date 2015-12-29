package com.iyouxun.ui.activity.message;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.comparator.FriendsPinyinComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.CharacterParser;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.SelectFriendsAdapter;
import com.iyouxun.ui.views.SideBar;
import com.iyouxun.ui.views.SideBar.OnTouchingLetterChangedListener;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: AddGroupMemebersActivity
 * @Description:添加群组成员
 * @author donglizhi
 * @date 2015年3月31日 上午11:37:43
 * 
 */
public class AddGroupMemebersActivity extends CommTitleActivity {
	private TextView btnAll;// 全选按钮
	private TextView selectCount;// 选择数量
	private ListView friendsList;// 好友列表
	private SelectFriendsAdapter adapter;
	/** 好友数据 */
	private final ArrayList<ManageFriendsBean> arrayList = new ArrayList<ManageFriendsBean>();
	/** 选中的好友数据 */
	private final ArrayList<ManageFriendsBean> selectedList = new ArrayList<ManageFriendsBean>();
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	/** 根据拼音来排列ListView里面的数据类 */
	private FriendsPinyinComparator pinyinComparator;
	private SideBar sideBar;
	private ArrayList<String> oids = new ArrayList<String>();// 选过的uid
	private String fromActivity = "";// 跳转来源页面
	private String groupId = "";// 群组id
	private int exsitingNums = 0;// 已经存在的成员数量已有分组添加成员时使用

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.create_group);
		titleLeftButton.setText(R.string.str_message_1);
		titleRightButton.setText(R.string.str_save);
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
		mContext = AddGroupMemebersActivity.this;
		J_NetManager.getInstance().loadIMG(null, J_Cache.sLoginUser.avatarUrl150, new ImageView(mContext), 0, 0);
		btnAll = (TextView) findViewById(R.id.add_group_members_btn_all);
		selectCount = (TextView) findViewById(R.id.add_group_members_selected_count);
		sideBar = (SideBar) findViewById(R.id.add_group_members_select_friends_sidebar);
		friendsList = (ListView) findViewById(R.id.add_group_members_select_friends_list);
		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		pinyinComparator = new FriendsPinyinComparator();
		adapter = new SelectFriendsAdapter(mContext, arrayList);
		friendsList.setAdapter(adapter);
		btnAll.setOnClickListener(listener);
		friendsList.setOnItemClickListener(onItemClickListener);
		if (getIntent().hasExtra(UtilRequest.FORM_OIDS)) {// 需要在解析数据之前初始化
			oids = getIntent().getStringArrayListExtra(UtilRequest.FORM_OIDS);
		}
		if (getIntent().hasExtra(UtilRequest.FORM_NUMS)) {// 需要在解析数据之前初始化
			exsitingNums = getIntent().getIntExtra(UtilRequest.FORM_NUMS, 0);
		}
		if (getIntent().hasExtra(UtilRequest.FROM_ACTIVITY)) {
			fromActivity = getIntent().getStringExtra(UtilRequest.FROM_ACTIVITY);
		}
		if (getIntent().hasExtra(UtilRequest.FORM_GROUP_ID)) {
			groupId = getIntent().getStringExtra(UtilRequest.FORM_GROUP_ID);
		}
		int nums = SharedPreUtil.getMyFriendsNums();
		String friendsData = SharedPreUtil.getMyFriendsData();
		if (Util.isBlankString(friendsData)) {// 没有数据就去请求数据
			UtilRequest.getFriends(J_Cache.sLoginUser.uid + "", 1, 0, nums, mHandler, mContext);
		} else {
			parserFriendsData(friendsData);
		}
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
		if (fromActivity.equals(GroupMembersActivity.class.toString())) {// 添加成员的标题和返回按钮
			titleCenter.setText(R.string.add_members);
			titleLeftButton.setText(R.string.go_back);
		}
	}

	private void setCount() {
		String text = String.format(getResources().getString(R.string.message_group_members_limit),
				UtilRequest.GROUP_MEMBERS_LIMIT_COUNT)
				+ "（"
				+ (selectedList.size() + exsitingNums)
				+ "/"
				+ UtilRequest.GROUP_MEMBERS_LIMIT_COUNT + "）";
		selectCount.setText(text);
		if ((selectedList.size() + exsitingNums) >= UtilRequest.GROUP_MEMBERS_LIMIT_COUNT
				|| (selectedList.size()) == arrayList.size()) {
			btnAll.setText("取消全选");
		} else {
			btnAll.setText("全选");
		}
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS:// 获得好友数据
				String friendsData = msg.obj.toString();
				parserFriendsData(friendsData);
				break;
			case NetTaskIDs.TASKID_INVITE_FRIEND_JOIN_GROUP:// 邀请好友加入群组
				Intent intent = new Intent();
				intent.putExtra(JsonParser.RESPONSE_DATA, selectedList);
				setResult(RESULT_OK, intent);
				finish();
				break;
			case NetTaskIDs.TASKID_GROUP_CREATE_GROUP:// 创建一个新群组
				DialogUtils.dismissDialog();
				try {
					JSONObject object = new JSONObject(msg.obj.toString());
					int retcode = object.optInt(JsonParser.RESPONSE_RETCODE);
					String retmean = object.optString(JsonParser.RESPONSE_RETMEAN);
					if (retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(retmean)) {
						JSONObject data = object.optJSONObject(JsonParser.RESPONSE_DATA);
						if (data != null) {// 新建群组成功后跳转到群组聊天页
							int newGroupId = data.optInt(UtilRequest.FORM_GROUP_ID);
							if (newGroupId > 0) {
								Intent groupIntent = new Intent(mContext, ChatMainActivity.class);
								groupIntent.putExtra(UtilRequest.FORM_GROUP_ID, newGroupId);
								startActivity(groupIntent);
								finish();
								break;
							}
						}
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
				ToastUtil.showToast(mContext, "创建失败，请再次尝试");
				break;
			default:
				break;
			}
		};
	};

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			if ((selectedList.size() + exsitingNums) < UtilRequest.GROUP_MEMBERS_LIMIT_COUNT) {// 群组最多人数
				if (arrayList.get(position).isChecked()) {
					arrayList.get(position).setChecked(false);
					selectedList.remove(arrayList.get(position));
				} else {
					arrayList.get(position).setChecked(true);
					selectedList.add(arrayList.get(position));
				}
				adapter.notifyDataSetChanged();
				setCount();
			}
		}
	};

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:// 保存
				if (selectedList.size() <= 0) {
					ToastUtil.showToast(mContext, "请至少选择一位好友");
				} else {
					if (fromActivity.equals(GroupMembersActivity.class.toString())) {// 编辑群组
						StringBuilder sb = new StringBuilder();
						for (int i = 0; i < selectedList.size(); i++) {
							sb.append(selectedList.get(i).getUid());
							if (i != selectedList.size() - 1) {
								sb.append(",");
							}
						}
						DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
						UtilRequest.inviteFriendJoinGroup(sb.toString(), groupId, mHandler, mContext);
					} else {// 新建群组
						DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
						ArrayList<String> avatarList = new ArrayList<String>();
						avatarList.add(J_Cache.sLoginUser.avatarUrl150);
						for (int i = 0; i < selectedList.size(); i++) {
							if (i < 3) {
								avatarList.add(selectedList.get(i).getAvatar());
							}
						}
						String newPath = Util.createNewAvatar(avatarList, mContext);
						if (!Util.isBlankString(newPath)) {
							StringBuilder nickSb = new StringBuilder();
							StringBuilder oidSb = new StringBuilder();
							for (int i = 0; i < selectedList.size(); i++) {
								nickSb.append(selectedList.get(i).getName());
								oidSb.append(selectedList.get(i).getUid());
								if (i != selectedList.size() - 1) {
									nickSb.append("、");
									oidSb.append(",");
								}
							}
							String title = "";
							if (nickSb.length() > 20) {
								title = nickSb.substring(0, 17) + "...";
							} else {
								title = nickSb.toString();
							}
							UtilRequest.createGroup(newPath, title, oidSb.toString(), mHandler, mContext);
						}
					}
				}
				break;
			case R.id.titleLeftButton:// 返回
				finish();
				break;
			case R.id.add_group_members_btn_all:// 全选
				if (selectedList.size() == arrayList.size()
						|| (selectedList.size() + exsitingNums + 1) >= UtilRequest.GROUP_MEMBERS_LIMIT_COUNT) {
					// 全反选
					selectedList.clear();
					for (int i = 0; i < arrayList.size(); i++) {
						arrayList.get(i).setChecked(false);
					}
					adapter.notifyDataSetChanged();
				} else {
					// 全选
					for (int i = 0; i < arrayList.size(); i++) {
						if ((selectedList.size() + exsitingNums + 1) > UtilRequest.GROUP_MEMBERS_LIMIT_COUNT) {
							break;
						} else {
							if (!arrayList.get(i).isChecked()) {
								arrayList.get(i).setChecked(true);
								selectedList.add(arrayList.get(i));
							}
						}
					}
					adapter.notifyDataSetChanged();
				}
				setCount();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * @Title: parserFriendsData
	 * @Description: 解析好友数据列表
	 * @return void 返回类型
	 * @param @param friendsData 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void parserFriendsData(String friendsData) {
		arrayList.clear();
		try {
			JSONObject dataObject = new JSONObject(friendsData);
			Iterator<String> it = dataObject.keys();
			while (it.hasNext()) {
				String key = it.next();
				JSONObject valueObject = JsonUtil.getJsonObject(dataObject, key);
				if (valueObject.has(UtilRequest.FORM_UID)) {
					ManageFriendsBean bean = new ManageFriendsBean();
					bean.setDataType(0);
					String uid = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_UID);
					if (oids.size() > 0 && oids.contains(uid)) {
						continue;
					}
					int sex = valueObject.optInt(UtilRequest.FORM_SEX);
					String nick = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_NICK);
					int marriage = valueObject.optInt(UtilRequest.FORM_MARRIAGE);
					JSONObject avatars = JsonUtil.getJsonObject(valueObject, UtilRequest.FORM_AVATARS);
					String avatarUrl = JsonUtil.getJsonString(avatars, UtilRequest.FORM_200);
					int mutualnums = valueObject.optInt(UtilRequest.FORM_MUTUALNUMS);
					bean.setDataType(0);
					bean.setAvatar(avatarUrl);
					bean.setChecked(false);
					bean.setHasRegistered(true);
					bean.setName(nick);
					bean.setUid(uid);
					bean.setMutualFriendsCount(mutualnums);
					bean.setSex(sex);
					bean.setMarriage(marriage);
					bean.setRelation(1);
					// 汉字转换成拼音
					if (Util.isBlankString(nick)) {
						bean.setSortLetter("#");
					} else {
						String pinyin = characterParser.getSelling(nick);
						String sortString = pinyin.substring(0, 1).toUpperCase();

						// 正则表达式，判断首字母是否是英文字母
						if (sortString.matches("[A-Z]")) {
							bean.setSortLetter(sortString.toUpperCase());
						} else {
							bean.setSortLetter("#");
						}
					}
					arrayList.add(bean);
				}
			}
			// 根据a-z进行排序源数据
			Collections.sort(arrayList, pinyinComparator);
			adapter.notifyDataSetChanged();
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

}
