package com.iyouxun.ui.activity.center;

import java.util.ArrayList;
import java.util.List;

import android.content.Intent;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.MarriageInfoBean;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.MarriageListAdapter;
import com.iyouxun.ui.dialog.ScrollPickerDialog;
import com.iyouxun.ui.dialog.ScrollPickerDialog.OnChooseListener;
import com.iyouxun.utils.ProfileUtils;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.Util;

/**
 * 个人资料编辑页面(各项内容的单独编辑页面)
 * 
 * @ClassName: ProfileEditActivity
 * @author likai
 * @date 2015-2-28 下午4:10:51
 * 
 */
public class ProfileEditActivity extends CommTitleActivity {
	private String type;// 当前页面更改内容的类型
	private LinearLayout profile_marry_edit_box;
	private ListView profile_marry_edit_lv;
	private RelativeLayout profile_birth_edit_box;
	private TextView profile_birth_tv;
	private RelativeLayout profile_height_edit_box;
	private TextView profile_height_tv;
	private RelativeLayout profile_weight_edit_box;
	private TextView profile_weight_tv;
	private RelativeLayout profile_job_edit_box;
	private TextView profile_job_tv;
	private RelativeLayout profile_location_edit_box;
	private TextView profile_location_tv;
	private EditText profile_address_et;// 常住地编辑
	private LinearLayout profile_address_edit_box;// 常驻地

	private MarriageListAdapter adapter;
	private final ArrayList<MarriageInfoBean> datas = new ArrayList<MarriageInfoBean>();

	protected LoginUser currentUserInfo = new LoginUser();

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		type = getIntent().getStringExtra("type");
		currentUserInfo = (LoginUser) getIntent().getSerializableExtra("userInfo");
		if (type.equals("marry")) {
			// 情感
			titleCenter.setText("情感状态");
		} else if (type.equals("birth")) {
			// 生日
			titleCenter.setText("生日");
		} else if (type.equals("height")) {
			// 升高
			titleCenter.setText("身高");
		} else if (type.equals("weight")) {
			// 体重
			titleCenter.setText("体重");
		} else if (type.equals("career")) {
			// 职业
			titleCenter.setText("职业");
		} else if (type.equals("company")) {
			// 公司
			titleCenter.setText("公司");
		} else if (type.equals("school")) {
			// 学生
			titleCenter.setText("学校");
		} else if (type.equals("location")) {
			// 位置
			titleCenter.setText("地区");
		} else if (type.equals("address")) {
			// 常驻地
			titleCenter.setText("常驻");
		}

		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_profile_edit, null);
	}

	@Override
	protected void initViews() {
		profile_marry_edit_box = (LinearLayout) findViewById(R.id.profile_marry_edit_box);
		profile_marry_edit_lv = (ListView) findViewById(R.id.profile_marry_edit_lv);
		profile_birth_edit_box = (RelativeLayout) findViewById(R.id.profile_birth_edit_box);
		profile_birth_tv = (TextView) findViewById(R.id.profile_birth_tv);
		profile_height_edit_box = (RelativeLayout) findViewById(R.id.profile_height_edit_box);
		profile_height_tv = (TextView) findViewById(R.id.profile_height_tv);
		profile_weight_edit_box = (RelativeLayout) findViewById(R.id.profile_weight_edit_box);
		profile_weight_tv = (TextView) findViewById(R.id.profile_weight_tv);
		profile_job_edit_box = (RelativeLayout) findViewById(R.id.profile_job_edit_box);
		profile_job_tv = (TextView) findViewById(R.id.profile_job_tv);
		profile_location_edit_box = (RelativeLayout) findViewById(R.id.profile_location_edit_box);
		profile_location_tv = (TextView) findViewById(R.id.profile_location_tv);
		profile_address_et = (EditText) findViewById(R.id.profile_address_et);
		profile_address_edit_box = (LinearLayout) findViewById(R.id.profile_address_edit_box);

		if (type.equals("marry")) {
			// 情感状态
			profile_marry_edit_box.setVisibility(View.VISIBLE);

			String[] marriage = J_Application.context.getResources().getStringArray(R.array.profile_marriage_array);
			for (int i = 0; i < marriage.length; i++) {
				MarriageInfoBean bean = new MarriageInfoBean();
				int id = i + 1;
				bean.id = id;
				bean.name = marriage[i];
				if (currentUserInfo.marriage == id) {
					bean.status = 1;
				} else {
					bean.status = 0;
				}
				datas.add(bean);
			}

			adapter = new MarriageListAdapter(mContext);
			adapter.setData(datas);
			profile_marry_edit_lv.setAdapter(adapter);

			profile_marry_edit_lv.setOnItemClickListener(new OnItemClickListener() {
				@Override
				public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
					for (int i = 0; i < datas.size(); i++) {
						MarriageInfoBean tempBean = datas.get(i);
						if (i == position) {
							// 其他项目置为1
							tempBean.status = 1;
							// 设置选中项的id
							currentUserInfo.marriage = tempBean.id;
						} else {
							tempBean.status = 0;
						}
						datas.set(i, tempBean);
					}
					adapter.setData(datas);
					adapter.notifyDataSetChanged();
				}
			});
		} else if (type.equals("birth")) {
			profile_birth_edit_box.setVisibility(View.VISIBLE);
		} else if (type.equals("height")) {
			profile_height_edit_box.setVisibility(View.VISIBLE);
		} else if (type.equals("weight")) {
			profile_weight_edit_box.setVisibility(View.VISIBLE);
		} else if (type.equals("career")) {
			profile_job_edit_box.setVisibility(View.VISIBLE);
		} else if (type.equals("location")) {
			profile_location_edit_box.setVisibility(View.VISIBLE);
		} else if (type.equals("address")) {
			// 常驻地
			profile_address_edit_box.setVisibility(View.VISIBLE);
		}

		profile_birth_edit_box.setOnClickListener(listener);
		profile_height_edit_box.setOnClickListener(listener);
		profile_weight_edit_box.setOnClickListener(listener);
		profile_job_edit_box.setOnClickListener(listener);
		profile_location_edit_box.setOnClickListener(listener);

		// 设置页面内容
		setContent();
	}

	/**
	 * 设置页面显示内容
	 * 
	 * @Title: setContent
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContent() {
		// 星座、生肖
		if (currentUserInfo.star > 0 && currentUserInfo.birthYear > 0) {
			profile_birth_tv.setText(ProfileUtils.getStar(currentUserInfo.star) + ","
					+ ProfileUtils.getBirthPet(currentUserInfo.birthpet));
		} else {
			profile_birth_tv.setText("请选择生日");
		}
		// 身高
		String height = ProfileUtils.getHeight(currentUserInfo.height);
		if (Util.isBlankString(height)) {
			height = "请选择身高";
		}
		profile_height_tv.setText(height);
		// 体重
		String weight = ProfileUtils.getWeight(currentUserInfo.weight);
		if (Util.isBlankString(weight)) {
			weight = "请选择体重";
		}
		profile_weight_tv.setText(weight);
		// 职业
		if (currentUserInfo.career > 0) {
			profile_job_tv.setText(ProfileUtils.getCareer(currentUserInfo.career));
		} else {
			profile_job_tv.setText("请选择职业");
		}
		// 位置
		if (!Util.isBlankString(currentUserInfo.locationName) && !Util.isBlankString(currentUserInfo.subLocationName)) {
			profile_location_tv.setText(currentUserInfo.locationName + " " + currentUserInfo.subLocationName);
		} else {
			profile_location_tv.setText("请选择所在地区");
		}
		// 常驻
		if (!Util.isBlankString(currentUserInfo.address)) {
			profile_address_et.setText(currentUserInfo.address);
		}

		// 常驻地最多输入20个汉字
		profile_address_et.addTextChangedListener(new TextWatcher() {
			private String temp;

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				temp = s.toString().trim();
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
				if (!TextUtils.isEmpty(temp)) {
					String limitSubstring = StringUtils.getLimitSubstring(temp, 40);
					if (!TextUtils.isEmpty(limitSubstring)) {
						if (!limitSubstring.equals(temp)) {
							profile_address_et.setText(limitSubstring);
							profile_address_et.setSelection(limitSubstring.length());
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
				// 返回保存
				setResultInfo();
				break;
			case R.id.profile_birth_edit_box:
				// 选择生日
				new ScrollPickerDialog(mContext, R.style.dialog, ScrollPickerDialog.TYPE_BIRTHDAY)
						.setOnChooseListener(new OnChooseListener() {
							@Override
							public void onChoose(List<String> data) {
								currentUserInfo.birthYear = Util.getInteger(data.get(0));
								currentUserInfo.birthMonth = Util.getInteger(data.get(1));
								currentUserInfo.birthDay = Util.getInteger(data.get(2));
								// 通过选择项转换到对应code进行保存
								String birthpet = ProfileUtils.computeBirthpet(currentUserInfo.birthYear,
										currentUserInfo.birthMonth, currentUserInfo.birthDay);
								currentUserInfo.birthpet = ProfileUtils.getBirthPetCodeFromName(birthpet);
								String star = ProfileUtils.computeStar(currentUserInfo.birthMonth, currentUserInfo.birthDay);
								currentUserInfo.star = ProfileUtils.getStarCodeFromStarName(star);
								// 更新页面显示
								setContent();
							}
						})
						.setDefault(currentUserInfo.birthYear + "", currentUserInfo.birthMonth + "",
								currentUserInfo.birthDay + "").show();
				break;
			case R.id.profile_height_edit_box:
				// 选择身高
				new ScrollPickerDialog(mContext, R.style.dialog, ScrollPickerDialog.TYPE_HEIGHT)
						.setOnChooseListener(new OnChooseListener() {
							@Override
							public void onChoose(List<String> data) {
								currentUserInfo.height = Util.getInteger(data.get(0));
								setContent();
							}
						}).setDefault(currentUserInfo.height + "").show();
				break;
			case R.id.profile_weight_edit_box:
				// 选择体重
				new ScrollPickerDialog(mContext, R.style.dialog, ScrollPickerDialog.TYPE_WEIGHT)
						.setOnChooseListener(new OnChooseListener() {
							@Override
							public void onChoose(List<String> data) {
								currentUserInfo.weight = Util.getInteger(data.get(0));
								setContent();
							}
						}).setDefault(currentUserInfo.weight + "").show();
				break;
			case R.id.profile_job_edit_box:
				// 选择职业
				new ScrollPickerDialog(mContext, R.style.dialog, ScrollPickerDialog.TYPE_CAREER)
						.setOnChooseListener(new OnChooseListener() {
							@Override
							public void onChoose(List<String> data) {
								currentUserInfo.career = Util.getInteger(data.get(0));
								setContent();
							}
						}).setDefault(currentUserInfo.career + "").show();
				break;
			case R.id.profile_location_edit_box:
				// 选择位置
				new ScrollPickerDialog(mContext, R.style.dialog, ScrollPickerDialog.TYPE_CITY)
						.setOnChooseListener(new OnChooseListener() {
							@Override
							public void onChoose(List<String> data) {
								currentUserInfo.locationName = data.get(0);
								currentUserInfo.location = Util.getInteger(data.get(1));
								currentUserInfo.subLocationName = data.get(2);
								currentUserInfo.subLocation = Util.getInteger(data.get(3));
								setContent();
							}
						}).setDefault(currentUserInfo.location + "", currentUserInfo.subLocation + "").show();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 捕获用户按键（菜单键和返回键）
	 * 
	 * */
	@Override
	public boolean dispatchKeyEvent(KeyEvent event) {
		if (event.getKeyCode() == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0 && event.getAction() != KeyEvent.ACTION_UP) {
			setResultInfo();
			return true;
		}
		return super.dispatchKeyEvent(event);
	}

	/**
	 * 返回值
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setResultInfo() {
		if (type.equals("address")) {
			// 常驻地
			currentUserInfo.address = profile_address_et.getText().toString().trim();
			// 隐藏键盘
			Util.hideKeyboard(mContext, profile_address_et);
		}

		Intent backIntent = new Intent();
		backIntent.putExtra("type", type);
		backIntent.putExtra("userInfo", currentUserInfo);
		setResult(ProfileDetailEditActivity.RESULT_CODE_EDIT, backIntent);
		finish();
	}
}
