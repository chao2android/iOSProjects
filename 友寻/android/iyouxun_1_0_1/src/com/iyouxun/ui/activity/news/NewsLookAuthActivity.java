package com.iyouxun.ui.activity.news;

import java.util.ArrayList;

import org.json.JSONArray;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.FriendsGroupBean;
import com.iyouxun.data.beans.NewsAuthInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.find.FriendsGroupActivity;
import com.iyouxun.ui.adapter.NewsAuthGroupListAdapter;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;

/**
 * 查看权限(选择好友分组)
 * 
 * @ClassName: NewsLookAuthActivity
 * @author likai
 * @date 2015-3-6 下午5:28:27
 * 
 */
public class NewsLookAuthActivity extends CommTitleActivity {
	private RelativeLayout newsLookAuthAllBoxButton;
	private CheckBox newsLookAuthAllButton;
	private LinearLayout newsLookAuthGroupBoxButton;
	private ImageView newsLookAuthStatusIcon;// 小图标
	private ListView newsLookAuthGroupListView;// 分组列表

	// 选择的数据
	private NewsAuthInfoBean authData;
	// 分组列表adapter
	private NewsAuthGroupListAdapter adapter;
	// 列表数据
	private final ArrayList<FriendsGroupBean> datas = new ArrayList<FriendsGroupBean>();

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("查看权限");
		// 左侧按钮
		titleLeftButton.setText("新动态");
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		// 右侧按钮
		titleRightButton.setText("分组设置");
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_news_look_auth_layout, null);
	}

	@Override
	protected void initViews() {
		authData = (NewsAuthInfoBean) getIntent().getSerializableExtra("authData");

		newsLookAuthAllBoxButton = (RelativeLayout) findViewById(R.id.newsLookAuthAllBoxButton);
		newsLookAuthAllButton = (CheckBox) findViewById(R.id.newsLookAuthAllButton);
		newsLookAuthGroupBoxButton = (LinearLayout) findViewById(R.id.newsLookAuthGroupBoxButton);
		newsLookAuthStatusIcon = (ImageView) findViewById(R.id.newsLookAuthStatusIcon);
		newsLookAuthGroupListView = (ListView) findViewById(R.id.newsLookAuthGroupListView);

		// 设置listview信息
		adapter = new NewsAuthGroupListAdapter();
		adapter.setDatas(datas);
		newsLookAuthGroupListView.setAdapter(adapter);

		// 设置默认选项
		if (authData.lookAuthType == 1) {
			// 所有用户
			newsLookAuthAllButton.setChecked(true);
		} else {
			// 指定分组
			newsLookAuthAllButton.setChecked(false);
		}

		// 选中点击
		newsLookAuthAllBoxButton.setOnClickListener(listener);
		newsLookAuthGroupBoxButton.setOnClickListener(listener);

		// 指定分组列表item选项点击
		newsLookAuthGroupListView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				DLog.d("likai-test", "click--item--");
				// 取消“所有好友”选中状态
				newsLookAuthAllButton.setChecked(false);// 设置类型为“指定分组”
				authData.lookAuthType = 2;
				// 当前点击群组的信息
				FriendsGroupBean bean = datas.get(position);
				String groupId = bean.getGroupId();
				if (bean.getIsChecked() == 0) {
					// 当前状态为未选中状态，设置为选中状态
					bean.setIsChecked(1);
					boolean isHave = false;
					for (int i = 0; i < authData.lookAuth.size(); i++) {
						if (authData.lookAuth.get(i).equals(groupId)) {
							isHave = true;
						}
					}
					if (!isHave) {
						// 不存在该分组，添加该分组
						authData.lookAuth.add(groupId);
					}
				} else {
					// 当前状态为选中状态，设置为未选中状态啊
					bean.setIsChecked(0);
					for (int i = 0; i < authData.lookAuth.size(); i++) {
						if (authData.lookAuth.get(i).equals(groupId)) {
							authData.lookAuth.remove(i);
							break;
						}
					}
				}
				datas.set(position, bean);
				adapter.notifyDataSetChanged();
			}
		});
	}

	@Override
	protected void onResume() {
		super.onResume();
		// 刷新分组信息
		getGroupsListInfo();
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_FRIENDS_GET_GROUP_LIST:
				// 获取好友分组列表
				String friendsGroupData = SharedPreUtil.getFriendsGroupData();
				try {
					datas.clear();
					JSONArray dataArray = new JSONArray(friendsGroupData);
					for (int i = 0; i < dataArray.length(); i++) {
						JSONArray item = dataArray.optJSONArray(i);
						FriendsGroupBean bean = new FriendsGroupBean();
						String groupId = item.optString(0);
						String groupName = item.optString(1);
						int count = item.optInt(2);
						bean.setGroupName(groupName);
						bean.setGroupId(groupId);
						bean.setGroupMembersCount(count);
						// 如果传来的存在指定分组信息，设置选中
						for (int j = 0; j < authData.lookAuth.size(); j++) {
							if (bean.getGroupId().equals(authData.lookAuth.get(j))) {
								bean.setIsChecked(1);
							}
						}
						datas.add(bean);
					}

					adapter.notifyDataSetChanged();
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 获取分组列表
	 * 
	 * @Title: getGroupsListInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getGroupsListInfo() {
		UtilRequest.getFriendsGroupList(J_Cache.sLoginUser.uid + "", mHandler, mContext);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				// 返回保存信息
				if (authData.lookAuthType == 2 && authData.lookAuth.size() <= 0) {
					ToastUtil.showToast(mContext, "请选择分组");
				} else {
					Intent intentData = new Intent();
					intentData.putExtra("authData", authData);
					setResult(AddNewNewsActivity.AUTH_RESULT_CODE, intentData);
					finish();
				}
				break;
			case R.id.titleRightButton:
				// 分组设置
				Intent groupIntent = new Intent(mContext, FriendsGroupActivity.class);
				startActivity(groupIntent);
				break;
			case R.id.newsLookAuthAllBoxButton:
				// 选择所有好友
				DLog.d("likai-test", "click--all--");
				// 取消所有指定好友的选中
				for (int i = 0; i < datas.size(); i++) {
					FriendsGroupBean tempBean = datas.get(i);
					tempBean.setIsChecked(0);
					datas.set(i, tempBean);
				}
				adapter.notifyDataSetChanged();
				// 选中“所有好友”
				newsLookAuthAllButton.setChecked(true);
				authData.lookAuthType = 1;
				authData.lookAuth.clear();
				break;
			case R.id.newsLookAuthGroupBoxButton:
				// 选择分组
				if (newsLookAuthGroupListView.getVisibility() == View.VISIBLE) {
					// 隐藏
					newsLookAuthGroupListView.setVisibility(View.GONE);
					newsLookAuthStatusIcon.setImageResource(R.drawable.icon_gray_down);
				} else {
					// 显示
					newsLookAuthGroupListView.setVisibility(View.VISIBLE);
					newsLookAuthStatusIcon.setImageResource(R.drawable.icon_gray_up);
				}
				break;
			default:
				break;
			}
		}
	};
}
