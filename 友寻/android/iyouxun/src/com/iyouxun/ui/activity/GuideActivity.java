package com.iyouxun.ui.activity;

import java.util.ArrayList;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.ui.activity.login.LoginActivity;
import com.iyouxun.ui.activity.register.RegisterActivity;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.Util;

/**
 * @Description: 引导页
 * @author donglizhi
 * @date 2015年3月3日 上午11:33:14
 * 
 */
public class GuideActivity extends BaseActivity {
	private ViewPager mViewPager;
	private ImageView mPage0, mPage1, mPage2, mPage3;// 声明导航图片对象
	private int currIndex = 0;// 当前页面

	private LinearLayout dotBox;// 提示点框
	private ImageButton guideBtnLogin;// 登录按钮
	private ImageButton guideBtnRegister;// 注册按钮
	private LinearLayout guide_btn_box;// 按钮模块

	protected ArrayList<View> allViews = new ArrayList<View>();

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_guide);

		// 获取当前手机的dpi，（240遮挡一半）
		double dpi = Util.getScreenDensityDpi(mContext);
		DLog.d("likai-test", "当前手机dpi:" + dpi);
		dotBox = (LinearLayout) findViewById(R.id.dotBox);

		// 设置小圆点部分的显示位置
		android.widget.FrameLayout.LayoutParams dotParams = new android.widget.FrameLayout.LayoutParams(
				android.widget.FrameLayout.LayoutParams.WRAP_CONTENT, android.widget.FrameLayout.LayoutParams.WRAP_CONTENT);
		dotParams.gravity = Gravity.CENTER_HORIZONTAL | Gravity.BOTTOM;
		if (dpi > 240) {
			dotParams.bottomMargin = getResources().getDimensionPixelSize(R.dimen.global_px160dp);
		} else if (dpi > 160) {
			dotParams.bottomMargin = getResources().getDimensionPixelSize(R.dimen.global_px100dp);
		} else {
			dotParams.bottomMargin = getResources().getDimensionPixelSize(R.dimen.global_px100dp);
		}
		dotBox.setLayoutParams(dotParams);

		// 需要显示的3张引导图
		View view = View.inflate(mContext, R.layout.guidenew_view, null);
		ImageView iv = (ImageView) view.findViewById(R.id.guide_image);
		iv.setImageResource(R.drawable.guide_img1);
		allViews.add(view);
		View view2 = View.inflate(mContext, R.layout.guidenew_view, null);
		ImageView iv2 = (ImageView) view2.findViewById(R.id.guide_image);
		iv2.setImageResource(R.drawable.guide_img2);
		allViews.add(view2);
		View view3 = View.inflate(mContext, R.layout.guidenew_view, null);
		ImageView iv3 = (ImageView) view3.findViewById(R.id.guide_image);
		iv3.setImageResource(R.drawable.guide_img3);
		allViews.add(view3);
		View view4 = View.inflate(mContext, R.layout.guidenew_view, null);
		ImageView iv4 = (ImageView) view4.findViewById(R.id.guide_image);
		guide_btn_box = (LinearLayout) view4.findViewById(R.id.guide_btn_box);
		guideBtnLogin = (ImageButton) view4.findViewById(R.id.guide_btn_login);
		guideBtnRegister = (ImageButton) view4.findViewById(R.id.guide_btn_register);
		guide_btn_box.setVisibility(View.VISIBLE);
		iv4.setImageResource(R.drawable.guide_img4);
		LayoutParams params = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		params.addRule(RelativeLayout.CENTER_HORIZONTAL, RelativeLayout.TRUE);
		params.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM, RelativeLayout.TRUE);
		if (dpi > 240) {
			params.bottomMargin = getResources().getDimensionPixelSize(R.dimen.global_px280dp);
		} else if (dpi > 160) {
			params.bottomMargin = getResources().getDimensionPixelSize(R.dimen.global_px200dp);
		} else {
			params.bottomMargin = getResources().getDimensionPixelSize(R.dimen.global_px200dp);
		}
		guide_btn_box.setLayoutParams(params);
		allViews.add(view4);

		// 设置按钮选项
		mPage0 = (ImageView) findViewById(R.id.page0);// 四个小黑点
		mPage1 = (ImageView) findViewById(R.id.page1);// 四个小黑点
		mPage2 = (ImageView) findViewById(R.id.page2);// 四个小黑点
		mPage3 = (ImageView) findViewById(R.id.page3);// 四个小黑点

		mViewPager = (ViewPager) findViewById(R.id.vpMain);// viewpager
		mViewPager.setOnPageChangeListener(new MyOnPageChangeListener());
		mViewPager.setAdapter(myViewPagerAdapter);

		guideBtnLogin.setOnClickListener(listener);
		guideBtnRegister.setOnClickListener(listener);
	}

	protected PagerAdapter myViewPagerAdapter = new PagerAdapter() {
		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == arg1;
		}

		@Override
		public int getItemPosition(Object object) {
			return POSITION_NONE;
		}

		@Override
		public int getCount() {
			return allViews.size();
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			container.removeView((View) object);
		}

		@Override
		public Object instantiateItem(ViewGroup container, int position) {
			View view = allViews.get(position);

			((ViewPager) container).addView(view);
			return view;
		}
	};

	protected class MyOnPageChangeListener implements OnPageChangeListener {
		@Override
		public void onPageSelected(int arg0) {// 参数arg0为选中的View
			Animation animation = null;// 声明动画对象
			switch (arg0) {
			case 0: // 页面一
				// 进入第一个导航页面，小圆点为选中状态，下一个页面的小圆点是未选中状态。
				mPage0.setImageDrawable(getResources().getDrawable(R.drawable.page_now1));
				mPage1.setImageDrawable(getResources().getDrawable(R.drawable.page));
				if (currIndex == arg0 + 1) {
					// 圆点移动效果动画，从当前View移动到下一个View
					animation = new TranslateAnimation(arg0 + 1, arg0, 0, 0);
				}
				break;
			case 1: // 页面二
				mPage1.setImageDrawable(getResources().getDrawable(R.drawable.page_now2));// 当前View
				mPage0.setImageDrawable(getResources().getDrawable(R.drawable.page));// 上一个View
				mPage2.setImageDrawable(getResources().getDrawable(R.drawable.page));// 下一个View
				if (currIndex == arg0 - 1) {// 如果滑动到上一个View
					// 圆点移动效果动画，从当前View移动到下一个View
					animation = new TranslateAnimation(arg0 - 1, arg0, 0, 0);
				} else if (currIndex == arg0 + 1) {
					// 圆点移动效果动画，从当前View移动到下一个View，下同。
					animation = new TranslateAnimation(arg0 + 1, arg0, 0, 0);
				}
				break;
			case 2: // 页面三
				mPage2.setImageDrawable(getResources().getDrawable(R.drawable.page_now3));// 当前View
				mPage1.setImageDrawable(getResources().getDrawable(R.drawable.page));// 上一个View
				mPage3.setImageDrawable(getResources().getDrawable(R.drawable.page));// 下一个View
				if (currIndex == arg0 - 1) {// 如果滑动到上一个View
					// 圆点移动效果动画，从当前View移动到下一个View
					animation = new TranslateAnimation(arg0 - 1, arg0, 0, 0);
				} else if (currIndex == arg0 + 1) {
					// 圆点移动效果动画，从当前View移动到下一个View，下同。
					animation = new TranslateAnimation(arg0 + 1, arg0, 0, 0);
				}
				break;
			case 3:// 页面四
				mPage3.setImageDrawable(getResources().getDrawable(R.drawable.page_now4));
				mPage2.setImageDrawable(getResources().getDrawable(R.drawable.page));
				if (currIndex == arg0 - 1) {
					animation = new TranslateAnimation(arg0 - 1, arg0, 0, 0);
				}
				break;
			}
			currIndex = arg0;// 设置当前View
			animation.setFillAfter(true);// True:设置图片停在动画结束位置
			animation.setDuration(300);// 设置动画持续时间
		}

		@Override
		public void onPageScrollStateChanged(int arg0) {
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
			// arg0 :当前页面，及你点击滑动的页面
			// arg1:当前页面偏移的百分比
			// arg2:当前页面偏移的像素位置
			// 当前数组中显示的图片的序列
		}
	}

	/**
	 * 返回键的返回事件处理
	 * 
	 * */

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			Intent intent = new Intent(Intent.ACTION_MAIN);
			intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			intent.addCategory(Intent.CATEGORY_HOME);
			startActivity(intent);
			return true;
		} else {
			return super.onKeyDown(keyCode, event);
		}
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.guide_btn_login:
				// 登录
				Intent loginIntent = new Intent(mContext, LoginActivity.class);
				startActivity(loginIntent);
				break;
			case R.id.guide_btn_register:
				// 注册
				Intent registerIntent = new Intent(mContext, RegisterActivity.class);
				startActivity(registerIntent);
				break;
			default:
				break;
			}
		}
	};
}
