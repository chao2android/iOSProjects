package com.iyouxun.ui.activity.find;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;

import android.content.Intent;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.FriendsGroupBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.FriendsGroupListAdapter;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: FriendsGroupActivity
 * @Description: 好友分组
 * @author donglizhi
 * @date 2015年3月10日 下午7:21:34
 * 
 */
public class FriendsGroupActivity extends CommTitleActivity {
	private ListView groupList;// 分组数据
	private LinearLayout createBox;// 新建层
	private Button btnCeate;// 创建按钮
	private FriendsGroupListAdapter adapter;
	private final ArrayList<FriendsGroupBean> datas = new ArrayList<FriendsGroupBean>();
	private int delPosition = -1;
	private boolean firstLoad = true;// 初次加载该页面

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.friends_group);
		titleLeftButton.setText(R.string.go_back);
		titleRightButton.setText(R.string.str_create);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleRightButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_friends_group, null);
	}

	@Override
	protected void initViews() {
		groupList = (ListView) findViewById(R.id.friends_group_list);
		createBox = (LinearLayout) findViewById(R.id.friends_group_create_box);
		btnCeate = (Button) findViewById(R.id.friends_group_btn_create);
		btnCeate.setOnClickListener(listener);
		adapter = new FriendsGroupListAdapter(mContext, datas);
		groupList.setAdapter(adapter);
		groupList.setOnItemLongClickListener(onItemLongClickListener);
		groupList.setOnItemClickListener(onItemClickListener);
		String groupData = SharedPreUtil.getFriendsGroupData();
		if (Util.isBlankString(groupData)) {
			UtilRequest.getFriendsGroupList(J_Cache.sLoginUser.uid + "", mHandler, mContext);
		} else {
			parserFriendsGroupData(groupData);
		}
	}

	@Override
	protected void onResume() {
		super.onResume();
		if (firstLoad) {
			firstLoad = false;
		} else {
			String groupData = SharedPreUtil.getFriendsGroupData();
			if (!Util.isBlankString(groupData)) {
				parserFriendsGroupData(groupData);
			}
		}
	}

	/**
	 * @Title: parserFriendsGroupData
	 * @Description: 解析好友分组数据
	 * @return void 返回类型
	 * @param @param str 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void parserFriendsGroupData(String str) {
		datas.clear();
		try {
			JSONArray dataArray = new JSONArray(str);
			for (int i = 0; i < dataArray.length(); i++) {
				JSONArray item = dataArray.optJSONArray(i);
				FriendsGroupBean bean = new FriendsGroupBean();
				String groupId = item.optString(0);
				String groupName = item.optString(1);
				int count = item.optInt(2);
				if (count <= 0) {// 删除群组成员为0的群组
					delPosition = -1;
					UtilRequest.delFriendsGroup(J_Cache.sLoginUser.uid + "", groupId, mHandler, mContext, false);
					continue;
				}
				bean.setGroupName(groupName);
				bean.setGroupId(groupId);
				bean.setGroupMembersCount(count);
				datas.add(bean);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		if (datas.size() > 0) {
			adapter.notifyDataSetChanged();
			createBox.setVisibility(View.GONE);
		} else {
			adapter.notifyDataSetChanged();
			createBox.setVisibility(View.VISIBLE);
		}
	}

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			FriendsGroupBean bean = datas.get(position);
			Intent editIntent = new Intent(mContext, EditFriendsGroupActivity.class);
			editIntent.putExtra(UtilRequest.FORM_FORM, bean);
			startActivity(editIntent);
		}
	};

	private final OnItemLongClickListener onItemLongClickListener = new OnItemLongClickListener() {

		@Override
		public boolean onItemLongClick(AdapterView<?> parent, View view, final int position, long id) {
			DialogUtils.showPromptDialog(mContext, "删除分组", "确定删除分组?", new OnSelectCallBack() {

				@Override
				public void onCallBack(String value1, String value2, String value3) {
					if ("0".equals(value1)) {
						delPosition = position;
						DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
						UtilRequest.delFriendsGroup(J_Cache.sLoginUser.uid + "", datas.get(position).getGroupId(), mHandler,
								mContext, true);
					}
				}
			});
			return true;
		}
	};

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 头部左侧按钮
				goBack();
				break;
			case R.id.titleRightButton:// 新建按钮
			case R.id.friends_group_btn_create:// 新建按钮
				Intent intent = new Intent(mContext, SelectFriendsActivity.class);
				startActivity(intent);
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
			case NetTaskIDs.TASKID_FRIENDS_DEL_GROUP:// 删除好友分组
				if (delPosition >= 0) {
					datas.remove(delPosition);
					String groupData = SharedPreUtil.getFriendsGroupData();
					try {
						JSONArray array = new JSONArray(groupData);
						if (array.length() > delPosition) {
							JSONArray array2 = new JSONArray();
							for (int i = 0; i < array.length(); i++) {
								if (i != delPosition) {
									array2.put(array.get(i));
								}
							}
							SharedPreUtil.setFriendsGroupData(array2.toString());
						}
					} catch (JSONException e) {
						e.printStackTrace();
					}

					adapter.notifyDataSetChanged();
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_GROUP_LIST:// 获得分组列表
				String str = (String) msg.obj;
				parserFriendsGroupData(str);
				break;

			default:
				break;
			}
		};
	};

	@Override
	public boolean onKeyDown(int keyCode, android.view.KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			goBack();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	};

	private void goBack() {
		Intent intent = new Intent();
		intent.putExtra(JsonParser.RESPONSE_DATA, datas.size());
		setResult(RESULT_OK, intent);
		finish();
	}
}
