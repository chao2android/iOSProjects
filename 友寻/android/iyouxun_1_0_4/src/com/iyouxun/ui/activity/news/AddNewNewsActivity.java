package com.iyouxun.ui.activity.news;

import java.io.File;
import java.util.ArrayList;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.NewsAuthInfoBean;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.UploadNewsInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.service.UploadNewsService;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.NewsUploadPhotoListAdapter;
import com.iyouxun.ui.views.NotScollGridView;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.NetworkUtil;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.UploadPhotoDataAccess;
import com.iyouxun.utils.Util;

/**
 * 发布新动态
 * 
 * @author likai
 * @date 2015-3-6 下午4:58:23
 * 
 */
public class AddNewNewsActivity extends CommTitleActivity {
	private EditText addNewsContent;// 内容
	private RelativeLayout addNewsAuthButton;// 设置权限按钮
	private TextView addNewsAtuhInfo;// 权限内容
	private CheckBox isSyncToAlbum;// 照片同步相册设置按钮
	private NotScollGridView addNewPhotoGv;// 选中的照片列表
	private ImageButton photoLayerButton;// 选择照片
	private LinearLayout addNewsUploadPhotoBox;// 上传照片选择层
	private ImageButton addNewsSelectCamera;// 选择拍照
	private ImageButton addNewsSelectAlbum;// 选择相册
	private LinearLayout photo_layer_box;// 图片盒子
	// 图片选择工具
	private final UploadPhotoDataAccess upload = new UploadPhotoDataAccess(this);
	// 上传图片的adapter
	private NewsUploadPhotoListAdapter adapter;
	// adapter的数据
	private final ArrayList<PhotoInfoBean> datas = new ArrayList<PhotoInfoBean>();
	// 准备上传发布的动态信息
	private final UploadNewsInfoBean uploadInfo = new UploadNewsInfoBean();
	// 权限选择code
	public final int AUTH_REQUEST_CODE = 0x101;
	public static final int AUTH_RESULT_CODE = 0X102;
	// 图库选择返回
	protected static final int REQUSET_CODE_IMAGE_SCAN = 1;

	/** 分享生成动态的内容 */
	public String shareContent = "";
	/** 分享带有的图片内容path */
	public String shareImagePath = "";

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("新动态");

		titleLeftButton.setText("取消");
		titleLeftButton.setPadding(0, 0, 0, 0);
		titleLeftButton.setCompoundDrawables(null, null, null, null);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);

		titleRightButton.setText("发布");
		titleRightButton.setPadding(0, 0, 0, 0);
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_add_new_news_layout, null);
	}

	@Override
	protected void initViews() {
		// 要生成动态的内容
		shareContent = getIntent().getStringExtra("shareContent");
		shareImagePath = getIntent().getStringExtra("shareImagePath");

		addNewsContent = (EditText) findViewById(R.id.addNewsContent);
		addNewsAuthButton = (RelativeLayout) findViewById(R.id.addNewsAuthButton);
		addNewsAtuhInfo = (TextView) findViewById(R.id.addNewsAtuhInfo);
		isSyncToAlbum = (CheckBox) findViewById(R.id.isSyncToAlbum);
		addNewPhotoGv = (NotScollGridView) findViewById(R.id.addNewPhotoGv);
		photoLayerButton = (ImageButton) findViewById(R.id.photoLayerButton);
		addNewsUploadPhotoBox = (LinearLayout) findViewById(R.id.addNewsUploadPhotoBox);
		addNewsSelectCamera = (ImageButton) findViewById(R.id.addNewsSelectCamera);
		addNewsSelectAlbum = (ImageButton) findViewById(R.id.addNewsSelectAlbum);
		photo_layer_box = (LinearLayout) findViewById(R.id.photo_layer_box);

		// 设置图片显示adapter
		adapter = new NewsUploadPhotoListAdapter(mContext);
		adapter.setDatas(datas);
		adapter.setHandler(mHandler);
		addNewPhotoGv.setAdapter(adapter);

		addNewsAuthButton.setOnClickListener(listener);
		isSyncToAlbum.setOnClickListener(listener);
		photoLayerButton.setOnClickListener(listener);
		addNewsSelectCamera.setOnClickListener(listener);
		addNewsSelectAlbum.setOnClickListener(listener);

		// 填充默认内容
		if (!Util.isBlankString(shareContent)) {
			addNewsContent.setText(shareContent);
		}
		if (!Util.isBlankString(shareImagePath)) {
			setUploadImg(shareImagePath);
		}

		// 设置最大输入字数999字
		addNewsContent.addTextChangedListener(new TextWatcher() {
			private String temp;

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				temp = s.toString();
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
				if (!TextUtils.isEmpty(temp)) {
					String limitSubstring = StringUtils.getLimitSubstring(temp, 1998);
					if (!TextUtils.isEmpty(limitSubstring)) {
						if (!limitSubstring.equals(temp)) {
							addNewsContent.setText(limitSubstring);
							addNewsContent.setSelection(limitSubstring.length());
						}
					}
				}

			}
		});
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				// 取消需要确认
				showBackConfirm();
				break;
			case R.id.titleRightButton:
				// 发布
				createNewNews();
				break;
			case R.id.addNewsSelectCamera:
				// 相机
				String cNameCamera = "upload_photo_" + datas.size();
				upload.setCacheName(cNameCamera);
				upload.getHeaderFromCamera();
				break;
			case R.id.addNewsSelectAlbum:
				// 相册
				// 跳转到系统相册(仅可以选择单张图片)
				String cNameAlbum = "upload_photo_" + datas.size();
				upload.setCacheName(cNameAlbum);
				upload.getHeaderFromGallery();
				// 跳转到相册选择页面(可多选)
				// int can_select_length = MAX_SELECT_PHOTO_LENGTH -
				// uploadInfo.photos.size();
				// if (can_select_length > 0 && can_select_length <=
				// MAX_SELECT_PHOTO_LENGTH) {
				// Intent albumIntent = new Intent(mContext,
				// ImageScanActivity.class);
				// albumIntent.putExtra(ImageScanActivity.IMAGE_SCAN_SELECT_LENGTH,
				// can_select_length);
				// startActivityForResult(albumIntent, REQUSET_CODE_IMAGE_SCAN);
				// } else {
				// ToastUtil.showToast(mContext, "最多上传" +
				// MAX_SELECT_PHOTO_LENGTH + "张图片");
				// }
				break;
			case R.id.photoLayerButton:
				// 添加照片
				showUploadBox(-1);
				break;
			case R.id.isSyncToAlbum:
				// 照片同步至相册按钮
				if (uploadInfo.isSyncToAlbum == 1) {
					// 如果当前状态为同步至相册，修改为不同步
					uploadInfo.isSyncToAlbum = 0;
					isSyncToAlbum.setChecked(false);
				} else {
					// 如果当前状态为不同步，改为同步
					uploadInfo.isSyncToAlbum = 1;
					isSyncToAlbum.setChecked(true);
				}
				break;
			case R.id.addNewsAuthButton:
				// 设置权限
				Intent authIntent = new Intent(mContext, NewsLookAuthActivity.class);
				authIntent.putExtra("authData", uploadInfo.lookAuth);
				startActivityForResult(authIntent, AUTH_REQUEST_CODE);
				break;
			default:
				break;
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case 0x10000:
				// 删除一张已经选择好的照片
				int position = msg.arg1;
				datas.remove(position);
				adapter.notifyDataSetChanged();
				// 刷新上传框的状态
				refreshUploadBox();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 展示上传图片选择框
	 * 
	 * @return void 返回类型
	 * @param type 0:隐藏，1：显示，-1：自动
	 * @author likai
	 * @throws
	 */
	private void showUploadBox(int type) {
		switch (type) {
		case -1:
			// 根据显示情况，自动显示隐藏
			if (addNewsUploadPhotoBox.getVisibility() == View.VISIBLE) {
				addNewsUploadPhotoBox.setVisibility(View.INVISIBLE);
				photoLayerButton.setImageResource(R.drawable.icon_select_photo);
				// 显示键盘
				Util.showKeybord(mContext, addNewsContent);
			} else {
				addNewsUploadPhotoBox.setVisibility(View.VISIBLE);
				photoLayerButton.setImageResource(R.drawable.icn_chat_keyboard);
				// 关闭键盘
				Util.hideKeyboard(mContext, addNewsUploadPhotoBox);
			}
			break;
		case 0:
			// 隐藏上传框
			addNewsUploadPhotoBox.setVisibility(View.INVISIBLE);
			photoLayerButton.setImageResource(R.drawable.icon_select_photo);
			// 显示键盘
			Util.showKeybord(mContext, addNewsContent);
			break;
		case 1:
			// 显示上传框
			addNewsUploadPhotoBox.setVisibility(View.VISIBLE);
			photoLayerButton.setImageResource(R.drawable.icn_chat_keyboard);
			// 关闭键盘
			Util.hideKeyboard(mContext, addNewsUploadPhotoBox);
			break;
		default:
			break;
		}
	}

	/**
	 * 刷新上传图片的按钮状态
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void refreshUploadBox() {
		if (uploadInfo.photos.size() >= 9) {
			photo_layer_box.setVisibility(View.VISIBLE);
			// 大于等于9张图片时，隐藏上传图片按钮
			// 隐藏上传照片按钮
			photoLayerButton.setVisibility(View.INVISIBLE);
			// 隐藏上传盒子
			showUploadBox(0);
		} else {
			// 小于9张图片时，显示上传图片按钮
			// 显示上传照片按钮
			photoLayerButton.setVisibility(View.VISIBLE);
			if (uploadInfo.photos.size() <= 0) {
				photo_layer_box.setVisibility(View.GONE);
			} else {
				photo_layer_box.setVisibility(View.VISIBLE);
			}
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
		switch (requestCode) {
		case REQUSET_CODE_IMAGE_SCAN:
			// 图库选择图片返回
			if (resultCode == ImageScanActivity.RESULT_CODE_IMAGE_SCAN) {
				ArrayList<String> pathList = intent.getExtras().getStringArrayList(ShowImageActivity.SHOW_IMAGE_RESULT_DATA);
				for (int i = 0; i < pathList.size(); i++) {
					String path = pathList.get(i);
					File photo = new File(path);
					if (photo.exists()) {
						PhotoInfoBean bean = new PhotoInfoBean();
						bean.picPath = path;
						bean.uid = J_Cache.sLoginUser.uid;
						bean.nick = J_Cache.sLoginUser.nickName;
						datas.add(bean);
					}
				}

				// 更新发布信息
				uploadInfo.photos = datas;
				adapter.notifyDataSetChanged();
				refreshUploadBox();
			}
			break;
		case AUTH_REQUEST_CODE:
			// 权限选择返回
			if (resultCode == AUTH_RESULT_CODE) {
				uploadInfo.lookAuth = (NewsAuthInfoBean) intent.getSerializableExtra("authData");
				if (uploadInfo.lookAuth.lookAuthType == 1) {
					addNewsAtuhInfo.setText("所有好友");
				} else {
					addNewsAtuhInfo.setText("指定分组");
				}
			}
			break;
		case UploadPhotoDataAccess.REQUEST_ASK_GALLERY:// 图库
		case UploadPhotoDataAccess.REQUEST_ASK_CAMERA:// 拍照
			// 此处是通过upload对象打开相机或相册时，选择图片后返回处理
			File file_photo = upload.onActivityResult(requestCode, resultCode, intent);
			if (file_photo != null) {
				// 原图地址
				String pathName = file_photo.getAbsolutePath();
				// 处理返回的图片
				if (!Util.isBlankString(pathName)) {
					setUploadImg(pathName);
				}
			}
			break;
		default:
			break;
		}
	}

	/**
	 * 设置待上传的图片
	 * 
	 * @Title: setUploadImg
	 * @return void 返回类型
	 * @param @param path 参数类型
	 * @author likai
	 * @throws
	 */
	private void setUploadImg(String path) {
		if (!Util.isBlankString(path)) {
			PhotoInfoBean bean = new PhotoInfoBean();
			bean.picPath = path;
			bean.uid = J_Cache.sLoginUser.uid;
			bean.nick = J_Cache.sLoginUser.nickName;
			datas.add(0, bean);

			// 更新发布信息
			uploadInfo.photos = datas;

			adapter.notifyDataSetChanged();
		}
		refreshUploadBox();
	}

	/**
	 * 发送请求，创建新动态
	 * 
	 * @Title: createNewNews
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void createNewNews() {
		String content = addNewsContent.getText().toString().trim();
		if (!Util.isBlankString(content) || uploadInfo.photos.size() > 0) {
			if (!Util.isBlankString(content)) {
				uploadInfo.content = content;
			}

			if (NetworkUtil.checkNetwork(mContext)) {
				// 开始执行发布操作
				showLoading("发布中...");
				// 关闭键盘
				Util.hideKeyboard(mContext, addNewsContent);
				// 添加监听方法
				J_Application.pushActiviy.put("AddNewNewsActivity", this);

				// 执行发布请求操作
				Intent uploadIntent = new Intent(mContext, UploadNewsService.class);
				uploadIntent.putExtra("uploadData", uploadInfo);
				startService(uploadIntent);
			} else {
				// 网络异常
				UtilRequest.showNetworkError(mContext);
			}
		} else {
			ToastUtil.showToast(mContext, "内容或图片，不能为空");
		}
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		// 移除监听方法
		J_Application.pushActiviy.remove("AddNewNewsActivity");
	}

	/**
	 * 发布成功后回调
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public void publishSuccess() {
		// 返回结果
		setResult(NewsMainActivity.RESULT_CODE_CREATE_OK);
		finish();
	}

	/**
	 * 发布动态中返回操作
	 * 
	 * 输入文字内容或插入图片后，点击左上角返回（安卓系统点左上角返回或手机返回键）
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void showBackConfirm() {
		// 关闭键盘
		Util.hideKeyboard(mContext, addNewsContent);

		// 获取输入内容
		String content = addNewsContent.getText().toString().trim();
		if (!Util.isBlankString(content) || uploadInfo.photos.size() > 0) {
			DialogUtils.showPromptDialog(mContext, "退出", "放弃发布动态？", new OnSelectCallBack() {
				@Override
				public void onCallBack(String value1, String value2, String value3) {
					if (value1.equals("0")) {
						// 确认退出
						finish();
					}
				}
			});
		} else {
			// 否则，直接关闭
			finish();
		}
	}

	@Override
	public boolean dispatchKeyEvent(KeyEvent event) {
		if (event.getKeyCode() == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0 && event.getAction() != KeyEvent.ACTION_UP) {
			// 返回确认
			showBackConfirm();
			return true;
		}
		return super.dispatchKeyEvent(event);
	}

}
