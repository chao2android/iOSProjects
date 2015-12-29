/**
 * 打开应用市场，进行评分弹层
 * 
 * @Package com.iyouxun.ui.dialog
 * @author likai
 * @date 2015-4-23 下午6:44:25
 * @version V1.0
 */
package com.iyouxun.ui.dialog;

import java.util.ArrayList;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;

import com.iyouxun.R;
import com.iyouxun.data.beans.MarketInfoBean;
import com.iyouxun.ui.adapter.MarketListAdapter;
import com.iyouxun.utils.Util;

/**
 * 
 * @author likai
 * @date 2015-4-23 下午6:44:25
 * 
 */
public class ShowMarketDialog extends Dialog {
	private final Context mContext;
	private ArrayList<MarketInfoBean> marketData = new ArrayList<MarketInfoBean>();

	private GridView marketGridView;// 市场列表

	private MarketListAdapter adapter;

	/**
	 * Title: Description:
	 * 
	 * @param context
	 * @param theme
	 */
	public ShowMarketDialog(Context context, int theme) {
		super(context, theme);
		mContext = context;
	}

	public ShowMarketDialog setData(ArrayList<MarketInfoBean> datas) {
		marketData = datas;
		return this;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_show_market_layout);

		// 设置显示位置
		Window window = getWindow();

		WindowManager.LayoutParams params = window.getAttributes();
		params.width = Util.getScreenWidth(mContext);
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
		marketGridView = (GridView) findViewById(R.id.marketGridView);

		// 设置gridview的adapter
		adapter = new MarketListAdapter(mContext, marketData);
		marketGridView.setAdapter(adapter);
		adapter.notifyDataSetChanged();

		// 设置点击后跳转相应市场
		marketGridView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				MarketInfoBean bean = marketData.get(arg2);
				Intent intent = new Intent(Intent.ACTION_VIEW);
				String packageName = mContext.getPackageName();
				Uri uri = Uri.parse("market://details?id=" + packageName);
				intent.setData(uri);
				intent.setPackage(bean.packageName);
				mContext.startActivity(intent);
			}
		});
	}

}
