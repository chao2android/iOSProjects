package com.iyouxun.ui.activity.center;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

import org.json.JSONObject;

import android.content.Intent;
import android.net.Uri;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.consts.NetConstans;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.managers.J_NetManager.OnLoadingListener;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.GetUserInfoRequest;
import com.iyouxun.net.request.J_OnDataBack;
import com.iyouxun.net.request.UpdateUserInfoRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.common.ClipPhoto;
import com.iyouxun.ui.dialog.PhotoSelectDialog;
import com.iyouxun.ui.views.ClearEditText;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.ProfileUtils;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.UploadPhotoDataAccess;
import com.iyouxun.utils.Util;

/**
 * 我的资料页(资料编辑详情列表页)
 * 
 * @ClassName: ProfileDetailEditActivity
 * @author likai
 * @date 2015-2-28 下午2:06:22
 * 
 */
public class ProfileDetailEditActivity extends CommTitleActivity {
	private ImageView profile_edit_avatar;// 头像
	private ClearEditText profile_edit_nick;// 昵称
	private RelativeLayout profile_edit_marry_box;// 婚姻状态选择框
	private TextView profile_edit_marray;// 婚姻
	private RelativeLayout profile_edit_location_box;// 位置
	private TextView profile_edit_location;
	private RelativeLayout profile_edit_birth_box;// 生日
	private TextView profile_edit_birth;
	private RelativeLayout profile_edit_height_box;// 身高
	private TextView profile_edit_height;
	private RelativeLayout profile_edit_weight_box;// 体重
	private TextView profile_edit_weight;
	private RelativeLayout profile_edit_job_box;// 工作
	private TextView profile_edit_job;
	private ClearEditText profile_edit_company;
	private TextView profile_edit_left_title8;// 公司（学校）标题
	private RelativeLayout profile_edit_address_box;// 常驻地
	private TextView profile_edit_address;// 常驻地

	private LinearLayout profile_detail_box;

	/** 裁剪后头像的地址 */
	private String cutAvatarPath = "";
	/** 裁剪前头像的原图地址 */
	private String avatarPath = "";

	// 裁剪返回值
	private final int REQUEST_CODE_CUT = 106;
	private final int REQUEST_CODE_ERROR = 500;
	/** 更新用户信息 */
	private static final int REQUEST_CODE_EDIT = 107;
	public static final int RESULT_CODE_EDIT = 108;

	private final UploadPhotoDataAccess upload = new UploadPhotoDataAccess(this);

	private LoginUser currentEditUser = new LoginUser();

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("我的资料");
		titleLeftButton.setText("取消");
		titleLeftButton.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleRightButton.setText("完成");
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_profile_detail_edit, null);
	}

	@Override
	protected void initViews() {
		currentEditUser = J_Cache.sLoginUser;

		profile_edit_avatar = (ImageView) findViewById(R.id.profile_edit_avatar);
		profile_edit_nick = (ClearEditText) findViewById(R.id.profile_edit_nick);
		profile_edit_marry_box = (RelativeLayout) findViewById(R.id.profile_edit_marry_box);
		profile_edit_marray = (TextView) findViewById(R.id.profile_edit_marry);
		profile_edit_location_box = (RelativeLayout) findViewById(R.id.profile_edit_location_box);
		profile_edit_location = (TextView) findViewById(R.id.profile_edit_location);
		profile_edit_birth_box = (RelativeLayout) findViewById(R.id.profile_edit_birth_box);
		profile_edit_birth = (TextView) findViewById(R.id.profile_edit_birth);
		profile_edit_height_box = (RelativeLayout) findViewById(R.id.profile_edit_height_box);
		profile_edit_height = (TextView) findViewById(R.id.profile_edit_height);
		profile_edit_weight_box = (RelativeLayout) findViewById(R.id.profile_edit_weight_box);
		profile_edit_weight = (TextView) findViewById(R.id.profile_edit_weight);
		profile_edit_job_box = (RelativeLayout) findViewById(R.id.profile_edit_job_box);
		profile_edit_job = (TextView) findViewById(R.id.profile_edit_job);
		profile_edit_company = (ClearEditText) findViewById(R.id.profile_edit_company);
		profile_edit_left_title8 = (TextView) findViewById(R.id.profile_edit_left_title8);
		profile_edit_address_box = (RelativeLayout) findViewById(R.id.profile_edit_address_box);
		profile_edit_address = (TextView) findViewById(R.id.profile_edit_address);
		profile_detail_box = (LinearLayout) findViewById(R.id.profile_detail_box);

		profile_edit_avatar.setOnClickListener(listener);
		profile_edit_marry_box.setOnClickListener(listener);
		profile_edit_location_box.setOnClickListener(listener);
		profile_edit_birth_box.setOnClickListener(listener);
		profile_edit_height_box.setOnClickListener(listener);
		profile_edit_weight_box.setOnClickListener(listener);
		profile_edit_job_box.setOnClickListener(listener);
		profile_edit_address_box.setOnClickListener(listener);
		profile_detail_box.setOnClickListener(listener);

		// 公司或学校，最多输入20个汉字
		profile_edit_company.addTextChangedListener(new TextWatcher() {
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
					profile_edit_company.setTextColor(getResources().getColor(R.color.text_normal_black));
					String limitSubstring = StringUtils.getLimitSubstring(temp, 40);
					if (!TextUtils.isEmpty(limitSubstring)) {
						if (!limitSubstring.equals(temp)) {
							profile_edit_company.setText(limitSubstring);
							profile_edit_company.setSelection(limitSubstring.length());
						}
					}
				} else {
					profile_edit_company.setTextColor(getResources().getColor(R.color.text_normal_gray));
				}
			}
		});
	}

	@Override
	protected void onResume() {
		super.onResume();

		// 更新用户信息
		setContent();
	}

	/**
	 * 设置页面默认显示内容
	 * 
	 * @Title: setContent
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContent() {
		// 头像
		J_NetManager.getInstance().loadIMG(null, currentEditUser.avatarUrl, profile_edit_avatar, R.drawable.icon_avatar,
				R.drawable.icon_avatar);
		// 昵称
		profile_edit_nick.setText(currentEditUser.nickName);
		profile_edit_nick.setSelection(currentEditUser.nickName.length());
		// 婚姻状况
		profile_edit_marray.setText(ProfileUtils.getMarriage(currentEditUser.marriage));
		// 位置地区
		if (!Util.isBlankString(currentEditUser.locationName) && !Util.isBlankString(currentEditUser.subLocationName)) {
			profile_edit_location.setText(currentEditUser.locationName + " " + currentEditUser.subLocationName);
			profile_edit_location.setTextColor(getResources().getColor(R.color.text_normal_black));
		} else {
			profile_edit_location.setText("请选择地区");
			profile_edit_location.setTextColor(getResources().getColor(R.color.text_normal_gray));
		}
		// 常驻地
		if (!Util.isBlankString(currentEditUser.address)) {
			profile_edit_address.setText(currentEditUser.address);
			profile_edit_address.setTextColor(getResources().getColor(R.color.text_normal_black));
		} else {
			profile_edit_address.setText("请填写常驻地");
			profile_edit_address.setTextColor(getResources().getColor(R.color.text_normal_gray));
		}
		// 生日
		if (currentEditUser.marriage == 1) {
			// 单身的时候才显示生日
			if (currentEditUser.star > 0 && currentEditUser.birthpet > 0) {
				profile_edit_birth.setText(ProfileUtils.getStar(currentEditUser.star) + " 属"
						+ ProfileUtils.getBirthPet(currentEditUser.birthpet));
				profile_edit_birth.setTextColor(getResources().getColor(R.color.text_normal_black));
			} else {
				profile_edit_birth.setText("请选择生日");
				profile_edit_birth.setTextColor(getResources().getColor(R.color.text_normal_gray));
			}
			// 身高
			String height = ProfileUtils.getHeight(currentEditUser.height);
			if (Util.isBlankString(height)) {
				height = "请选择身高";
				profile_edit_height.setTextColor(getResources().getColor(R.color.text_normal_gray));
			} else {
				profile_edit_height.setTextColor(getResources().getColor(R.color.text_normal_black));
			}
			profile_edit_height.setText(height);
			// 体重
			String weight = ProfileUtils.getWeight(currentEditUser.weight);
			if (Util.isBlankString(weight)) {
				weight = "请选择体重";
				profile_edit_weight.setTextColor(getResources().getColor(R.color.text_normal_gray));
			} else {
				profile_edit_weight.setTextColor(getResources().getColor(R.color.text_normal_black));
			}
			profile_edit_weight.setText(weight);

			profile_edit_birth_box.setVisibility(View.VISIBLE);
			profile_edit_height_box.setVisibility(View.VISIBLE);
			profile_edit_weight_box.setVisibility(View.VISIBLE);
		} else {
			profile_edit_birth_box.setVisibility(View.GONE);
			profile_edit_height_box.setVisibility(View.GONE);
			profile_edit_weight_box.setVisibility(View.GONE);
		}
		// 职业
		if (currentEditUser.career > 0) {
			profile_edit_job.setText(ProfileUtils.getCareer(currentEditUser.career));
			profile_edit_job.setTextColor(getResources().getColor(R.color.text_normal_black));
		} else {
			profile_edit_job.setText("请选择职业");
			profile_edit_job.setTextColor(getResources().getColor(R.color.text_normal_gray));
		}
		// 公司/学校
		if (currentEditUser.career == J_Consts.SCHOOL_CAREER_ID) {
			profile_edit_left_title8.setText("学校");
			if (!Util.isBlankString(currentEditUser.school)) {
				profile_edit_company.setText(currentEditUser.school);
				profile_edit_company.setSelection(currentEditUser.school.length());
				profile_edit_company.setTextColor(getResources().getColor(R.color.text_normal_black));
			} else {
				profile_edit_company.setHint("请填写学校");
				profile_edit_company.setTextColor(getResources().getColor(R.color.text_normal_gray));
			}
		} else {
			profile_edit_left_title8.setText("公司");
			if (!Util.isBlankString(currentEditUser.company)) {
				profile_edit_company.setText(currentEditUser.company);
				profile_edit_company.setSelection(currentEditUser.company.length());
				profile_edit_company.setTextColor(getResources().getColor(R.color.text_normal_black));
			} else {
				profile_edit_company.setHint("请填写公司信息");
				profile_edit_company.setTextColor(getResources().getColor(R.color.text_normal_gray));
			}
		}
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.profile_detail_box:
				Util.hideKeyboard(mContext, profile_detail_box);
				break;
			case R.id.profile_edit_marry_box:
				// 情感
				Intent marryIntent = new Intent(mContext, ProfileEditActivity.class);
				marryIntent.putExtra("type", "marry");
				marryIntent.putExtra("userInfo", currentEditUser);
				startActivityForResult(marryIntent, REQUEST_CODE_EDIT);
				break;
			case R.id.profile_edit_location_box:
				// 位置地区
				Intent locationIntent = new Intent(mContext, ProfileEditActivity.class);
				locationIntent.putExtra("type", "location");
				locationIntent.putExtra("userInfo", currentEditUser);
				startActivityForResult(locationIntent, REQUEST_CODE_EDIT);
				break;
			case R.id.profile_edit_address_box:
				// 常驻地设置
				Intent addressIntent = new Intent(mContext, ProfileEditActivity.class);
				addressIntent.putExtra("type", "address");
				addressIntent.putExtra("userInfo", currentEditUser);
				startActivityForResult(addressIntent, REQUEST_CODE_EDIT);
				break;
			case R.id.profile_edit_birth_box:
				// 生日
				Intent birthIntent = new Intent(mContext, ProfileEditActivity.class);
				birthIntent.putExtra("type", "birth");
				birthIntent.putExtra("userInfo", currentEditUser);
				startActivityForResult(birthIntent, REQUEST_CODE_EDIT);
				break;
			case R.id.profile_edit_height_box:
				// 身高
				Intent heightIntent = new Intent(mContext, ProfileEditActivity.class);
				heightIntent.putExtra("type", "height");
				heightIntent.putExtra("userInfo", currentEditUser);
				startActivityForResult(heightIntent, REQUEST_CODE_EDIT);
				break;
			case R.id.profile_edit_weight_box:
				// 体重
				Intent weightIntent = new Intent(mContext, ProfileEditActivity.class);
				weightIntent.putExtra("type", "weight");
				weightIntent.putExtra("userInfo", currentEditUser);
				startActivityForResult(weightIntent, REQUEST_CODE_EDIT);
				break;
			case R.id.profile_edit_job_box:
				// 工作
				Intent jobIntent = new Intent(mContext, ProfileEditActivity.class);
				jobIntent.putExtra("type", "career");
				jobIntent.putExtra("userInfo", currentEditUser);
				startActivityForResult(jobIntent, REQUEST_CODE_EDIT);
				break;
			case R.id.titleRightButton:
				// 完成
				String nick = profile_edit_nick.getText().toString();
				String companySchool = profile_edit_company.getText().toString();
				// 发送请求更新数据
				if (Util.isBlankString(nick) || nick.length() < 1 || nick.length() > 14) {
					// 昵称判断
					ToastUtil.showToast(mContext, "昵称为1-14个字");
				} else {
					HashMap<String, String> param = new HashMap<String, String>();
					// 判断昵称是否需要修改，昵称不等才修改
					param.put("nick", nick);
					// 如果填写公司名称了，更新名称
					if (currentEditUser.career == J_Consts.SCHOOL_CAREER_ID && !currentEditUser.school.equals(companySchool)) {
						// 学生-学校
						param.put("school", companySchool);
					} else if (currentEditUser.career != J_Consts.SCHOOL_CAREER_ID
							&& !currentEditUser.company.equals(companySchool)) {
						// 其他职业-公司
						param.put("company_name", companySchool);
					}
					// 情感状态
					param.put("marriage", currentEditUser.marriage + "");
					// 地区
					param.put("live_location", currentEditUser.location + "");
					param.put("live_sublocation", currentEditUser.subLocation + "");
					// 常驻
					param.put("address", currentEditUser.address);
					// 生日
					if (currentEditUser.birthYear > 0 && currentEditUser.birthMonth > 0 && currentEditUser.birthDay > 0) {
						String birthday = currentEditUser.birthYear + "-" + currentEditUser.birthMonth + "-"
								+ currentEditUser.birthDay;
						param.put("birthday", birthday);
					}
					// 身高
					param.put("height", currentEditUser.height + "");
					// 体重
					param.put("weight", currentEditUser.weight + "");
					// 职业
					param.put("career", currentEditUser.career + "");
					if (param.size() > 0) {
						updateUserInfo(param);
					} else {
						finish();
					}
				}
				break;
			case R.id.profile_edit_avatar:
				// 上传头像
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
			default:
				break;
			}
		}
	};

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
		switch (requestCode) {
		case REQUEST_CODE_EDIT:
			// 编辑资料
			if (resultCode == RESULT_CODE_EDIT) {
				currentEditUser = (LoginUser) intent.getSerializableExtra("userInfo");
				setContent();
			}
			break;
		case UploadPhotoDataAccess.REQUEST_ASK_CAMERA:// 拍照
			// 从拍照intent返回
			if (resultCode == -1) {
				// 获取原图地址
				String file_path_camera = J_FileManager.getInstance().getFileStore()
						.getFileSdcardAndRamPath(upload.getCacheName());
				// 跳转裁剪
				startPhotoZoomForAvatar(file_path_camera);
			}
			break;
		case UploadPhotoDataAccess.REQUEST_ASK_GALLERY:// 图库
			// 此处是通过upload对象打开相册时，选择图片后返回处理
			if (intent != null) {
				try {
					Uri uri = intent.getData();
					long fileSize = getContentResolver().openInputStream(uri).available();
					if (fileSize < 2 * 1024) {
						ToastUtil.showToast(mContext, "图片尺寸不能小于2k");
					} else if (fileSize > 5 * 1024 * 1024) {
						ToastUtil.showToast(mContext, "图片尺寸不能大于5M");
					} else if (fileSize <= Util.getAvailaleSize()) {
						// 创建要裁剪的图片文件
						InputStream is = getContentResolver().openInputStream(uri);
						File file_path = upload.copyBitmapToTempFile(is);
						// 获取要裁剪的图片path
						String file_path_gallery = file_path.getAbsolutePath();
						// 跳转裁剪
						startPhotoZoomForAvatar(file_path_gallery);
					} else {
						// 内存不够
						ToastUtil.showToast(mContext, getString(R.string.str_memory_not_enough));
					}
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			break;
		case REQUEST_CODE_CUT:// 裁剪结束后图片处理106
			if (resultCode == 500) {
				ToastUtil.showToast(mContext, getString(R.string.str_photo_small_error));
				return;
			}
			// 从裁剪intent返回
			if (resultCode == -1 && intent != null) {
				// 对返回的图片进行处理
				cutAvatarPath = intent.getStringExtra("avatarPath");
				avatarPath = intent.getStringExtra("path");
				// 上传更新头像
				uploadAvatar(cutAvatarPath);
			}
			break;
		case REQUEST_CODE_ERROR:
			// 图片有问题
			ToastUtil.showToast(mContext, getString(R.string.str_photo_small_error));
			break;
		default:
			break;
		}
	}

	/**
	 * 跳转至照片裁剪
	 * 
	 * */
	public void startPhotoZoomForAvatar(String path) {
		Intent intent = new Intent(this, ClipPhoto.class);
		intent.putExtra("path", path);
		intent.putExtra("isAvatar", true);
		startActivityForResult(intent, REQUEST_CODE_CUT);
	}

	/**
	 * 上传头像
	 * 
	 * 
	 */
	public void uploadAvatar(String avatarPicPath) {
		try {
			if (!Util.isBlankString(avatarPicPath)) {
				// 执行上传操作
				showLoading("上传中...");
				HashMap<String, String> params = new HashMap<String, String>();
				params.put("uid", currentEditUser.uid + "");
				File file = new File(avatarPicPath);
				if (file.exists()) {
					J_NetManager.getInstance().uploadWithXUtils(NetConstans.UPLOAD_USER_AVATAR_URL, params, avatarPicPath,
							new OnLoadingListener() {
								@Override
								public void startLoading() {
								}

								@Override
								public void onfinishLoading(String result) {
									try {
										JSONObject json = new JSONObject(result);
										int retcode = json.optInt("retcode");
										String retmean = json.optString("retmean");
										if (retcode == 1) {
											JSONObject datas = json.optJSONObject("data");
											String avatar150 = datas.optString("pic150");
											String avatar200 = datas.optString("pic200");
											String avatar600 = datas.optString("pic600");
											LoginUser user = SharedPreUtil.getLoginInfo();
											user.avatarUrl = avatar150;
											user.avatarUrl150 = avatar150;
											user.avatarUrl200 = avatar200;
											user.avatarUrl600 = avatar600;
											SharedPreUtil.saveLoginInfo(user);
											setContent();
											// 头像上传成功后，再上传生活照
											uploadPhoto(avatarPath);
										} else {
											ToastUtil.showToast(mContext, "头像更新失败:" + retmean);
										}
									} catch (Exception e) {
										e.printStackTrace();
									}
									dismissLoading();
								}

								@Override
								public void onLoading(long total, long current, boolean isUploading) {
								}

								@Override
								public void onError() {
									ToastUtil.showToast(mContext, "头像保存失败");
									dismissLoading();
								}
							});
				} else {
					DLog.d("likai-test", "头像文件不存在");
				}
			} else {
				DLog.d("likai-test", "头像图片地址为空");
			}
		} catch (Exception e) {
			ToastUtil.showToast(this, getString(R.string.str_upload_photo_fail));
			e.printStackTrace();
		}
	}

	/**
	 * @Title: uploadPhoto
	 * @Description: 上传生活照
	 * @param @param pathName
	 * @return void
	 * @throws Exception
	 * @throws
	 * @date 2014-2-7
	 */
	public void uploadPhoto(String pathName) {
		try {
			if (!Util.isBlankString(pathName)) {
				// 执行上传操作
				File file = new File(pathName);
				if (file.exists()) {
					HashMap<String, String> param = new HashMap<String, String>();
					param.put("uid", SharedPreUtil.getLoginInfo().uid + "");
					J_NetManager.getInstance().uploadFile(NetConstans.UPLOAD_PHOTO_URL, param, pathName, new OnLoadingListener() {
						@Override
						public void startLoading() {
						}

						@Override
						public void onfinishLoading(String result) {
							dismissLoading();
						}

						@Override
						public void onLoading(long total, long current, boolean isUploading) {
						}

						@Override
						public void onError() {
							dismissLoading();
						}
					});
				} else {
					DLog.d("likai-test", "上传文件不存在");
				}
			} else {
				DLog.d("likai-test", "图片地址为空");
			}
		} catch (Exception e) {
			ToastUtil.showToast(this, getString(R.string.str_upload_photo_fail));
			e.printStackTrace();
		}
	}

	/**
	 * 发送请求更新用户信息
	 * 
	 * @Title: updateUserInfo
	 * @return void 返回类型
	 * @param @param key
	 * @param @param value 参数类型
	 * @author likai
	 * @throws
	 */
	private void updateUserInfo(HashMap<String, String> params) {
		showLoading("信息更新中...");
		// 更新用户信息
		new UpdateUserInfoRequest(new J_OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					// 重新获取用户信息
					new GetUserInfoRequest(new OnDataBack() {
						@Override
						public void onResponse(Object result) {
							J_Response response = (J_Response) result;
							if (response.retcode == 1) {
								ToastUtil.showToast(mContext, "保存成功");
								finish();
							} else {
								dismissLoading();
							}
						}

						@Override
						public void onError(HashMap<String, Object> errorMap) {
							finish();
						}
					}).execute(SharedPreUtil.getLoginInfo().uid + "");
				} else {
					dismissLoading();
					ToastUtil.showToast(mContext, "保存失败:" + response.retmean);
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				ToastUtil.showToast(mContext, "保存失败");
				finish();
			}
		}).execute(params);
	}

}
