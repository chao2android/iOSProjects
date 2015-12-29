package com.iyouxun.ui.activity.find;

import android.content.Intent;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.baidu.platform.comapi.map.D;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.R;
import com.iyouxun.comparator.FriendsPinyinComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.CharacterParser;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.adapter.ManageFriendsAdapter;
import com.iyouxun.ui.dialog.FilterPopupWindow;
import com.iyouxun.ui.views.SideBar;
import com.iyouxun.ui.views.SideBar.OnTouchingLetterChangedListener;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

/**
 * @ClassName: ManageFriendsActivity
 * @Description: 管理一度好友
 * @author donglizhi
 * @date 2015年3月10日 下午4:31:07
 * 
 */
public class ManageFriendsActivity extends CommTitleActivity {
	protected static final int REQUEST_GROUP_LIST = 100;
	private RelativeLayout btnGruop;// 分组
	private TextView btnFilter;// 筛选
	private TextView friendsCount;// 好友数量
	private PullToRefreshListView friendsList;// 好友列表
	private ManageFriendsAdapter adapter;
	private final ArrayList<ManageFriendsBean> friendsArrayList = new ArrayList<ManageFriendsBean>();// 全部好友数据
	private final ArrayList<ManageFriendsBean> singleList = new ArrayList<ManageFriendsBean>();// 单身好友数据
	private final ArrayList<ManageFriendsBean> oppositeList = new ArrayList<ManageFriendsBean>();// 异性好友数据
	private FilterPopupWindow filterPop;
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	/** 根据拼音来排列ListView里面的数据类 */
	private FriendsPinyinComparator pinyinComparator;
	private SideBar sideBar;
	private int showType = 0;// 查看数据的类型0全部1只看单身2只看异性
	private TextView friendsGroupCount;// 好友分组数量
	private boolean firstLoadData = true;// 首次加载数据

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.manage_friends);
		titleLeftButton.setText(R.string.str_find);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_manage_friends, null);
	}

	@Override
	protected void initViews() {
		btnGruop = (RelativeLayout) findViewById(R.id.manage_friends_btn_group);
		btnFilter = (TextView) findViewById(R.id.manage_friends_btn_filter);
		friendsCount = (TextView) findViewById(R.id.manage_friends_count);
		friendsList = (PullToRefreshListView) findViewById(R.id.manage_friends_list);
		sideBar = (SideBar) findViewById(R.id.manage_friends_sidebar);
		friendsGroupCount = (TextView) findViewById(R.id.manage_friends_group_count);
		adapter = new ManageFriendsAdapter(mContext, friendsArrayList, listener);
		filterPop = new FilterPopupWindow(mContext, listener);
		friendsList.getRefreshableView().setAdapter(adapter);
		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		pinyinComparator = new FriendsPinyinComparator();
		btnFilter.setOnClickListener(listener);
		btnGruop.setOnClickListener(listener);
		// 获取分组数据
		UtilRequest.getFriendsGroupList(J_Cache.sLoginUser.uid + "", mHandler, mContext);

		int friendsNums = SharedPreUtil.getMyFriendsNums();
		String text = "共" + friendsNums + "个好友";
		friendsCount.setText(text);
		String myFriendsData = SharedPreUtil.getMyFriendsData();
		parserFriendsData(myFriendsData);
		// 进入页面后刷新数据
		firstLoadData = true;
		UtilRequest.getFriendsNums(J_Cache.sLoginUser.uid + "", 1, 1, mHandler, mContext);
		// 设置右侧触摸监听
		sideBar.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {
			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = adapter.getPositionForSection(s.charAt(0));
				if (position >= 0) {
					int index = position + 1;
					if (index >= 0) {
						friendsList.getRefreshableView().setSelection(index);
					}
				}
			}
		});
		friendsList.setScrollingWhileRefreshingEnabled(false);// 加载的时候不允许滑动
		friendsList.setPullToRefreshOverScrollEnabled(false);// 滑动到底部的时候的缓冲提示
		friendsList.setMode(Mode.PULL_FROM_END);
		friendsList.setOnItemClickListener(onItemClickListener);
		friendsList.setOnRefreshListener(new OnRefreshListener<ListView>() {

			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				if (firstLoadData) {// 首次加载数据更新用户一度好友数据
					UtilRequest.getFriendsNums(J_Cache.sLoginUser.uid + "", 1, 1, mHandler, mContext);
				} else {
					UtilRequest.getFriendsList(J_Cache.sLoginUser.uid + "", mHandler, mContext, friendsArrayList.size(),
							UtilRequest.GET_MY_FRIENDS_LIST_NUMS);
				}
			}

		});
	}

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			if (position > 0) {
				ManageFriendsBean bean = (ManageFriendsBean) adapter.getItem(position);
				if (bean.isHasRegistered()) {
					String uid = bean.getUid();
					if (!Util.isBlankString(uid) && !Util.isSystemMail(uid)) {
						long userId = Long.valueOf(uid);
						Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
						profileIntent.putExtra(UtilRequest.FORM_UID, userId);
						startActivity(profileIntent);
					}
				}
			}
		}
	};

	/**
	 * @Title: parserFriendsData
	 * @Description: 解析用户数据
	 * @return void 返回类型
	 * @param @param friendsData 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void parserFriendsData(String friendsData) {
		try {
			JSONObject dataObject = new JSONObject(friendsData);
			Iterator<String> it = dataObject.keys();
			while (it.hasNext()) {
				String key = it.next();
				JSONObject valueObject = JsonUtil.getJsonObject(dataObject, key);
				ManageFriendsBean bean = new ManageFriendsBean();
				int gid = valueObject.optInt(UtilRequest.FORM_GID);
				String uid = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_UID);
				bean.setGid(gid);
				bean.setUid(uid);
				if (valueObject.has(UtilRequest.FORM_GID) && gid != 100) {
					int sex = valueObject.optInt(UtilRequest.FORM_SEX);
					String nick = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_NICK);
					int marriage = valueObject.optInt(UtilRequest.FORM_MARRIAGE);
					JSONObject avatars = JsonUtil.getJsonObject(valueObject, UtilRequest.FORM_AVATARS);
					String avatarUrl = JsonUtil.getJsonString(avatars, UtilRequest.FORM_200);
					int mutualnums = valueObject.optInt(UtilRequest.FORM_MUTUALNUMS);
					bean.setAvatar(avatarUrl);
					bean.setChecked(false);
					bean.setHasRegistered(true);
					bean.setName(nick);
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
					friendsArrayList.add(bean);
				} else {
					String mobile = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_MOBILE);
					String nick = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_TRUENAME);
					bean.setMobile(mobile);
					bean.setName(nick);
					bean.setChecked(false);
					bean.setHasRegistered(false);
					bean.setSortLetter("@");
					bean.setMutualFriendsCount(-1);
					bean.setSex(-1);
					friendsArrayList.add(bean);
				}
			}
			// 根据a-z进行排序源数据
			Collections.sort(friendsArrayList, pinyinComparator);
			for (int i = 0; i < friendsArrayList.size(); i++) {// 排序后把@换成#
				if (friendsArrayList.get(i).getSortLetter().equals("@")) {
					friendsArrayList.get(i).setSortLetter("#");
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		switch (showType) {
		case 0:// 全部好友
			adapter.updateList(friendsArrayList);
			break;
		case 1:// 单身好友
			showSingleList();
			break;
		case 2:// 异性好友
			showOppositeList();
			break;
		default:
			adapter.updateList(friendsArrayList);
			break;
		}
	}

	/**
	 * @Title: showOppositeList
	 * @Description: 异性数据
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void showOppositeList() {
		oppositeList.clear();
		for (ManageFriendsBean bean : friendsArrayList) {
			if (bean.getSex() >= 0 && bean.getSex() != J_Cache.sLoginUser.sex) {
				oppositeList.add(bean);
			}
		}
		adapter.updateList(oppositeList);
	}

	/**
	 * @Title: showSingleList
	 * @Description: 单身数据
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void showSingleList() {
		singleList.clear();
		for (ManageFriendsBean bean : friendsArrayList) {
			if (bean.getMarriage() == 1) {// 单身
				singleList.add(bean);
			}
		}
		adapter.updateList(singleList);
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS:// 好友数量
				int friendsNums = Util.getInteger(msg.obj.toString());
				String text = "共" + friendsNums + "个好友";
				friendsCount.setText(text);
				if (friendsNums > 0) {
					if (friendsNums > UtilRequest.GET_MY_FRIENDS_LIST_NUMS) {
						UtilRequest.getFriendsList(J_Cache.sLoginUser.uid + "", mHandler, mContext, 0, friendsNums);
					} else {
						UtilRequest.getFriendsList(J_Cache.sLoginUser.uid + "", mHandler, mContext, 0,
								UtilRequest.GET_MY_FRIENDS_LIST_NUMS);
					}
				} else {// 没有一度好友，提示没有好友
					Intent noFriendsIntent = new Intent(mContext, NoFriendsActivity.class);
					noFriendsIntent.putExtra(UtilRequest.FORM_TYPE, 1);
					startActivity(noFriendsIntent);
					finish();
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL:// 所用好友
				if (firstLoadData) {
					friendsArrayList.clear();
					adapter.updateList(friendsArrayList);
					firstLoadData = false;
				}
				String friendsData = msg.obj.toString();
				if (!Util.isBlankString(friendsData) && !friendsData.equals("[]")) {
					parserFriendsData(friendsData);
					friendsList.onRefreshComplete();
				} else {
					friendsList.onRefreshComplete();
					friendsList.setMode(Mode.DISABLED);
					ToastUtil.showToast(mContext, getString(R.string.no_more_friends));
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_GROUP_LIST:// 获得分组列表
				String str = (String) msg.obj;
				try {
					JSONArray dataArray = new JSONArray(str);
					int groupNumber = dataArray.length();
					if (groupNumber > 0) {
						friendsGroupCount.setText("（" + groupNumber + "）");
					} else {
						friendsGroupCount.setText("");
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
				break;
			default:
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
			case R.id.manage_friends_btn_filter:// 筛选按钮
				filterPop.showAsDropDown(btnFilter, -120, 0);
				filterPop.setType(showType);
				break;
			case R.id.manage_friends_btn_group:// 好友分组
				Intent intent = new Intent(mContext, FriendsGroupActivity.class);
				startActivityForResult(intent, REQUEST_GROUP_LIST);
				break;
			case R.id.filter_friends_btn_all:// 所有好友
				showType = 0;
				adapter.updateList(friendsArrayList);
				filterPop.setType(showType);
				filterPop.dismiss();
				break;
			case R.id.filter_friends_btn_opposite:// 异性好友
				showType = 2;
				showOppositeList();
				filterPop.setType(showType);
				filterPop.dismiss();
				break;
			case R.id.filter_friends_btn_single:// 单身好友
				showType = 1;
				showSingleList();
				filterPop.setType(showType);
				filterPop.dismiss();
				break;
			case R.id.friends_btn_invitation:// 邀请按钮
				ManageFriendsBean bean = (ManageFriendsBean) v.getTag();
				String toNumbers = bean.getMobile();
				Util.sendSMS(toNumbers, mContext);
				break;
			case R.id.friends_icon:// 跳转到个人主页
				ManageFriendsBean friendBean = (ManageFriendsBean) v.getTag();
				String code = friendBean.getMobile();
				String uid = friendBean.getUid();
				String nick = friendBean.getName();
				int gid = friendBean.getGid();
				if (!Util.isBlankString(uid) && gid != 100) {
					long userId = Long.valueOf(uid);
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra(UtilRequest.FORM_UID, userId);
					startActivity(profileIntent);
				} else {// 未注册的用户
					if (!Util.isBlankString(uid)){
					Intent notJoinIntent = new Intent(mContext, NotJoinUserActivity.class);
					notJoinIntent.putExtra(UtilRequest.FORM_CODE, code);
					notJoinIntent.putExtra(UtilRequest.FORM_NICK, nick);
					notJoinIntent.putExtra(UtilRequest.FORM_UID, uid);
					startActivity(notJoinIntent);
					}
				}
				break;
			default:
				break;
			}
		}
	};

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (data != null && data.hasExtra(JsonParser.RESPONSE_DATA)) {
			int groupCount = data.getIntExtra(JsonParser.RESPONSE_DATA, 0);
			if (groupCount > 0) {
				friendsGroupCount.setText("（" + groupCount + "）");
			} else {
				friendsGroupCount.setText("");
			}
		}
	};
}
