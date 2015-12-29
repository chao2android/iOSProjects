package com.iyouxun.ui.activity.find;

import java.util.ArrayList;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnKeyListener;
import android.content.Intent;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.FindFriendsBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.FriendListAdapter;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: FindActivity
 * @Description: 发现页面
 * @author donglizhi
 * @date 2015年3月7日 下午4:16:35
 * 
 */
public class FindActivity extends CommTitleActivity {
	private ListView findListView;
	private Context mContext;
	private FriendListAdapter adapter;
	/**
	 * @Fields textIds : 显示的文本数据
	 */
	private final int[] textIds = { R.string.str_add_friends, R.string.str_find_indirect_friends, R.string.str_manage_friends };
	/**
	 * @Fields imageIds : 展示的icon
	 */
	private final int[] imageIds = { R.drawable.icn_add_friends, R.drawable.icn_indirect_friends, R.drawable.icn_friends };
	private final ArrayList<FindFriendsBean> array = new ArrayList<FindFriendsBean>();// 展示数据
	private int friendType = 1;// 1一度2二度
	private Dialog loadingDialog;// 加载对话框

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.str_find);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_find, null);
	}

	@Override
	protected void initViews() {
		mContext = FindActivity.this;
		findListView = (ListView) findViewById(R.id.find_friend_list);
		for (int i = 0; i < textIds.length; i++) {
			FindFriendsBean bean = new FindFriendsBean();
			bean.setImageId(imageIds[i]);
			bean.setTextId(textIds[i]);
			array.add(bean);
		}
		adapter = new FriendListAdapter(mContext, array);
		findListView.setAdapter(adapter);
		findListView.setOnItemClickListener(onItemClickListener);
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS:// 好友数量
				int friendsNums = Util.getInteger(msg.obj.toString());
				if (friendsNums <= 0) {
					DialogUtils.dismissDialog();
					Intent noFriendsIntent = new Intent(mContext, NoFriendsActivity.class);
					noFriendsIntent.putExtra(UtilRequest.FORM_TYPE, friendType);
					startActivity(noFriendsIntent);
				} else {
					adapter.notifyDataSetChanged();
					if (friendType == 1) {// 一度好友
						if (friendsNums > UtilRequest.GET_MY_FRIENDS_LIST_NUMS) {
							UtilRequest.getFriendsList(J_Cache.sLoginUser.uid + "", mHandler, mContext, 0, friendsNums);
						} else {
							UtilRequest.getFriendsList(J_Cache.sLoginUser.uid + "", mHandler, mContext, 0,
									UtilRequest.GET_MY_FRIENDS_LIST_NUMS);
						}
						SharedPreUtil.setMyfriendsNums(friendsNums);
					} else if (friendType == 2) {// 二度好友
						DialogUtils.dismissDialog();
						Intent intent = new Intent();
						intent.setClass(mContext, FindIndirectFriendsActivity.class);
						intent.putExtra(UtilRequest.FORM_NUMS, friendsNums);
						startActivity(intent);
					}
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL:// 所用好友
				DialogUtils.dismissDialog();
				Intent intent = new Intent();
				intent.setClass(mContext, ManageFriendsActivity.class);
				startActivity(intent);
				break;
			default:
				break;
			}
		};
	};

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			Intent intent = new Intent();
			switch (position) {
			case 0:
				// 添加好友页面
				intent.setClass(mContext, AddFriendsActivity.class);
				startActivity(intent);
				break;
			case 1:
				// 发现二度好友
				friendType = 2;
				loadingDialog = DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				loadingDialog.setOnKeyListener(onKeyListener);
				UtilRequest.getFriendsNums(J_Cache.sLoginUser.uid + "", friendType, 1, mHandler, mContext);
				break;
			case 2:
				// 管理一度好友
				String myFriendsData = SharedPreUtil.getMyFriendsData();
				if (Util.isBlankString(myFriendsData)) {// 没有缓存数据加载数据
					loadingDialog = DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					loadingDialog.setOnKeyListener(onKeyListener);
					friendType = 1;
					UtilRequest.getFriendsNums(J_Cache.sLoginUser.uid + "", friendType, 1, mHandler, mContext);
				} else {// 有缓存数据先跳转
					Intent manageFriendsIntent = new Intent();
					manageFriendsIntent.setClass(mContext, ManageFriendsActivity.class);
					startActivity(manageFriendsIntent);
				}
				break;
			}

		}
	};

	private final OnKeyListener onKeyListener = new OnKeyListener() {

		@Override
		public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
			if (event.getKeyCode() == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_DOWN) {
				// 取消之前的请求
				J_NetManager.getInstance().cancelAllRequest(NetConstans.FRIENDS_GET_FRIENDS_NUMS_URL);
				J_NetManager.getInstance().cancelAllRequest(NetConstans.FRIENDS_GET_MY_FRIENDS_ALL_URL);
			}
			dialog.dismiss();
			return true;
		}
	};
}
