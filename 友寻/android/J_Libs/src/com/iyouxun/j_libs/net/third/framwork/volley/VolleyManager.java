package com.iyouxun.j_libs.net.third.framwork.volley;

import java.util.HashMap;

import android.content.Context;
import android.widget.ImageView;

import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.ImageLoadListener;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.lru.BitmapLruCache;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.android.volley.toolbox.ImageLoader.ImageListener;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

public class VolleyManager {
	public static final int R_GET = Request.Method.GET;
	public static final int R_POST = Request.Method.POST;

	private RequestQueue mRequestQueue;
	private ImageLoader imageLoader;
	private BitmapLruCache lruCache;

	public void init(Context context) {
		mRequestQueue = Volley.newRequestQueue(context);
		lruCache = new BitmapLruCache(BitmapLruCache.getDefaultLruCacheSize());
		imageLoader = new ImageLoader(mRequestQueue, lruCache);
	}

	public void getString(String url, int method, Response.Listener<String> rListener, Response.ErrorListener eListener) {
		StringRequest sq = new StringRequest(method, url, rListener, eListener);
		DefaultRetryPolicy policy = new DefaultRetryPolicy(J_NetManager.TIMEOUT_HTTP_REQUEST, J_NetManager.RETRY_HTTP_TIMES, 1);
		sq.setRetryPolicy(policy);
		mRequestQueue.add(sq);
	}

	public void getString(String url, HashMap<String, String> params, int method, Response.Listener<String> rListener,
			Response.ErrorListener eListener) {
		StringRequest sq = new StringRequest(method, url, params, rListener, eListener);
		DefaultRetryPolicy policy = new DefaultRetryPolicy(J_NetManager.TIMEOUT_HTTP_REQUEST, J_NetManager.RETRY_HTTP_TIMES, 1);
		sq.setRetryPolicy(policy);
		mRequestQueue.add(sq);
	}

	/**
	 * 清空图片缓存
	 */
	public void clearImgCache() {
		mRequestQueue.getCache().clear();
	}

	public ImageContainer getIMG(String url, ImageView imageView, int defaultDrawableID, int errorDrawableID, int width,
			int height) {
		int w = imageView.getWidth();
		int h = imageView.getHeight();
		if (w > 0 && h > 0) {
			return imageLoader.get(url, ImageLoader.getImageListener(imageView, defaultDrawableID, errorDrawableID), w, h);
		} else {
			return imageLoader.get(url, ImageLoader.getImageListener(imageView, defaultDrawableID, errorDrawableID));
		}
	}

	public ImageContainer getIMG(String url, final ImageView imageView, final ImageLoadListener listener,
			final int defaultDrawableID, final int errorDrawableID) {
		int w = imageView.getWidth();
		int h = imageView.getHeight();
		if (w > 0 && h > 0) {
			return imageLoader.get(url, new ImageListener() {
				@Override
				public void onErrorResponse(VolleyError error) {
					if (errorDrawableID != 0) {
						imageView.setImageResource(errorDrawableID);
					}
					if (listener != null) {
						listener.onLoadFinish();
					}
				}

				@Override
				public void onResponse(ImageContainer response, boolean isImmediate) {
					if (response.getBitmap() != null) {
						imageView.setImageBitmap(response.getBitmap());
						if (listener != null) {
							listener.onLoadFinish();
						}
					} else if (defaultDrawableID != 0) {
						imageView.setImageResource(defaultDrawableID);
					}

				}
			}, w, h);
		} else {
			return imageLoader.get(url, new ImageListener() {
				@Override
				public void onErrorResponse(VolleyError error) {
					if (errorDrawableID != 0) {
						imageView.setImageResource(errorDrawableID);
					}
					if (listener != null) {
						listener.onLoadFinish();
					}
				}

				@Override
				public void onResponse(ImageContainer response, boolean isImmediate) {
					if (response.getBitmap() != null) {
						imageView.setImageBitmap(response.getBitmap());
						if (listener != null) {
							listener.onLoadFinish();
						}
					} else if (defaultDrawableID != 0) {
						imageView.setImageResource(defaultDrawableID);
					}

				}
			});
		}
	}

	public ImageLoader getLoader() {
		return imageLoader;
	}

	public BitmapLruCache getImgCache() {
		return lruCache;
	}

	public void removeBitmapFromCache(String url) {
	}

	public void cancelAllRequest(String url) {
		mRequestQueue.cancelAll(url);
	}
}
