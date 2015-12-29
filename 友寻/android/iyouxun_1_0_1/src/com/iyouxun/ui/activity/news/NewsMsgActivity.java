package com.iyouxun.ui.activity.news;

import java.util.ArrayList;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.SystemMsgInfoBean;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.SetOnreadRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.NewsMsgListViewAdapter;
import com.iyouxun.utils.ProfileUtils;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 熟人圈，新消息列表
 * 
 * @ClassName: NewsMsgActivity
 * @author likai
 * @date 2015-3-9 上午10:05:22
 * 
 */
public class NewsMsgActivity extends CommTitleActivity {
	private PullToRefreshListView newsMsgLv;
	private NewsMsgListViewAdapter adapter;
	private final ArrayList<SystemMsgInfoBean> datas = new ArrayList<SystemMsgInfoBean>();
	private int PAGE = 1;
	private final int PAGE_SIZE = 30;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("动态消息");

		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);

		titleRightButton.setText("全部设为已读");
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_news_msg_layout, null);
	}

	@Override
	protected void initViews() {
		newsMsgLv = (PullToRefreshListView) findViewById(R.id.newsMsgLv);

		adapter = new NewsMsgListViewAdapter(this);
		adapter.setData(datas);
		newsMsgLv.setAdapter(adapter);
		// 设置上拉操作
		newsMsgLv.setMode(Mode.PULL_FROM_END);
		newsMsgLv.setOnRefreshListener(new OnRefreshListener<ListView>() {
			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				// 上拉加载下一页
				getMsgInfo();
			}
		});
		newsMsgLv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				int realPosition = position - 1;
				SystemMsgInfoBean bean = datas.get(realPosition);
				// 跳转到对应的动态详情页面
				Intent newsIntent = new Intent(mContext, NewsDetailActivity.class);
				newsIntent.putExtra("feedId", bean.feedId);
				startActivity(newsIntent);
				// 请求置为已读
				new SetOnreadRequest(null).execute(bean.iid, ProfileUtils.getSystemMsgTypeNameFromTypeId(bean.type));
				// 数字-1
				SharedPreUtil.setNewsNewMsgData(SharedPreUtil.getNewsNewMsgData() - 1);
				// 该条记录删除
				datas.remove(realPosition);
				adapter.notifyDataSetChanged();
				if (datas.size() <= 0) {
					finish();
				}
			}
		});

		// 获取动态提醒消息列表
		showLoading();
		getMsgInfo();
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_SET_ONREAD_ALLSYSMSG:
				// 全部置为已读
				SharedPreUtil.setNewsNewMsgData(0);
				// 关闭页面
				finish();
				break;
			case NetTaskIDs.TASKID_LIST_SYSTEM:
				// 获取未读消息列表
				J_Response response = (J_Response) msg.obj;
				if (response.retcode == 1) {
					try {
						JSONArray dataArray = new JSONArray(response.data);
						if (dataArray.length() > 0) {
							for (int i = 0; i < dataArray.length(); i++) {
								JSONObject singleData = dataArray.optJSONObject(i);
								SystemMsgInfoBean bean = new SystemMsgInfoBean();
								bean.iid = singleData.optString("iid");
								bean.feedId = singleData.optInt("fid");
								bean.type = singleData.optInt("type");
								bean.uid = singleData.optLong("uid");
								bean.time = singleData.optString("sendtime");

								bean.avatar = singleData.optString("avatars");
								bean.nick = singleData.optString("nick");
								bean.feedContent = singleData.optString("fcontent");
								String fpids = singleData.optString("fpids");
								if (!Util.isBlankString(fpids)) {
									JSONObject picJson = new JSONObject(fpids);
									if (picJson != null && picJson.length() > 0) {
										Iterator allkeys = picJson.keys();
										while (allkeys.hasNext()) {
											String key = (String) allkeys.next();
											if (!Util.isBlankString(key)) {
												JSONObject picInfo = picJson.optJSONObject(key);
												bean.feedImgUrl = picInfo.optString("300");
											}
										}
									}
								}
								bean.commentContent = singleData.optString("reply");
								bean.feedType = singleData.optInt("ftype");

								datas.add(bean);
							}

							// 页码+1
							PAGE++;
						} else {
							ToastUtil.showToast(mContext, "没有更多新消息了");
						}
					} catch (Exception e) {
						e.printStackTrace();
					}

					// 获取系统消息列表
					dismissLoading();
					adapter.notifyDataSetChanged();
					newsMsgLv.onRefreshComplete();
					// 页面中没有可显示数据，关闭页面
					if (datas.size() <= 0) {
						SharedPreUtil.setNewsNewMsgData(0);
						ToastUtil.showToast(mContext, "没有更多新消息了");
						finish();
					}
				}
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 获取动态提醒消息列表
	 * 
	 * @Title: getMsgInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getMsgInfo() {
		UtilRequest.getSystemList("dynamic", PAGE, PAGE_SIZE, 100, 0, 0, mHandler);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:
				// 全部置为已读
				showLoading();
				UtilRequest.setOnreadAll("dynamic", mHandler);
				break;
			case R.id.titleLeftButton:
				// 返回，全部置为已读
				showLoading();
				UtilRequest.setOnreadAll("dynamic", mHandler);
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 捕获用户按键（菜单键和返回键）
	 * 
	 * */
	@Override
	public boolean dispatchKeyEvent(KeyEvent event) {
		if (event.getKeyCode() == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0 && event.getAction() != KeyEvent.ACTION_UP) {
			// 返回物理返回键也置为已读
			UtilRequest.setOnreadAll("dynamic", mHandler);
			return true;
		}
		return super.dispatchKeyEvent(event);
	}
}
