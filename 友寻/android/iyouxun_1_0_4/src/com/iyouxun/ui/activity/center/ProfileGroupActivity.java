package com.iyouxun.ui.activity.center;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.GroupsListAdapter;
import com.iyouxun.utils.ToastUtil;

/**
 * 群组管理（是否个人资料页展示的管理）
 * 
 * @ClassName: ProfileGroupActivity
 * @author likai
 * @date 2015-2-28 下午2:38:58
 * 
 */
public class ProfileGroupActivity extends CommTitleActivity {
	private ListView profile_groups_lv;
	private GroupsListAdapter adapter;
	private final ArrayList<GroupsInfoBean> datas = new ArrayList<GroupsInfoBean>();
	private LinearLayout group_warm_box;

	private int currentEditPosition;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("群组");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_profile_groups, null);
	}

	@Override
	protected void initViews() {
		profile_groups_lv = (ListView) findViewById(R.id.profile_groups_lv);

		View emptyView = View.inflate(mContext, R.layout.empty_layer, null);
		TextView tv = (TextView) emptyView.findViewById(R.id.emptyTv);
		tv.setText("没有群组信息");
		profile_groups_lv.setEmptyView(emptyView);

		// 添加顶部提示信息
		View headerView = View.inflate(mContext, R.layout.group_manage_warm_layer, null);
		group_warm_box = (LinearLayout) headerView.findViewById(R.id.group_warm_box);
		profile_groups_lv.addHeaderView(headerView, null, false);

		adapter = new GroupsListAdapter(this);
		adapter.setData(datas);
		profile_groups_lv.setAdapter(adapter);
		profile_groups_lv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// 因为添加了顶部header提示信息，所以整体偏移-1
				int realPosition = position - 1;
				realPosition = realPosition < 0 ? 0 : realPosition;

				currentEditPosition = realPosition;
				GroupsInfoBean bean = datas.get(realPosition);
				int currentStatus = -1;
				if (bean.show == 1) {
					currentStatus = 0;
				} else {
					currentStatus = 1;
				}
				// 发送请求更新设置
				showLoading();
				UtilRequest.updateGroupShow(bean.id + "", currentStatus, mHandler, mContext);
			}
		});

		// 获取群组列表
		getGroupsInfo();
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_UPDATE_GROUP_SHOW:
				try {
					JSONObject showObject = new JSONObject(msg.obj.toString());
					int result = showObject.optInt(UtilRequest.FORM_RESULT);
					if (result == 1) {
						ToastUtil.showToast(mContext, "群主已经修改群组状态为不公开，修改失败！");
					} else {
						// 修改成功
						GroupsInfoBean bean = datas.get(currentEditPosition);
						if (bean.show == 1) {
							bean.show = 0;
						} else {
							bean.show = 1;
						}
						datas.set(currentEditPosition, bean);
						adapter.setData(datas);
						adapter.notifyDataSetChanged();
					}
				} catch (JSONException e) {
					ToastUtil.showToast(mContext, "群组状态更新失败，请再次尝试！");
					e.printStackTrace();
				}
				dismissLoading();
				break;
			case NetTaskIDs.TASKID_GROUP_LIST:
				// 获取群组列表
				try {
					JSONArray groupArray = new JSONArray(msg.obj.toString());
					datas.clear();
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
						bean.hint = groupOjb.optInt("hint");
						datas.add(bean);
					}
					// 存在数据的情况下，显示提醒信息
					if (datas.size() > 0) {
						group_warm_box.setVisibility(View.VISIBLE);
					}

					// 刷新页面数据
					adapter.notifyDataSetChanged();
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

	/**
	 * 获取群组信息
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getGroupsInfo() {
		showLoading();
		UtilRequest.getGroupList(J_Cache.sLoginUser.uid + "", mHandler, mContext);
	}

}
