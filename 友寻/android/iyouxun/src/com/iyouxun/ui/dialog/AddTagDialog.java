package com.iyouxun.ui.dialog;

import java.util.ArrayList;
import java.util.Collections;

import org.json.JSONObject;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.TagsInfoBean;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.views.MyEditText;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

public class AddTagDialog extends Dialog {
	private Button btnOk;// 确定按钮
	private MyEditText inputTag;// 标签输入框
	private ImageView btnClose;// 关闭按钮
	private LinearLayout tagLayout;// 标签区域
	private final Context mContext;
	private ArrayList<TagsInfoBean> recommendTagsData;// 推荐的标签数据
	private final int SHOW_SIZE = 6;// 每次展示4个推荐标签
	private String toUid = "";// 添加标签的人
	private DialogUtils.DialogCallBack callBack;// 回调接口
	private ArrayList<TagsInfoBean> existTagsData;// 已经存在的标签数据

	public AddTagDialog(Context context) {
		super(context);
		mContext = context;
	}

	public AddTagDialog(Context context, boolean cancelable, OnCancelListener cancelListener) {
		super(context, cancelable, cancelListener);
		mContext = context;
	}

	public AddTagDialog(Context context, int theme) {
		super(context, theme);
		mContext = context;
	}

	/**
	 * Title: Description:
	 * 
	 * @param context
	 * @param theme
	 * @param uid 添加标签对象的uid
	 * @param recommendTagsData 推荐的标签数据
	 * @param existTagsData 已有标签的数据
	 */
	public AddTagDialog(Context context, int theme, String uid, ArrayList<TagsInfoBean> recommendTagsData,
			ArrayList<TagsInfoBean> existTagsData) {
		super(context, theme);
		mContext = context;
		this.toUid = uid;
		this.recommendTagsData = recommendTagsData;
		this.existTagsData = existTagsData;
	}

	public AddTagDialog setCallBack(DialogUtils.DialogCallBack callBack) {
		this.callBack = callBack;
		return this;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_add_tag);
		// 设置显示位置
		Window window = getWindow();

		WindowManager.LayoutParams params = window.getAttributes();
		params.width = Util.getScreenWidth(mContext);
		params.height = WindowManager.LayoutParams.WRAP_CONTENT;
		window.setAttributes(params);
		window.setGravity(Gravity.BOTTOM);
		window.setWindowAnimations(R.style.AnimBottom); // 设置窗口弹出动画

		btnOk = (Button) findViewById(R.id.add_tag_ok_btn);
		btnClose = (ImageView) findViewById(R.id.add_tag_btn_close);
		inputTag = (MyEditText) findViewById(R.id.add_tag_input_tag);
		tagLayout = (LinearLayout) findViewById(R.id.add_tag_recommend);
		btnClose.setOnClickListener(listener);
		btnOk.setOnClickListener(listener);
		setCanceledOnTouchOutside(true);

		inputTag.addTextChangedListener(textWatcher);
		for (TagsInfoBean tagsInfoBean : existTagsData) {// 去除已经存在的标签数据
			for (int i = 0; i < recommendTagsData.size(); i++) {
				if (tagsInfoBean.name.equals(recommendTagsData.get(i).name)) {
					recommendTagsData.remove(i);
				}
			}
		}
		if (recommendTagsData.size() > 0) {
			Collections.shuffle(recommendTagsData);
			refeshTag();
		} else {
			tagLayout.setVisibility(View.GONE);
		}
	}

	private final TextWatcher textWatcher = new TextWatcher() {
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
				String limitSubstring = StringUtils.getLimitSubstring(temp, 20);
				if (!TextUtils.isEmpty(limitSubstring)) {
					if (!limitSubstring.equals(temp)) {
						inputTag.setText(limitSubstring);
						inputTag.setSelection(limitSubstring.length());
					}
				}
			}
		}
	};
	private final J_OnViewClickListener listener = new J_OnViewClickListener() {

		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.add_tag_ok_btn:// 手动添加标签按钮
				String tagName = inputTag.getText().toString().trim();
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.addNewTag(mContext, toUid, tagName, mHandler);
				break;
			case R.id.add_tag_btn_close:// 关闭按钮
				dismiss();
				break;
			case R.id.item_tag_add:// 添加按钮
				int index = (Integer) v.getTag();
				String tag = recommendTagsData.get(index).name;
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.addNewTag(mContext, toUid, tag, mHandler);
				break;
			}
		}
	};
	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_ADD_TAG:// 添加标签
				DialogUtils.dismissDialog();
				// 标签添加成功
				J_Response response = (J_Response) msg.obj;
				if (response.retcode == 1) {
					inputTag.setText("");
					try {
						if (response.data.equals("-1")) {
							ToastUtil.showToast(mContext, "添加失败：标签已经存在");
						} else {
							ToastUtil.showToast(mContext, "添加成功");
							JSONObject data = new JSONObject(response.data);
							String tid = data.optString("tid");
							String title = data.optString("title");

							TagsInfoBean bean = new TagsInfoBean();
							bean.tid = tid;
							bean.name = title;
							callBack.onCallBack(R.id.add_tag_dialog, bean);
							for (int i = 0; i < recommendTagsData.size(); i++) {
								if (bean.name.equals(recommendTagsData.get(i).name)) {
									recommendTagsData.remove(i);
								}
							}
							if (recommendTagsData.size() <= 0) {
								dismiss();
							}
							// 刷新标签列表
							refeshTag();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else if (response.retcode == -2) {
					ToastUtil.showToast(mContext, "标签添加失败：包含敏感词！");
				} else {
					ToastUtil.showToast(mContext, "标签添加失败");
				}
				break;

			default:
				break;
			}
		};
	};

	/**
	 * @Title: refeshTag
	 * @Description: 刷新标签内容
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void refeshTag() {
		int showTagSize = recommendTagsData.size() <= SHOW_SIZE ? recommendTagsData.size() : SHOW_SIZE;
		if (showTagSize >= 0) {
			tagLayout.removeAllViews();
			View view[] = new View[showTagSize];
			for (int i = 0; i < showTagSize; i++) {
				View item = View.inflate(mContext, R.layout.item_tag_add_layer, null);
				TextView tag = (TextView) item.findViewById(R.id.item_tag_name);
				ImageView add = (ImageView) item.findViewById(R.id.item_tag_add);
				tag.setText(recommendTagsData.get(i).name);
				add.setTag(i);
				view[i] = item;
				add.setOnClickListener(listener);
			}
			if (view.length > 0 && view[0] != null && view[0] instanceof View) {
				Util.populateText(tagLayout, view, mContext,
						mContext.getResources().getDimensionPixelSize(R.dimen.add_tag_dialog_tag_margin), true);
			} else {
				tagLayout.setVisibility(View.GONE);
			}
		}
	}
}
