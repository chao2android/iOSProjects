package com.iyouxun.j_libs.managers;

import java.util.ArrayList;

import android.app.Activity;

/**
 * 页面管理
 * 
 * @author likai
 * @date 2015-3-25 下午7:19:55
 * 
 */
public class J_PageManager {
	private static J_PageManager self = null;
	private final ArrayList<Activity> totalPage = new ArrayList<Activity>();
	private final ArrayList<Activity> beforeLoginPage = new ArrayList<Activity>();

	private J_PageManager() {
	}

	public static J_PageManager getInstance() {
		if (self == null) {
			self = new J_PageManager();
		}
		return self;
	}

	/**
	 * 添加一个当前页面
	 * 
	 * @Title: addCurrentPage
	 * @return void 返回类型
	 * @param @param pageName
	 * @param @param activity 参数类型
	 * @author likai
	 * @throws
	 */
	public void addPage(Activity currentActivity) {
		if (!self.totalPage.contains(currentActivity)) {
			self.totalPage.add(currentActivity);
		}
	}

	/**
	 * 添加一个用户状态为未登录的页面
	 * 
	 * @return void 返回类型
	 * @param @param currentActivity 参数类型
	 * @author likai
	 * @throws
	 */
	public void addBeforeLoginPage(Activity currentActivity) {
		if (!self.beforeLoginPage.contains(currentActivity)) {
			self.beforeLoginPage.add(currentActivity);
		}
	}

	/**
	 * 获取登陆前已经加载过的页面
	 * 
	 * @return ArrayList<Activity> 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public ArrayList<Activity> getBeforeLoginPage() {
		return self.beforeLoginPage;
	}

	/**
	 * 移除一个页面
	 * 
	 * @Title: removeCurrentPage
	 * @return void 返回类型
	 * @param @param currentPageName 参数类型
	 * @author likai
	 * @throws
	 */
	public void finishPage(Activity currentActivity) {
		if (self.totalPage.contains(currentActivity)) {
			currentActivity.finish();
			self.totalPage.remove(currentActivity);
		}
	}

	/**
	 * 移除所有页面
	 * 
	 * @Title: clearAllPage
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public void finishAllPage() {
		for (int i = 0; i < self.totalPage.size(); i++) {
			self.totalPage.get(i).finish();
		}
		self.totalPage.clear();
	}

	/**
	 * 移除所有登录前的页面
	 * 
	 * @Title: finishBeforeLoginPage
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public void finishBeforeLoginPage() {
		for (int i = 0; i < self.beforeLoginPage.size(); i++) {
			self.beforeLoginPage.get(i).finish();
		}
		self.beforeLoginPage.clear();
	}
}
