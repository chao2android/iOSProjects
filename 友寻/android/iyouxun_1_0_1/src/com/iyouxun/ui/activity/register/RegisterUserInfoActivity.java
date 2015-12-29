package com.iyouxun.ui.activity.register;

import java.io.File;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Handler;
import android.provider.MediaStore;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.file.FileUtils;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.MainBoxActivity;
import com.iyouxun.ui.activity.common.ClipPhoto;
import com.iyouxun.ui.dialog.PhotoSelectDialog;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.UploadPhotoDataAccess;
import com.iyouxun.utils.Util;

/**
 * @ClassName: RegisterUserInfoActivity
 * @Description: 填写信息页面
 * @author donglizhi
 * @date 2015年3月5日 上午11:33:02
 * 
 */
public class RegisterUserInfoActivity extends CommTitleActivity {
	private CircularImage userIcon;// 用户头像
	private EditText userNick;// 昵称
	private Button btnMan;// 按钮男
	private Button btnWoman;// 按钮女
	private Button btnEmotional;// 情感状态按钮
	private Button btnSave;// 保存按钮
	private int userGender = 1;// 性别
	private int marriageStatus = -1;// 情感状态
	private String[] marriageArr;
	private final UploadPhotoDataAccess upload = new UploadPhotoDataAccess(this);
	private String avatarPath = "";// 头像地址
	private File cameraFile;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.input_user_info);
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_register_user_info, null);
	}

	@Override
	protected void initViews() {
		userIcon = (CircularImage) findViewById(R.id.supplement_user_icon);
		userNick = (EditText) findViewById(R.id.supplement_user_nick);
		btnEmotional = (Button) findViewById(R.id.supplement_btn_emotional);
		btnMan = (Button) findViewById(R.id.supplement_btn_man);
		btnWoman = (Button) findViewById(R.id.supplement_btn_woman);
		btnSave = (Button) findViewById(R.id.register_user_info_btn_save);
		btnEmotional.setOnClickListener(listener);
		btnMan.setOnClickListener(listener);
		btnWoman.setOnClickListener(listener);
		btnSave.setOnClickListener(listener);
		userIcon.setOnClickListener(listener);
		marriageArr = getResources().getStringArray(R.array.profile_marriage_array);
		if (userGender == 1) {
			btnMan.setEnabled(false);
			btnWoman.setEnabled(true);
		} else {
			btnMan.setEnabled(true);
			btnWoman.setEnabled(false);
		}
		btnSave.setEnabled(false);
		userNick.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
				int length = userNick.getText().toString().length();
				if ((length == 0 || (length >= 1 && length <= 16)) && marriageStatus > 0) {
					btnSave.setEnabled(true);
				} else {
					btnSave.setEnabled(false);
				}
			}
		});
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 头部左侧按钮
				finish();
				break;
			case R.id.supplement_btn_man:// 按钮男
				btnMan.setEnabled(false);
				btnWoman.setEnabled(true);
				userGender = 1;
				break;
			case R.id.supplement_btn_woman:// 按钮女
				btnMan.setEnabled(true);
				btnWoman.setEnabled(false);
				userGender = 0;
				break;
			case R.id.supplement_btn_emotional:// 情感状态按钮
				if (marriageStatus == -1) {
					marriageStatus = 1;
				}
				Intent emotionalIntent = new Intent(mContext, EmotionalSelectActivity.class);
				emotionalIntent.putExtra(UtilRequest.USER_MARRIAGE_STATUS, marriageStatus);
				startActivityForResult(emotionalIntent, UtilRequest.REQUEST_CODE_EMOTIONAL_SELECT);
				break;
			case R.id.register_user_info_btn_save:// 保存按钮
				String nickString = userNick.getText().toString();
				if (marriageStatus == -1) {
					ToastUtil.showToast(mContext, getString(R.string.please_select_emotional));
				} else {
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					String mobilenumber = getIntent().getStringExtra(UtilRequest.MOBILE_NUMBER);
					String password = getIntent().getStringExtra(UtilRequest.REGISTER_PASSWORD);
					String securityCode = getIntent().getStringExtra(UtilRequest.SECURITY_CODE);
					String nick = userNick.getText().toString();
					try {
						JSONObject form = new JSONObject();
						if (!Util.isBlankString(nick)) {
							form.put(UtilRequest.FORM_NICK, nick);
						}
						form.put(UtilRequest.FORM_MOBILE, mobilenumber);
						form.put(UtilRequest.FORM_MOBILE_CODE, securityCode);
						form.put(UtilRequest.FORM_PASSWORD, password);
						form.put(UtilRequest.FORM_SEX, userGender);
						form.put(UtilRequest.FORM_MARRIAGE, marriageStatus);
						UtilRequest.doRegister(form.toString(), avatarPath, mHandler, mContext);
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
				break;
			case R.id.supplement_user_icon:// 选择头像
				// 弹出上传图片dialog
				new PhotoSelectDialog(mContext, R.style.dialog).setCallBack(new DialogUtils.OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if (!FileUtils.isSDCardExist()) {
							ToastUtil.showToast(mContext, getString(R.string.str_not_install_sd_card));
							return;
						}
						if (value1.equals("1")) {// 相机拍摄
							if (FileUtils.getSDCardAvailableSize() < 1.0) {
								ToastUtil.showToast(mContext, getString(R.string.str_memory_not_enough));
								return;
							}
							goToCamera();// 从相机拍摄
						} else if (value1.equals("2")) {
							goToAlbum();// 从手机相册
						}
					}
				}).show();
				break;
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_DO_REGISTER:// 注册返回
				if (msg.obj != null) {
					String token = SharedPreUtil.getLoginToken();
					SharedPreUtil.setNewUser(true);
					UtilRequest.doAutoLogin(token, mContext, mHandler);
				}
				break;
			case NetTaskIDs.TASKID_GET_USER_INFO:// 获得用户信息
				// 注册成功，自动登录成功后获取用户信息返回
				if (J_Cache.sLoginUser != null && J_Cache.sLoginUser.uid > 0) {
					J_Cache.sLoginUser.userName = getIntent().getStringExtra(UtilRequest.MOBILE_NUMBER);
					SharedPreUtil.saveLoginInfo(J_Cache.sLoginUser);
				}
				Intent intent = new Intent(mContext, MainBoxActivity.class);
				startActivity(intent);
				finish();
				break;
			default:
				break;
			}
		};
	};

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		switch (requestCode) {
		case UtilRequest.REQUEST_CODE_EMOTIONAL_SELECT:// 情感状态返回
			marriageStatus = data.getIntExtra(UtilRequest.USER_MARRIAGE_STATUS, 1);
			btnEmotional.setText(marriageArr[marriageStatus - 1]);
			int length = userNick.getText().toString().length();
			if (length == 0 || (length >= 1 && length <= 16)) {
				btnSave.setEnabled(true);
			} else {
				btnSave.setEnabled(false);
			}
			break;
		case UploadPhotoDataAccess.REQUEST_ASK_CAMERA:// 拍照
			// 从拍照intent返回
			if (resultCode == -1) {
				startPhotoZoomForAvatar(cameraFile.getAbsolutePath());
			}
			break;
		case UploadPhotoDataAccess.REQUEST_ASK_GALLERY:// 图库
			if (resultCode == -1) {
				// 从相册返回
				if (data != null) {
					Uri uri = data.getData();
					String path = upload.getRealFilePath(uri);
					startPhotoZoomForAvatar(path);
				}
			}
			break;
		case UtilRequest.REQUEST_CODE_CLIP_PHOTO:
			if (resultCode == 500 || resultCode == 501) {
				ToastUtil.showToast(mContext, getString(R.string.str_photo_small_error));
				return;
			}
			if (resultCode == -1 && data != null) {
				avatarPath = data.getStringExtra("avatarPath");
				Bitmap bm = BitmapFactory.decodeFile(avatarPath);
				userIcon.setImageBitmap(bm);
			}
			break;
		default:
			break;
		}
	};

	/**
	 * 跳转至照片裁剪
	 * 
	 * */
	public void startPhotoZoomForAvatar(String path) {
		Intent intent = new Intent(this, ClipPhoto.class);
		intent.putExtra("path", path);
		intent.putExtra("minWidth", 100);
		intent.putExtra("minHeight", 100);
		intent.putExtra("isAvatar", true);
		startActivityForResult(intent, UtilRequest.REQUEST_CODE_CLIP_PHOTO);
	}

	/**
	 * 跳转至拍照
	 * 
	 * */
	public void goToCamera() {
		// 设置拍照照片存放
		cameraFile = new File(J_FileManager.getInstance().getFileStore().getFileStorePath(), "temp");
		// 跳转至相机
		Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
		cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(cameraFile));
		startActivityForResult(cameraIntent, UploadPhotoDataAccess.REQUEST_ASK_CAMERA);
	}

	/**
	 * 去相册选取图片
	 * 
	 * @params
	 * @author
	 * @return
	 * */
	public void goToAlbum() {
		Intent albumIntent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
		albumIntent.setType("image/*");
		startActivityForResult(albumIntent, UploadPhotoDataAccess.REQUEST_ASK_GALLERY);
	}
}
