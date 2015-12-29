package com.iyouxun.ui.activity.find;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.GridView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.comparator.FriendsPinyinComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.FriendsGroupBean;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.CharacterParser;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.EditGroupAdapter;
import com.iyouxun.ui.views.ClearEditText;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: EditFriendsGroupActivity
 * @Description: 编辑好友分组页面
 * @author donglizhi
 * @date 2015年3月24日 下午7:26:39
 * 
 */
public class EditFriendsGroupActivity extends CommTitleActivity {
	private static final int REQUEST_SELECT_FRIENDS = 100;
	private ClearEditText groupNameEditText;// 分组名
	private GridView gridView;// 分组成员
	private EditGroupAdapter adapter;
	private final ArrayList<ManageFriendsBean> arrayList = new ArrayList<ManageFriendsBean>();
	private TextView memberCount;// 成员数量
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	/** 根据拼音来排列ListView里面的数据类 */
	private FriendsPinyinComparator pinyinComparator;
	private String groupId = "";// 分组id
	private int groupMemebersCount = 0;// 分组成员数量
	private String groupNameString;// 分组名
	private int delPosition = -1;// 删除的数据
	private boolean isCreate = false;// 是否是新建分组

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleLeftButton.setText(R.string.go_back);
		titleRightButton.setText(R.string.str_save);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleRightButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_edit_friends_group, null);
	}

	@Override
	protected void initViews() {
		groupNameEditText = (ClearEditText) findViewById(R.id.edit_group_name);
		gridView = (GridView) findViewById(R.id.edit_group_gridview);
		memberCount = (TextView) findViewById(R.id.edit_group_count);
		adapter = new EditGroupAdapter(mContext, arrayList);
		gridView.setAdapter(adapter);
		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		pinyinComparator = new FriendsPinyinComparator();

		gridView.setOnItemClickListener(onItemClickListener);
		if (getIntent().hasExtra(UtilRequest.FORM_FORM)) {// 编辑分组
			titleCenter.setText(R.string.edit_group);
			isCreate = false;
			FriendsGroupBean bean = (FriendsGroupBean) getIntent().getSerializableExtra(UtilRequest.FORM_FORM);
			String text = getString(R.string.str_member) + " (" + bean.getGroupMembersCount() + ")";
			memberCount.setText(text);
			groupNameEditText.setText(bean.getGroupName());
			groupNameEditText.setSelection(bean.getGroupName().length());
			groupId = bean.getGroupId();
			groupMemebersCount = bean.getGroupMembersCount();
			groupNameString = bean.getGroupName();
			UtilRequest.getFriendsGroupMembers(J_Cache.sLoginUser.uid + "", bean.getGroupId(), 0, bean.getGroupMembersCount(),
					mHandler, mContext);
		} else if (getIntent().hasExtra(JsonParser.RESPONSE_DATA)) {// 新建分组
			titleCenter.setText(R.string.save_group);
			isCreate = true;
			if (getIntent().hasExtra(UtilRequest.FORM_GROUP_ID)) {
				groupId = getIntent().getStringExtra(UtilRequest.FORM_GROUP_ID);
			}
			arrayList.clear();
			ArrayList<ManageFriendsBean> tempList = (ArrayList<ManageFriendsBean>) getIntent().getSerializableExtra(
					JsonParser.RESPONSE_DATA);
			arrayList.addAll(tempList);
			String text = getString(R.string.str_member) + " (" + arrayList.size() + ")";
			groupMemebersCount = arrayList.size();
			addAddDelBtnData();
			memberCount.setText(text);
			adapter.notifyDataSetChanged();
		}

	}

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			int type = arrayList.get(position).getDataType();
			switch (type) {
			case 0:// 用户数据
				if (adapter.isShowDel()) {
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.removeGroupMembers(J_Cache.sLoginUser.uid + "", arrayList.get(position).getUid(), groupId,
							mHandler, mContext);
					delPosition = position;
				}
				break;
			case 1:// 添加按钮
				Util.hideKeyboard(mContext, groupNameEditText);
				ArrayList<String> uids = new ArrayList<String>();
				for (ManageFriendsBean bean : arrayList) {
					uids.add(bean.getUid());
				}
				Intent selectIntent = new Intent(mContext, SelectFriendsActivity.class);
				selectIntent.putStringArrayListExtra(UtilRequest.HAS_SELET_DATA, uids);
				selectIntent.putExtra(UtilRequest.FORM_GROUP_ID, groupId);
				startActivityForResult(selectIntent, REQUEST_SELECT_FRIENDS);
				break;
			case 2:// 删除按钮
				if (adapter.isShowDel()) {
					adapter.setShowDel(false);
				} else {
					adapter.setShowDel(true);
				}
				Util.hideKeyboard(mContext, groupNameEditText);
				adapter.notifyDataSetChanged();
				break;
			default:
				break;
			}
		}
	};

	private void addAddDelBtnData() {
		ManageFriendsBean addBean = new ManageFriendsBean();
		addBean.setName(getString(R.string.str_add));
		addBean.setDataType(1);
		arrayList.add(addBean);
		ManageFriendsBean delBean = new ManageFriendsBean();
		delBean.setName(getString(R.string.str_del));
		delBean.setDataType(2);
		arrayList.add(delBean);
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:// 保存按钮
				String nameString = groupNameEditText.getText().toString().trim();
				if (Util.isBlankString(nameString) && nameString.length() < 1) {
					ToastUtil.showToast(mContext, "分组名不可为空");
				} else if (groupMemebersCount <= 0) {
					ToastUtil.showToast(mContext, "请至少选择一位好友");
				} else {
					DialogUtils.showProgressDialog(mContext, "正在保存...");
					String group_name = groupNameEditText.getText().toString();
					UtilRequest.modFriendsGroup(J_Cache.sLoginUser.uid + "", groupId, group_name, mHandler, mContext);
				}
				break;
			case R.id.titleLeftButton:// 返回按钮

				if (isCreate || groupMemebersCount == 0) {
					UtilRequest.delFriendsGroup(J_Cache.sLoginUser.uid + "", groupId, mHandler, mContext, false);
					if (groupMemebersCount == 0) {
						delFriendGroupData();
					}
				} else {
					if (arrayList.size() > 2) {
						groupMemebersCount = arrayList.size() - 2;
					} else {
						groupMemebersCount = 0;
					}
					updateFriendsGroupData();
				}
				finish();
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
			case NetTaskIDs.TASKID_FRIENDS_REMOVE_GROUP_MEMBERS:// 移除分组成员
				DialogUtils.dismissDialog();
				arrayList.remove(delPosition);
				if (arrayList.size() > 2) {
					groupMemebersCount = arrayList.size() - 2;
				} else {
					groupMemebersCount = 0;
				}
				String text = getString(R.string.str_member) + " (" + groupMemebersCount + ")";
				memberCount.setText(text);
				adapter.notifyDataSetChanged();
				break;
			case NetTaskIDs.TASKID_FRIENDS_MOD_GROUP:// 修改分组名
				DialogUtils.dismissDialog();
				groupNameString = groupNameEditText.getText().toString();
				if (arrayList.size() > 2) {
					groupMemebersCount = arrayList.size() - 2;
				} else {
					groupMemebersCount = 0;
				}
				updateFriendsGroupData();
				finish();
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_GROUP_MEMBERS:// 分组成员数据
				try {
					JSONObject dataObject = new JSONObject(msg.obj.toString());
					Iterator<String> it = dataObject.keys();
					while (it.hasNext()) {
						String key = it.next();
						JSONObject valueObject = JsonUtil.getJsonObject(dataObject, key);
						ManageFriendsBean bean = new ManageFriendsBean();
						String uid = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_UID);
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
						bean.setSex(sex);
						arrayList.add(bean);
					}
					// 根据a-z进行排序源数据
					Collections.sort(arrayList, pinyinComparator);
					addAddDelBtnData();
					adapter.notifyDataSetChanged();
				} catch (JSONException e) {
					e.printStackTrace();
				}
				break;
			default:
				break;
			}
		};
	};

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (data != null && data.hasExtra(JsonParser.RESPONSE_DATA)) {
			ArrayList<ManageFriendsBean> tempList = (ArrayList<ManageFriendsBean>) data
					.getSerializableExtra(JsonParser.RESPONSE_DATA);
			if (tempList.size() > 0) {
				arrayList.remove(arrayList.size() - 1);
				arrayList.remove(arrayList.size() - 1);
				arrayList.addAll(tempList);
				Collections.sort(arrayList, pinyinComparator);
				addAddDelBtnData();
				adapter.setShowDel(false);
				if (arrayList.size() > 2) {
					groupMemebersCount = arrayList.size() - 2;
				} else {
					groupMemebersCount = 0;
				}
				String text = getString(R.string.str_member) + " (" + groupMemebersCount + ")";
				memberCount.setText(text);
				adapter.notifyDataSetChanged();
			}
		}
	};

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if (isCreate || groupMemebersCount == 0) {
				UtilRequest.delFriendsGroup(J_Cache.sLoginUser.uid + "", groupId, mHandler, mContext, false);
				if (groupMemebersCount == 0) {
					delFriendGroupData();
				}
			} else {
				if (arrayList.size() > 2) {
					groupMemebersCount = arrayList.size() - 2;
				} else {
					groupMemebersCount = 0;
				}
				updateFriendsGroupData();
			}
			finish();
			return true;
		} else {
			return super.onKeyDown(keyCode, event);
		}

	}

	/**
	 * @Title: updateFriendsGroupData
	 * @Description: 更新好友分组数据
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void updateFriendsGroupData() {
		String friendsGroupData = SharedPreUtil.getFriendsGroupData();
		try {
			JSONArray array = new JSONArray(friendsGroupData);
			JSONArray bean = new JSONArray();
			bean.put(groupId);
			bean.put(groupNameString);
			bean.put(groupMemebersCount);
			if (isCreate) {
				array.put(bean);
			} else {
				for (int i = 0; i < array.length(); i++) {
					JSONArray item = array.optJSONArray(i);
					String arrayGroupId = item.optString(0);
					if (groupId.equals(arrayGroupId)) {
						array.put(i, bean);
						break;
					}
				}
			}
			SharedPreUtil.setFriendsGroupData(array.toString());
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void delFriendGroupData() {

		String friendsGroupData = SharedPreUtil.getFriendsGroupData();
		try {
			JSONArray array = new JSONArray(friendsGroupData);
			JSONArray newArray = new JSONArray();
			for (int i = 0; i < array.length(); i++) {
				JSONArray item = array.optJSONArray(i);
				String arrayGroupId = item.optString(0);
				if (groupId.equals(arrayGroupId)) {
					continue;
				}
				newArray.put(item);
			}
			SharedPreUtil.setFriendsGroupData(newArray.toString());
		} catch (JSONException e) {
			e.printStackTrace();
		}

	}
}
