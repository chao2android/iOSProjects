package com.iyouxun.ui.activity.news;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.provider.MediaStore.MediaColumns;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.iyouxun.R;
import com.iyouxun.data.beans.ImageBean;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.j_libs.J_LibsConfig;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.AlbumGroupAdapter;
import com.iyouxun.utils.Util;

/**
 * 手机相册列表
 * 
 * @author likai
 * @date 2015-4-24 下午2:43:33
 * 
 */
public class ImageScanActivity extends CommTitleActivity {
	private final HashMap<String, List<String>> mGruopMap = new HashMap<String, List<String>>();
	private List<ImageBean> list = new ArrayList<ImageBean>();
	public static final String IMAGE_SCAN_SELECT_LENGTH = "image_scan_select_length";
	private final static int SCAN_OK = 1;
	private ProgressDialog mProgressDialog;
	private AlbumGroupAdapter adapter;
	private ListView mGroupListView;
	private int select_length = 9;// 可选择照片数量
	protected static final int REQUEST_CODE_SHOW_IMAGE = 0;
	protected static final int RESULT_CODE_SHOW_IAMGE = 1;
	public static final int RESULT_CODE_IMAGE_SCAN = 100;
	@SuppressLint("HandlerLeak")
	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			switch (msg.what) {
			case SCAN_OK:
				// 关闭进度条
				mProgressDialog.dismiss();

				adapter = new AlbumGroupAdapter(mContext, list = subGroupOfImage(mGruopMap), mGroupListView);
				mGroupListView.setAdapter(adapter);
				break;
			}
		}
	};

	/**
	 * 
	 * @param titleCenter
	 * @param titleLeftButton
	 * @param titleRightButton
	 */
	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("相册列表");
		titleLeftButton.setText("返回");
		titleLeftButton.setOnClickListener(listener);
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	/**
	 * 
	 * @return
	 */
	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_image_scan, null);
	}

	/**
	 *  
	 */
	@Override
	protected void initViews() {
		J_LibsConfig config = new J_LibsConfig();
		JsonParser jsonParser = new JsonParser();
		config.setJ_JsonParser(jsonParser);// 设置json解析器-网络请求返回后，会使用该解析器解析数据
		config.CLIENT_ID = Util.getClientId();
		config.CHANNEL_ID = Util.getChannelId();
		config.APP_VERSION = Util.getAppVersionName();
		config.OPERATOR_CODE = Util.operatorCode2String();
		config.DEVICE_IMEI = Util.getDeviceIMEI();
		config.MOBILE_MODEL = android.os.Build.MODEL;
		config.SYSTEM_VERSION = android.os.Build.VERSION.RELEASE;
		config.USER_ID = "";
		config.LOG_ENABLE = true;// 是否打印日志信息
		config.CRASH_LOG_ENABLE = false;// 开启crash的日志抓取
		config.API_SETTING = 1;// 接口环境1：测试，2：预上线，3：正式

		// 启动sdk框架
		J_SDK.start(config, mContext);

		// 参数
		select_length = getIntent().getIntExtra(IMAGE_SCAN_SELECT_LENGTH, 0);

		mGroupListView = (ListView) findViewById(R.id.main_list);

		getImages();

		mGroupListView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				List<String> childList = mGruopMap.get(list.get(position).getFolderName());

				Intent mIntent = new Intent(mContext, ShowImageActivity.class);
				mIntent.putStringArrayListExtra("data", (ArrayList<String>) childList);
				mIntent.putExtra("length", select_length);
				startActivityForResult(mIntent, REQUEST_CODE_SHOW_IMAGE);
			}
		});
	}

	/**
	 * 利用ContentProvider扫描手机中的图片，此方法在运行在子线程中
	 */
	private void getImages() {
		if (!Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
			Toast.makeText(this, getString(R.string.str_no_external_memory), Toast.LENGTH_SHORT).show();
			return;
		}

		// 显示进度条
		mProgressDialog = ProgressDialog.show(this, null, getString(R.string.xlistview_header_hint_loading));

		new Thread(new Runnable() {
			@Override
			public void run() {
				Uri mImageUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
				ContentResolver mContentResolver = mContext.getContentResolver();

				// 只查询jpeg和png的图片
				Cursor mCursor = mContentResolver.query(mImageUri, null, "(" + MediaColumns.MIME_TYPE + "=? or "
						+ MediaColumns.MIME_TYPE + "=?" + " ) and " + MediaColumns.SIZE + " > 10240 and " + MediaColumns.SIZE
						+ " < 5242880", new String[] { "image/jpeg", "image/png" }, MediaColumns.DATE_MODIFIED);
				while (mCursor.moveToNext()) {
					// 获取图片的路径
					String path = mCursor.getString(mCursor.getColumnIndex(MediaColumns.DATA));
					// 获取该图片的父路径名
					File file = new File(path);
					String parentName = file.getParentFile().getName();
					// 根据父路径名将图片放入到mGruopMap中
					if (!mGruopMap.containsKey(parentName)) {
						List<String> chileList = new ArrayList<String>();
						chileList.add(path);
						mGruopMap.put(parentName, chileList);
					} else {
						mGruopMap.get(parentName).add(path);
					}
				}

				mCursor.close();

				// 通知Handler扫描图片完成
				mHandler.sendEmptyMessage(SCAN_OK);
			}
		}).start();
	}

	/**
	 * 组装分组界面ListView的数据源，因为我们扫描手机的时候将图片信息放在HashMap中 所以需要遍历HashMap将数据组装成List
	 * 
	 * @param mGruopMap
	 * @return
	 */
	private List<ImageBean> subGroupOfImage(HashMap<String, List<String>> mGruopMap) {
		if (mGruopMap.size() == 0) {
			return null;
		}
		List<ImageBean> list = new ArrayList<ImageBean>();

		Iterator<Map.Entry<String, List<String>>> it = mGruopMap.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry<String, List<String>> entry = it.next();
			ImageBean mImageBean = new ImageBean();
			String key = entry.getKey();
			List<String> value = entry.getValue();

			mImageBean.setFolderName(key);
			mImageBean.setImageCounts(value.size());
			mImageBean.setTopImagePath(value.get(0));// 获取该组的第一张图片

			list.add(mImageBean);
		}

		return list;
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		switch (requestCode) {
		case REQUEST_CODE_SHOW_IMAGE:
			if (resultCode == RESULT_CODE_SHOW_IAMGE) {
				setResult(RESULT_CODE_IMAGE_SCAN, data);
				finish();
				android.os.Process.killProcess(android.os.Process.myPid());
			}
			break;
		default:
			break;
		}
		super.onActivityResult(requestCode, resultCode, data);
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				finish();
				android.os.Process.killProcess(android.os.Process.myPid());
				break;
			default:
				break;
			}
		}
	};
}
