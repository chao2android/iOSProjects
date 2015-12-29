package com.iyouxun.ui.activity.find;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.text.format.DateFormat;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
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
import com.iyouxun.ui.activity.setting.SettingBlackListActivity;
import com.iyouxun.ui.adapter.SelectFriendsAdapter;
import com.iyouxun.ui.dialog.FilterPopupWindow;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.ui.views.SideBar;
import com.iyouxun.ui.views.SideBar.OnTouchingLetterChangedListener;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: SelectFriendsActivity
 * @Description: 选择好友
 * @author donglizhi
 * @date 2015年3月11日 下午1:21:50
 * 
 */
public class SelectFriendsActivity extends CommTitleActivity {
	private TextView btnFilter;// 筛选按钮
	private Button btnOk;// 确认按钮
	private TextView friendsCount;// 好友数量
	private LinearLayout selectedLinearLayout;// 选中的好友
	private PullToRefreshListView friendsList;// 好友列表
	private SelectFriendsAdapter adapter;
	private final ArrayList<ManageFriendsBean> arrayList = new ArrayList<ManageFriendsBean>();
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	/** 根据拼音来排列ListView里面的数据类 */
	private FriendsPinyinComparator pinyinComparator;
	private SideBar sideBar;
	private FilterPopupWindow filterPop;
	private final ArrayList<ManageFriendsBean> selectdata = new ArrayList<ManageFriendsBean>();
	private ArrayList<String> uids;// 已经选择过得用户id
	private String groupId;// 分组id
	private final ArrayList<ManageFriendsBean> singleList = new ArrayList<ManageFriendsBean>();// 单身好友数据
	private final ArrayList<ManageFriendsBean> oppositeList = new ArrayList<ManageFriendsBean>();// 异性好友数据
	/** 页面类型：0:普通的添加分组选择好友，1：选择黑名单添加好友 */
	private int pageType = 0;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.select_friends);
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_select_friends, null);
	}

	@Override
	protected void initViews() {
		if (getIntent().hasExtra(UtilRequest.HAS_SELET_DATA)) {
			uids = getIntent().getStringArrayListExtra(UtilRequest.HAS_SELET_DATA);
		}
		if (getIntent().hasExtra(UtilRequest.FORM_GROUP_ID)) {
			groupId = getIntent().getStringExtra(UtilRequest.FORM_GROUP_ID);
		}
		if (getIntent().hasExtra("pageType")) {
			pageType = getIntent().getIntExtra("pageType", 0);
		}

		btnFilter = (TextView) findViewById(R.id.select_friends_btn_filter);
		btnOk = (Button) findViewById(R.id.select_friends_btn_ok);
		friendsCount = (TextView) findViewById(R.id.select_friends_count);
		selectedLinearLayout = (LinearLayout) findViewById(R.id.select_friends_selected);
		friendsList = (PullToRefreshListView) findViewById(R.id.select_friends_list);
		sideBar = (SideBar) findViewById(R.id.select_friends_sidebar);

		friendsList.setMode(Mode.DISABLED);
		int nums = SharedPreUtil.getMyFriendsNums();
		if (pageType == 1) {
			// 黑名单好友
			nums = SharedPreUtil.getFriendsNum(3);
		}
		// 好友数量信息
		friendsCount.setText("共" + nums + "个好友");

		View emptyView = View.inflate(mContext, R.layout.empty_layer, null);
		TextView emptyTv = (TextView) emptyView.findViewById(R.id.emptyTv);
		emptyTv.setText("没有好友信息");
		friendsList.setEmptyView(emptyView);

		adapter = new SelectFriendsAdapter(mContext, arrayList);
		friendsList.setAdapter(adapter);

		btnFilter.setOnClickListener(listener);
		btnOk.setOnClickListener(listener);
		friendsList.setOnItemClickListener(onItemClickListener);
		filterPop = new FilterPopupWindow(mContext, listener);
		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		pinyinComparator = new FriendsPinyinComparator();

		// 普通的添加分组选择好友
		if (pageType == 1) {
			// 黑名单好友
			String friendsData = SharedPreUtil.getMyFriendsAllData();
			if (Util.isBlankString(friendsData)) {
				ToastUtil.showToast(mContext, "没有好友信息");
			} else {
				parserFriendsData(friendsData);
			}
		} else {
			// 普通的添加分组选择好友
			String friendsData = SharedPreUtil.getMyFriendsData();
			if (Util.isBlankString(friendsData)) {
				UtilRequest.getFriends(J_Cache.sLoginUser.uid + "", 1, 0, nums, mHandler, mContext);
			} else {
				parserFriendsData(friendsData);
			}
		}

		// 设置右侧触摸监听
		sideBar.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {
			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = adapter.getPositionForSection(s.charAt(0));
				if (position != -1) {
					friendsList.getRefreshableView().setSelection(position);
				}
			}
		});
	}

	/**
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
					if (uids != null && uids.size() > 0 && uids.contains(uid)) {
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
					if (pageType == 0) {// 好友分组添加好友都是一度好友
						bean.setRelation(1);
					} else {
						if (valueObject.has("f_dimension")) {
							int relation = valueObject.optInt("f_dimension");
							bean.setRelation(relation);
						}
					}
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
			String text = "共" + arrayList.size() + "个好友";
			friendsCount.setText(text);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		adapter.notifyDataSetChanged();
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS:// 获得好友数据
				String friendsData = msg.obj.toString();
				parserFriendsData(friendsData);
				break;
			case NetTaskIDs.TASKID_FRIENDS_CREATE_GROUP:// 创建临时用户分组
				groupId = msg.obj.toString();
				addGroupMemebers();
				break;
			case NetTaskIDs.TASKID_FRIENDS_ADD_GROUP_MEMBERS:// 添加分组成员
				DialogUtils.dismissDialog();
				if (uids != null) {
					Intent resultIntent = new Intent();
					resultIntent.putExtra(JsonParser.RESPONSE_DATA, selectdata);
					setResult(RESULT_OK, resultIntent);
					finish();
				} else {
					Intent editIntent = new Intent(mContext, EditFriendsGroupActivity.class);
					editIntent.putExtra(JsonParser.RESPONSE_DATA, selectdata);
					editIntent.putExtra(UtilRequest.FORM_GROUP_ID, groupId);
					startActivity(editIntent);
					finish();
				}
				break;
			default:
				break;
			}
		};
	};

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			int realPosition = position - friendsList.getRefreshableView().getHeaderViewsCount();

			ManageFriendsBean bean = (ManageFriendsBean) adapter.getItem(realPosition);
			if (bean.isChecked()) {
				bean.setChecked(false);
			} else {
				bean.setChecked(true);
			}
			selectedLinearLayout.removeAllViews();
			selectdata.clear();
			int checkCount = 0;
			for (int i = 0; i < arrayList.size(); i++) {
				if (arrayList.get(i).getUid().equals(bean.getUid())) {
					arrayList.get(i).setChecked(bean.isChecked());
				}
				if (arrayList.get(i).isChecked()) {
					checkCount++;
					View item_view = View.inflate(mContext, R.layout.select_friends_item, null);
					CircularImage avatar = (CircularImage) item_view.findViewById(R.id.select_friends_avatar_icn);
					J_NetManager.getInstance().loadIMG(null, arrayList.get(i).getAvatar(), avatar, 0, 0);
					selectedLinearLayout.addView(item_view);
					selectdata.add(arrayList.get(i));
				}
			}
			if (checkCount > 0) {
				btnOk.setText("确定（" + checkCount + "）");
			} else {
				btnOk.setText(R.string.dialog_btn_ok);
			}

			adapter.notifyDataSetChanged();
		}
	};

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 头部左侧按钮
				finish();
				break;
			case R.id.select_friends_btn_filter:// 筛选按钮
				filterPop.showAsDropDown(btnFilter, -120, 0);
				break;
			case R.id.select_friends_btn_ok:// 确定按钮
				if (selectdata.size() <= 0) {
					ToastUtil.showToast(mContext, getString(R.string.you_must_select_one_friend));
				} else {
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					if (pageType == 0) {
						if (uids != null) {
							addGroupMemebers();
						} else {
							long now = System.currentTimeMillis();
							String groupName = DateFormat.format("yyyy/MM/dd", now).toString() + "（草稿）";
							UtilRequest.friendsCreateGroup(J_Cache.sLoginUser.uid + "", groupName, mHandler, mContext);
						}
					} else {
						DialogUtils.dismissDialog();
						// 添加黑名单
						Intent dataIntent = new Intent();
						dataIntent.putExtra("friendsData", selectdata);
						setResult(SettingBlackListActivity.RESULT_CODE_SELECT_FRIENDS, dataIntent);
						finish();
					}
				}
				break;
			case R.id.filter_friends_btn_all:// 所有好友
				adapter.updateDatas(arrayList);
				filterPop.dismiss();
				break;
			case R.id.filter_friends_btn_opposite:// 异性好友
				oppositeList.clear();
				for (ManageFriendsBean bean : arrayList) {
					if (bean.getSex() >= 0 && bean.getSex() != J_Cache.sLoginUser.sex) {
						oppositeList.add(bean);
					}
				}
				adapter.updateDatas(oppositeList);
				filterPop.dismiss();
				break;
			case R.id.filter_friends_btn_single:// 单身好友
				singleList.clear();
				for (ManageFriendsBean bean : arrayList) {
					if (bean.getMarriage() == 1) {
						singleList.add(bean);
					}
				}
				adapter.updateDatas(singleList);
				filterPop.dismiss();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * @Title: addGroupMemebers
	 * @Description: 添加群组成员
	 * @return String 返回类型
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void addGroupMemebers() {
		StringBuilder sb = new StringBuilder();
		for (ManageFriendsBean bean : selectdata) {
			if (!Util.isBlankString(bean.getUid())) {
				sb.append(bean.getUid());
				sb.append(",");
			} else {
				continue;
			}
		}
		if (sb.length() > 0) {
			String uidSelected = sb.substring(0, sb.length() - 1);
			UtilRequest.addFriendsGroupMembers(J_Cache.sLoginUser.uid + "", uidSelected, groupId, mHandler, mContext);
		}
	}
}
