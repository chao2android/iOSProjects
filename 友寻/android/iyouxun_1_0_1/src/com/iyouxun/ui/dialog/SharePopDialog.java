package com.iyouxun.ui.dialog;

import java.util.ArrayList;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.GridView;
import android.widget.TextView;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

import com.iyouxun.R;
import com.iyouxun.data.beans.SharePlatformInfoBean;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.open.J_OpenManager;
import com.iyouxun.open.J_ShareParams;
import com.iyouxun.ui.adapter.SharePopGridViewAdapter;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 分享弹框
 * 
 * @author likai
 * @date 2014年11月28日 下午4:22:02
 */
public class SharePopDialog extends Dialog {
	private final Activity mActivity;

	// 是否直接分享
	private final boolean isSilentShare = false;

	private GridView item_share_pop_gridview;
	private Button item_share_pop_cancel;
	private TextView item_share_pop_title;// 标题

	private String title = "分享";// 标题内容

	private SharePopGridViewAdapter adapter;

	private final ArrayList<SharePlatformInfoBean> datas = new ArrayList<SharePlatformInfoBean>();

	private final String[] platformNames = { "友寻", "微信", "朋友圈", "微博", "QQ", "动态" };
	private final int[] platformIcons = { R.drawable.icon_open_friend, R.drawable.icon_open_wechat,
			R.drawable.icon_open_wechatmoment, R.drawable.icon_open_weibo, R.drawable.icon_open_qq, R.drawable.icon_open_news };
	private final int[] platformOpentype = { 100, 1, 101, 2, 3, 102 };

	// 分享（授权）参数
	private J_ShareParams params;
	private PlatformActionListener callBack;

	public SharePopDialog(Activity mActivity, int theme) {
		super(mActivity, theme);
		this.mActivity = mActivity;
	}

	/**
	 * 设置显示标题
	 * 
	 * @Title: setDialogTitle
	 * @return SharePopDialog 返回类型
	 * @param @param title
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public SharePopDialog setDialogTitle(String title) {
		this.title = title;
		return this;
	}

	/**
	 * 设置分享参数
	 * 
	 * @return void 返回类型
	 * @param @param params 参数类型
	 * @author likai
	 */
	public SharePopDialog setParams(J_ShareParams params) {
		this.params = params;
		return this;
	}

	/**
	 * 设置回调方法
	 * 
	 * @return void 返回类型
	 * @param @param listener 参数类型
	 * @author likai
	 */
	public SharePopDialog setCallBack(PlatformActionListener callBack) {
		this.callBack = callBack;
		return this;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_share_pop_layout);

		// 设置显示位置
		Window window = getWindow();

		WindowManager.LayoutParams params = window.getAttributes();
		params.width = Util.getScreenWidth(mActivity);
		params.height = WindowManager.LayoutParams.WRAP_CONTENT;
		window.setAttributes(params);
		window.setGravity(Gravity.BOTTOM);
		window.setWindowAnimations(R.style.AnimBottom); // 设置窗口弹出动画

		initViews();
	}

	/**
	 * 设置页面控件
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 */
	private void initViews() {
		item_share_pop_gridview = (GridView) findViewById(R.id.item_share_pop_gridview);
		item_share_pop_cancel = (Button) findViewById(R.id.item_share_pop_cancel);
		item_share_pop_title = (TextView) findViewById(R.id.item_share_pop_title);

		item_share_pop_title.setText(title);

		// 设置显示数据
		// ShareSDK.initSDK(mActivity);
		for (int i = 0; i < platformOpentype.length; i++) {
			// if (platformOpentype[i] == 1 || platformOpentype[i] == 101) {
			// Platform pf = ShareSDK.getPlatform(mActivity, Wechat.NAME);
			// if (!pf.isClientValid()) {
			// continue;
			// }
			// } else if (platformOpentype[i] == 2) {
			// Platform pf = ShareSDK.getPlatform(mActivity, SinaWeibo.NAME);
			// if (!pf.isClientValid()) {
			// continue;
			// }
			// }
			SharePlatformInfoBean bean = new SharePlatformInfoBean();
			bean.name = platformNames[i];
			bean.openType = platformOpentype[i];
			bean.platformIcon = platformIcons[i];
			datas.add(bean);
		}

		// 设置adapter
		adapter = new SharePopGridViewAdapter(mActivity, datas);
		item_share_pop_gridview.setAdapter(adapter);
		ShareSDK.initSDK(mActivity);
		item_share_pop_gridview.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				SharePlatformInfoBean bean = datas.get(position);
				switch (bean.openType) {
				case 1:
					// 微信好友
					Platform pfWechat = ShareSDK.getPlatform(mActivity, Wechat.NAME);
					if (!pfWechat.isClientValid()) {
						ToastUtil.showToast(mActivity, "未安装微信客户端");
					} else {
						doShare(Wechat.NAME);
					}
					break;
				case 2:
					// 微博
					Platform pfSinaWeibo = ShareSDK.getPlatform(mActivity, SinaWeibo.NAME);
					if (!pfSinaWeibo.isClientValid()) {
						ToastUtil.showToast(mActivity, "未安装微博客户端");
					} else {
						doShare(SinaWeibo.NAME);
					}
					break;
				case 3:
					// QQ
					doShare(QQ.NAME);
					break;
				case 100:
					// 友寻好友
					doShare("friend");
					break;
				case 101:
					// 微信朋友圈
					Platform pfWechatMoments = ShareSDK.getPlatform(mActivity, WechatMoments.NAME);
					if (!pfWechatMoments.isClientValid()) {
						ToastUtil.showToast(mActivity, "未安装微信客户端");
					} else {
						doShare(WechatMoments.NAME);
					}
					break;
				case 102:
					// 转发为动态
					doShare("news");
					break;
				default:
					break;
				}
			}
		});

		// 设置监听方法
		item_share_pop_cancel.setOnClickListener(listener);
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.item_share_pop_cancel:
				dismiss();
				break;
			default:
				break;
			}

			dismiss();
		}
	};

	/**
	 * 执行分享
	 * 
	 * @return void 返回类型
	 * @param position 参数类型
	 * @author likai
	 */
	private void doShare(String platform) {
		J_OpenManager.getInstance().share(mActivity, platform, params, callBack, isSilentShare);

		// 关闭弹窗
		dismiss();
	}
}
