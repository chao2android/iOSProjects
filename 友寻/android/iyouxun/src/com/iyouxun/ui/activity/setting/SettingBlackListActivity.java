package com.iyouxun.ui.activity.setting;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.R;
import com.iyouxun.comparator.PinyinComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.data.beans.SortInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.CharacterParser;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.activity.find.SelectFriendsActivity;
import com.iyouxun.ui.adapter.BlackListAdapter;
import com.iyouxun.ui.views.SideBar;
import com.iyouxun.ui.views.SideBar.OnTouchingLetterChangedListener;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 黑名单列表
 * 
 * @ClassName: SettingBlackListActivity
 * @author likai
 * @date 2015-3-9 下午7:41:55
 * 
 */
public class SettingBlackListActivity extends CommTitleActivity {
	private PullToRefreshListView settingBlackListView;
	private final ArrayList<SortInfoBean> datas = new ArrayList<SortInfoBean>();
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	/** 根据拼音来排列ListView里面的数据类 */
	private PinyinComparator pinyinComparator;
	private SideBar sideBar;
	// 黑名单adapter
	private BlackListAdapter adapter;
	// 页码
	private int PAGE = 1;
	// 每页加载数量
	private final int PAGE_SIZE = 50;

	private final int REQUEST_CODE_SELECT_FRIENDS = 0X1000;
	public static final int RESULT_CODE_SELECT_FRIENDS = 0X1001;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("黑名单");
		titleLeftButton.setText("关闭");
		titleLeftButton.setVisibility(View.VISIBLE);
		titleRightButton.setText("添加成员");
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_black_list, null);
	}

	@Override
	protected void initViews() {
		settingBlackListView = (PullToRefreshListView) findViewById(R.id.settingBlackListView);
		sideBar = (SideBar) findViewById(R.id.sidebar);

		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		pinyinComparator = new PinyinComparator();

		// 设置空数据提示
		View emptyView = View.inflate(mContext, R.layout.empty_layer, null);
		TextView emptyTv = (TextView) emptyView.findViewById(R.id.emptyTv);
		emptyTv.setText("没有黑名单信息");
		settingBlackListView.setEmptyView(emptyView);

		adapter = new BlackListAdapter();
		adapter.setDatas(datas);
		settingBlackListView.setAdapter(adapter);
		// 上拉刷新
		settingBlackListView.setMode(Mode.BOTH);
		settingBlackListView.setOnRefreshListener(new OnRefreshListener2<ListView>() {
			@Override
			public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
				PAGE = 1;
				// 获取黑名单列表
				getBlackListInfo();
			}

			@Override
			public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
				// 获取黑名单列表
				getBlackListInfo();
			}
		});
		// 单击选项跳转资料页
		settingBlackListView.getRefreshableView().setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				int realPosition = position - settingBlackListView.getRefreshableView().getHeaderViewsCount();

				SortInfoBean bean = datas.get(realPosition);

				Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
				profileIntent.putExtra("uid", bean.uid);
				startActivity(profileIntent);
			}
		});
		// 长按移出黑名单
		settingBlackListView.getRefreshableView().setOnItemLongClickListener(new OnItemLongClickListener() {
			@Override
			public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
				final int realPosition = position - settingBlackListView.getRefreshableView().getHeaderViewsCount();

				final SortInfoBean bean = datas.get(realPosition);
				DialogUtils.showPromptDialog(mContext, "删除黑名单用户", "确定删除：" + bean.name, new OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if (value1.equals("0")) {
							// 从列表中移除该用户
							datas.remove(realPosition);
							adapter.notifyDataSetChanged();
							// 请求接口进行删除操作
							UtilRequest.delBlackListUser(bean.uid, mHandler);
						}
					}
				});
				return true;
			}
		});

		// 设置右侧触摸监听
		sideBar.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {
			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = adapter.getPositionForSection(s.charAt(0));
				if (position != -1) {
					settingBlackListView.getRefreshableView().setSelection(position);
				}
			}
		});

		// 获取黑名单列表
		showLoading();
		getBlackListInfo();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == REQUEST_CODE_SELECT_FRIENDS) {
			if (resultCode == RESULT_CODE_SELECT_FRIENDS) {
				ArrayList<ManageFriendsBean> allFriends = (ArrayList<ManageFriendsBean>) data.getSerializableExtra("friendsData");
				StringBuilder sb = new StringBuilder();
				for (int i = 0; i < allFriends.size(); i++) {
					ManageFriendsBean bean = allFriends.get(i);
					if (sb.length() > 0) {
						sb.append(",");
					}
					sb.append(bean.getUid());
				}
				UtilRequest.addBlack(J_Cache.sLoginUser.uid + "", sb.toString(), mHandler);
			}
		}
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_ADD_BLACK:
				// 添加黑名单用户返回结果
				int errorId = msg.arg1;
				if (errorId != 0) {
					String errInfo = J_NetManager.getInstance().getErrorMsg(errorId);
					ToastUtil.showToast(mContext, errInfo);
					dismissLoading();
				} else {
					J_Response responseAdd = (J_Response) msg.obj;
					if (responseAdd.retcode == 1) {
						if (responseAdd.data.equals("true")) {
							// 添加成功--重新刷新列表
							PAGE = 1;
							getBlackListInfo();
						} else {
							// 添加失败
							ToastUtil.showToast(mContext, "添加黑名单用户失败");
						}
					}
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDSNUMS_ALL:
				// 获取好友数量
				int errorId2 = msg.arg1;
				if (errorId2 != 0) {
					dismissLoading();
				} else {
					int friendsNums = Util.getInteger(msg.obj.toString());
					if (friendsNums <= 0) {
						dismissLoading();
						ToastUtil.showToast(mContext, "没有好友");
					} else {
						// 根据好友数量，获取好友列表
						if (friendsNums > UtilRequest.GET_MY_FRIENDS_LIST_NUMS) {
							UtilRequest.getFriendsAll(J_Cache.sLoginUser.uid, 0, friendsNums, mHandler, mContext);
						} else {
							UtilRequest.getFriendsAll(J_Cache.sLoginUser.uid, 0, UtilRequest.GET_MY_FRIENDS_LIST_NUMS, mHandler,
									mContext);
						}
					}
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_ALL:// 获取所有一度、二度好友
				dismissLoading();
				Intent intent = new Intent(mContext, SelectFriendsActivity.class);
				intent.putExtra("pageType", 1);
				startActivityForResult(intent, REQUEST_CODE_SELECT_FRIENDS);
				break;
			case NetTaskIDs.TASKID_DEL_BLACKLIST:
				// 删除联系人
				ToastUtil.showToast(mContext, "删除成功");
				break;
			case NetTaskIDs.TASKID_GET_BLACKLIST_LIST:
				// 获取黑名单列表
				int errorId3 = msg.arg1;
				if (errorId3 != 0) {
					dismissLoading();
				} else {
					J_Response response = (J_Response) msg.obj;
					if (response.retcode == 1) {
						try {
							if (PAGE == 1) {
								datas.clear();
							}
							if (!Util.isBlankString(response.data) && !response.data.equals("[]")) {
								JSONObject jsonData = new JSONObject(response.data);
								Iterator it = jsonData.keys();
								while (it.hasNext()) {
									String key = (String) it.next();
									JSONObject singleData = jsonData.optJSONObject(key);

									SortInfoBean user = new SortInfoBean();
									user.uid = singleData.optLong("uid");
									user.name = singleData.optString("nick");
									JSONObject avatarData = singleData.optJSONObject("avatars");
									user.avatar = avatarData.optString("200");
									user.marriage = singleData.optInt("marriage");
									user.friendDimen = singleData.optInt("is_myfriends");
									user.sameFriendsNum = singleData.optInt("mutualmus");
									user.sex = singleData.optInt("sex");
									if (user.uid != J_Cache.sLoginUser.uid) {
										// 过滤掉黑名单中的自己
										datas.add(user);
									}
								}
								PAGE++;
							}
						} catch (Exception e) {
							e.printStackTrace();
						}
						for (int i = 0; i < datas.size(); i++) {
							SortInfoBean sortModel = datas.get(i);
							// 汉字转换成拼音
							String pinyin = characterParser.getSelling(sortModel.name);
							String sortString = pinyin.substring(0, 1).toUpperCase();

							// 正则表达式，判断首字母是否是英文字母
							if (sortString.matches("[A-Z]")) {
								sortModel.sortLetter = sortString.toUpperCase();
							} else {
								sortModel.sortLetter = "#";
							}
							datas.set(i, sortModel);
						}

						// 根据a-z进行排序源数据
						Collections.sort(datas, pinyinComparator);

						// 刷新页面信息
						adapter.setDatas(datas);
						adapter.notifyDataSetChanged();
						settingBlackListView.onRefreshComplete();
					}
					dismissLoading();
				}
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 获取黑名单列表
	 * 
	 * @Title: getBlackListInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getBlackListInfo() {
		// 请求接口获取数据
		UtilRequest.getBlackList(PAGE, PAGE_SIZE, mContext, mHandler);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:
				showLoading();
				// 首先获取好友数量
				UtilRequest.getFriendsAllNums(J_Cache.sLoginUser.uid, 3, mHandler, mContext);
				break;

			default:
				break;
			}
		}
	};
}
