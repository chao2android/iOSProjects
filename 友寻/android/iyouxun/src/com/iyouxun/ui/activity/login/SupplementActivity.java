package com.iyouxun.ui.activity.login;

import java.io.File;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.OpenPlatformBeans;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.MainBoxActivity;
import com.iyouxun.ui.activity.common.ClipPhoto;
import com.iyouxun.ui.activity.register.EmotionalSelectActivity;
import com.iyouxun.ui.dialog.PhotoSelectDialog;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.ui.views.ClearEditText;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.UploadPhotoDataAccess;
import com.iyouxun.utils.Util;

/**
 * @ClassName: SupplementActivity
 * @Description: 补充资料页
 * @author donglizhi
 * @date 2015年3月3日 下午4:00:48
 * 
 */
public class SupplementActivity extends CommTitleActivity {
	private CircularImage userIcon;// 头像
	private EditText userNick;// 昵称
	private Button btnMan;// 按钮男
	private Button btnWoman;// 按钮女
	private Button btnEmotional;// 情感状态按钮
	private ClearEditText inputPhoneNumber;// 输入电话号码
	private ClearEditText inputSecurityCode;// 输入验证码
	private Button btnGetSecurityCode;// 获得验证码按钮
	private Button btnComplete;// 完成按钮
	private int userGender = 1;// 性别
	private int marriageStatus = -1;// 情感状态
	private String[] marriageArr;
	private final UploadPhotoDataAccess upload = new UploadPhotoDataAccess(this);
	private String avatarPath = "";// 头像地址
	private int openType;
	private String accessToken;
	private String openId;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.str_supplement);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		titleLeftButton.setText(R.string.go_back);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_supplement, null);
	}

	@Override
	protected void initViews() {
		userIcon = (CircularImage) findViewById(R.id.supplement_user_icon);
		userNick = (EditText) findViewById(R.id.supplement_user_nick);
		btnComplete = (Button) findViewById(R.id.supplement_btn_complete);
		btnEmotional = (Button) findViewById(R.id.supplement_btn_emotional);
		btnGetSecurityCode = (Button) findViewById(R.id.supplement_btn_security_code);
		btnMan = (Button) findViewById(R.id.supplement_btn_man);
		btnWoman = (Button) findViewById(R.id.supplement_btn_woman);
		inputPhoneNumber = (ClearEditText) findViewById(R.id.supplement_input_phone_number);
		inputSecurityCode = (ClearEditText) findViewById(R.id.supplement_input_security_code);

		btnComplete.setOnClickListener(listener);
		btnEmotional.setOnClickListener(listener);
		btnGetSecurityCode.setOnClickListener(listener);
		btnMan.setOnClickListener(listener);
		btnWoman.setOnClickListener(listener);
		userIcon.setOnClickListener(listener);
		inputPhoneNumber.addTextChangedListener(textWatcher);
		inputSecurityCode.addTextChangedListener(textWatcher);
		userNick.addTextChangedListener(textWatcher);
		if (getIntent().hasExtra(UtilRequest.PLATFORM_DATA)) {
			OpenPlatformBeans beans = (OpenPlatformBeans) getIntent().getSerializableExtra(UtilRequest.PLATFORM_DATA);
			userNick.setText(beans.getUserNick());
			J_NetManager.getInstance().loadIMG(null, beans.getUserIcon(), userIcon, 0, 0);
			if (UtilRequest.PLATFORM_USER_GENDER_MAN.equals(beans.getUserGender())) {
				userGender = 1;
				btnMan.setEnabled(false);
				btnWoman.setEnabled(true);
			} else {
				userGender = 0;
				btnMan.setEnabled(true);
				btnWoman.setEnabled(false);
			}
			avatarPath = beans.getImgPath();
			openType = beans.getOpenType();
			accessToken = beans.getAccessToken();
			openId = beans.getUserId();
		} else {
			btnMan.setEnabled(false);
		}
		marriageArr = getResources().getStringArray(R.array.profile_marriage_array);
	}

	private final TextWatcher textWatcher = new TextWatcher() {

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void afterTextChanged(Editable s) {
			setBtnCompleteEnable();
		}

	};

	/**
	 * @Title: setBtnCompleteEnable
	 * @Description: 设置完成按钮是否可用
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void setBtnCompleteEnable() {
		int length = userNick.getText().toString().length();
		String moblie = inputPhoneNumber.getText().toString();
		String securityCode = inputSecurityCode.getText().toString();
		if ((length == 0 || (length >= 1 && length <= 16)) && marriageStatus > 0 && Util.isMobileNumber(moblie)
				&& securityCode.length() > 0) {
			btnComplete.setEnabled(true);
		} else {
			btnComplete.setEnabled(false);
		}
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 头部左侧按钮
				Intent loginIntent = new Intent(mContext, LoginActivity.class);
				startActivity(loginIntent);
				finish();
				break;
			case R.id.supplement_btn_complete:// 完成按钮
				String mobileNumber = inputPhoneNumber.getText().toString();
				String securityCode = inputSecurityCode.getText().toString();
				if (marriageStatus == -1) {
					ToastUtil.showToast(mContext, getString(R.string.please_select_emotional));
				} else if (Util.isBlankString(securityCode)) {
					ToastUtil.showToast(mContext, getString(R.string.register_error_security_code_empty));
				} else {

					try {
						JSONObject formSecurity_code = new JSONObject();
						formSecurity_code.put(UtilRequest.FORM_MOBILE, mobileNumber);
						formSecurity_code.put(UtilRequest.FORM_MOBILE_CODE, securityCode);
						DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
						UtilRequest.valMobileCode(formSecurity_code.toString(), mHandler, mContext);
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
				}
				break;
			case R.id.supplement_btn_emotional:// 情感状态按钮
				if (marriageStatus == -1) {
					marriageStatus = 1;
				}
				Intent emotionalIntent = new Intent(mContext, EmotionalSelectActivity.class);
				emotionalIntent.putExtra(UtilRequest.USER_MARRIAGE_STATUS, marriageStatus);
				startActivityForResult(emotionalIntent, UtilRequest.REQUEST_CODE_EMOTIONAL_SELECT);
				break;
			case R.id.supplement_btn_man:// 按钮男
				btnMan.setEnabled(false);
				btnWoman.setEnabled(true);
				userGender = 1;
				break;
			case R.id.supplement_btn_security_code:// 验证码按钮
				String phoneNumber = inputPhoneNumber.getText().toString();
				if (Util.isMobileNumber(phoneNumber)) {
					try {
						JSONObject form = new JSONObject();
						form.put(UtilRequest.FORM_MOBILE, phoneNumber);
						DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
						UtilRequest.vaildMobile(mContext, mHandler, form.toString(), 1);// 手机号已存在不能注册
					} catch (JSONException e) {
						e.printStackTrace();
					}
				} else {
					ToastUtil.showToast(mContext, getString(R.string.please_input_true_mobile_number));
				}
				break;
			case R.id.supplement_btn_woman:// 按钮女
				btnMan.setEnabled(true);
				btnWoman.setEnabled(false);
				userGender = 0;
				break;
			case R.id.supplement_user_icon:// 选择头像
				// 弹出上传图片dialog
				new PhotoSelectDialog(mContext, R.style.dialog).setCallBack(new DialogUtils.OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if (value1.equals("1")) {
							// 拍照
							upload.getHeaderFromCamera();
						} else if (value1.equals("2")) {
							// 相册
							upload.getHeaderFromGallery();
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
			case NetTaskIDs.TASKID_VAILD_MOBILE_EXISTS:// 验证手机是否存在
				if (msg.obj == null) {
					return;
				}
				J_Response response = (J_Response) msg.obj;
				if (response.retcode == -1) {// 账号已经存在直接登录
					mHandler.postDelayed(new Runnable() {
						@Override
						public void run() {
							Intent intent = new Intent(mContext, LoginActivity.class);
							startActivity(intent);
							finish();
						}
					}, 1500);
				} else {
					String phoneNumber = inputPhoneNumber.getText().toString();
					try {
						JSONObject form = new JSONObject();
						form.put(UtilRequest.FORM_MOBILE, phoneNumber);
						UtilRequest.getSecurityCode(mHandler, form.toString(), mContext);
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
				break;
			case NetTaskIDs.TASKID_GET_SECURITY_CODE:// 获得验证码
				DialogUtils.dismissDialog();
				if (J_SDK.getConfig().LOG_ENABLE) {
					inputSecurityCode.setText(msg.obj.toString());
				}
				Util.btnCountdown(mHandler, Util.COUNTDOWN_TIME, getString(R.string.str_countdown_title), btnGetSecurityCode);
				btnGetSecurityCode.setEnabled(false);
				break;
			case NetTaskIDs.TASKID_DO_REGISTER:// 注册返回
				if (msg.obj != null) {
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					String token = SharedPreUtil.getLoginToken();
					SharedPreUtil.setNewUser(true);
					UtilRequest.doAutoLogin(token, 0, mContext, mHandler);
				}
				break;
			case NetTaskIDs.TASKID_GET_USER_INFO:// 获取用户状态
				Intent mainIntent = new Intent(mContext, MainBoxActivity.class);
				startActivity(mainIntent);
				DialogUtils.dismissDialog();
				finish();
				break;
			case NetTaskIDs.TASKID_VAILD_MOBILE_CODE:// 验证验证码
				String nick = userNick.getText().toString();
				String mobileNumber = inputPhoneNumber.getText().toString();
				String securityCode = inputSecurityCode.getText().toString();
				try {
					JSONObject form = new JSONObject();
					if (!Util.isBlankString(nick)) {
						form.put(UtilRequest.FORM_NICK, nick);
					}
					form.put(UtilRequest.FORM_MOBILE, mobileNumber);
					form.put(UtilRequest.FORM_MOBILE_CODE, securityCode);
					form.put(UtilRequest.FORM_SEX, userGender);
					form.put(UtilRequest.FORM_MARRIAGE, marriageStatus);
					form.put(UtilRequest.FORM_OPEN_ID, openId);
					form.put(UtilRequest.FORM_OPENID_TYPE, openType);
					form.put(UtilRequest.FORM_ACCESS_TOKEN, accessToken);
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.doRegister(form.toString(), avatarPath, mHandler, mContext);
				} catch (JSONException e) {
					e.printStackTrace();
				}
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
			setBtnCompleteEnable();
			break;
		case UploadPhotoDataAccess.REQUEST_ASK_CAMERA:// 拍照
		case UploadPhotoDataAccess.REQUEST_ASK_GALLERY:// 图库
			// 此处是通过upload对象打开相机或相册时，选择图片后返回处理
			File file_photo = upload.onActivityResult(requestCode, resultCode, data);
			if (file_photo != null) {
				String photoPath = file_photo.getAbsolutePath();
				if (!Util.isBlankString(photoPath)) {
					startPhotoZoomForAvatar(photoPath);
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

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			Intent loginIntent = new Intent(mContext, LoginActivity.class);
			startActivity(loginIntent);
			finish();
		}
		return super.onKeyDown(keyCode, event);
	}

}
