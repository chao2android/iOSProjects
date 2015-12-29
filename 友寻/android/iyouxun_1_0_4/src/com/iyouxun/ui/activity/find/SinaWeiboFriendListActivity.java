package com.iyouxun.ui.activity.find;

import java.util.ArrayList;
import java.util.HashMap;

import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.sina.weibo.SinaWeibo;

import com.iyouxun.R;
import com.iyouxun.data.beans.OpenPlatformBeans;
import com.iyouxun.open.J_OpenManager;
import com.iyouxun.open.J_ShareParams;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.SinaWeiboFriendListAdapter;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.OpenPlatformUtil;
import com.iyouxun.utils.ToastUtil;

/**
 * @ClassName: SinaWeiboFriendListActivity
 * @Description: 新浪微博好友列表
 * @author donglizhi
 * @date 2015年3月10日 下午3:10:51
 * 
 */
public class SinaWeiboFriendListActivity extends CommTitleActivity {
	private TextView friendsSize;// 好友数量
	private ListView friendList;// 好友列表
	private SinaWeiboFriendListAdapter adapter;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.sina_weibo_friends);
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_sina_weibo_friends, null);
	}

	@Override
	protected void initViews() {
		mContext = SinaWeiboFriendListActivity.this;
		friendsSize = (TextView) findViewById(R.id.sina_weibo_friends_size);
		friendList = (ListView) findViewById(R.id.sina_weibo_friends_list);
		if (getIntent().hasExtra("sinaWeiboFriends")) {
			ArrayList<OpenPlatformBeans> arrayList = (ArrayList<OpenPlatformBeans>) getIntent().getSerializableExtra(
					"sinaWeiboFriends");
			friendsSize.setText("可邀请的好友" + "( " + arrayList.size() + " )");
			adapter = new SinaWeiboFriendListAdapter(mContext, arrayList, listener);
			friendList.setAdapter(adapter);
		}
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				finish();
				break;
			case R.id.sina_weibo_btn_invitation:
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				String userName = "@" + (String) v.getTag();
				J_ShareParams params = OpenPlatformUtil.inviteNewFriend(userName);
				J_OpenManager.getInstance().share(SinaWeiboFriendListActivity.this, SinaWeibo.NAME, params,
						new PlatformActionListener() {

							@Override
							public void onError(Platform arg0, int arg1, Throwable arg2) {
								Log.d("leif", "arg2====" + arg2.getMessage());
								DialogUtils.dismissDialog();
								showToast(getString(R.string.platform_send_fail));
							}

							@Override
							public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
								DialogUtils.dismissDialog();
								showToast(getString(R.string.platform_send_success));
							}

							@Override
							public void onCancel(Platform arg0, int arg1) {
								DialogUtils.dismissDialog();
								showToast(getString(R.string.platform_send_cancel));
							}
						}, true);
				break;
			default:
				break;
			}
		}
	};

	private void showToast(final String text) {
		mHandler.post(new Runnable() {

			@Override
			public void run() {
				ToastUtil.showToast(mContext, text);
			}
		});
	}

	private final Handler mHandler = new Handler() {
	};
}
