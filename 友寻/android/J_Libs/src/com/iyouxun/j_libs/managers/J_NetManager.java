package com.iyouxun.j_libs.managers;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;

import pl.droidsonroids.gif.GifImageView;
import pl.droidsonroids.gif.J_GifImgLoader;
import android.graphics.Bitmap;
import android.os.Handler;
import android.text.TextUtils;
import android.widget.ImageView;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkError;
import com.android.volley.NoConnectionError;
import com.android.volley.ParseError;
import com.android.volley.Response.ErrorListener;
import com.android.volley.Response.Listener;
import com.android.volley.ServerError;
import com.android.volley.TimeoutError;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.R;
import com.iyouxun.j_libs.log.J_Log;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.j_libs.net.third.framwork.volley.VolleyManager;
import com.iyouxun.j_libs.utils.J_CommonUtils;
import com.iyouxun.j_libs.utils.J_NetUtil;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

public class J_NetManager {
	public static final String LOG_TAG = "J_NET";

	/**
	 * J_NetManager是否被销毁
	 */
	public static boolean IS_DESTROIED = false;

	// ------------------------------------------错误类型定义----------------------------------------------------------

	/**
	 * 错误类型：其他错误
	 */
	public static final int E_OTHER_ERROR = -1;
	/**
	 * 错误类型：没有可用连接
	 */
	public static final int E_NOT_CONNECT = 5;
	/**
	 * 错误类型：网络错误
	 */
	public static final int E_NETWORK_ERROR = 1;
	/**
	 * 错误类型：服务器错误
	 */
	public static final int E_SERVER_ERROR = 2;
	/**
	 * 错误类型：请求超时
	 */
	public static final int E_TIME_OUT = 3;
	/**
	 * 错误类型：数据解析错误
	 */
	public static final int E_PARSER_ERROR = 4;
	// -------------------------------------------框架选取---------------------------------------------------------
	/**
	 * 选用Volley框架
	 */
	public static final int FRAMEWORK_VOLLEY = 0;
	/**
	 * 选用Afinal框架
	 */
	public static final int FRAMEWORK_AFINAL = 1;
	/**
	 * 选用XUtiles框架
	 */
	public static final int FRAMEWORK_XUTILES = 2;
	/**
	 * 默认选用Volley框架
	 */
	public static int FRAMEWORK_DEFAULT = FRAMEWORK_VOLLEY;
	// ----------------------------------------------------------------------------------------------------
	private HttpUtils xUtilsHttp = null;

	// -----------------------设置超时时间------------------------------
	/**
	 * 普通Http请求超时时间，单位：毫秒 默认10000
	 */
	public static int TIMEOUT_HTTP_REQUEST = 10000;
	/**
	 * 下载请求超时时间，单位：毫秒 默认15000
	 */
	public static int TIMEOUT_DOWNLOAD_REQUEST = 15000;
	/**
	 * 上传请求超时时间，单位：毫秒 默认1500
	 */
	public static int TIMEOUT_UPLOAD_REQUEST = 15000;

	/**
	 * 普通Http请求重试次数 默认1次
	 */
	public static int RETRY_HTTP_TIMES = 1;

	/**
	 * cookie信息
	 */
	public static HashMap<String, String> VOLLEY_COOKIESTORE = new HashMap<String, String>();
	public static String VolleyCookie = "";

	/**
	 * 网络数据返回的回调接口，试用于普通网络请求
	 * 
	 * @author wang
	 * 
	 */
	public interface OnDataBack {
		public final static String KEY_ERROR = "error";
		public final static String KEY_CHAT_TABLE_ID = "chat_table_id";

		public abstract void onResponse(Object result);

		/**
		 * 错误类型
		 * 
		 * -1：其他错误 <br />
		 * 1：网络错误 <br />
		 * 2：服务器错误 <br />
		 * 3：请求超时 <br />
		 * 4：数据解析错误 <br />
		 * 5：没有可用链接 <br />
		 * 
		 * @return void 返回类型
		 * @param @param Error 参数类型
		 * @author likai
		 */
		public abstract void onError(HashMap<String, Object> errorMap);
	}

	/**
	 * Volley框架实例
	 */
	private VolleyManager volleyInterface = null;
	/**
	 * Gif加载器实例
	 */
	private J_GifImgLoader gifImgLoader = null;

	private static J_NetManager self = null;

	// ---------------------handler 相关-----------------------

	private final int FRESH_TOKEN = 0;
	private final int EXCUTE_FAILED_REQUEST = 1;
	private final int RELEASE_FAILED_REQUEST = 2;
	private final int REQUEST_CALLBACK = 3;
	/** 接口公用参数 */
	private HashMap<String, String> commonParams;

	public HashMap<String, String> getCommonParams() {
		return commonParams;
	}

	public void setCommonParams(HashMap<String, String> commonParams) {
		this.commonParams = commonParams;
	}

	/**
	 * 用于发起网络请求和控制请求挑选器。
	 */
	private final Handler handler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case FRESH_TOKEN:

				break;
			case EXCUTE_FAILED_REQUEST:

				break;
			case RELEASE_FAILED_REQUEST:

				break;
			case REQUEST_CALLBACK:

				break;
			default:
				break;
			}

		};

	};

	// ----------------------------------------------------------------------------------------------------

	private J_NetManager() {
		checkVolley();
		J_Log.i(LOG_TAG, "J_NetManager()");
	}

	public static J_NetManager getInstance() {
		// J_Log.i("getInstance()");
		if (self == null) {
			self = new J_NetManager();
		}
		return self;
	}

	/**
	 * 将请求加入任务队列
	 * 
	 * @param request
	 */
	public void sendRequest(J_Request request) {
		sendUnblockRequest(request);
	}

	/**
	 * 从J_Request中提取适用于Volley的请求参数
	 * 
	 * @param j_Request
	 * @return
	 */
	private String createVolleyRequestString(J_Request j_Request) {
		StringBuilder builder = null;
		String d = "";
		HashMap<String, String> params = j_Request.getRequestData();
		if (params != null && params.size() > 0) {
			builder = new StringBuilder();
			if (!TextUtils.isEmpty(j_Request.getTokenField())) {
				builder.append(j_Request.getTokenField() + "=" + j_Request.getToken() + "&");
			}
			// 设置请求的公共参数
			if (commonParams != null && commonParams.size() > 0) {
				params.putAll(getCommonParams());
			}
			for (String str : params.keySet()) {
				builder.append(str + "=" + params.get(str) + "&");
			}
			d = builder.toString();
			d = d.substring(0, d.length() - 1);
			builder = null;
		}
		J_Log.i(LOG_TAG, "request--->>>" + j_Request.URL + d);
		return j_Request.URL + d;
	}

	/**
	 * 
	 * @Title: createRequestParams
	 * @return HashMap<String,String> 返回类型
	 * @param @param j_Request
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	private HashMap<String, String> createRequestParams(J_Request j_Request) {
		HashMap<String, String> params = j_Request.getRequestData();
		// 设置请求的公共参数
		if (commonParams != null && commonParams.size() > 0) {
			params.putAll(getCommonParams());
		}

		// 仅用作日志输出
		if (params.size() > 0) {
			StringBuilder builder = new StringBuilder();
			for (String str : params.keySet()) {
				builder.append(str + "=" + params.get(str) + "&");
			}
			String d = builder.toString();
			d = d.substring(0, d.length() - 1);
			J_Log.i(LOG_TAG, "request--->>>" + j_Request.URL + d);
		} else {
			J_Log.i(LOG_TAG, "request--->>>" + j_Request.URL);
		}

		return params;
	}

	/**
	 * 根据参数和地址生成请求所用字符串
	 * 
	 * @param host 主机地址
	 * @param params 参数集合
	 * @return
	 */
	public String createRequestStr(String host, HashMap<String, String> params) {

		StringBuilder builder = null;
		String d = "";
		String url = host;

		if (!host.endsWith("?")) {
			url = host + "?";
		}

		builder = new StringBuilder();
		for (String str : params.keySet()) {
			builder.append(str + "=" + params.get(str) + "&");
		}
		d = builder.toString();
		d = d.substring(0, d.length() - 1);
		builder = null;
		return url + d;
	}

	/**
	 * 发起请求
	 */
	private void excuteRequest(J_Request request) {
		J_Log.i(LOG_TAG, "excuteRequest()");
		switch (FRAMEWORK_DEFAULT) {
		case FRAMEWORK_VOLLEY:
			sendVolleyRequest(request);
			break;
		default:
			break;
		}
	}

	/**
	 * 清空图片缓存
	 */
	public void clearIMGCache() {
		J_Log.i(LOG_TAG, "clearIMGCache()");
		switch (FRAMEWORK_DEFAULT) {
		case FRAMEWORK_VOLLEY:
			clearVolleyCache();
			break;
		default:
			break;
		}
	}

	/**
	 * 获取图片，适用于ListView，如果没有默认图片或者错误图片，直接传0
	 */
	public ImageContainer loadIMG(ImageContainer imgRequest, String url, ImageView imageView, int defaultDrawableID,
			int errorDrawableID) {
		return loadIMG(imgRequest, url, imageView, defaultDrawableID, errorDrawableID, -1, -1);
	}

	/**
	 * 获取图片，适用于ListView，如果没有默认图片或者错误图片，直接传0
	 */
	public ImageContainer loadIMG(ImageContainer imgRequest, String url, ImageView imageView, int defaultDrawableID,
			int errorDrawableID, int imgWidth, int imgHeight) {
		switch (FRAMEWORK_DEFAULT) {
		case FRAMEWORK_VOLLEY:
			return loadVolleyIMG(imgRequest, url, imageView, defaultDrawableID, errorDrawableID, imgWidth, imgHeight);
		default:
			break;
		}
		return null;
	}

	public ImageContainer loadIMG(ImageContainer imgRequest, String url, ImageView imageView, ImageLoadListener listener,
			int defaultDrawableID, int errorDrawableID) {
		switch (FRAMEWORK_DEFAULT) {
		case FRAMEWORK_VOLLEY:
			if (imgRequest != null) {
				imgRequest.cancelRequest();
			}
			return volleyInterface.getIMG(url, imageView, listener, defaultDrawableID, errorDrawableID);
		default:
			break;
		}
		return null;
	}

	/**
	 * 需要自行处理图片闪烁问题，本方法只负责下载、显示及缓存
	 */
	public void loadGifImg(GifImageView imageView, String url) {

		if (J_CommonUtils.isEmpty(url)) {
			return;
		}

		if (gifImgLoader == null) {
			gifImgLoader = J_GifImgLoader.getInstance();
		}
		gifImgLoader.loadGifImg(imageView, url);

	}

	public interface OnLoadingListener {
		public abstract void startLoading();

		public abstract void onLoading(long total, long current, boolean isUploading);

		public abstract void onfinishLoading(String result);

		public abstract void onError();
	}

	/**
	 * 文件上传，支持大文件上传，断点续传
	 */
	public void uploadFile(final String url, final Map<String, String> params, final String filePath,
			final OnLoadingListener loadingListener) {
		new Thread() {
			@Override
			public void run() {
				uploadWithCustom(url, params, filePath, loadingListener);
			};
		}.start();

	}

	// -----------------佳缘老的上传-------------------------
	private final String boundary = "--------boundary";

	private void uploadWithCustom(String url, Map<String, String> params, String filePath, final OnLoadingListener loadingListener) {
		File file = new File(filePath);
		HttpClient client = null;
		if (!file.exists()) {
			J_Log.e(LOG_TAG, "文件上传：文件未找到-->" + filePath);
			handler.post(new Runnable() {

				@Override
				public void run() {
					loadingListener.onError();
				}
			});
			return;
		}

		try {
			HttpPost httpPost = new HttpPost(J_NetUtil.url2uri(new URL(url)));
			ByteArrayOutputStream baos = new ByteArrayOutputStream(1024);
			FileInputStream ins = new FileInputStream(file);
			baos.write(("--" + boundary + "\r\n").getBytes());

			String formDataName = "upload";

			if (file.getName().endsWith(".amr")) {
				formDataName = "stream";
			}

			baos.write(("Content-Disposition: form-data; name=\"" + formDataName + "\"; filename=\"image.png\"\r\n").getBytes());
			baos.write("Content-Type:application/octet-stream\r\n\r\n".getBytes());
			int readLen = 0;
			byte[] data = new byte[4 * 1024];
			while ((readLen = ins.read(data)) != -1) {
				baos.write(data, 0, readLen);
			}
			baos.write("\r\n".getBytes());

			// 添加公共参数
			params.put("reg_meid", J_CommonUtils.getDeviceIMEI());
			params.put("reg_channel_id", J_CommonUtils.getChannelId());
			params.put("reg_mtype", "android");
			params.put("reg_version", J_CommonUtils.getAppVersionName());
			if (params != null && params.size() > 0) {
				String temp1 = "--" + boundary + "\r\n";
				for (String key : params.keySet()) {
					J_Log.i(LOG_TAG, "upload params key = " + key + " , value = " + params.get(key));
					baos.write(temp1.getBytes());
					String nameStr = "Content-Disposition: form-data; name=" + key + "\r\n";
					baos.write(nameStr.getBytes());
					baos.write("\r\n".getBytes());
					String t1 = params.get(key) + "\r\n";
					baos.write(t1.getBytes());
				}
			}
			baos.flush();
			J_Log.i(LOG_TAG, "requestData>>>>>>" + new String(baos.toByteArray()) + "<<<<<<<");
			ByteArrayEntity formEntity = new ByteArrayEntity(baos.toByteArray());
			ins.close();
			baos.close();
			baos = null;
			ins = null;

			httpPost.setEntity(formEntity);
			// httpPost.setHeader("Authorization","Basic bG92ZTIxY246amlheXVhbiFAIw==");
			httpPost.setHeader("Content-Type", "multipart/form-data; boundary=" + boundary);
			String cookieStore = J_NetManager.VolleyCookie;
			J_Log.d("likai-test", "uploadFile---cookie:" + cookieStore);
			httpPost.setHeader("Cookie", cookieStore);
			httpPost.setHeader("Charset", "UTF-8");

			client = new DefaultHttpClient();
			StringBuilder sb = new StringBuilder();
			sb.append("connect to URL: ").append(url.toString()).append("; at: ")
					.append(Calendar.getInstance().getTime().toGMTString());
			J_Log.i(LOG_TAG, sb.toString());
			HttpResponse rep = client.execute(httpPost);
			sb.setLength(0);
			sb.append("send to URL: ").append(url.toString()).append("; result: ");

			final String reStr = EntityUtils.toString(rep.getEntity());
			sb.append(reStr);
			sb.append("\n  responseCode = " + rep.getStatusLine().getStatusCode());
			sb.append("; at: ").append(Calendar.getInstance().getTime().toGMTString());
			J_Log.i(LOG_TAG, sb.toString());

			handler.post(new Runnable() {
				@Override
				public void run() {
					try {
						loadingListener.onfinishLoading(reStr);
					} catch (ParseException e) {
						e.printStackTrace();
					}
				}
			});
		} catch (MalformedURLException e) {
			e.printStackTrace();
			handler.post(new Runnable() {
				@Override
				public void run() {
					loadingListener.onError();
				}
			});
		} catch (IOException e) {
			handler.post(new Runnable() {
				@Override
				public void run() {
					loadingListener.onError();
				}
			});
			e.printStackTrace();
		}
	}

	// ---------------------------------------------------------

	/**
	 * 通过XUtils进行文件上传，支持断点续传
	 * 
	 * @param url
	 * @param params
	 * @param filePath
	 * @param loadingListener
	 */
	public void uploadWithXUtils(String url, Map<String, String> params, String filePath, final OnLoadingListener loadingListener) {
		if (xUtilsHttp == null) {
			xUtilsHttp = new HttpUtils(TIMEOUT_UPLOAD_REQUEST);
		}

		RequestParams paramsEntity = new RequestParams("UTF-8");
		// 添加公共参数
		params.put("reg_meid", J_CommonUtils.getDeviceIMEI());
		params.put("reg_channel_id", J_CommonUtils.getChannelId());
		params.put("reg_mtype", "android");
		params.put("reg_version", J_CommonUtils.getAppVersionName());
		if (params != null && params.size() > 0) {
			for (String key : params.keySet()) {
				J_Log.i(LOG_TAG, "upload params key = " + key + " , value = " + params.get(key));
				paramsEntity.addBodyParameter(key, params.get(key));
			}
		}

		if (!J_CommonUtils.isEmpty(filePath)) {
			File file = new File(filePath);
			if (!file.exists()) {
				J_Log.e(LOG_TAG, "文件上传：文件未找到-->" + filePath);
				handler.post(new Runnable() {
					@Override
					public void run() {
						loadingListener.onError();
					}
				});
				return;
			}
			// 设置上传文件表单的名称
			paramsEntity.addBodyParameter("upload", file);

			J_Log.i(LOG_TAG, "request--->>>" + url);

			xUtilsHttp.send(HttpRequest.HttpMethod.POST, url, paramsEntity, new RequestCallBack<String>() {
				@Override
				public void onStart() {
					if (loadingListener != null) {
						loadingListener.startLoading();
					}
				}

				@Override
				public void onLoading(long total, long current, boolean isUploading) {
					if (loadingListener != null) {
						loadingListener.onLoading(total, current, isUploading);
					}
				}

				@Override
				public void onSuccess(ResponseInfo<String> responseInfo) {

					if (loadingListener != null) {
						J_Log.i(LOG_TAG, "<<<<------" + responseInfo.result);
						loadingListener.onfinishLoading(responseInfo.result);
					}
				}

				@Override
				public void onFailure(HttpException error, String msg) {
					error.printStackTrace();
					J_Log.i(LOG_TAG, "<<<<------" + msg);
					if (loadingListener != null) {
						loadingListener.onError();
					}
				}
			});

		}

	}

	public void downloadFile(String url, String path, RequestCallBack<File> callback) {
		if (xUtilsHttp == null) {
			xUtilsHttp = new HttpUtils(TIMEOUT_DOWNLOAD_REQUEST);
		}
		xUtilsHttp.download(url, path, callback);
	}

	// -------------------------------集成Volley---------------------------------------------

	public ImageLoader getIMGLoader() {
		return volleyInterface.getLoader();
	}

	public Bitmap getLoadBitmap(String url) {
		return volleyInterface.getImgCache().getBitmap(ImageLoader.getCacheKey(url, 0, 0));
	}

	private void clearVolleyCache() {
		volleyInterface.clearImgCache();
	}

	private ImageContainer loadVolleyIMG(ImageContainer imgRequest, String url, ImageView imageView, int defaultDrawableID,
			int errorDrawableID, int imgWidth, int imgHeight) {
		if (imageView == null) {
			return null;
		}
		if (TextUtils.isEmpty(url)) {
			if (!url.equals(imageView.getTag(R.string.img_key))) {
				imageView.setImageResource(errorDrawableID);
			} else {
				return null;
			}
			imageView.setTag(R.string.img_key, url);
			return null;
		}
		if (!url.equals(imageView.getTag(R.string.img_key))) {
			imageView.setImageResource(defaultDrawableID);
		} else {
			return null;
		}
		imageView.setTag(R.string.img_key, url);
		if (imgRequest != null) {
			imgRequest.cancelRequest();
		}

		return volleyInterface.getIMG(url, imageView, defaultDrawableID, errorDrawableID, imgWidth, imgHeight);

	}

	// /**
	// * 删除某一张图片
	// * @param url
	// */
	// public void removeBitmapFromCache(String url){
	// volleyInterface.removeBitmapFromCache(url);
	// }

	/**
	 * 发送非阻塞式请求
	 * 
	 * @param request
	 */
	public void sendUnblockRequest(J_Request request) {
		excuteRequest(request);
	}

	/**
	 * TODO 使用Volley发起请求
	 */
	private void sendVolleyRequest(final J_Request request) {
		int method = VolleyManager.R_GET;

		if (request.REQUEST_METHOD.equals(J_Request.METHOD_GET)) {
			method = VolleyManager.R_GET;
			// ------------get请求-----------
			volleyInterface.getString(createVolleyRequestString(request), method, new Listener<String>() {
				@Override
				public void onResponse(String response) {
					J_Log.i(LOG_TAG, "<<<<------" + response);
					new WillCallback(request, response).start();
				}
			}, new ErrorListener() {
				@Override
				public void onErrorResponse(VolleyError error) {
					J_Log.i(LOG_TAG, "<<<<------ErrorListener");
					errorAnalisys(request, error);
				}
			});
		} else if (request.REQUEST_METHOD.equals(J_Request.METHOD_POST)) {
			method = VolleyManager.R_POST;
			// ------------post请求-----------
			volleyInterface.getString(request.URL, createRequestParams(request), method, new Listener<String>() {
				@Override
				public void onResponse(String response) {
					J_Log.i(LOG_TAG, "<<<<------" + response);
					new WillCallback(request, response).start();
				}
			}, new ErrorListener() {
				@Override
				public void onErrorResponse(VolleyError error) {
					J_Log.i(LOG_TAG, "<<<<------ErrorListener");
					errorAnalisys(request, error);
				}
			});
		}

	}

	class WillCallback extends Thread {
		J_Request request = null;
		String response = "";

		public WillCallback(final J_Request request, final String response) {
			this.request = request;
			this.response = response;
		}

		@Override
		public void run() {
			try {
				// 返回数据一"<"开头的，说明请求数据有异常
				if (response.trim().startsWith("<")) {
					handler.post(new Runnable() {
						@Override
						public void run() {
							if (request != null && request.callback != null) {
								HashMap<String, Object> hashMap = new HashMap<String, Object>();
								hashMap.put(OnDataBack.KEY_ERROR, E_PARSER_ERROR);
								hashMap.put(OnDataBack.KEY_CHAT_TABLE_ID, request.CHAT_TABLE_ID);
								request.callback.onError(hashMap);
							}
						}
					});
					return;
				}
				final Object object = J_SDK.getConfig().getJ_JsonParser().parsJson(response, request);
				handler.post(new Runnable() {
					@Override
					public void run() {
						if (request != null && request.callback != null) {
							request.callback.onResponse(object);
						}
					}
				});
			} catch (JSONException e) {
				e.printStackTrace();
				handler.post(new Runnable() {
					@Override
					public void run() {
						if (request != null && request.callback != null) {
							HashMap<String, Object> hashMap = new HashMap<String, Object>();
							hashMap.put(OnDataBack.KEY_ERROR, E_PARSER_ERROR);
							hashMap.put(OnDataBack.KEY_CHAT_TABLE_ID, request.CHAT_TABLE_ID);
							request.callback.onError(hashMap);
							// request.callback.onError(E_PARSER_ERROR);
						}
					}
				});
			} catch (Exception e) {
				e.printStackTrace();
				handler.post(new Runnable() {
					@Override
					public void run() {
						if (request != null && request.callback != null) {
							HashMap<String, Object> hashMap = new HashMap<String, Object>();
							hashMap.put(OnDataBack.KEY_ERROR, E_OTHER_ERROR);
							hashMap.put(OnDataBack.KEY_CHAT_TABLE_ID, request.CHAT_TABLE_ID);
							request.callback.onError(hashMap);
							// request.callback.onError(E_OTHER_ERROR);
						}
					}
				});
			}
		}
	}

	private void checkVolley() {
		if (volleyInterface == null) {
			volleyInterface = new VolleyManager();
			volleyInterface.init(J_SDK.getContext());
		}
	}

	private void errorAnalisys(J_Request request, VolleyError volleyError) {
		J_Log.i(LOG_TAG, "errorAnalisys()");
		OnDataBack listener = request.callback;
		if (listener == null) {
			return;
		}
		HashMap<String, Object> hashMap = new HashMap<String, Object>();
		hashMap.put(OnDataBack.KEY_CHAT_TABLE_ID, request.CHAT_TABLE_ID);
		if (volleyError instanceof NoConnectionError) {
			hashMap.put(OnDataBack.KEY_ERROR, E_NOT_CONNECT);
			// listener.onError(J_NetManager.E_NOT_CONNECT);
		} else if (volleyError instanceof NetworkError) {
			hashMap.put(OnDataBack.KEY_ERROR, E_NETWORK_ERROR);
			// listener.onError(J_NetManager.E_NETWORK_ERROR);
		} else if (volleyError instanceof AuthFailureError) {
			hashMap.put(OnDataBack.KEY_ERROR, E_OTHER_ERROR);
			// listener.onError(J_NetManager.E_OTHER_ERROR);
		} else if (volleyError instanceof ParseError) {
			hashMap.put(OnDataBack.KEY_ERROR, E_PARSER_ERROR);
			// listener.onError(J_NetManager.E_PARSER_ERROR);
		} else if (volleyError instanceof ServerError) {
			hashMap.put(OnDataBack.KEY_ERROR, E_SERVER_ERROR);
			// listener.onError(J_NetManager.E_SERVER_ERROR);
		} else if (volleyError instanceof TimeoutError) {
			hashMap.put(OnDataBack.KEY_ERROR, E_TIME_OUT);
			// listener.onError(J_NetManager.E_TIME_OUT);
		} else {
			hashMap.put(OnDataBack.KEY_ERROR, E_OTHER_ERROR);
			// listener.onError(J_NetManager.E_OTHER_ERROR);
		}
		listener.onError(hashMap);
	}

	public static interface ImageLoadListener {
		public void onLoadFinish();
	}

	/**
	 * 根据错误码返回相应错误信息
	 * 
	 * @return String 返回类型
	 * @param @param error
	 * @param @return 参数类型
	 * @author likai
	 */
	public String getErrorMsg(int error) {
		String result = "";
		switch (error) {
		case E_OTHER_ERROR:
			result = J_SDK.getContext().getResources().getString(R.string.network_error_other);
			break;
		case E_NOT_CONNECT:
			result = J_SDK.getContext().getResources().getString(R.string.network_error_none);
			break;
		case E_NETWORK_ERROR:
			result = J_SDK.getContext().getResources().getString(R.string.network_error);
		case E_SERVER_ERROR:
			result = J_SDK.getContext().getResources().getString(R.string.network_error_server);
			break;
		case E_TIME_OUT:
			result = J_SDK.getContext().getResources().getString(R.string.network_error_timeout);
			break;
		case E_PARSER_ERROR:
			result = J_SDK.getContext().getResources().getString(R.string.network_error_parse);
			break;
		default:
			result = J_SDK.getContext().getResources().getString(R.string.network_request_error);
			break;
		}
		return result;
	}

	/**
	 * @Title: cancelAllRequest
	 * @Description: 取消指定url的post请求
	 * @return void 返回类型
	 * @param @param url 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public void cancelAllRequest(String url) {
		if (volleyInterface == null) {
			volleyInterface = new VolleyManager();
			volleyInterface.init(J_SDK.getContext());
		}
		volleyInterface.cancelAllRequest(url);
	}

}
