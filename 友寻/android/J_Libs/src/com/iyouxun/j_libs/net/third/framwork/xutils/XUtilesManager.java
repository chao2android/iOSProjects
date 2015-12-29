package com.iyouxun.j_libs.net.third.framwork.xutils;

import java.io.File;
import java.util.Map;

import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.net.third.framwork.xutils.download.DownloadManager;
import com.iyouxun.j_libs.net.third.framwork.xutils.download.DownloadService;

import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.DbException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

public class XUtilesManager {

	private static XUtilesManager self;
	private DownloadManager downloadManager;

	private XUtilesManager() {

	}

	public static XUtilesManager getInstance() {
		if (self == null) {
			self = new XUtilesManager();
		}
		return self;
	}

	public void upload(String url, Map<String, String> p, String filePath, RequestCallBack<String> callback) {

		RequestParams params = new RequestParams();

		if (p != null && p.size() > 0) {
			for (String key : p.keySet()) {
				params.addBodyParameter(key, p.get(key));
			}
		}

		params.addBodyParameter("file", new File(filePath));

		HttpUtils http = new HttpUtils();
		http.send(HttpRequest.HttpMethod.POST, url, params, callback);

	}

	public void download(String url, String fileName, String target, boolean autoResume, boolean autoRename,
			final RequestCallBack<File> callback) throws DbException {

		if (downloadManager == null) {
			downloadManager = DownloadService.getDownloadManager(J_SDK.getContext());
		}

		downloadManager.addNewDownload(url, fileName, target, true, // 如果目标文件存在，接着未完成的部分继续下载。服务器不支持RANGE时将从新下载。
				false, // 如果从请求返回信息中获取到文件名，下载完成后自动重命名。
				callback);

	}

}
