package com.iyouxun.ui.activity.web;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;

import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshWebView;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.ToastUtil;

/**
 * webview和js交互的接口文件
 * 
 * @Title: JSApiInterface.java
 * 
 * @ClassName: JSApiInterface
 * @author likai
 * @date 2014-6-11 上午10:06:19
 * 
 */
public class JSApiInterface extends Object {
	public static final String SQUARE_STRING = "square_red_dot_";// 广场显示红点
	public static final int REQUEST_CODE_WEBVIEW_SHOW_PHOTO = 1;// webview查看大图返回值
	public static final int REQUEST_CODE_WEBVIEW_PHONE_CERTIFICATION = 2;// webview跳转到手机认证
	private final Context ctx;
	private final String pageName;
	private WebView webView;// web页面
	private PullToRefreshWebView pullWebview;// 下拉的webView控件
	private String url;// 执行下拉操作的页面url
	private final Activity activity;
	public static boolean refreshView = false;// 刷新页面

	public JSApiInterface(Context ctx, String pageName, Activity activity) {
		this.ctx = ctx;
		this.pageName = pageName;
		this.activity = activity;
	}

	/**
	 * @Title: set_webView
	 * @Description: 传递广场的webView
	 * @param @param webView 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public void set_webView(WebView webView) {
		this.webView = webView;
	}

	/**
	 * @Title: showPhotos
	 * @Description: 查看用户生活照
	 * @param @param uid 用户uid
	 * @param @param nickname 昵称
	 * @author donglizhi
	 * @throws
	 */
	@JavascriptInterface
	public void IYXAPP_ShowPhotos(String uid, String nickname) {
	}

	/**
	 * @Title: IYXAPP_SetTitle
	 * @Description: 设置左侧按钮的标题
	 * @return void 返回类型
	 * @param @param title 标题
	 * @author donglizhi
	 * @throws
	 */
	@JavascriptInterface
	public void IYXAPP_SetTitle(String title) {
	}

	/**
	 * @Title: IYXAPP_ShowFaceBox
	 * @Description: 显示消息输入框
	 * @return void 返回类型
	 * @param @param enable 是否可以输入
	 * @author donglizhi
	 * @throws
	 */
	@JavascriptInterface
	public void IYXAPP_ShowFaceBox(final boolean enable) {
	}

	/**
	 * @Title: IYXAPP_HideFaceBox
	 * @Description: 隐藏消息输入框
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	@JavascriptInterface
	public void IYXAPP_HideFaceBox() {
	}

	/**
	 * @Title: IYXAPP_CheckUpgrade
	 * @Description: 检查是否有新版本
	 * @author donglizhi
	 */
	@JavascriptInterface
	public void IYXAPP_CheckUpgrade() {

	}

	/**
	 * 关闭页面
	 * 
	 * @Title: IYXAPP_Finish
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 * @date 2014-6-10 下午3:26:34
	 */
	@JavascriptInterface
	public void IYXAPP_Finish() {
		activity.finish();
	}

	/**
	 * 显示对话框
	 * 
	 * @Title: IYXAPP_Dialog
	 * @return void 返回类型
	 * @param @param content 参数类型
	 * @author likai
	 * @throws
	 * @date 2014-6-11 上午10:12:17
	 */
	@JavascriptInterface
	public void IYXAPP_Dialog(String content) {
		DialogUtils.showPromptDialog(ctx, "提示", content, new OnSelectCallBack() {
			@Override
			public void onCallBack(String value1, String value2, String value3) {
			}
		});
	}

	/**
	 * 显示toast
	 * 
	 * @Title: IYXAPP_Toast
	 * @return void 返回类型
	 * @param @param content 参数类型
	 * @author likai
	 * @throws
	 * @date 2014-6-11 上午10:12:28
	 */
	@JavascriptInterface
	public void IYXAPP_Toast(String content) {
		ToastUtil.showToast(ctx, content);
	}

	/**
	 * @Title: IYXAPP_Profile
	 * @Description: 查看个人主页
	 * @return void 返回类型
	 * @param @param uid 用户uid
	 * @param @param nickName 用户昵称
	 * @author donglizhi
	 * @throws
	 */
	@JavascriptInterface
	public void IYXAPP_Profile(String uid, String nickName) {
	}

	/**
	 * 显示菜单
	 * 
	 * @Title: IYXAPP_ShowMenu
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 * @date 2014-6-12 下午2:58:43
	 */
	@JavascriptInterface
	public void IYXAPP_ShowMenu() {
		if (pageName.equals("Square")) {
		} else {
			IYXAPP_Toast("该页面不支持此功能");
		}
	}

	/**
	 * @Title: set_pullWebView
	 * @Description: 设置pullWebView用于实现下拉操作
	 * @return void 返回类型
	 * @param @param pullWebview 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public void set_pullWebView(PullToRefreshWebView pullWebview) {
		this.pullWebview = pullWebview;
	}

	/**
	 * @Title: IYXAPP_DisablePull
	 * @Description: 禁用下拉功能
	 * @author donglizhi
	 * @throws
	 */
	@JavascriptInterface
	public void IYXAPP_DisablePull() {
		if (pullWebview != null && !Mode.DISABLED.equals(pullWebview.getMode())) {
			pullWebview.setMode(Mode.DISABLED);
		}
	}

	/**
	 * @Title: IYXAPP_EnablePull
	 * @Description: 启用下拉功能
	 * @author donglizhi
	 * @throws
	 */
	@JavascriptInterface
	public void IYXAPP_EnablePull() {
		if (pullWebview != null && Mode.DISABLED.equals(pullWebview.getMode())) {
			pullWebview.setMode(Mode.PULL_FROM_START);
		}
	}

	/**
	 * @Title: getUrl
	 * @Description: 获得执行下拉操作的url
	 * @return String 返回类型
	 * @author donglizhi
	 * @throws
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * @Title: IYXAPP_reloadUrl
	 * @Description: 刷新页面
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	@JavascriptInterface
	public void IYXAPP_reloadUrl() {
		webView.reload();
	}

	/**
	 * @Title: IYXAPP_startActivity
	 * @Description: 打开页面
	 * @return void 返回类型
	 * @param action activity的action
	 * @author donglizhi
	 * @throws
	 */
	@JavascriptInterface
	public void IYXAPP_startActivity(String action) {
		Intent intent = new Intent(action);
		intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
		activity.startActivity(intent);
	}

	public void setUrl(String url) {
		this.url = url;
	}
}
