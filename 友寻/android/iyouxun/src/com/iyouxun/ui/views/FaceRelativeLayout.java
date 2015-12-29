package com.iyouxun.ui.views;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Handler;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.iyouxun.R;
import com.iyouxun.ui.adapter.FaceAdapter;
import com.iyouxun.utils.Util;

/**
 * 
 ****************************************** 
 * @文件名称 : FaceRelativeLayout.java
 * @文件描述 : 带表情的自定义输入框
 ****************************************** 
 * 
 */
public class FaceRelativeLayout extends RelativeLayout implements OnItemClickListener, OnClickListener, TextWatcher {

	private final Context context;

	/** 表情页的监听事件 */
	private OnCorpusSelectedListener mListener;

	/** 显示表情页的viewpager */
	private ViewPager face_box;

	/** 表情页界面集合 */
	private ArrayList<View> pageViews;

	/** 游标显示布局 */
	private LinearLayout face_view_index;

	/** 游标点集合 */
	private ArrayList<ImageView> pointViews;

	/** 表情集合 */
	private List<List<ChatEmoji>> emojis;

	/** 表情区域 */
	private View view;

	/** 输入框 */
	private EditText input_msg_text;

	/** 动态表情输入框 */
	private EditText input_msg_text_hide;

	/** 表情数据填充器 */
	private List<FaceAdapter> faceAdapters;

	/** 当前表情页 */
	private int current = 0;

	/** 提交按钮 */
	private Button btn_send_face;

	/** 图片选择框 */
	private ImageButton btn_select_img;

	/** 表情打开按钮 **/
	private ImageButton btn_select_face;

	/** 声音、键盘切换按钮 **/
	private ImageButton btn_voice_keyboard;

	/** 语音状态 */
	private Button btn_chat_voice;

	/** 最后点击时间 */
	private long lastClickTm = 0;

	/** 表情是否可点击 */
	private boolean isFaceCanClick = true;

	/** 最多可以输入表情的数量 */
	private final int totalInputNum = 35;
	/** 图片上传提示框 **/
	private View face_layout_choose_img_box;
	/** 表情选择按钮切换tab **/
	// private LinearLayout ll_facebutton;
	// private Button buttonDefault;// 默认表情
	private Button buttonEmoji;// emoji表情
	// private Button buttonCartoon;// 动态表情
	// private ImageButton buttonDel;// 删除键

	protected String currButtonType = "face";// 当前显示状态
	protected int currentType = 2;// 当前表情所属的类型
	protected int columnsNum = 7;// 表情显示列数表情1:6列，表情2：7列，表情3:4列

	protected boolean isCartoonFaceIn = false;// 标记本次输入中是否有动态表情

	/** 1:普通输入文字状态，2:语音状态 */
	protected int chatType = 1;

	public FaceRelativeLayout(Context context) {
		super(context);
		this.context = context;
	}

	/**
	 * 加载该组件，会首先加载该方法
	 * 
	 * @param context
	 * @param attrs
	 */
	public FaceRelativeLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.context = context;
		if (isInEditMode()) {
			return;
		}
		// 获取表情图片信息1:默认 2:emoji 3:动态
		FaceConversionUtil.getInstace().getFileText(context, currentType);
	}

	public void setOnCorpusSelectedListener(OnCorpusSelectedListener listener) {
		mListener = listener;
	}

	/**
	 * 表情选择监听
	 */
	public interface OnCorpusSelectedListener {
		void onCorpusSelected(ChatEmoji emoji);

		void onCorpusDeleted();
	}

	@Override
	protected void onFinishInflate() {
		super.onFinishInflate();
		emojis = FaceConversionUtil.getInstace().emojiLists;
		onCreate();
	}

	/**
	 * 创建内容
	 * 
	 * */
	private void onCreate() {
		Init_View();// 初始化界面元素
		Init_viewPager();// 设置viewpage的数据
		Init_Point();// 初始化游标
		Init_Data();// 填充数据
	}

	/**
	 * 重建内容
	 * 
	 * */
	private void reCreate() {
		FaceConversionUtil.getInstace().getFileText(context, currentType);
		current = 0;
		emojis = FaceConversionUtil.getInstace().emojiLists;

		Init_viewPager();// 设置viewpage的数据
		Init_Point();// 初始化游标
		Init_Data();// 填充数据

		setFaceButtonStatus(currentType);// 重置按钮状态
	}

	/**
	 * 隐藏表情选择框,恢复为初始状态
	 * 
	 */
	public boolean hideFaceView() {
		btn_select_face.setPressed(false);
		// 隐藏表情选择框
		Util.hideKeyboard(context, input_msg_text);
		face_layout_choose_img_box.setVisibility(View.GONE);
		if (view.getVisibility() == View.VISIBLE) {
			view.setVisibility(View.GONE);
			return true;
		}
		return false;
	}

	/**
	 * 初始化控件
	 */
	private void Init_View() {
		face_box = (ViewPager) findViewById(R.id.face_box);
		input_msg_text_hide = (EditText) findViewById(R.id.input_msg_text_hide);
		face_view_index = (LinearLayout) findViewById(R.id.face_view_index);
		btn_send_face = (Button) findViewById(R.id.btn_send_face);
		btn_select_img = (ImageButton) findViewById(R.id.btn_select_img);
		btn_voice_keyboard = (ImageButton) findViewById(R.id.btn_voice_keyboard);
		btn_select_face = (ImageButton) findViewById(R.id.btn_select_face);
		view = findViewById(R.id.face_layout_face_box);
		// ll_facebutton = (LinearLayout) findViewById(R.id.ll_facebutton);
		// buttonDefault = (Button) findViewById(R.id.face_button_default);
		buttonEmoji = (Button) findViewById(R.id.btn_choose_emoji);
		// buttonCartoon = (Button) findViewById(R.id.face_button_cartoon);
		// buttonDel = (ImageButton) findViewById(R.id.face_button_del);

		input_msg_text = (MyEditText) findViewById(R.id.input_msg_text);
		btn_chat_voice = (Button) findViewById(R.id.btn_chat_voice);
		face_layout_choose_img_box = findViewById(R.id.face_layout_choose_img_box);
		input_msg_text.setHorizontallyScrolling(false);
		// 设置按钮的禁用、可用状态
		btn_send_face.setEnabled(false);
		input_msg_text.addTextChangedListener(this);

		input_msg_text.setOnClickListener(this);
		btn_voice_keyboard.setOnClickListener(this);
		btn_select_face.setOnClickListener(this);
		btn_send_face.setOnClickListener(this);
		// buttonDefault.setOnClickListener(this);
		buttonEmoji.setOnClickListener(this);
		btn_select_img.setOnClickListener(this);
		// buttonCartoon.setOnClickListener(this);
		// buttonDel.setOnClickListener(this);

		setFaceButtonStatus(currentType);// 默认状态为选中“默认表情”
		updateInputTextHeight();
		input_msg_text.setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				face_layout_choose_img_box.setVisibility(View.GONE);
				return false;
			}
		});
	}

	/**
	 * @Title: showImageBox
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 * @date 2014-6-30 下午1:24:32
	 */
	public void showImageBox() {
		chatType = 1;
		// 从语音状态切换为普通状态
		btn_voice_keyboard.setImageResource(R.drawable.icn_chat_voice);
		btn_chat_voice.setVisibility(View.GONE);
		input_msg_text.setVisibility(View.VISIBLE);
		if (face_layout_choose_img_box.getVisibility() == View.VISIBLE) {
			face_layout_choose_img_box.setVisibility(View.GONE);
		} else {
			// 隐藏键盘
			Util.hideKeyboard(context, input_msg_text);
			// 隐藏表情框
			hideFaceView();
			// 显示图片上传选择框
			face_layout_choose_img_box.setVisibility(View.VISIBLE);
		}
	}

	/**
	 * 设置表情按钮选择状态
	 * 
	 * */
	public void setFaceButtonStatus(int type) {
		face_view_index.setVisibility(View.GONE);
		// buttonDefault.setEnabled(true);
		buttonEmoji.setEnabled(true);
		// buttonCartoon.setEnabled(true);
		switch (type) {
		case 1:// 默认
			face_view_index.setVisibility(View.VISIBLE);
			// buttonDefault.setEnabled(false);
			break;
		case 2:// emoji
			face_view_index.setVisibility(View.VISIBLE);
			buttonEmoji.setEnabled(false);
			break;
		case 3:// 动态
			face_view_index.setVisibility(View.VISIBLE);
			// buttonCartoon.setEnabled(false);
			break;
		default:
			break;
		}
	}

	/**
	 * 初始化显示表情的viewpager
	 */
	private void Init_viewPager() {
		pageViews = new ArrayList<View>();
		// 左侧添加空页
		View nullView1 = new View(context);
		// 设置透明背景
		nullView1.setBackgroundColor(Color.TRANSPARENT);
		pageViews.add(nullView1);
		// 中间添加表情页
		faceAdapters = new ArrayList<FaceAdapter>();
		for (int i = 0; i < emojis.size(); i++) {
			GridView view = new GridView(context);
			FaceAdapter adapter = new FaceAdapter(context, emojis.get(i), currentType);// 获取表情内容
			view.setAdapter(adapter);
			faceAdapters.add(adapter);
			view.setOnItemClickListener(this);
			view.setNumColumns(columnsNum);// 设置列数默认8
			view.setBackgroundColor(Color.TRANSPARENT);
			view.setHorizontalSpacing(0);
			view.setVerticalSpacing(0);
			view.setStretchMode(GridView.STRETCH_COLUMN_WIDTH);
			view.setCacheColorHint(0);
			if (currentType == 2) {
				view.setPadding(0, 10, 0, 0);
			}
			view.setSelector(new ColorDrawable(Color.TRANSPARENT));
			view.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
			view.setGravity(Gravity.CENTER);
			pageViews.add(view);
		}
		// 右侧添加空页面
		View nullView2 = new View(context);
		// 设置透明背景
		nullView2.setBackgroundColor(Color.TRANSPARENT);
		pageViews.add(nullView2);
	}

	/**
	 * 初始化游标
	 */
	private void Init_Point() {
		pointViews = new ArrayList<ImageView>();
		ImageView imageView;
		face_view_index.removeAllViews();
		for (int i = 0; i < pageViews.size(); i++) {
			imageView = new ImageView(context);
			imageView.setBackgroundResource(R.drawable.page);
			LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(new ViewGroup.LayoutParams(
					LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
			layoutParams.leftMargin = 0;
			layoutParams.rightMargin = getResources().getDimensionPixelSize(R.dimen.global_px18dp);
			layoutParams.width = getResources().getDimensionPixelSize(R.dimen.global_px8dp);
			layoutParams.height = getResources().getDimensionPixelSize(R.dimen.global_px8dp);
			face_view_index.addView(imageView, layoutParams);
			if (i == 0 || i == pageViews.size() - 1) {
				imageView.setVisibility(View.GONE);
			}
			if (i == 1) {
				imageView.setBackgroundResource(R.drawable.page_now);
			}
			pointViews.add(imageView);
		}
	}

	/**
	 * 填充数据
	 */
	private void Init_Data() {
		face_box.setAdapter(new ViewPagerAdapter(pageViews));

		face_box.setCurrentItem(1);
		current = 0;
		face_box.setOnPageChangeListener(new OnPageChangeListener() {
			@Override
			public void onPageSelected(int arg0) {
				current = arg0 - 1;
				// 描绘分页点
				draw_Point(arg0);
				// 如果是第一屏或者是最后一屏禁止滑动，其实这里实现的是如果滑动的是第一屏则跳转至第二屏，如果是最后一屏则跳转到倒数第二屏.
				if (arg0 == pointViews.size() - 1 || arg0 == 0) {
					if (arg0 == 0) {
						face_box.setCurrentItem(arg0 + 1);// 第二屏 会再次实现该回调方法实现跳转.
						pointViews.get(1).setBackgroundResource(R.drawable.page_now);
					} else {
						face_box.setCurrentItem(arg0 - 1);// 倒数第二屏
						pointViews.get(arg0 - 1).setBackgroundResource(R.drawable.page_now);
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
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_voice_keyboard:
			// 隐藏上传图片选择框
			if (face_layout_choose_img_box.getVisibility() == View.VISIBLE) {
				face_layout_choose_img_box.setVisibility(View.GONE);
			}
			// 声音、键盘切换按钮
			if (chatType == 1) {
				chatType = 2;
				// 从普通状态切换为语音状态
				btn_voice_keyboard.setImageResource(R.drawable.icn_chat_keyboard);
				input_msg_text.setVisibility(View.GONE);
				btn_chat_voice.setVisibility(View.VISIBLE);
				if (view.getVisibility() == View.VISIBLE) {
					// 如果表情框显示中，则隐藏
					view.setVisibility(View.GONE);
					btn_select_face.setPressed(false);
				}
				Util.hideKeyboard(context, input_msg_text);// 隐藏键盘
			} else if (chatType == 2) {
				chatType = 1;
				// 从语音状态切换为普通状态
				btn_voice_keyboard.setImageResource(R.drawable.icn_chat_voice);
				btn_chat_voice.setVisibility(View.GONE);
				input_msg_text.setVisibility(View.VISIBLE);
				// 显示键盘
				Util.showKeybord(context, input_msg_text);
			}
			break;
		case R.id.btn_select_face:
			// 隐藏上传图片选择框
			if (face_layout_choose_img_box.getVisibility() == View.VISIBLE) {
				face_layout_choose_img_box.setVisibility(View.GONE);
			}
			btn_chat_voice.setVisibility(View.GONE);
			input_msg_text.setVisibility(View.VISIBLE);
			chatType = 1;
			btn_voice_keyboard.setImageResource(R.drawable.icn_chat_voice);
			Util.hideKeyboard(context, input_msg_text);// 隐藏键盘
			if (view.getVisibility() != View.VISIBLE) {
				// 切换状态为表情输入状态
				// 显示表情区域
				new Handler().postDelayed(new Runnable() {
					@Override
					public void run() {
						input_msg_text.requestFocus();
						view.setVisibility(View.VISIBLE);
						btn_select_face.setPressed(true);
					}
				}, 100);
			} else if (view.getVisibility() == View.VISIBLE) {
				// 表情选择框已经显示，则隐藏
				view.setVisibility(View.GONE);
				btn_select_face.setPressed(false);
			}
			break;
		case R.id.input_msg_text:// 输入框
		case R.id.btn_setting_msg:// 发送按钮
			// 隐藏表情选择框
			if (view.getVisibility() == View.VISIBLE) {
				view.setVisibility(View.GONE);
				btn_select_face.setPressed(false);
			}
			if (face_layout_choose_img_box.getVisibility() == View.VISIBLE) {
				face_layout_choose_img_box.setVisibility(View.GONE);
			}
			break;
		// case R.id.face_button_default:// 默认表情
		// currentType = 1;// 属于哪一类表情
		// columnsNum = 6;// 显示多少列
		// reCreate();
		// break;
		case R.id.btn_choose_emoji:// emoji表情
			currentType = 2;// 属于哪一类表情
			columnsNum = 7;// 显示多少列
			reCreate();
			break;
		// case R.id.face_button_cartoon:// 动态表情
		// currentType = 3;// 属于哪一类表情
		// columnsNum = 4;// 显示多少列
		// reCreate();
		// break;
		case R.id.btn_select_img:// 显示选择图片框
			showImageBox();
			break;
		}
	}

	/**
	 * 绘制游标背景
	 */
	public void draw_Point(int index) {
		for (int i = 1; i < pointViews.size(); i++) {
			if (index == i) {
				pointViews.get(i).setBackgroundResource(R.drawable.page_now);
			} else {
				pointViews.get(i).setBackgroundResource(R.drawable.page);
			}
		}
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		ChatEmoji emoji = (ChatEmoji) faceAdapters.get(current).getItem(arg2);
		if (!TextUtils.isEmpty(emoji.getCharacter())) {
			if (mListener != null) {
				mListener.onCorpusSelected(emoji);
			}
			// 动画表情的处理
			if (emoji.getFaceType() == 3) {
				long currTm = System.currentTimeMillis();
				if (currTm - lastClickTm < 1500) {// 两次表情的点击选择时间小于1.5秒
					return;
				} else {
					lastClickTm = currTm;
					isCartoonFaceIn = true;
					// 如果当前选中的表情为动态表情，需要先取出输入框中的信息，仅发送该表情后，重新填充该信息
					input_msg_text_hide.append(emoji.getCharacter());
				}
			} else {
				if (emoji.getCharacter().equals("[#删除]")) {
					int selection = input_msg_text.getSelectionStart();
					String text = input_msg_text.getText().toString();
					if (selection > 0) {
						String text2 = text.substring(selection - 1);
						if ("]".equals(text2)) {
							int start = text.lastIndexOf("[");
							int end = selection;
							input_msg_text.getText().delete(start, end);
							return;
						}
						input_msg_text.getText().delete(selection - 1, selection);
					}
				} else {
					// 判断当前表情是否可点
					if (!isFaceCanClick) {
						return;
					}
					String inputString = input_msg_text.getText() + emoji.getCharacter();
					if (inputString.length() <= 1000) {
						// 输入框赋值
						input_msg_text.append(emoji.getCharacter());
					}
				}
			}
		}
	}

	/**
	 * 获取当前表情页面的显示状态
	 * 
	 * */
	public boolean getFaceLayerShowStatus() {
		boolean isShown = false;
		if (view.getVisibility() == View.VISIBLE || face_layout_choose_img_box.getVisibility() == View.VISIBLE) {
			isShown = true;
		}
		return isShown;
	}

	/**
	 * 获取本地输入中是否有动态表情的状态
	 * */
	public boolean getCartoonFaceInStatus() {
		return isCartoonFaceIn;
	}

	/**
	 * 设置输入动态表情的状态
	 * 
	 * */
	public void setCartoonFaceInStatus(boolean status) {
		this.isCartoonFaceIn = status;
		input_msg_text_hide.setText("");
	}

	/**
	 * 隐藏动态表情按钮
	 * 
	 * */
	public void hideCartoonFace() {
		// buttonCartoon.setVisibility(View.GONE);
	}

	/**
	 * 设置表情可输入状态
	 * 
	 * */
	public void setFaceIfCanInput(boolean isCanInput) {
		isFaceCanClick = isCanInput;
	}

	@Override
	public void beforeTextChanged(CharSequence s, int start, int count, int after) {
	}

	@Override
	public void onTextChanged(CharSequence s, int start, int before, int count) {
		// 输入框内容有变化
		String inputTxt = input_msg_text.getText().toString().trim();
		if (inputTxt.length() > 0) {
			// 输入内容后
			btn_send_face.setEnabled(true);

			// 计算表情数量，超过50个，不能再点击输入
			int totalNum = FaceConversionUtil.getInstace().getFaceNumFromContent(context, inputTxt);
			if (totalNum >= totalInputNum) {
				isFaceCanClick = false;// 设置为表情不可点击
			} else {
				isFaceCanClick = true;
			}
		} else {
			btn_send_face.setEnabled(false);

			isFaceCanClick = true;
		}
		updateInputTextHeight();
	}

	@Override
	public void afterTextChanged(Editable s) {
	}

	/**
	 * @Title: updateInputTextHeight
	 * @Description: 动态设置输入框的高度
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void updateInputTextHeight() {
		new Handler().post(new Runnable() {

			@Override
			public void run() {
				int lines = input_msg_text.getLineCount();
				if (lines > 5) {
					lines = 5;
				}
				int height = context.getResources().getDimensionPixelSize(R.dimen.inputbox_input_min_hight);
				if (lines == 3) {
					height = context.getResources().getDimensionPixelSize(R.dimen.inputbox_input_middle_hight);
				} else if (lines == 5) {
					height = context.getResources().getDimensionPixelSize(R.dimen.inputbox_input_max_hight);
				} else if (lines == 2) {
					height = context.getResources().getDimensionPixelSize(R.dimen.inputbox_input_middle_hight2);
				} else if (lines == 4) {
					height = context.getResources().getDimensionPixelSize(R.dimen.inputbox_input_middle_hight4);
				}
				input_msg_text.setHeight(height);
			}
		});
	}
}
