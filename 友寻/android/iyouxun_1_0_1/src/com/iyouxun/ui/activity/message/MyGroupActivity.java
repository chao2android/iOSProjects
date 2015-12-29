package com.iyouxun.ui.activity.message;

import java.util.ArrayList;
import java.util.Collections;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.MyGroupAdapter;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: MyGroupActivity
 * @Description: 我的群组
 * @author donglizhi
 * @date 2015年4月3日 上午10:51:50
 * 
 */
public class MyGroupActivity extends CommTitleActivity {
	private ListView groupList;// 群组列表
	private MyGroupAdapter adapter;
	private final ArrayList<GroupsInfoBean> datas = new ArrayList<GroupsInfoBean>();// 群组数据
	private final ArrayList<GroupsInfoBean> myGroups = new ArrayList<GroupsInfoBean>();// 我的群组数据
	private final ArrayList<GroupsInfoBean> recommendGroups = new ArrayList<GroupsInfoBean>();// 推荐的群组数据

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.my_group);
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_my_group, null);

	}

	@Override
	protected void initViews() {
		mContext = MyGroupActivity.this;
		groupList = (ListView) findViewById(R.id.my_group_list);
		adapter = new MyGroupAdapter(mContext, datas, listener);
		groupList.setAdapter(adapter);
		groupList.setOnItemClickListener(onItemClickListener);
		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		UtilRequest.recommendGroupList(mHandler, mContext);
		IntentFilter filter = new IntentFilter();
		filter.addAction(UtilRequest.BROADCAST_ACTION_EXIT_GROUP);
		registerReceiver(mReceiver, filter);
	}

	@Override
	protected void onResume() {
		super.onResume();
		UtilRequest.getGroupList(J_Cache.sLoginUser.uid + "", mHandler, mContext);
	}

	private final BroadcastReceiver mReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			String groupId = intent.getStringExtra(UtilRequest.FORM_GROUP_ID);
			if (UtilRequest.BROADCAST_ACTION_EXIT_GROUP.equals(action)) {// 退群通知
				for (int i = 0; i < myGroups.size(); i++) {// 退出群组后需要删除该群组
					if (!Util.isBlankString(groupId) && groupId.equals(myGroups.get(i).id + "")) {
						myGroups.remove(i);
						refreshView();
						break;
					}
				}
			}
		}
	};

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(mReceiver);
	};

	/**
	 * @Title: refreshView
	 * @Description: 刷新页面数据
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void refreshView() {
		DialogUtils.dismissDialog();
		datas.clear();
		datas.addAll(myGroups);// 先显示我的群组数据
		if (recommendGroups.size() > 2) {
			datas.add(recommendGroups.get(0));
			datas.add(recommendGroups.get(1));
		} else {
			datas.addAll(recommendGroups);// 再显示推荐的群组数据
		}
		adapter.setMyGroupsSize(myGroups.size());
		adapter.notifyDataSetChanged();
	}

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			if (position < myGroups.size()) {
				Intent intent = new Intent(mContext, ChatMainActivity.class);
				intent.putExtra(UtilRequest.FORM_NICK, datas.get(position).name);
				intent.putExtra(UtilRequest.FORM_GROUP_ID, datas.get(position).id);
				startActivity(intent);
			}
		}
	};

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 头部左侧按钮
				finish();
				break;
			case R.id.my_group_btn_refresh:// 刷新按钮
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.recommendGroupList(mHandler, mContext);
				break;
			case R.id.my_group_btn_join:// 加入按钮
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				int position = (Integer) v.getTag();
				UtilRequest.addGroup(datas.get(position).id, datas.get(position).uid + "", mHandler, mContext);
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
			case NetTaskIDs.TASKID_GROUP_LIST:
				// 获取用户的群组列表
				try {
					JSONArray groupArray = new JSONArray(msg.obj.toString());
					if (groupArray.length() > 0) {
						myGroups.clear();
						for (int i = 0; i < groupArray.length(); i++) {
							JSONObject groupOjb = groupArray.optJSONObject(i);
							GroupsInfoBean bean = new GroupsInfoBean();
							bean.id = groupOjb.optInt("group_id");
							bean.name = groupOjb.optString("title");
							bean.intro = groupOjb.optString("intro");
							bean.count = groupOjb.optInt("total");
							bean.logo = groupOjb.optString("logo");
							bean.friendsNum = groupOjb.optInt("friend_num");
							bean.show = groupOjb.optInt("show");
							myGroups.add(bean);
						}
					}
					refreshView();
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case NetTaskIDs.TASKID_RECOMMEND_GROUP_LIST:// 获取推荐群组列表
				try {
					JSONArray groupArray = new JSONArray(msg.obj.toString());
					recommendGroups.clear();
					for (int i = 0; i < groupArray.length(); i++) {
						JSONObject groupOjb = groupArray.optJSONObject(i);
						GroupsInfoBean bean = new GroupsInfoBean();
						bean.uid = groupOjb.optInt("uid");
						bean.id = groupOjb.optInt("group_id");
						bean.name = groupOjb.optString("title");
						bean.intro = groupOjb.optString("intro");
						bean.count = groupOjb.optInt("total");
						bean.logo = groupOjb.optString("logo");
						bean.friendsNum = groupOjb.optInt("friend_num");
						bean.show = groupOjb.optInt("show");
						recommendGroups.add(bean);
					}
					Collections.shuffle(recommendGroups);// 随机排序
					refreshView();
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case NetTaskIDs.TASKID_ADD_GROUP:// 申请加入群组
				String data = msg.obj.toString();
				try {
					JSONObject dObject = new JSONObject(data);
					int result = dObject.optInt(UtilRequest.FORM_RESULT, 2);
					if (result != 1) {
						DialogUtils.dismissDialog();
						ToastUtil.showToast(mContext, "请等待群主审核");
					} else {
						for (int i = 0; i < recommendGroups.size(); i++) {
							if (recommendGroups.get(i).id == msg.arg1) {
								recommendGroups.get(i).friendsNum++;
								myGroups.add(0, recommendGroups.get(i));
							}
						}
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
				UtilRequest.recommendGroupList(mHandler, mContext);

				break;
			default:
				break;
			}
		};
	};

}
