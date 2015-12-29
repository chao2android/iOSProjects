package com.iyouxun.ui.activity.center;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.os.Parcelable;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.R;
import com.iyouxun.comparator.PinyinComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.SameFriendSearchBean;
import com.iyouxun.data.beans.SortInfoBean;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.CharacterParser;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.SameFriendListAdapter;
import com.iyouxun.ui.views.DrawableCenterFromRightButton;
import com.iyouxun.ui.views.SideBar;
import com.iyouxun.ui.views.SideBar.OnTouchingLetterChangedListener;
import com.iyouxun.utils.Util;
import com.iyouxun.utils.Util.OnAnimationCallBack;

/**
 * 共同好友
 * 
 * @ClassName: ProfileSameFriendsActivity
 * @author likai
 * @date 2015-3-5 下午5:43:51
 * 
 */
public class ProfileSameFriendsActivity extends CommTitleActivity {
	private Button sameFriendButton;// 共同好友
	private Button oppoFriendButton;// 对方的好友
	private ViewPager same_user_viewPager;// 分页pager
	private PullToRefreshListView profileSameFriendListView;// 好友列表
	private PullToRefreshListView profileOppoFriendListView;// 对方的好友列表
	private LinearLayout profile_sf_search_box;// 筛选项目盒子（默认隐藏）
	private TextView profile_sf_sex_nolimit;
	private TextView profile_sf_sex_male;
	private TextView profile_sf_sex_famale;
	private TextView profile_sf_marray_nolimit;
	private TextView profile_sf_marray_single;
	private DrawableCenterFromRightButton profile_sf_search_button;

	// 空数据提示信息
	private TextView emptyTv1;
	private TextView emptyTv2;

	private SameFriendListAdapter adapter1;
	private SameFriendListAdapter adapter2;
	private final ArrayList<SortInfoBean> datas1 = new ArrayList<SortInfoBean>();
	private final ArrayList<SortInfoBean> datas2 = new ArrayList<SortInfoBean>();
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	/** 根据拼音来排列ListView里面的数据类 */
	private PinyinComparator pinyinComparator;
	/** 当前对比用户 */
	private LoginUser currentUserInfo;
	/** 列表类型0：共同好友，1：他的好友 */
	private int searchType = 0;
	/** 搜索条件设置(共同好友) */
	private final SameFriendSearchBean sameSearchBean = new SameFriendSearchBean();
	/** 搜索条件设置（他的好友） */
	private final SameFriendSearchBean oppoSearchBean = new SameFriendSearchBean();

	private UserPagerAdapter userPagerAdapter;
	// 右侧字母栏
	private SideBar sideBar1;
	private SideBar sideBar2;
	// viewpager
	private final ArrayList<View> mViews = new ArrayList<View>();// 用来存放下方滚动的layout
	private View eachViewPager1;
	private View eachViewPager2;
	/** 标记TA的好友页面是否已经加载 */
	protected boolean isOppoViewShown = false;
	protected boolean isSameViewShown = false;
	private boolean isOppoRefresh = false;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("共同好友");
		titleLeftButton.setText("个人资料");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_profile_same_friends, null);
	}

	@Override
	protected void initViews() {
		currentUserInfo = (LoginUser) getIntent().getSerializableExtra("userInfo");
		searchType = getIntent().getIntExtra("type", 0);

		sameFriendButton = (Button) findViewById(R.id.sameFriendButton);
		oppoFriendButton = (Button) findViewById(R.id.oppoFriendButton);
		same_user_viewPager = (ViewPager) findViewById(R.id.same_user_viewPager);
		profile_sf_search_box = (LinearLayout) findViewById(R.id.profile_sf_search_box);
		profile_sf_sex_nolimit = (TextView) findViewById(R.id.profile_sf_sex_nolimit);
		profile_sf_sex_male = (TextView) findViewById(R.id.profile_sf_sex_male);
		profile_sf_sex_famale = (TextView) findViewById(R.id.profile_sf_sex_famale);
		profile_sf_marray_nolimit = (TextView) findViewById(R.id.profile_sf_marray_nolimit);
		profile_sf_marray_single = (TextView) findViewById(R.id.profile_sf_marray_single);
		profile_sf_search_button = (DrawableCenterFromRightButton) findViewById(R.id.profile_sf_search_button);

		if (currentUserInfo.sex == 0) {
			// 女
			oppoFriendButton.setText("她的好友");
		} else {
			// 男
			oppoFriendButton.setText("他的好友");
		}

		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		pinyinComparator = new PinyinComparator();

		// 设置连个要显示的pager
		eachViewPager1 = View.inflate(mContext, R.layout.share_user_select_pageview, null);
		eachViewPager2 = View.inflate(mContext, R.layout.share_user_select_pageview, null);
		mViews.add(eachViewPager1);
		mViews.add(eachViewPager2);

		// 共同好友adapter
		profileSameFriendListView = (PullToRefreshListView) eachViewPager1.findViewById(R.id.shareUserPageviewListview);
		sideBar1 = (SideBar) eachViewPager1.findViewById(R.id.sidebar);
		adapter1 = new SameFriendListAdapter(mContext, 0);
		adapter1.setData(datas1);
		profileSameFriendListView.setAdapter(adapter1);
		profileSameFriendListView.setMode(Mode.DISABLED);
		// 点击选择
		profileSameFriendListView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				int realPosition = position - 1;
				realPosition = realPosition < 0 ? 0 : realPosition;
				SortInfoBean user = datas1.get(realPosition);

				Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
				profileIntent.putExtra("uid", user.uid);
				startActivity(profileIntent);
			}
		});
		// 设置右侧触摸监听
		sideBar1.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {
			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = adapter1.getPositionForSection(s.charAt(0));
				if (position != -1) {
					profileSameFriendListView.getRefreshableView().setSelection(position);
				}
			}
		});

		// TA的好友adapter
		profileOppoFriendListView = (PullToRefreshListView) eachViewPager2.findViewById(R.id.shareUserPageviewListview);
		sideBar2 = (SideBar) eachViewPager2.findViewById(R.id.sidebar);
		adapter2 = new SameFriendListAdapter(mContext, 1);
		adapter2.setData(datas2);
		profileOppoFriendListView.setAdapter(adapter2);
		profileOppoFriendListView.setMode(Mode.PULL_FROM_END);
		profileOppoFriendListView.setOnRefreshListener(new OnRefreshListener<ListView>() {
			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				isOppoRefresh = false;
				getUserNum();
			}
		});
		// 点击选择
		profileOppoFriendListView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				int realPosition = position - 1;
				realPosition = realPosition < 0 ? 0 : realPosition;
				SortInfoBean user = datas2.get(realPosition);

				if (user.uid > 0) {
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", user.uid);
					startActivity(profileIntent);
				}
			}
		});
		// 设置右侧触摸监听
		sideBar2.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {
			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = adapter2.getPositionForSection(s.charAt(0));
				if (position != -1) {
					profileOppoFriendListView.getRefreshableView().setSelection(position);
				}
			}
		});

		// viewpager设置
		userPagerAdapter = new UserPagerAdapter();
		same_user_viewPager.setAdapter(userPagerAdapter);
		same_user_viewPager.setOnPageChangeListener(new MyPagerOnPageChangeListener());

		sameFriendButton.setOnClickListener(listener);
		oppoFriendButton.setOnClickListener(listener);
		profile_sf_sex_nolimit.setOnClickListener(listener);
		profile_sf_sex_male.setOnClickListener(listener);
		profile_sf_sex_famale.setOnClickListener(listener);
		profile_sf_marray_nolimit.setOnClickListener(listener);
		profile_sf_marray_single.setOnClickListener(listener);
		profile_sf_search_button.setOnClickListener(listener);

		// 空数据展示
		View view1 = View.inflate(mContext, R.layout.empty_layer, null);
		emptyTv1 = (TextView) view1.findViewById(R.id.emptyTv);
		profileSameFriendListView.setEmptyView(emptyTv1);
		View view2 = View.inflate(mContext, R.layout.empty_layer, null);
		emptyTv2 = (TextView) view2.findViewById(R.id.emptyTv);
		profileOppoFriendListView.setEmptyView(emptyTv2);

		// 页面中按钮的默认选择项
		refreshSearchChoiceStyle();

		if (searchType == 0) {
			// 加载页面
			showLoading();
			isSameViewShown = true;
			getUserNum();// 首次加载该页面，需要请求数据
		}
	}

	/**
	 * 刷新显示样式
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void refreshSearchChoiceStyle() {
		if (searchType == 0) {
			same_user_viewPager.setCurrentItem(0, true);
			// 共同好友
			sameFriendButton.setEnabled(false);
			oppoFriendButton.setEnabled(true);
			// 性别选择
			if (sameSearchBean.sex == 0) {
				profile_sf_sex_nolimit.setEnabled(true);
				profile_sf_sex_male.setEnabled(true);
				profile_sf_sex_famale.setEnabled(false);
			} else if (sameSearchBean.sex == 1) {
				profile_sf_sex_nolimit.setEnabled(true);
				profile_sf_sex_male.setEnabled(false);
				profile_sf_sex_famale.setEnabled(true);
			} else {
				profile_sf_sex_nolimit.setEnabled(false);
				profile_sf_sex_male.setEnabled(true);
				profile_sf_sex_famale.setEnabled(true);
			}
			// 情感状况选择
			if (sameSearchBean.marriage == 0) {
				profile_sf_marray_nolimit.setEnabled(false);
				profile_sf_marray_single.setEnabled(true);
			} else {
				profile_sf_marray_nolimit.setEnabled(true);
				profile_sf_marray_single.setEnabled(false);
			}
		} else {
			same_user_viewPager.setCurrentItem(1, true);
			// ta的好友
			sameFriendButton.setEnabled(true);
			oppoFriendButton.setEnabled(false);
			// 性别选择
			if (oppoSearchBean.sex == 0) {
				profile_sf_sex_nolimit.setEnabled(true);
				profile_sf_sex_male.setEnabled(true);
				profile_sf_sex_famale.setEnabled(false);
			} else if (oppoSearchBean.sex == 1) {
				profile_sf_sex_nolimit.setEnabled(true);
				profile_sf_sex_male.setEnabled(false);
				profile_sf_sex_famale.setEnabled(true);
			} else {
				profile_sf_sex_nolimit.setEnabled(false);
				profile_sf_sex_male.setEnabled(true);
				profile_sf_sex_famale.setEnabled(true);
			}
			// 情感状况选择
			if (oppoSearchBean.marriage == 0) {
				profile_sf_marray_nolimit.setEnabled(false);
				profile_sf_marray_single.setEnabled(true);
			} else {
				profile_sf_marray_nolimit.setEnabled(true);
				profile_sf_marray_single.setEnabled(false);
			}
		}
	}

	/**
	 * 刷新页面数据
	 * 
	 * @Title: setContent
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContent() {
		if (searchType == 0) {
			// 共同好友
			if (datas1.size() > 0) {
				for (int i = 0; i < datas1.size(); i++) {
					SortInfoBean sortModel = datas1.get(i);
					// 汉字转换成拼音
					String pinyin = characterParser.getSelling(sortModel.name);
					String sortString = pinyin.substring(0, 1).toUpperCase();

					// 正则表达式，判断首字母是否是英文字母
					if (sortString.matches("[A-Z]")) {
						sortModel.sortLetter = sortString.toUpperCase();
					} else {
						sortModel.sortLetter = "#";
					}
					datas1.set(i, sortModel);
				}

				// 根据a-z进行排序源数据
				Collections.sort(datas1, pinyinComparator);
			} else {
				// 共同好友
				emptyTv1.setText("还没有共同好友哦");
				emptyTv1.setVisibility(View.VISIBLE);
			}
			adapter1.setData(datas1);
			adapter1.notifyDataSetChanged();
			profileSameFriendListView.onRefreshComplete();
		} else {
			// TA的好友
			if (datas2.size() > 0) {
				for (int i = 0; i < datas2.size(); i++) {
					SortInfoBean sortModel = datas2.get(i);
					if (sortModel.uid == 0) {
						sortModel.sortLetter = "@";
					} else {
						// 汉字转换成拼音
						String pinyin = characterParser.getSelling(sortModel.name);
						String sortString = pinyin.substring(0, 1).toUpperCase();
						// 正则表达式，判断首字母是否是英文字母
						if (sortString.matches("[A-Z]")) {
							sortModel.sortLetter = sortString.toUpperCase();
						} else {
							sortModel.sortLetter = "#";
						}
					}
					datas2.set(i, sortModel);
				}
				// 根据a-z进行排序源数据
				Collections.sort(datas2, pinyinComparator);
				for (int i = 0; i < datas2.size(); i++) {// 排序后把@换成#
					if (datas2.get(i).sortLetter.equals("@")) {
						datas2.get(i).sortLetter = "#";
					}
				}
			} else {
				// 他的好友
				emptyTv2.setText("TA还没有好友哦");
				emptyTv2.setVisibility(View.VISIBLE);
			}

			adapter2.setData(datas2);
			adapter2.notifyDataSetChanged();
			profileOppoFriendListView.onRefreshComplete();
		}
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS:
				// ta的好友数量
				getUserList();
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MUTUALNUMS:
				// 共同好友的数量
				J_Response responseSameNum = (J_Response) msg.obj;
				if (responseSameNum.retcode == 1) {
					sameSearchBean.num = Util.getInteger(responseSameNum.data);
					getUserList();
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MUTUALFRIENDS:
				// 获取共同好友
				J_Response responseSame = (J_Response) msg.obj;
				if (responseSame.retcode == 1) {
					try {
						if (!Util.isBlankString(responseSame.data) && !responseSame.data.equals("[]")) {
							JSONObject friendsData = new JSONObject(responseSame.data);
							datas1.clear();
							// 好友姓名列表
							String mutualUserStr = friendsData.optString("mutualuser");
							if (!Util.isBlankString(mutualUserStr) && !mutualUserStr.equals("[]")) {
								JSONObject friendsObj = friendsData.optJSONObject("mutualuser");
								Iterator iterator = friendsObj.keys();
								while (iterator.hasNext()) {
									String key = (String) iterator.next();
									JSONObject singleFriend = friendsObj.optJSONObject(key);

									SortInfoBean user = new SortInfoBean();
									user.uid = singleFriend.optLong("uid");
									user.name = singleFriend.optString("nick");
									if (Util.isBlankString(user.name)) {
										continue;
									}
									JSONObject avatarObj = singleFriend.optJSONObject("avatars");
									user.avatar = avatarObj.optString("200");
									user.marriage = singleFriend.optInt("marriage");
									user.friendDimen = 1;// 该共同好友都是1度好友
									user.sameFriendsNum = singleFriend.optInt("mutualnums");// 共同好友的数量
									user.sex = singleFriend.optInt("sex");
									user.isReg = 1;// 标记是否已注册
									datas1.add(user);
								}
							}
						} else {
							datas1.clear();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				// 刷新页面数据
				setContent();
				dismissLoading();
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL:
				// 获取TA的好友
				try {
					// 好友姓名列表
					String dataInfo = msg.obj.toString();
					if (!Util.isBlankString(dataInfo) && !dataInfo.equals("[]")) {
						JSONObject friendsObj = new JSONObject(dataInfo);
						Iterator iterator = friendsObj.keys();
						if (isOppoRefresh) {
							datas2.clear();
						}
						while (iterator.hasNext()) {
							String key = (String) iterator.next();
							JSONObject singleFriend = friendsObj.optJSONObject(key);

							if (singleFriend.has("uid")) {
								// 注册用户
								SortInfoBean user = new SortInfoBean();
								user.uid = singleFriend.optLong("uid");
								user.name = singleFriend.optString("nick");
								JSONObject avatarObj = singleFriend.optJSONObject("avatars");
								user.avatar = avatarObj.optString("200");
								user.marriage = singleFriend.optInt("marriage");
								user.friendDimen = singleFriend.optInt("f_dimension");// 他的好友都是1度好友
								user.sameFriendsNum = singleFriend.optInt("mutualnums");// 共同好友的数量
								user.sex = singleFriend.optInt("sex");
								user.isReg = 1;
								datas2.add(user);
							}
						}
					} else {
						if (isOppoRefresh) {
							datas2.clear();
						}
					}
					// 刷新页面数据
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

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.sameFriendButton:
				// 获取列表
				same_user_viewPager.setCurrentItem(0);
				break;
			case R.id.oppoFriendButton:
				// 获取列表
				isOppoRefresh = true;
				same_user_viewPager.setCurrentItem(1);
				break;
			case R.id.profile_sf_sex_nolimit:
				// 性别不限
				if (searchType == 0) {
					sameSearchBean.sex = 2;
				} else {
					oppoSearchBean.sex = 2;
					isOppoRefresh = true;
				}
				// 更新按钮样式
				refreshSearchChoiceStyle();
				// 获取列表
				showLoading();
				getUserNum();
				break;
			case R.id.profile_sf_sex_male:
				// 男性
				if (searchType == 0) {
					sameSearchBean.sex = 1;
				} else {
					isOppoRefresh = true;
					oppoSearchBean.sex = 1;
				}
				// 更新按钮样式
				refreshSearchChoiceStyle();
				// 获取列表
				showLoading();
				getUserNum();
				break;
			case R.id.profile_sf_sex_famale:
				// 女性
				if (searchType == 0) {
					sameSearchBean.sex = 0;
				} else {
					isOppoRefresh = true;
					oppoSearchBean.sex = 0;
				}
				// 更新按钮样式
				refreshSearchChoiceStyle();
				// 获取列表
				showLoading();
				getUserNum();
				break;
			case R.id.profile_sf_marray_nolimit:
				// 情感状态-不限
				if (searchType == 0) {
					sameSearchBean.marriage = 0;
				} else {
					isOppoRefresh = true;
					oppoSearchBean.marriage = 0;
				}
				// 更新按钮样式
				refreshSearchChoiceStyle();
				// 获取列表
				showLoading();
				getUserNum();
				break;
			case R.id.profile_sf_marray_single:
				// 情感状态-单身
				if (searchType == 0) {
					sameSearchBean.marriage = 1;
				} else {
					isOppoRefresh = true;
					oppoSearchBean.marriage = 1;
				}
				// 更新按钮样式
				refreshSearchChoiceStyle();
				// 获取列表
				showLoading();
				getUserNum();
				break;
			case R.id.profile_sf_search_button:
				// 显示，隐藏
				Util.collapse_expand(profile_sf_search_box, new OnAnimationCallBack() {
					@Override
					public void onComplete(int visible, int viewId) {
						if (visible == View.VISIBLE) {
							// 可见
							profile_sf_search_button.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.icon_up, 0);
						} else {
							// 不可见
							profile_sf_search_button.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.icon_down, 0);
						}
					}
				});
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 获取好友数量
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getUserNum() {
		if (searchType == 0) {
			// 共同好友
			UtilRequest.getMutualFriendsNums(J_Cache.sLoginUser.uid + "", currentUserInfo.uid + "", mHandler);
		} else {
			// ta的好友
			UtilRequest.getFriendsNums(currentUserInfo.uid + "", 1, 1, mHandler, mContext);
		}
	}

	/**
	 * 获取好友列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getUserList() {
		if (searchType == 0) {
			// 共同好友
			UtilRequest.getMutualFriends(J_Cache.sLoginUser.uid + "", currentUserInfo.uid + "", 0, sameSearchBean.num,
					sameSearchBean.sex, sameSearchBean.marriage, mHandler);
		} else {
			// ta的好友
			int start = 0;
			if (!isOppoRefresh) {
				start = datas2.size();
			}
			UtilRequest.getFriendsListSearch(currentUserInfo.uid + "", mHandler, mContext, start, oppoSearchBean.num,
					oppoSearchBean.sex, oppoSearchBean.marriage);
		}
	}

	/**
	 * ViewPager的适配器
	 * 
	 * @author likai
	 */
	private class UserPagerAdapter extends PagerAdapter {
		@Override
		public void destroyItem(View v, int position, Object obj) {
			((ViewPager) v).removeView(mViews.get(position));
		}

		@Override
		public void finishUpdate(View arg0) {
		}

		@Override
		public int getCount() {
			return mViews.size();
		}

		@Override
		public Object instantiateItem(View v, int position) {
			((ViewPager) v).addView(mViews.get(position));
			return mViews.get(position);
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == arg1;
		}

		@Override
		public void restoreState(Parcelable arg0, ClassLoader arg1) {
		}

		@Override
		public Parcelable saveState() {
			return null;
		}

		@Override
		public void startUpdate(View arg0) {
		}
	}

	/**
	 * ViewPager的PageChangeListener(页面改变的监听器)
	 * 
	 * @author likai
	 */
	private class MyPagerOnPageChangeListener implements OnPageChangeListener {
		@Override
		public void onPageScrollStateChanged(int arg0) {
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
		}

		/**
		 * 滑动ViewPager的时候,让上方的HorizontalScrollView自动切换
		 * 
		 */
		@Override
		public void onPageSelected(int position) {
			if (position == 0) {
				// 共同好友
				searchType = 0;
				// 更新按钮样式
				refreshSearchChoiceStyle();
				if (!isSameViewShown) {
					showLoading();
					isSameViewShown = true;
					getUserNum();// 首次加载该页面，需要请求数据
				}
			} else if (position == 1) {
				// 对方的好友
				searchType = 1;
				// 更新按钮样式
				refreshSearchChoiceStyle();
				// 如果该页面没有加载过，执行加载操作
				if (!isOppoViewShown) {
					showLoading();
					isOppoViewShown = true;
					isOppoRefresh = true;
					getUserNum();// 首次加载该页面，需要请求数据
				}
			}
		}
	}
}
