package com.iyouxun.ui.activity.find;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.comparator.FriendsPinyinComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.FilterIndirectBeans;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.CharacterParser;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.location.J_LocationPoint;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.adapter.IndirectFilterAdapter;
import com.iyouxun.ui.adapter.IndirectFriendsAdapter;
import com.iyouxun.ui.views.SideBar;
import com.iyouxun.ui.views.SideBar.OnTouchingLetterChangedListener;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;
import com.iyouxun.utils.Util.OnAnimationCallBack;
import com.iyouxun.utils.WorkLocation;

/**
 * @ClassName: FindIndirectFriendsActivity
 * @Description: 发现二度好友
 * @author donglizhi
 * 
 */
public class FindIndirectFriendsActivity extends CommTitleActivity {
	private TextView friendsCount;// 好友数量
	private PullToRefreshListView friendList;// 好友列表
	private GridView signGridView;// 星座数据
	private ImageView btnSign;// 星座展开按钮
	private TextView btnSignUnlimited;// 星座不限按钮
	private LinearLayout llSign;// 星座数据区域
	private ArrayList<FilterIndirectBeans> signArray;// 星座数据
	private IndirectFilterAdapter signAdapter;// 星座适配器
	private GridView areaGridView;// 地区数据
	private ImageView btnArea;// 地区展开按钮
	private TextView btnAreaUnlimited;// 地区不限按钮
	private LinearLayout llArea;// 地区数据区域
	private ArrayList<FilterIndirectBeans> areaArray;// 地区数据
	private IndirectFilterAdapter areaAdapter;// 地区适配器
	private LinearLayout tagView;// 标签数据
	private ImageView btnTag;// 标签展开按钮
	private TextView btnTagUnlimited;// 标签不限按钮
	private LinearLayout llTag;// 标签数据区域
	private ArrayList<FilterIndirectBeans> tagArray;// 标签数据
	private GridView heightGridView;// 身高数据
	private ImageView btnHeight;// 身高展开按钮
	private TextView btnHeightUnlimited;// 身高不限按钮
	private LinearLayout llHeight;// 身高数据区域
	private RelativeLayout heightBox;// 身高区域
	private ArrayList<FilterIndirectBeans> heightArray;// 身高数据
	private IndirectFilterAdapter heightAdapter;// 身高适配器
	private Button btnReset;// 重置按钮
	private Button btnOk;// 确定按钮
	private EditText minAge;// 筛选的最小年龄
	private EditText maxAge;// 筛选的最大年龄
	private View filterView;// 筛选视图
	private TextView simpleFilterSexNolimit;// 简单筛选性别不限
	private TextView simpleFilterSexMale;// 简单筛选性别男
	private TextView simpleFilterSexFamale;// 简单筛选性别女
	private TextView simpleFilterEmotionalNolimit;// 简单筛选情感状态不限
	private TextView simpleFilterEmotionalSingle;// 简单筛选情感状态单身
	private LinearLayout simpleFilterBtn;// 简单筛选筛选按钮
	private LinearLayout simpleFilterBox;// 筛选区域
	private TextView filterSexNolimit;// 性别不限
	private TextView filterSexMale;// 性别男
	private TextView filterSexFamale;// 性别女
	private TextView filterEmotionalNolimit;// 情感状态不限
	private TextView filterEmotionalSingle;// 情感状态单身
	private LinearLayout filterBtn;// 筛选按钮
	private TextView refreshTagData;// 换一批标签按钮
	private ScrollView scrollView;
	private TextView userLocation;// 用户位置
	private TextView refreshUserLocation;// 刷新用户信息
	private IndirectFriendsAdapter friendsAdapter;
	private final ArrayList<ManageFriendsBean> friendsArrayList = new ArrayList<ManageFriendsBean>();// 全部好友数据
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	/** 根据拼音来排列ListView里面的数据类 */
	private FriendsPinyinComparator pinyinComparator;
	private SideBar sideBar;
	private LinearLayout tagSelectedBox;// 标签选中模块
	ArrayList<FilterIndirectBeans> selectedArrayList = new ArrayList<FilterIndirectBeans>();// 选中的标签
	private boolean firstLoadData = true;// 首次加载数据

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.find_indirect_friends);
		titleLeftButton.setText(R.string.str_find);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_find_indirect_friends, null);
	}

	@Override
	protected void initViews() {
		mContext = FindIndirectFriendsActivity.this;
		filterView = findViewById(R.id.find_indirect_friends_filter);
		friendList = (PullToRefreshListView) findViewById(R.id.find_indirect_friends_list);
		signGridView = (GridView) findViewById(R.id.indirect_sign_gridview);
		btnSignUnlimited = (TextView) findViewById(R.id.indirect_sign_btn_unlimited);
		btnSign = (ImageView) findViewById(R.id.indirect_btn_sign);
		llSign = (LinearLayout) findViewById(R.id.indirect_sign_ll);
		areaGridView = (GridView) findViewById(R.id.indirect_area_gridview);
		btnAreaUnlimited = (TextView) findViewById(R.id.indirect_area_btn_unlimited);
		btnArea = (ImageView) findViewById(R.id.indirect_btn_area);
		llArea = (LinearLayout) findViewById(R.id.indirect_area_ll);
		tagSelectedBox = (LinearLayout) findViewById(R.id.indirect_tag_selected_box);
		btnTag = (ImageView) findViewById(R.id.indirect_btn_tag);
		llTag = (LinearLayout) findViewById(R.id.indirect_tag_ll);
		heightGridView = (GridView) findViewById(R.id.indirect_height_gridview);
		btnHeightUnlimited = (TextView) findViewById(R.id.indirect_height_btn_unlimited);
		btnHeight = (ImageView) findViewById(R.id.indirect_btn_height);
		heightBox = (RelativeLayout) findViewById(R.id.indirect_height_box);
		llHeight = (LinearLayout) findViewById(R.id.indirect_height_ll);
		btnOk = (Button) findViewById(R.id.indirect_btn_ok);
		btnReset = (Button) findViewById(R.id.indirect_btn_reset);
		minAge = (EditText) findViewById(R.id.indirect_age_min);
		maxAge = (EditText) findViewById(R.id.indirect_age_max);
		simpleFilterBox = (LinearLayout) findViewById(R.id.find_indirect_simple_filter_box);
		simpleFilterBtn = (LinearLayout) findViewById(R.id.find_indirect_btn_simple_filter);
		simpleFilterEmotionalNolimit = (TextView) findViewById(R.id.find_indirect_emotional_nolimit);
		simpleFilterEmotionalSingle = (TextView) findViewById(R.id.find_indirect_emotional_single);
		simpleFilterSexFamale = (TextView) findViewById(R.id.find_indirect_sex_famale);
		simpleFilterSexMale = (TextView) findViewById(R.id.find_indirect_sex_male);
		simpleFilterSexNolimit = (TextView) findViewById(R.id.find_indirect_sex_nolimit);
		filterBtn = (LinearLayout) findViewById(R.id.indirect_btn_filter);
		filterEmotionalNolimit = (TextView) findViewById(R.id.indirect_emotional_nolimit);
		filterEmotionalSingle = (TextView) findViewById(R.id.indirect_emotional_single);
		filterSexFamale = (TextView) findViewById(R.id.indirect_sex_famale);
		filterSexMale = (TextView) findViewById(R.id.indirect_sex_male);
		filterSexNolimit = (TextView) findViewById(R.id.indirect_sex_nolimit);
		tagView = (LinearLayout) findViewById(R.id.indirect_tag_view);
		refreshTagData = (TextView) findViewById(R.id.indirect_tag_change);
		scrollView = (ScrollView) findViewById(R.id.indirect_filter_scroll);
		userLocation = (TextView) findViewById(R.id.indirect_area_location);
		refreshUserLocation = (TextView) findViewById(R.id.indirect_area_refresh_loaction);
		sideBar = (SideBar) findViewById(R.id.find_indirect_friends_sidebar);
		View headerView = View.inflate(mContext, R.layout.indirect_friends_num, null);
		friendList.getRefreshableView().addHeaderView(headerView);
		friendsCount = (TextView) findViewById(R.id.find_indirect_friends_nums);
		String[] SignDatas = getResources().getStringArray(R.array.profile_zodiac_array);
		String[] areaDatas = getResources().getStringArray(R.array.work_location_array);
		String[] heightDatas = getResources().getStringArray(R.array.profile_height_array);
		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		pinyinComparator = new FriendsPinyinComparator();
		signArray = new ArrayList<FilterIndirectBeans>();
		tagArray = new ArrayList<FilterIndirectBeans>();
		areaArray = new ArrayList<FilterIndirectBeans>();
		heightArray = new ArrayList<FilterIndirectBeans>();
		for (int i = 0; i < SignDatas.length; i++) {// 初始化星座数据
			FilterIndirectBeans beans = new FilterIndirectBeans();
			beans.setText(SignDatas[i]);
			beans.setSelected(false);
			signArray.add(beans);
		}
		for (int i = 0; i < heightDatas.length; i++) {// 初始化身高数据
			FilterIndirectBeans beans = new FilterIndirectBeans();
			beans.setText(heightDatas[i]);
			beans.setSelected(false);
			heightArray.add(beans);
		}
		for (int i = 0; i < areaDatas.length; i++) {// 初始化地区数据
			FilterIndirectBeans beans = new FilterIndirectBeans();
			beans.setText(areaDatas[i]);
			beans.setSelected(false);
			areaArray.add(beans);
		}
		setLocationInfo();
		int friendsNums = getIntent().getIntExtra(UtilRequest.FORM_NUMS, 0);
		friendsCount.setText("二度好友推荐( " + friendsNums + " )");
		firstLoadData = true;
		signAdapter = new IndirectFilterAdapter(mContext, signArray);
		areaAdapter = new IndirectFilterAdapter(mContext, areaArray);
		heightAdapter = new IndirectFilterAdapter(mContext, heightArray);
		friendsAdapter = new IndirectFriendsAdapter(mContext, friendsArrayList, listener);
		refreshSelectedTag();
		friendList.setAdapter(friendsAdapter);
		signGridView.setAdapter(signAdapter);
		areaGridView.setAdapter(areaAdapter);
		heightGridView.setAdapter(heightAdapter);
		signGridView.setOnItemClickListener(itemClickListener);
		areaGridView.setOnItemClickListener(itemClickListener);
		heightGridView.setOnItemClickListener(itemClickListener);
		btnSign.setOnClickListener(listener);
		btnSignUnlimited.setOnClickListener(listener);
		btnArea.setOnClickListener(listener);
		btnAreaUnlimited.setOnClickListener(listener);
		btnHeight.setOnClickListener(listener);
		btnHeightUnlimited.setOnClickListener(listener);
		btnTag.setOnClickListener(listener);
		btnOk.setOnClickListener(listener);
		btnReset.setOnClickListener(listener);
		simpleFilterBtn.setOnClickListener(listener);
		simpleFilterEmotionalNolimit.setOnClickListener(listener);
		simpleFilterEmotionalSingle.setOnClickListener(listener);
		simpleFilterSexFamale.setOnClickListener(listener);
		simpleFilterSexMale.setOnClickListener(listener);
		simpleFilterSexNolimit.setOnClickListener(listener);
		filterBtn.setOnClickListener(listener);
		filterEmotionalNolimit.setOnClickListener(listener);
		filterEmotionalSingle.setOnClickListener(listener);
		filterSexFamale.setOnClickListener(listener);
		filterSexMale.setOnClickListener(listener);
		filterSexNolimit.setOnClickListener(listener);
		refreshTagData.setOnClickListener(listener);
		refreshUserLocation.setOnClickListener(listener);
		friendList.getRefreshableView().setOnTouchListener(onTouchListener);
		minAge.addTextChangedListener(new MyTextWatcher(minAge));
		maxAge.addTextChangedListener(new MyTextWatcher(maxAge));
		friendList.setMode(Mode.PULL_FROM_END);// 设置只能从底部上拉
		friendList.setScrollingWhileRefreshingEnabled(false);// 加载的时候不允许滑动
		friendList.setPullToRefreshOverScrollEnabled(false);// 滑动到底部的时候的缓冲提示

		// 设置右侧触摸监听
		sideBar.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {
			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = friendsAdapter.getPositionForSection(s.charAt(0));
				int index = position + 2;
				if (index >= 0) {
					friendList.getRefreshableView().setSelection(index);
				}
			}
		});
		friendList.setOnRefreshListener(new OnRefreshListener<ListView>() {

			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				if (firstLoadData) {
					hasConditionRequest(0);
				} else {
					hasConditionRequest(friendsArrayList.size());
				}
			}

		});
		friendList.setOnItemClickListener(onItemClickListener);
		String friendsData = SharedPreUtil.getIndirectFriendsData();
		if (!Util.isBlankString(friendsData)) {// 首先展示缓存数据
			parserFriendsData(friendsData);
		}
		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		UtilRequest.getMaxTag(mHandler, mContext);
		UtilRequest.getFriendsFsFriends(0, UtilRequest.GET_MY_FRIENDS_LIST_NUMS, "", "", "", mHandler, mContext);
		IntentFilter filter = new IntentFilter();
		filter.addAction(UtilRequest.BROADCAST_ACTION_REFRESH_LOCATION);
		filter.addAction(UtilRequest.BROADCAST_ACTION_ADD_FRIEND);
		registerReceiver(mReceiver, filter);
	}

	private void refreshSelectedTag() {
		tagSelectedBox.removeAllViews();
		int size = selectedArrayList.size() + 1;
		View[] views = new View[size];
		View viewUnlimit = View.inflate(mContext, R.layout.filter_indirect_tag_unlimit_item, null);
		btnTagUnlimited = (TextView) viewUnlimit.findViewById(R.id.indirect_tag_btn_unlimited);
		btnTagUnlimited.setOnClickListener(listener);
		views[0] = viewUnlimit;
		if (selectedArrayList.size() > 0) {
			for (int i = 0; i < selectedArrayList.size(); i++) {
				View view = View.inflate(mContext, R.layout.filter_indirect_tag_selected_item, null);
				TextView textView = (TextView) view.findViewById(R.id.indirect_fiter_tag_selected);
				textView.setText(selectedArrayList.get(i).getText());
				textView.setTag(i);
				textView.setOnClickListener(listener);
				views[i + 1] = view;
			}
			btnTagUnlimited.setEnabled(true);
		} else {
			btnTagUnlimited.setEnabled(false);
		}
		Util.populateText(tagSelectedBox, views, mContext,
				getResources().getDimensionPixelSize(R.dimen.filter_tag_select_margin_width), true);

	}

	/**
	 * @Title: setLocationInfo
	 * @Description: 设置位置信息
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void setLocationInfo() {
		J_LocationPoint location = SharedPreUtil.getLocation();
		if (location != null && location.locationInfo != null && !Util.isBlankString(location.locationInfo.province)) {
			String province = location.locationInfo.province.replace("省", "").replace("市", "");
			userLocation.setText(province);
		} else {
			userLocation.setText(R.string.not_know);
		}
	}

	/**
	 * @Title: hideFilterView
	 * @Description: 隐藏详细筛选页面展示简单筛选页面
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void hideFilterView() {
		filterView.setVisibility(View.GONE);
		simpleFilterBox.setVisibility(View.GONE);
	}

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			int index = position - 2;
			if (index >= 0) {
				String uid = friendsArrayList.get(index).getUid();
				long userID = Long.valueOf(uid);
				if (userID > 0) {
					Intent intent = new Intent(mContext, ProfileViewActivity.class);
					intent.putExtra(UtilRequest.FORM_UID, userID);
					startActivity(intent);
				}
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_FRIENDS_GET_FSFRIENDS:// 获取二度好友数据
				if (firstLoadData) {
					friendsArrayList.clear();
					friendsAdapter.updateList(friendsArrayList);
					firstLoadData = false;
				}
				String friendsData = msg.obj.toString();
				if (!Util.isBlankString(friendsData) && !friendsData.equals("[]")) {
					parserFriendsData(friendsData);
					friendList.onRefreshComplete();
				} else {
					friendList.onRefreshComplete();
					friendList.setMode(Mode.DISABLED);
					ToastUtil.showToast(mContext, getString(R.string.no_more_friends));
				}
				DialogUtils.dismissDialog();
				break;
			case NetTaskIDs.TASKID_FRIENDS_SENT_REQ:
				// 申请添加好友
				DialogUtils.dismissDialog();
				J_Response responseSent = (J_Response) msg.obj;
				if (responseSent.retcode == 1) {
					ToastUtil.showToast(mContext, "好友申请已发送，等待对方接受");
				} else {
					ToastUtil.showToast(mContext, "添加失败：" + responseSent.retmean);
				}
				break;
			case NetTaskIDs.TASKID_TAG_GET_MAX_TAGS:// 获得使用最多的30个标签
				try {
					JSONArray dataObject = new JSONArray(msg.obj.toString());
					if (dataObject.length() > 0) {
						tagArray.clear();
						for (int i = 0; i < dataObject.length(); i++) {
							JSONObject item = dataObject.optJSONObject(i);
							FilterIndirectBeans bean = new FilterIndirectBeans();
							bean.setTagId(item.optInt(UtilRequest.FORM_TID, 0));
							bean.setText(item.optString(UtilRequest.FORM_TITLE));
							bean.setSelected(false);
							if (bean.getTagId() != 0) {
								tagArray.add(bean);
							}
						}
						if (tagArray.size() > 0) {
							Collections.shuffle(tagArray);
						}
						refreshTag();
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
			Util.hideKeyboard(mContext, maxAge);
			switch (v.getId()) {
			case R.id.indirect_friends_friends_btn_add:// 加好友按钮
				long currentUid = (Long) v.getTag();
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.friendsSentReq(J_Cache.sLoginUser.uid, currentUid, mHandler, mContext);
				break;
			case R.id.indirect_btn_filter:// 筛选按钮
				hideFilterView();
				break;
			case R.id.find_indirect_btn_simple_filter:// 简单的筛选按钮
				if (simpleFilterBox.getVisibility() == View.VISIBLE) {// 展开详细筛选页面
					filterView.setVisibility(View.VISIBLE);
				} else {
					Util.expand(simpleFilterBox, callback);
				}
				break;
			case R.id.find_indirect_emotional_nolimit:// 简单地情感不限
				simpleFilterEmotionalSingle.setEnabled(true);
				simpleFilterEmotionalNolimit.setEnabled(false);
				hasConditionRequest(0);
			case R.id.indirect_emotional_nolimit:// 情感不限
				filterEmotionalSingle.setEnabled(true);
				filterEmotionalNolimit.setEnabled(false);
				heightBox.setVisibility(View.GONE);
				llHeight.setVisibility(View.GONE);
				btnHeight.setImageResource(R.drawable.icon_gray_down);
				break;
			case R.id.find_indirect_emotional_single:// 简单地单身
				simpleFilterEmotionalSingle.setEnabled(false);
				simpleFilterEmotionalNolimit.setEnabled(true);
				hasConditionRequest(0);
			case R.id.indirect_emotional_single:// 单身
				filterEmotionalSingle.setEnabled(false);
				filterEmotionalNolimit.setEnabled(true);
				heightBox.setVisibility(View.VISIBLE);
				break;
			case R.id.find_indirect_sex_famale:// 简单的女性
				simpleFilterSexFamale.setEnabled(false);
				simpleFilterSexMale.setEnabled(true);
				simpleFilterSexNolimit.setEnabled(true);
				hasConditionRequest(0);
			case R.id.indirect_sex_famale:// 女性
				filterSexFamale.setEnabled(false);
				filterSexMale.setEnabled(true);
				filterSexNolimit.setEnabled(true);
				break;
			case R.id.find_indirect_sex_male:// 简单的男性
				simpleFilterSexFamale.setEnabled(true);
				simpleFilterSexMale.setEnabled(false);
				simpleFilterSexNolimit.setEnabled(true);
				hasConditionRequest(0);
			case R.id.indirect_sex_male:// 男性
				filterSexFamale.setEnabled(true);
				filterSexMale.setEnabled(false);
				filterSexNolimit.setEnabled(true);
				break;
			case R.id.find_indirect_sex_nolimit:// 简单的性别不限
				simpleFilterSexFamale.setEnabled(true);
				simpleFilterSexMale.setEnabled(true);
				simpleFilterSexNolimit.setEnabled(false);
				hasConditionRequest(0);
			case R.id.indirect_sex_nolimit:// 性别不限
				filterSexFamale.setEnabled(true);
				filterSexMale.setEnabled(true);
				filterSexNolimit.setEnabled(false);
				break;
			case R.id.titleLeftButton:// 头部左侧按钮
				finish();
				break;
			case R.id.indirect_btn_ok:// 完成按钮
				simpleFilterEmotionalNolimit.setEnabled(filterEmotionalNolimit.isEnabled());
				simpleFilterEmotionalSingle.setEnabled(filterEmotionalSingle.isEnabled());
				simpleFilterSexFamale.setEnabled(filterSexFamale.isEnabled());
				simpleFilterSexMale.setEnabled(filterSexMale.isEnabled());
				simpleFilterSexNolimit.setEnabled(filterSexNolimit.isEnabled());
				if (hasConditionRequest(0)) {
					hideFilterView();
				}
				break;
			case R.id.indirect_btn_sign:// 星座展开
				Util.collapse_expand(llSign, callback);
				break;
			case R.id.indirect_sign_btn_unlimited:// 星座不限按钮
				unlimitedSign();
				break;
			case R.id.indirect_btn_area:// 地区展开
				Util.collapse_expand(llArea, callback);
				break;
			case R.id.indirect_area_btn_unlimited:// 地区不限按钮
				unlimitedArea();
				break;
			case R.id.indirect_btn_tag:// 标签展开
				Util.collapse_expand(llTag, callback);
				break;
			case R.id.indirect_tag_btn_unlimited:// 标签不限按钮
				unlimitedTag();
				break;
			case R.id.indirect_btn_height:// 身高展开
				Util.collapse_expand(llHeight, callback);
				break;
			case R.id.indirect_height_btn_unlimited:// 身高不限按钮
				unlimitedHeight();
				break;
			case R.id.indirect_btn_reset:// 重置按钮
				unlimitedSign();
				unlimitedArea();
				filterEmotionalSingle.setEnabled(true);
				filterEmotionalNolimit.setEnabled(false);
				unlimitedHeight();
				unlimitedTag();
				filterSexFamale.setEnabled(true);
				filterSexMale.setEnabled(true);
				filterSexNolimit.setEnabled(false);
				minAge.setText("");
				maxAge.setText("");
				break;
			case R.id.indirect_fiter_tag_text:// 标签点击
				int index = (Integer) v.getTag();
				if (tagArray.get(index).isSelected()) {
					tagArray.get(index).setSelected(false);
				} else {
					if (selectedArrayList.size() < 5) {
						tagArray.get(index).setSelected(true);
					} else {
						ToastUtil.showToast(mContext, "最多只能选择五个标签");
					}
				}
				boolean hasTag = false;
				for (int i = 0; i < selectedArrayList.size(); i++) {
					if (tagArray.get(index).getTagId() == selectedArrayList.get(i).getTagId()) {
						hasTag = true;
						if (!tagArray.get(index).isSelected()) {
							selectedArrayList.remove(i);
						}
						break;
					}
				}
				if (!hasTag && tagArray.get(index).isSelected()) {
					selectedArrayList.add(tagArray.get(index));
				}
				refreshSelectedTag();
				refreshTag();
				break;
			case R.id.indirect_tag_change:// 换一批
				if (tagArray.size() <= 0) {
					UtilRequest.getMaxTag(mHandler, mContext);
				} else {
					// for (int i = 0; i < tagArray.size(); i++) {
					// tagArray.get(i).setSelected(false);
					// }
					Collections.shuffle(tagArray);
					refreshTag();
				}
				break;
			case R.id.indirect_area_refresh_loaction:// 刷新用户坐标
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				J_Application.requestLocation();
				break;
			case R.id.indirect_fiter_tag_selected:// 取消选中的标签
				int indexSelected = (Integer) v.getTag();
				for (int i = 0; i < tagArray.size(); i++) {
					if (tagArray.get(i).getTagId() == selectedArrayList.get(indexSelected).getTagId()) {
						tagArray.get(i).setSelected(false);
						selectedArrayList.remove(indexSelected);
						break;
					}
				}
				refreshSelectedTag();
				refreshTag();
				break;
			}
		}
	};
	private final OnAnimationCallBack callback = new OnAnimationCallBack() {

		@Override
		public void onComplete(int visible, int viewId) {
			switch (viewId) {
			case R.id.indirect_sign_ll:// 星座展开图标
				if (visible == View.GONE) {
					btnSign.setImageResource(R.drawable.icon_gray_down);
				} else {
					btnSign.setImageResource(R.drawable.icon_gray_up);
				}
				break;
			case R.id.indirect_area_ll:// 区域展开图标
				if (visible == View.GONE) {
					btnArea.setImageResource(R.drawable.icon_gray_down);
				} else {
					btnArea.setImageResource(R.drawable.icon_gray_up);
				}
				break;
			case R.id.indirect_tag_ll:// 标签展开图标
				if (visible == View.GONE) {
					btnTag.setImageResource(R.drawable.icon_gray_down);
				} else {
					btnTag.setImageResource(R.drawable.icon_gray_up);
					scrollView.fullScroll(ScrollView.FOCUS_DOWN);
				}
				break;
			case R.id.indirect_height_ll:// 身高展开图标
				if (visible == View.GONE) {
					btnHeight.setImageResource(R.drawable.icon_gray_down);
				} else {
					btnHeight.setImageResource(R.drawable.icon_gray_up);
				}
				break;
			default:
				break;
			}
		}
	};

	private final OnItemClickListener itemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			if (parent == signGridView) {// 星座多选
				if (signArray.get(position).isSelected()) {
					signArray.get(position).setSelected(false);
				} else {
					signArray.get(position).setSelected(true);
					btnSignUnlimited.setEnabled(true);
				}
				int selected = 0;// 选中的数量
				for (int i = 0; i < signArray.size(); i++) {
					if (signArray.get(i).isSelected()) {
						selected++;
					}
				}
				if (selected == signArray.size()) {// 全选就是不限
					for (int j = 0; j < signArray.size(); j++) {
						signArray.get(j).setSelected(false);
						btnSignUnlimited.setEnabled(false);
					}
				}
				signAdapter.notifyDataSetChanged();
			} else if (parent == areaGridView) {// 地区单选
				for (int i = 0; i < areaArray.size(); i++) {
					areaArray.get(i).setSelected(false);
				}
				btnAreaUnlimited.setEnabled(true);
				areaArray.get(position).setSelected(true);
				areaAdapter.notifyDataSetChanged();
			} else if (parent == heightGridView) {// 身高单选
				for (int i = 0; i < heightArray.size(); i++) {
					heightArray.get(i).setSelected(false);
				}
				btnHeightUnlimited.setEnabled(true);
				heightArray.get(position).setSelected(true);
				heightAdapter.notifyDataSetChanged();
			}
		}
	};

	/**
	 * @Title: refreshTag
	 * @Description: 刷新标签数据
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void refreshTag() {
		tagView.removeAllViews();
		int size = 6;
		if (tagArray.size() < 6) {
			size = tagArray.size();
		}
		View[] views = new View[size];
		for (int i = 0; i < size; i++) {
			View view = View.inflate(mContext, R.layout.filter_indirect_tag_item, null);
			TextView textView = (TextView) view.findViewById(R.id.indirect_fiter_tag_text);
			textView.setText(tagArray.get(i).getText());
			if (tagArray.get(i).isSelected()) {// 选中状态
				textView.setTextColor(getResources().getColor(R.color.text_normal_white));
				textView.setBackgroundResource(R.drawable.bg_filter_conditions_pressed);
			} else {
				textView.setTextColor(getResources().getColor(R.color.text_normal_blue));
				textView.setBackgroundResource(R.drawable.bg_filter_conditions_normal);
			}
			textView.setPadding(20, 3, 20, 3);
			textView.setTag(i);
			textView.setOnClickListener(listener);
			views[i] = view;
		}
		Util.populateText(tagView, views, mContext, getResources().getDimensionPixelSize(R.dimen.filter_tag_margin_width), true);
		// scrollView.fullScroll(ScrollView.FOCUS_DOWN);
		// Util.hideKeyboard(mContext, maxAge);
	}

	/**
	 * @Title: unlimitedHeight
	 * @Description: 身高不限
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void unlimitedHeight() {
		for (int i = 0; i < heightArray.size(); i++) {
			heightArray.get(i).setSelected(false);
		}
		btnHeightUnlimited.setEnabled(false);
		heightAdapter.notifyDataSetChanged();
	}

	/**
	 * @Title: unlimitedTag
	 * @Description: 标签不限
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void unlimitedTag() {
		for (int i = 0; i < tagArray.size(); i++) {
			tagArray.get(i).setSelected(false);
		}
		refreshTag();
		selectedArrayList.clear();
		refreshSelectedTag();
	}

	/**
	 * @Title: unlimitedArea
	 * @Description: 区域不限
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void unlimitedArea() {
		for (int i = 0; i < areaArray.size(); i++) {
			areaArray.get(i).setSelected(false);
		}
		btnAreaUnlimited.setEnabled(false);
		areaAdapter.notifyDataSetChanged();
	}

	/**
	 * @Title: unlimitedSign
	 * @Description: 星座不限
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void unlimitedSign() {
		for (int i = 0; i < signArray.size(); i++) {
			signArray.get(i).setSelected(false);
		}
		btnSignUnlimited.setEnabled(false);
		signAdapter.notifyDataSetChanged();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if (filterView.getVisibility() == View.VISIBLE) {// 隐藏筛选层
				hideFilterView();
				return true;
			}
		}
		return super.onKeyDown(keyCode, event);
	}

	/**
	 * @Title: hasConditionRequest
	 * @Description: 有条件的请求数据
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public boolean hasConditionRequest(int start) {
		String minAgeText = minAge.getText().toString();
		String maxAgeText = maxAge.getText().toString();
		if (!Util.isBlankString(minAgeText) && !Util.isBlankString(maxAgeText)) {
			int max = Integer.valueOf(maxAgeText);
			int min = Integer.valueOf(minAgeText);
			if (max < min) {
				ToastUtil.showToast(mContext, "请输入有效的年龄区间");
				return false;
			}
		}
		try {
			String conditionStarString = "";
			String conditionTags = "";
			JSONObject conditions = new JSONObject();
			if (!simpleFilterEmotionalSingle.isEnabled()) {// 单身
				conditions.put(UtilRequest.FORM_MARRIAGE, "1");
			}
			if (!simpleFilterSexMale.isEnabled()) {// 男性
				conditions.put(UtilRequest.FORM_SEX, "1");
			}
			if (!simpleFilterSexFamale.isEnabled()) {// 女性
				conditions.put(UtilRequest.FORM_SEX, "0");
			}
			if (!Util.isBlankString(minAgeText)) {// 最小年龄
				int min = Integer.valueOf(minAgeText);
				conditions.put(UtilRequest.FORM_MIN_AGE, min);
			}
			if (!Util.isBlankString(maxAgeText)) {// 最大年龄
				int max = Integer.valueOf(maxAgeText);
				conditions.put(UtilRequest.FORM_MAX_AGE, max);
			}
			for (int i = 0; i < areaArray.size(); i++) {
				if (areaArray.get(i).isSelected()) {// 位置条件
					int locationIndex = WorkLocation.getLocationIndexWithName(areaArray.get(i).getText());
					String locationCode = WorkLocation.getLocationCodeWithIndex(locationIndex);
					if (!Util.isBlankString(locationCode)) {
						conditions.put(UtilRequest.FORM_LIVE_LOCATION, locationCode);
					}
					break;
				}
			}
			for (int i = 0; i < heightArray.size(); i++) {
				if (heightArray.get(i).isSelected()) {// 身高条件
					conditions.put(UtilRequest.FORM_HEIGHT, i);
					break;
				}
			}
			StringBuilder signSb = new StringBuilder();
			for (int i = 0; i < signArray.size(); i++) {
				if (signArray.get(i).isSelected()) {
					signSb.append(i + 1);
					signSb.append(",");
				}
			}
			if (signSb.length() > 1) {// 星座
				conditionStarString = signSb.substring(0, signSb.length() - 1);
			}
			for (int i = 0; i < selectedArrayList.size(); i++) {
				if (i != selectedArrayList.size() - 1) {
					conditionTags += selectedArrayList.get(i).getTagId() + ",";
				} else {
					conditionTags += selectedArrayList.get(i).getTagId();
				}
			}
			if (start == 0) {
				friendsArrayList.clear();
				friendList.setMode(Mode.PULL_FROM_END);
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				friendsAdapter.notifyDataSetChanged();
			}
			String conditionString = conditions.toString();
			if (conditions.length() <= 0) {
				conditionString = "";
			}
			UtilRequest.getFriendsFsFriends(start, UtilRequest.GET_MY_FRIENDS_LIST_NUMS, conditionString, conditionStarString,
					conditionTags, mHandler, mContext);
			return true;
		} catch (JSONException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * @ClassName: MyTextWatcher
	 * @Description: 观察年龄数据变化
	 * @author donglizhi
	 * @date 2015年4月18日 上午11:11:26
	 * 
	 */
	private class MyTextWatcher implements TextWatcher {
		private final EditText editText;

		public MyTextWatcher(EditText editText) {
			this.editText = editText;
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
		}

		@Override
		public void afterTextChanged(Editable s) {
			String temp = s.toString();
			if ("0".equals(temp)) {
				ToastUtil.showToast(mContext, "请输入1-99的数字！");
				editText.setText("");
				return;
			}
			if (temp.length() > 1 && temp.startsWith("0")) {// 防止01这种情况
				editText.setText(temp.substring(1));
				editText.setSelection(temp.length() - 1);
				return;
			}
		}

	}

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
				if (valueObject.has(UtilRequest.FORM_UID)) {
					String uid = JsonUtil.getJsonString(valueObject, UtilRequest.FORM_UID);
					if (uid.equals(SharedPreUtil.getLoginInfo().uid + "")) {
						continue;
					}
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
					friendsArrayList.add(bean);
				}
			}
			// 根据a-z进行排序源数据
			Collections.sort(friendsArrayList, pinyinComparator);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		friendsAdapter.updateList(friendsArrayList);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(mReceiver);
	}

	private final BroadcastReceiver mReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			if (UtilRequest.BROADCAST_ACTION_REFRESH_LOCATION.equals(action)) {// 刷新位置信息
				DialogUtils.dismissDialog();
				setLocationInfo();
			} else if (UtilRequest.BROADCAST_ACTION_ADD_FRIEND.equals(action)) {// 添加好友
				for (int i = 0; i < friendsArrayList.size(); i++) {
					long addUid = intent.getLongExtra(UtilRequest.FORM_UID, 0);
					if (friendsArrayList.get(i).getUid().equals(addUid + "")) {
						friendsArrayList.get(i).setHasAdd(true);
						friendsAdapter.notifyDataSetChanged();
						addUid = -1;
						break;
					}
				}
			}
		}
	};

	private final OnTouchListener onTouchListener = new OnTouchListener() {
		float startY = 0;

		@Override
		public boolean onTouch(View v, MotionEvent event) {
			switch (event.getAction()) {
			case MotionEvent.ACTION_DOWN:
				startY = event.getY();
				if (simpleFilterBox.getVisibility() == View.VISIBLE) {// 筛选框存在的情况下不响应点击
					return true;
				}
				break;
			case MotionEvent.ACTION_MOVE:
				if (simpleFilterBox.getVisibility() == View.VISIBLE) {// 筛选框存在的情况下不响应滑动
					return true;
				}
				break;
			case MotionEvent.ACTION_UP:
				float endY = event.getY();
				if (startY - endY > 30 && simpleFilterBox.getVisibility() != View.GONE) {// 隐藏筛选框
					hideFilterView();
					return true;
				}
				break;
			}
			return false;
		}
	};
}
