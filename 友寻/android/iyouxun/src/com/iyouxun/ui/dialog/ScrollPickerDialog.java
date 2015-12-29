package com.iyouxun.ui.dialog;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import android.app.Dialog;
import android.content.Context;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.ui.views.ArrayWheelAdapter;
import com.iyouxun.ui.views.OnWheelChangedListener;
import com.iyouxun.ui.views.WheelView;
import com.iyouxun.utils.Util;
import com.iyouxun.utils.WorkLocation;

public class ScrollPickerDialog extends Dialog {
	/** 返回用户的选择 */
	private List<String> resultData = null;

	private Context mContext;
	private Resources mRes;

	/** 显示标题控件 */
	private TextView title_tv;

	/** 单选选择控件 */
	private WheelView wv_single;
	/** 选择年份控件 */
	private WheelView year_wv;
	/** 选择月份控件 */
	private WheelView month_wv;
	/** 选择日期控件 */
	private WheelView day_wv;

	/** 选择省份控件 */
	private WheelView province_wv;
	/** 选择城市控件 */
	private WheelView city_wv;

	/** 标记选择性别 */
	public final static int TYPE_SEX = 0X10;
	/** 标记选择生日(年月日) */
	public final static int TYPE_BIRTHDAY = 0X11;
	/** 标记选择城市 */
	public final static int TYPE_CITY = 0X12;
	/** 选择身高 */
	public final static int TYPE_HEIGHT = 0X13;
	/** 体重 */
	public final static int TYPE_WEIGHT = 0X14;
	/** 职业 */
	public final static int TYPE_CAREER = 0X15;
	/** 位置 */
	public final static int TYPE_LOCATION = 0X16;

	/** 标识哪种选择控件 */
	private int choose_type = TYPE_SEX;

	private int mBirthdayYear = 0;
	private int mBirthdayMonth = 12;
	private int mBirthdayDay = 31;
	/** 传入的默认值年 */
	private String mDefaultYear = "2000";
	/** 传入的默认值月 */
	private String mDefaultMonth = "01";
	/** 传入的默认值日 */
	private String mDefaultDay = "01";
	private String defaultPid;
	private String defaultCid;

	/** 生日 */
	private String[] showYear = null;
	private String[] showDay = null;
	private final String[] showMonth = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" };
	/** 性别 */
	private String[] sexs = null;
	/** 身高 */
	private String[] heights = null;
	/** 体重 */
	private String[] weights = null;
	/** 职业 */
	private String[] careers = null;

	private String[] defaultStrs;
	// 选择回调方法
	private OnChooseListener mOnChooseListener;

	public interface OnChooseListener {
		void onChoose(List<String> data);
	}

	public ScrollPickerDialog setOnChooseListener(OnChooseListener listener) {
		this.mOnChooseListener = listener;
		return this;
	}

	public ScrollPickerDialog setDefault(String... args) {
		this.defaultStrs = args;
		return this;
	}

	public ScrollPickerDialog(Context context, int theme, int type) {
		super(context, theme);
		mContext = context;
		mRes = context.getResources();
		choose_type = type;
	}

	private ScrollPickerDialog(Context context) {
		super(context);
	}

	private ScrollPickerDialog(Context context, int theme) {
		super(context, theme);
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_scroll_picker);

		// 点击外部不关闭
		// setCanceledOnTouchOutside(false);

		// 设置显示位置
		Window window = getWindow();
		WindowManager.LayoutParams params = window.getAttributes();
		params.width = Util.getScreenWidth(mContext);
		params.height = WindowManager.LayoutParams.WRAP_CONTENT;
		window.setAttributes(params);
		window.setGravity(Gravity.BOTTOM);// 显示在底部
		window.setWindowAnimations(R.style.AnimBottom); // 设置窗口弹出动画

		initViews();
	}

	private final J_OnViewClickListener confirmListener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			resultData = new ArrayList<String>();

			switch (choose_type) {
			case TYPE_SEX:
				// 性别序列从0开始
				resultData.add(wv_single.getCurrentItem() + "");
				break;
			case TYPE_CITY:
				// 省份城市返回正常id
				int pIndex = province_wv.getCurrentItem();
				int cIndex = city_wv.getCurrentItem();
				// 通过所在序列，获取id和对应的名称
				String pName = WorkLocation.getLocationNameWithIndex(pIndex); // 获取省份名称
				String pId = WorkLocation.getLocationCodeWithIndex(pIndex); // 获取省份id
				String cName = WorkLocation.getSubLocationNameWithIndex(pIndex, cIndex, false);
				String cId = WorkLocation.getSubLocationCodeWithIndex(pIndex, cIndex);

				resultData.add(pName);
				resultData.add(pId);
				resultData.add(cName);
				resultData.add(cId);
				break;
			case TYPE_BIRTHDAY:
				// 生日返回正常数值
				String year = showYear[year_wv.getCurrentItem()];
				String month = showMonth[month_wv.getCurrentItem()];
				String day = showDay[day_wv.getCurrentItem()];

				resultData.add(year);
				resultData.add(month);
				resultData.add(day);
				break;
			case TYPE_HEIGHT:
				// 身高序列从1开始
				int heightIndex = wv_single.getCurrentItem() + 1;
				resultData.add(heightIndex + "");
				break;
			case TYPE_WEIGHT:
				// 体重序列从1开始
				int weightIndex = wv_single.getCurrentItem() + 1;
				resultData.add(weightIndex + "");
				break;
			case TYPE_CAREER:
				// 职业序列从1开始
				int careerIndex = wv_single.getCurrentItem() + 1;
				resultData.add(careerIndex + "");
				break;
			}

			if (mOnChooseListener != null) {
				mOnChooseListener.onChoose(resultData);
			}
			dismiss();
		}
	};

	private final View.OnClickListener cancelListener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			ScrollPickerDialog.this.dismiss();
		}
	};

	private void initViews() {
		findViewById(R.id.dsp_btn_confirm).setOnClickListener(confirmListener);
		findViewById(R.id.dsp_btn_cancel).setOnClickListener(cancelListener);

		title_tv = (TextView) findViewById(R.id.spd_tv_title);

		int titleRes = R.string.choose_sex;
		switch (choose_type) {
		case TYPE_SEX:
			showSexView();
			break;

		case TYPE_BIRTHDAY:
			titleRes = R.string.choose_birthday;
			showYearMonthDayView();
			break;

		case TYPE_CITY:
			titleRes = R.string.choose_city;
			showAddressView();
			break;
		case TYPE_HEIGHT:
			titleRes = R.string.choose_height;
			showHeightView();
			break;
		case TYPE_WEIGHT:
			titleRes = R.string.choose_weight;
			showWeightView();
			break;
		case TYPE_CAREER:
			titleRes = R.string.choose_career;
			showCareerView();
			break;
		}
		title_tv.setText(titleRes);
	}

	/** 显示地址选择框 */
	private void showAddressView() {
		province_wv = (WheelView) findViewById(R.id.wv_province);
		city_wv = (WheelView) findViewById(R.id.wv_city);
		province_wv.setVisibility(View.VISIBLE);
		city_wv.setVisibility(View.VISIBLE);

		String provinces[] = mRes.getStringArray(R.array.work_location_array); // 获取省份列表内容
		province_wv.setVisibleItems(3); // 设置可见状态的item的数量
		// provinceView.toSetTextSize(30);// 设置字体大小
		province_wv.setCyclic(true); // 列表是否循环展示
		province_wv.setAdapter(new ArrayWheelAdapter<String>(provinces));

		city_wv.setVisibleItems(3); // 设置可见状态的item的数量

		if (defaultStrs != null && defaultStrs.length == 2) {
			defaultPid = defaultStrs[0];
			defaultCid = defaultStrs[1];
		}

		// 获取城市信息
		int[] ids = getSecondaryLocIds(provinces.length);
		final String[][] cities = getSecondaryArrays(ids);

		int tempPidIndex = 0;
		if (defaultPid != null && Util.getInteger(defaultPid) > 0) {
			tempPidIndex = WorkLocation.getLocationIndexWithCode(defaultPid);
		}

		int tempCidIndex = 0;
		if (defaultCid != null && Util.getInteger(defaultCid) > 0) {
			tempCidIndex = WorkLocation.getSubLocationIndexWithCode(tempPidIndex, defaultCid);
		}
		// 监听change事件
		province_wv.addChangingListener(new OnWheelChangedListener() {
			@Override
			public void onChanged(WheelView wheel, int oldValue, int newValue) {
				city_wv.setAdapter(new ArrayWheelAdapter<String>(cities[newValue]));
				city_wv.setCurrentItem(0);
			}
		});

		// 初始化省份、城市的默认显示状态
		province_wv.setCurrentItem(tempPidIndex);
		city_wv.setAdapter(new ArrayWheelAdapter<String>(cities[tempPidIndex]));
		city_wv.setCurrentItem(tempCidIndex);
	}

	/** 显示性别选择框 */
	private void showSexView() {
		wv_single = (WheelView) findViewById(R.id.wv_single);
		wv_single.setVisibility(View.VISIBLE);

		sexs = mRes.getStringArray(R.array.profile_sex_array);

		int cur = 0;
		if (defaultStrs != null && defaultStrs.length == 1) {
			cur = Util.getInteger(defaultStrs[0]);
		}

		wv_single.setVisibleItems(3);
		wv_single.setCyclic(false);
		wv_single.setAdapter(new ArrayWheelAdapter<String>(sexs));
		wv_single.setCurrentItem(cur);
	}

	/** 显示年月日选择框 */
	private void showYearMonthDayView() {
		year_wv = (WheelView) findViewById(R.id.wv_year);
		month_wv = (WheelView) findViewById(R.id.wv_month);
		day_wv = (WheelView) findViewById(R.id.wv_day);

		year_wv.setVisibility(View.VISIBLE);
		month_wv.setVisibility(View.VISIBLE);
		day_wv.setVisibility(View.VISIBLE);

		if (defaultStrs != null && defaultStrs.length == 3) {
			mDefaultYear = defaultStrs[0];
			mDefaultMonth = defaultStrs[1];
			mDefaultDay = defaultStrs[2];
		}

		// 年份设置
		Calendar d = Calendar.getInstance(Locale.CHINA);
		Date myDate = new Date();
		d.setTime(myDate);
		int nowYear = d.get(Calendar.YEAR);
		int maxYear = nowYear - 18;
		int minYear = nowYear - 99;
		showYear = new String[maxYear - minYear + 1];
		int j = 0;
		int defaultYear = 76;
		for (int i = minYear; i <= maxYear; i++) {
			showYear[j] = String.valueOf(i);
			if (i == Integer.parseInt(mDefaultYear) && Integer.parseInt(mDefaultYear) != 0) {
				defaultYear = j;
			}
			j++;
		}
		year_wv.setVisibleItems(3); // 设置可见的item数量
		year_wv.setCyclic(true);
		year_wv.setAdapter(new ArrayWheelAdapter<String>(showYear));
		year_wv.setCurrentItem(defaultYear);// 设置年份初始值
		// month设置
		int defaultMonth = 0;
		for (int i = 1; i <= 12; i++) {
			if (i == Integer.parseInt(mDefaultMonth)) {
				defaultMonth = i - 1;
			}
		}
		month_wv.setVisibleItems(3);
		month_wv.setCyclic(true);
		month_wv.setAdapter(new ArrayWheelAdapter<String>(showMonth));
		month_wv.setCurrentItem(defaultMonth);// 设置月份初始值
		// day设置
		int defaultDay = 0;
		showDay = new String[mBirthdayDay];
		for (int i = 1; i <= mBirthdayDay; i++) {
			showDay[i - 1] = String.valueOf(i);
			if (i == Integer.parseInt(mDefaultDay)) {
				defaultDay = i - 1;
			}
		}
		day_wv.setVisibleItems(3);
		day_wv.setCyclic(true);
		day_wv.setAdapter(new ArrayWheelAdapter<String>(showDay));
		day_wv.setCurrentItem(defaultDay);// 设置日期初始值

		// 监听年份change事件
		year_wv.addChangingListener(new OnWheelChangedListener() {
			@Override
			public void onChanged(WheelView wheel, int oldValue, int newValue) {
				// monthView.setAdapter(new
				// ArrayWheelAdapter<String>(showMonth));
				// monthView.setCurrentItem(0);
				// 获取当前选中的年份数字
				mBirthdayYear = Integer.parseInt(showYear[year_wv.getCurrentItem()]);
			}
		});
		// 监听月份change事件
		month_wv.addChangingListener(new OnWheelChangedListener() {
			@Override
			public void onChanged(WheelView wheel, int oldValue, int newValue) {
				mBirthdayMonth = Integer.parseInt(showMonth[month_wv.getCurrentItem()]);
				int tempDay = Integer.parseInt(showDay[day_wv.getCurrentItem()]);
				// 设置2月份的天数数字
				if (mBirthdayMonth == 2) {
					mBirthdayDay = 29;
					if ((mBirthdayYear % 4 == 0 && mBirthdayYear % 100 != 0) || (mBirthdayYear % 400 == 0)) {
						//
					} else {
						if (mBirthdayDay > 28) {
							mBirthdayDay = 28;
						}
					}
				} else {
					switch (mBirthdayMonth) {
					case 1:
					case 3:
					case 5:
					case 7:
					case 8:
					case 10:
					case 12:
						mBirthdayDay = 31;
						break;
					case 4:
					case 6:
					case 9:
					case 11:
						mBirthdayDay = 30;
						break;
					default:
						break;
					}
				}
				showDay = new String[mBirthdayDay];
				for (int i = 1; i <= mBirthdayDay; i++) {
					showDay[i - 1] = String.valueOf(i);
				}
				day_wv.setAdapter(new ArrayWheelAdapter<String>(showDay));
				day_wv.setCurrentItem(tempDay - 1);
			}
		});
	}

	/**
	 * 身高选择框
	 * 
	 * @Title: showHeightView
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void showHeightView() {
		wv_single = (WheelView) findViewById(R.id.wv_single);
		wv_single.setVisibility(View.VISIBLE);

		heights = mRes.getStringArray(R.array.profile_height_array);

		int cur = 0;
		if (defaultStrs != null && defaultStrs.length == 1) {
			cur = Util.getInteger(defaultStrs[0]) - 1;
		}

		wv_single.setVisibleItems(3);
		wv_single.setCyclic(false);
		wv_single.setAdapter(new ArrayWheelAdapter<String>(heights));
		wv_single.setCurrentItem(cur);
	}

	/**
	 * 体重选择框
	 * 
	 * @Title: showWeightView
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void showWeightView() {
		wv_single = (WheelView) findViewById(R.id.wv_single);
		wv_single.setVisibility(View.VISIBLE);

		weights = mRes.getStringArray(R.array.profile_weight_array);

		int cur = 0;
		if (defaultStrs != null && defaultStrs.length == 1) {
			cur = Util.getInteger(defaultStrs[0]) - 1;
		}

		wv_single.setVisibleItems(3);
		wv_single.setCyclic(false);
		wv_single.setAdapter(new ArrayWheelAdapter<String>(weights));
		wv_single.setCurrentItem(cur);
	}

	/**
	 * 职业选择框
	 * 
	 * @Title: showCareerView
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void showCareerView() {
		wv_single = (WheelView) findViewById(R.id.wv_single);
		wv_single.setVisibility(View.VISIBLE);

		careers = mRes.getStringArray(R.array.profile_career_array);

		int cur = 0;
		if (defaultStrs != null && defaultStrs.length == 1) {
			cur = Util.getInteger(defaultStrs[0]) - 1;
		}

		wv_single.setVisibleItems(3);
		wv_single.setCyclic(false);
		wv_single.setAdapter(new ArrayWheelAdapter<String>(careers));
		wv_single.setCurrentItem(cur);
	}

	/**
	 * get city array's ids
	 * 
	 * @param count
	 * @return
	 */
	private int[] getSecondaryLocIds(int count) {
		int[] ids = new int[count];
		for (int i = 0; i < count; i++) {
			ids[i] = WorkLocation.getSubLocationNameArrayId(i);
		}
		return ids;
	}

	/**
	 * get city arrays
	 * 
	 * @param resIds
	 * @return
	 */
	private String[][] getSecondaryArrays(int[] resIds) {
		String[][] secondaryArrays;
		if (resIds.length <= 0) {
			return null;
		}
		secondaryArrays = new String[resIds.length][];
		for (int i = 0; i < resIds.length; i++) {
			secondaryArrays[i] = mRes.getStringArray(resIds[i]);
		}
		return secondaryArrays;
	}
}
