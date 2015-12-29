package com.iyouxun.ui.activity.web;

import java.net.URLEncoder;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.DownloadListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetConstans;
import com.iyouxun.j_libs.utils.J_CommonUtils;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 公共web页面加载
 * 
 * title = getIntent().getStringExtra(PARAM_TITLE);
 * 
 * url = getIntent().getStringExtra(PARAM_URL);
 * 
 * @author likai
 * 
 */
@SuppressLint("SetJavaScriptEnabled")
public class CommonWebActivity extends CommTitleActivity {
	/** 加载url地址 */
	public static final String PARAM_URL = "params_url";
	/** 页面title */
	public static final String PARAM_TITLE = "params_title";

	private Context mContext = null;
	private WebView webView = null;
	private String title = "";
	private String loadUrl = "";

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
	}

	@Override
	protected void onCreate(Bundle arg0) {
		mContext = this;

		Intent mIntent = getIntent();
		title = mIntent.getStringExtra(PARAM_TITLE);
		if (title == null) {
			title = getString(R.string.service_title);
		}
		loadUrl = mIntent.getStringExtra(PARAM_URL);
		String sso = mIntent.getStringExtra("sso");

		// 用户http请求的session，需要追加到url中，用于保持登录
		String host = NetConstans.SERVER_URL;
		StringBuilder sb = new StringBuilder(host);
		sb.append("login/rsynLogin?");
		sb.append("url=");
		loadUrl = URLEncoder.encode(loadUrl);
		sb.append(loadUrl);
		sb.append("&ticket=").append(sso);
		sb.append("&key=").append(SharedPreUtil.getLoginInfo().uid + "");
		loadUrl = sb.toString();

		DLog.d("likai-test", "url:" + loadUrl);

		super.onCreate(arg0);
	}

	@Override
	@SuppressLint("JavascriptInterface")
	protected void initViews() {
		webView = (WebView) findViewById(R.id.web_browser);

		webView.setScrollBarStyle(0);
		JSApiInterface apiInterface = new JSApiInterface(this, this.getPackageName(), this);
		webView.addJavascriptInterface(apiInterface, "WJBAPP");

		webView.getSettings().setAllowFileAccess(true);
		webView.getSettings().setJavaScriptEnabled(true);
		webView.getSettings().setBuiltInZoomControls(false);// 设置WebView可触摸放大缩小
		webView.getSettings().setSupportZoom(true);
		webView.getSettings().setUseWideViewPort(false);// WebView双击变大，再双击后变小，当手动放大后，双击可以恢复到原始大小
		webView.getSettings().setLoadWithOverviewMode(true);
		webView.setWebViewClient(new WebViewClient() {
			// 页面家在完成后
			@Override
			public void onPageFinished(WebView view, String url) {
				super.onPageFinished(view, url);
				DialogUtils.dismissDialog();
			}

			// 页面加载前
			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon) {
				super.onPageStarted(view, url, favicon);
				DialogUtils.showProgressDialog(mContext, "加载中...");
			}

			// 这里可以设置使用哪种类型打开连接，当前内置or外部浏览器
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				view.loadUrl(url);
				return true;
			}

		});
		// 监听文件下载连接
		webView.setDownloadListener(new DownloadListener() {
			@Override
			public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimetype,
					long contentLength) {
				// 监听下载功能，当用户点击下载链接的时候，直接调用系统的浏览器来下载
				Uri uri = Uri.parse(url);
				Intent intent = new Intent(Intent.ACTION_VIEW, uri);
				startActivity(intent);
			}
		});
		if (!J_CommonUtils.isEmpty(loadUrl)) {
			webView.loadUrl(loadUrl);
		}

	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if (webView.canGoBack()) {
				webView.goBack();
				return true;
			} else {
				finish();
			}
		}

		return false;
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_web_browser, null);
	}

	@Override
	protected void onResume() {
		super.onResume();
	}

	@Override
	protected void onPause() {
		super.onPause();
	}

}
