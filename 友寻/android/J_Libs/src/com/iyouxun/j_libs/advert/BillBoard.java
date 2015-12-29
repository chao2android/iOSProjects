package com.iyouxun.j_libs.advert;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map.Entry;

import pl.droidsonroids.gif.GifDrawable;
import pl.droidsonroids.gif.GifImageView;
import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Handler;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.iyouxun.j_libs.J_LibsConfig;
import com.iyouxun.j_libs.R;
import com.iyouxun.j_libs.managers.J_AdvertManager;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.utils.J_CommonUtils;
import com.iyouxun.j_libs.views.AdvertPager;
import com.iyouxun.j_libs.views.MarqueeTextView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
/**
 * 布告板，用于显示广告
 * @author wang
 *
 */
public class BillBoard extends LinearLayout implements OnClickListener{
	public interface OnPageSelectedListener{
	    public void onPageSelected(BillBoard borad,int position);
	}
	public static final int AD_STATUS_SHOW = 0 ;
	public static final int AD_STATUS_HIDDEN = 1 ;
	public static final int AD_STATUS_DEFAULT = 2 ;
	
	/**
	 * 显示下一个广告
	 */
	private final int SHOW_NEXT_ADVERT = 1 ;
	private Context context ;
	private AdvertPager pager ;
	private HashMap<String, ArrayList<Advertisement>> adsMap = new HashMap<String, ArrayList<Advertisement>>();
	private HashMap<String, ArrayList<View>> viewsMap = new HashMap<String, ArrayList<View>>();
	private HashMap<String, ADAdapter> adapterMap = new HashMap<String, ADAdapter>();
	private HashMap<String, Integer> statusMap = new HashMap<String, Integer>();
	private boolean isShowCircle=false;
	/**
	 * 每页广告的停留时间
	 */
	public int INTERVAL_TIME = 1000 ;
	/**
	 * 当前播放的广告频道
	 */
	private String CURRENT_CHANNEL = "";
//	/**
//	 * 广告是否被按下
//	 */
//	private boolean IS_TOUCH_DOWN = false ;
	/**
	 * 是否要结束轮播线程
	 */
	private boolean IS_STOP_LOOPING = false ;
	/**
	 * 轮播线程
	 */
	private LoopingThread loopingThread = null ;
	
	/**
	 * 圈圈点点
	 */
	private LinearLayout linQuanQuan;
	private ImageView imageView;
	public enum POSITION{
	    BOTTOM_LEFT,BOTTOM_RIGHT,BOTTOM_CENTER
	}
	private Handler handler = new Handler(){
		public void handleMessage(android.os.Message msg) {
//			J_Log.i("Received mas and TOUCH = "+IS_TOUCH_DOWN);
			switch (msg.what) {
			case SHOW_NEXT_ADVERT:
				if(!pager.isTouchDown()){
					nextAdert();
				}
				break;

			default:
				break;
			}
			
		};
	};
	
	public BillBoard(Context context) {
		super(context);
		this.context = context;
	}
	public BillBoard(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.context = context;
	}
	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	public BillBoard(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		this.context = context;
	}
	
	public int getCurrentItem(){
		return pager.getCurrentItem();
	}
	
	/**
	 * 显示下一个广告
	 */
	private void nextAdert(){
		int i = pager.getCurrentItem();
//		J_Log.i( "nextAdert()  pager.getCurrentItem() = "+i);
		if(J_CommonUtils.isEmpty(CURRENT_CHANNEL)){
			return ;
		}
		if(!adsMap.containsKey(CURRENT_CHANNEL)){
			return;
		}
		int c = adsMap.get(CURRENT_CHANNEL).size();
		if(c == 0){
			return ;
		}
		if(i+1 == c){
			i = 0 ;
		}else if(i+1 < c){
			i++ ;
		}
		pager.setCurrentItem(i, true);
	}
	
	
	/**
	 * 添加一组广告，参数可理解为在制定频道下播放指定的一组广告
	 * @param channel  频道标识
	 * @param advertisements  广告集合
	 */
	public void addAdvertisements(Integer status ,String channel,ArrayList<Advertisement> advertisements){
		clearChannel(channel);
		createAdViews(status,channel,advertisements);
	}
	/**
	 * 根据频道号清空对应的广告
	 * @param channel
	 */
	public void clearChannel(String channel){
		if(adsMap.containsKey(channel)){
			adsMap.get(channel).clear();
			adsMap.remove(channel);
		}
		
		if(viewsMap.containsKey(channel)){
			
			ArrayList<View> list = viewsMap.get(channel);
			for(int i = 0 ; i < list.size() ; i++){
				View v = list.get(i);
				if(v instanceof GifImageView){
					GifDrawable gd = (GifDrawable) ((GifImageView)v).getDrawable();
					if(gd != null){
						gd.recycle();
					}
				}
			}
			viewsMap.get(channel).clear();
			viewsMap.remove(channel);
		}
		
		if(adapterMap.containsKey(channel)){
			adapterMap.get(channel).notifyDataSetChanged();
			adapterMap.remove(channel);
		}
		
		if(statusMap.containsKey(channel)){
			statusMap.remove(channel);
		}
	}
	
	
	/**
 * 
  * 功能描述：
  * 刷新当前标志位
  * @author xuhuawei
  * <p>创建日期 ：2014-4-24 下午4:30:37</p>
  * @param positioin
  * <p>修改历史 ：(修改人，修改时间，修改原因/内容)</p>
 */
private void refreshQuanQuan(int positioin) {
 int count = linQuanQuan.getChildCount();
 for (int i = 0; i < count; i++) {
  if (i == positioin) {
   linQuanQuan.getChildAt(i).setBackgroundResource(R.drawable.red_point);
  } else {
   linQuanQuan.getChildAt(i).setBackgroundResource(R.drawable.gray_point);
  }
 }
}
	
 /**
  * 添加圈圈
  * @param size 个数
  */
    private void addQuanQuan(int size) {
        linQuanQuan.removeAllViews();
        for (int i = 0; i < size; i++) {
            imageView = new ImageView(context);
            imageView.setLayoutParams(new LayoutParams(
                    android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
                    android.widget.LinearLayout.LayoutParams.WRAP_CONTENT));
            imageView.setBackgroundResource(R.drawable.gray_point);
            imageView.setPadding(5, 0, 5, 0);
            linQuanQuan.addView(imageView);
        }
    }
	/**
	 * 根据频道标识显示一组广告
	 * @param channel
	 */
	public void showChannel(String channel){
		Integer s = statusMap.get(channel);
		showChannel(s, channel);
	}
	
	
	/**
	 * 根据频道标识显示一组广告
	 * @param channel
	 */
	private  void showChannel(Integer status , String channel){
		
		if(status == null){
			status = AD_STATUS_HIDDEN ;
		}
		
		switch (status) {
		case AD_STATUS_HIDDEN:
			if(getVisibility() != View.INVISIBLE){
				setVisibility(View.INVISIBLE);
			}
			break;
		case AD_STATUS_SHOW:
		case AD_STATUS_DEFAULT:
			if(getVisibility() != View.VISIBLE){
				setVisibility(View.VISIBLE);
			}
			
			if(adsMap != null && adsMap.containsKey(channel) && adsMap.get(channel) != null){
				if(adsMap.get(channel).size() > 1){
					linQuanQuan.setVisibility(View.VISIBLE);
				}else{
					linQuanQuan.setVisibility(View.INVISIBLE);
				}
			}
			
			
			break;
		default:
			break;
		}
		
		ADAdapter ada = null ; 
		ada = adapterMap.get(channel);
		if(ada == null){
			ada = new ADAdapter(viewsMap.get(channel));
			adapterMap.put(channel, ada);
		}
		pager.setAdapter(ada);
		adapterMap.get(channel).notifyDataSetChanged();
		CURRENT_CHANNEL = channel ;
		
		addQuanQuan(viewsMap.get(channel).size());
		
	}
	/**
	 * 创建单个广告所需要的View
	 * @param channel
	 * @param advertisements
	 */
	private void createAdViews(Integer status , String channel,ArrayList<Advertisement> advertisements) {
		
		ArrayList<View> viewList = new ArrayList<View>();
		
		for(int i = 0 ; i < advertisements.size() ; i++){
			View view = null ;
			Advertisement adver = advertisements.get(i);
			if(adver.showType == Advertisement.TYPE_IMG || adver.showType == Advertisement.TYPE_GIF){
				view = getImgAdView(adver);
			}else if(adver.showType == Advertisement.TYPE_TEXT){
				view = getTextAdView(adver);
			}else if(adver.showType == Advertisement.TYPE_WEB){
				view = getWebAdView(adver);
			}
			
			if(view != null){
				view.setTag(i+"");
				view.setOnClickListener(this);
				if(adver.showType == Advertisement.TYPE_WEB){
					view.findViewById(R.id.webView).setTag(i+"");
				}
				viewList.add(view);
			}
			
		}
		adsMap.put(channel, advertisements);
		viewsMap.put(channel, viewList);
		statusMap.put(channel, status);
	}
	
	
	/**
	 * 创建图片广告对应的View，支持普通图片和GIF
	 * @param advertisement
	 * @return
	 */
	private View getImgAdView(Advertisement advertisement){
		View view = null ;
		view = LayoutInflater.from(context).inflate(R.layout.ad_view_gif, null);
		final GifImageView gifImageView = (GifImageView) view.findViewById(R.id.ad_gif);
		loadImage(gifImageView, advertisement);
		return view;
	}
	
	
	private void loadImage(final GifImageView gifImageView,Advertisement advertisement){
		final String[] tempStr = advertisement.imageUrl.split("/");
		final int len = tempStr.length ;
		if(len == 0){
			return  ;
		}
		final String path = J_LibsConfig.TEMP_FILE_DIR+tempStr[len-1];
		if(tempStr[len-1].endsWith("gif") || tempStr[len-1].endsWith("GIF")){
			J_NetManager.getInstance().downloadFile(advertisement.imageUrl, path, new RequestCallBack<File>() {
				
				@Override
				public void onSuccess(ResponseInfo<File> responseInfo) {
							try {
								gifImageView.setBackgroundDrawable(new GifDrawable(path));
							} catch (IOException e) {
								e.printStackTrace();
							}
				}
				
				@Override
				public void onFailure(HttpException error, String msg) {
					
				}
				
				@Override
				public void onLoading(long total, long current,
						boolean isUploading) {
					super.onLoading(total, current, isUploading);
				}
			});
		}else{
			J_NetManager.getInstance().loadIMG(null, advertisement.imageUrl, gifImageView, 0, 0);
		}
	}
	
	/**
	 * 创建文字广告对应的View，自带走马灯效果
	 * @param advertisement
	 * @return
	 */
	private View getTextAdView(Advertisement advertisement){
		View view = null ;
		view = LayoutInflater.from(context).inflate(R.layout.ad_view_text, null);
		MarqueeTextView textView = (MarqueeTextView) view.findViewById(R.id.ad_text);
		textView.setText(advertisement.content);
		return view;
	}
	
	/**
	 * 创建WebView的广告
	 * @param advertisement
	 * @return
	 */
	private View getWebAdView(Advertisement advertisement){
		View view = null ;
		view = LayoutInflater.from(context).inflate(R.layout.ad_view_loop, null);
		WebView webView=(WebView)view.findViewById(R.id.webView);
		
		WebSettings ws = webView.getSettings();
		ws.setAllowFileAccess(true);

		ws.setJavaScriptEnabled(true);
		ws.setBuiltInZoomControls(false);
		ws.setSupportZoom(false);
		webView.loadUrl(advertisement.webUrl);
		webView.setWebViewClient(new WebViewClient(){
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				if(getVisibility() != View.VISIBLE){
					return true;
				}
				int index = Integer.parseInt((String)view.getTag());
				Advertisement advert = adsMap.get(CURRENT_CHANNEL).get(index);
				advert.webUrl = url ;
				if(J_AdvertManager.getInstance().getOnAdvertClickListener() != null){
					J_AdvertManager.getInstance().getOnAdvertClickListener().onAdvertClicked(CURRENT_CHANNEL, advert);
				}
				return true;
			}
			
		});
		return view;
	}
	
	@Override
	protected void onFinishInflate() {
		super.onFinishInflate();
		init();
	}
	

	private void init(){
		pager = (AdvertPager) findViewById(R.id.ad_pager);
		linQuanQuan=(LinearLayout)findViewById(R.id.layout_quanquan);
		pager.setOnPageChangeListener(new OnPageChangeListener() {
			
			@Override
			public void onPageSelected(int position) {
				if(!J_CommonUtils.isEmpty(CURRENT_CHANNEL)){
					View v = viewsMap.get(CURRENT_CHANNEL).get(position);
					refreshQuanQuan(position);
					if(v instanceof GifImageView){
						Drawable drawable = ((GifImageView) v).getDrawable();
						if(drawable == null){
							loadImage((GifImageView) v, adsMap.get(CURRENT_CHANNEL).get(position));
						}
					}
				}
			}
			
			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {
				
			}
			
			@Override
			public void onPageScrollStateChanged(int arg0) {
				
			}
		});
//		pager.setOnTouchListener(new OnTouchListener() {
//			
//			@Override
//			public boolean onTouch(View view, MotionEvent event) {
////				J_Log.i( "onTouch："+event.getAction());
//				
//				if(event.getAction() == MotionEvent.ACTION_DOWN || event.getAction() == MotionEvent.ACTION_MOVE){
//					if(!IS_TOUCH_DOWN){
//						IS_TOUCH_DOWN = true ;
//					}
//				}
//				if(event.getAction() == MotionEvent.ACTION_UP){
//					if(IS_TOUCH_DOWN){
//						IS_TOUCH_DOWN = false ;
//					}
//				}
//				return false;
//			}
//		});
		if(loopingThread == null){
			loopingThread = new LoopingThread();
			loopingThread.start();
		}
	}
	
	class ADAdapter extends PagerAdapter {
		
		private ArrayList<View> viewList = null;
		
		public ADAdapter(ArrayList<View> viewList){
			this.viewList = viewList;
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			if(viewList.size() > position){
				container.removeView(viewList.get(position));// 删除页卡
			}
		}

		@Override
		public Object instantiateItem(ViewGroup container, int position) { // 这个方法用来实例化页卡
			container.addView(viewList.get(position), 0);// 添加页卡
			return viewList.get(position);
		}

		@Override
		public int getCount() {
			return viewList.size();// 返回页卡的数量
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == arg1;// 官方提示这样写
		}

	}
	
	
	public void clearCache(){
		pager.setAdapter(null);
		adsMap.clear();
		for(Entry<String, ArrayList<View>> entry:viewsMap.entrySet()){
			ArrayList<View> list = entry.getValue();
			for(int i = 0 ; i < list.size() ; i++){
				View v = list.get(i);
				if(v instanceof GifImageView){
					GifDrawable gd = (GifDrawable) ((GifImageView)v).getDrawable();
					if(gd != null){
						gd.recycle();
					}
				}
			}
		}
		viewsMap.clear();
		adapterMap.clear();
		statusMap.clear();
//		adsMap = null ;
//		viewsMap = null ;
//		adapterMap = null ;
	}
	
	
	public boolean hasChannel(String channel){
		if(adsMap.containsKey(channel)){
			return true ;
		}
		
		return false ;
	}
	
	public ArrayList<Advertisement> getAdvertsByChannel(String channel){
		return adsMap.get(channel);
	}
	
	@Override
	protected void onDetachedFromWindow() {
		clearCache();
		IS_STOP_LOOPING = true ;
		super.onDetachedFromWindow();
	}
	
	
	class LoopingThread extends Thread{
		@Override
		public void run() {
			while (!IS_STOP_LOOPING) {
				try {
					sleep(INTERVAL_TIME);
					if(!pager.isTouchDown() && !IS_STOP_LOOPING){
						if(System.currentTimeMillis() - pager.getTouchUpTime() > 2000){
							handler.sendEmptyMessage(SHOW_NEXT_ADVERT);
						}
					}
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				
			}
		}
	}


	@Override
	public void onClick(View v) {
		
		if(getVisibility() != View.VISIBLE){
			return ;
		}
		int index = Integer.parseInt((String)v.getTag());
		Advertisement advert = adsMap.get(CURRENT_CHANNEL).get(index);
		if(advert.showType != Advertisement.TYPE_WEB){
			if(J_AdvertManager.getInstance().getOnAdvertClickListener() != null){
				J_AdvertManager.getInstance().getOnAdvertClickListener().onAdvertClicked(CURRENT_CHANNEL, advert);
			}
		}
		
	}
	/**
	 * 
	 * @param isShow 是否可见
	 * @Description:设置是否环原点可见
	 */
	public void setCircleShow(boolean isShow){
	    isShowCircle=isShow;
	    if(isShowCircle){
	        linQuanQuan.setVisibility(View.VISIBLE);  
	    }else{
	        linQuanQuan.setVisibility(View.GONE);  
	    }
	    
	}
	/**
	 * 
	 * @param position  BOTTOM_LEFT 左下， BOTTOM_RIGHT 右下，BOTTOM_CENTER下面居中
	 * @Description:圆圈位置参数
	 */
	public void setPosition(POSITION position){
	    RelativeLayout.LayoutParams lp1 =(RelativeLayout.LayoutParams)linQuanQuan.getLayoutParams();
	    lp1.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM,RelativeLayout.TRUE);
	    switch(position){
	    case BOTTOM_LEFT:
	        lp1.addRule(RelativeLayout.ALIGN_PARENT_LEFT,-1);
         lp1.addRule(RelativeLayout.ALIGN_PARENT_RIGHT,0);
         lp1.addRule(RelativeLayout.CENTER_HORIZONTAL,0);
	        break;
	    case BOTTOM_RIGHT:
	        lp1.addRule(RelativeLayout.ALIGN_PARENT_RIGHT,-1);
	        lp1.addRule(RelativeLayout.ALIGN_PARENT_LEFT,0);
	        lp1.addRule(RelativeLayout.CENTER_HORIZONTAL,0);
	        break;
	    case BOTTOM_CENTER:
	        lp1.addRule(RelativeLayout.ALIGN_PARENT_RIGHT,0);
	        lp1.addRule(RelativeLayout.ALIGN_PARENT_LEFT,0);
	        lp1.addRule(RelativeLayout.CENTER_HORIZONTAL,-1);
	        break;
	    }
	    linQuanQuan.setLayoutParams(lp1);
	}
	
}
