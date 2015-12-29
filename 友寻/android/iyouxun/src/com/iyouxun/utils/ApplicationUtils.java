/**
 * 
 * @Package com.iyouxun.utils
 * @author likai
 * @date 2015-4-23 下午7:31:50
 * @version V1.0
 */
package com.iyouxun.utils;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.ResolveInfo;
import android.graphics.drawable.Drawable;
import android.net.Uri;

import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.MarketInfoBean;
import com.iyouxun.ui.dialog.ShowMarketDialog;

public class ApplicationUtils {
	/**
	 * 通过包名获取应用程序的名称。
	 * 
	 * @param context Context对象。
	 * @param packageName 包名。
	 * @return 返回包名所对应的应用程序的名称。
	 */
	public static String getProgramNameByPackageName(Context context, String packageName) {
		PackageManager pm = context.getPackageManager();
		String name = null;
		try {
			name = pm.getApplicationLabel(pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA)).toString();
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		return name;
	}

	/**
	 * 通过报名获取应用程序的icon
	 * 
	 * @return Drawable 返回类型
	 * @param @param context
	 * @param @param packageName
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static Drawable getProgramIconByPackageName(Context context, String packageName) {
		PackageManager pm = context.getPackageManager();
		Drawable dm = null;
		try {
			dm = pm.getApplicationIcon(pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA));
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		return dm;
	}

	/**
	 * 检查手机是否安装应用市场
	 * 
	 * @Title: isMarketInstall
	 * @return boolean 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static boolean isMarketInstall(Context mContext) {
		boolean isInstall = false;

		ArrayList<MarketInfoBean> marketData = ApplicationUtils.getInstallMarketList(mContext);
		if (marketData.size() > 0) {
			// 安装的有市场
			isInstall = true;
		} else {
			// 没有获取到市场列表，有可能手机自带的有市场，也需要做判断
			String packageName = mContext.getPackageName();
			String str = "market://details?id=" + packageName;
			Intent localIntent = new Intent(Intent.ACTION_VIEW);
			localIntent.setData(Uri.parse(str));
			localIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			if (localIntent.resolveActivity(mContext.getPackageManager()) != null) {
				// 市场可以跳转
				isInstall = true;
			} else {
				// 市场不存在
				isInstall = false;
			}
		}

		return isInstall;
	}

	/**
	 * 获取手机中安装的应用市场列表
	 * 
	 * @return ArrayList<MarketInfoBean> 返回类型
	 * @param @param mContext
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static ArrayList<MarketInfoBean> getInstallMarketList(Context mContext) {
		ArrayList<MarketInfoBean> marketData = new ArrayList<MarketInfoBean>();
		Intent intent = new Intent();
		intent.setAction("android.intent.action.MAIN");
		intent.addCategory("android.intent.category.APP_MARKET");
		PackageManager pm = mContext.getPackageManager();
		List<ResolveInfo> infos = pm.queryIntentActivities(intent, 0);
		for (int i = 0; i < infos.size(); i++) {
			// 获取应用信息
			ActivityInfo activityInfo = infos.get(i).activityInfo;
			// 获取市场应用报名
			String packageName = activityInfo.packageName;

			MarketInfoBean bean = new MarketInfoBean();
			bean.name = ApplicationUtils.getProgramNameByPackageName(mContext, packageName);
			bean.packageName = packageName;
			marketData.add(bean);
		}
		return marketData;
	}

	/**
	 * 打开市场弹层
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static void openMarket(Context mContext) {
		// 首先获取手机上已经安装的市场信息
		ArrayList<MarketInfoBean> marketData = ApplicationUtils.getInstallMarketList(mContext);
		if (marketData.size() > 0) {
			// 手机中安装的有应用市场，打开弹层
			new ShowMarketDialog(mContext, R.style.dialog).setData(marketData).show();
		} else {
			// 判断如果没有安装市场，不再再弹窗，如果有默认市场，打开默认市场，否则打开网站
			String packageName = mContext.getPackageName();
			String str = "market://details?id=" + packageName;

			Intent localIntent = new Intent(Intent.ACTION_VIEW);
			localIntent.setData(Uri.parse(str));
			localIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

			if (localIntent.resolveActivity(mContext.getPackageManager()) != null) {
				mContext.startActivity(localIntent);
			} else {
				// 部分手机会找不到市场，需要跳转到网页
				Intent webIntent = new Intent(Intent.ACTION_VIEW);
				webIntent.setData(Uri.parse(J_Consts.SITE_URL));
				webIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				mContext.startActivity(webIntent);
			}
		}
	}
}
