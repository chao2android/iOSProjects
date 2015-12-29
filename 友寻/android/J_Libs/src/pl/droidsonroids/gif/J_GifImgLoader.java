package pl.droidsonroids.gif;

import java.io.File;
import java.io.IOException;

import android.os.Handler;

import com.iyouxun.j_libs.J_LibsConfig;
import com.iyouxun.j_libs.log.J_Log;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;

public class J_GifImgLoader {
	
	public static int THREAD_COUNT = 3 ;
	
	private static J_GifImgLoader self = null ;
	
//	private ExecutorService executorService = null;
//	private HashMap<String, SoftReference<GifDrawable>> gifImgCache = null;
	private final Handler handler = new Handler();
	
	private J_GifImgLoader(){
//		executorService = Executors.newFixedThreadPool(THREAD_COUNT);
//		gifImgCache = new HashMap<String, SoftReference<GifDrawable>>();
	}
	
	public static J_GifImgLoader getInstance(){
		if(self == null){
			self = new J_GifImgLoader() ;
		}
		return self ;
	}
	
	
	
	public void loadGifImg(final GifImageView imageView,final String url){
		
//		executorService.submit(new GifTask(imageView,url));
		

		
		J_Log.i("Gift", "loadGif="+url);
		final String fileName = getGifFileName(url);
		final String path = J_LibsConfig.TEMP_FILE_DIR+fileName;
		
		File file = new File(path);
		if(file.exists()){
			try {
				GifDrawable drawable = new GifDrawable(file);
				setGifImgToView(imageView, drawable);
				return ;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}else{
			J_NetManager.getInstance().downloadFile(url, path, new RequestCallBack<File>() {
				
				@Override
				public void onSuccess(ResponseInfo<File> responseInfo) {
							try {
								GifDrawable drawable = new GifDrawable(path);
//								gifImgCache.put(fileName, new SoftReference<GifDrawable>(drawable));
								setGifImgToView(imageView, drawable);
								
							} catch (IOException e) {
								e.printStackTrace();
							}
				}
				
				@Override
				public void onFailure(HttpException error, String msg) {
					
				}
			});
		}
		
	
		
		
		
	}
	
	
	class GifTask implements Runnable{
		
		private GifImageView imageView = null ;
		private String url = null ;
		
		public GifTask(final GifImageView imageView,final String url){
			this.imageView = imageView ;
			this.url = url ;
		}

		@Override
		public void run() {}
		
	}
	
	
	private String getGifFileName(String url){
		String[] subStr = url.split("/");
		return subStr[subStr.length-1];
	}
	
	
	private void setGifImgToView(final GifImageView imageView,final GifDrawable drawable){
		handler.post(new Runnable() {
			
			@Override
			public void run() {
				imageView.setImageDrawable(drawable);
//				Log.i("Gift", "imageView.setImageDrawable(drawable)");
			}
		});
	}
	
	
	class GifRequest{
		
		public GifImageView imageView ;
		public String url = "";
		
		public GifRequest(GifImageView imageView,String url){
			this.imageView = imageView ;
			this.url = url ;
		}
	}
	
	

}
