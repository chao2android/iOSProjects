package com.iyouxun.ui.activity.find;

import java.util.ArrayList;
import java.util.Collections;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.comparator.TagListComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.TagsInfoBean;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.dialog.AddTagDialog;
import com.iyouxun.ui.dialog.EditTextDialog;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.DialogCallBack;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: NotJoinUserActivity
 * @Description: 未加入用户的个人主页
 * @author donglizhi
 * @date 2015年6月29日 下午3:50:56
 * 
 */
public class NotJoinUserActivity extends CommTitleActivity {
	private TextView userNick;// 用户昵称
	private TextView userCode;// 用户号码
	private Button btnInvite;// 邀请按钮
	private String nick;// 昵称
	private String code;// 手机号或者微博openid
	private LinearLayout tagLayout;// 标签区域
	private String currentUid;// 当前用户id
	// 标签数据
	private final ArrayList<TagsInfoBean> tagsData = new ArrayList<TagsInfoBean>();
	// 标签视图数组
	private View[] textViews;
	/** 推荐标签数组 */
	private final ArrayList<TagsInfoBean> recommendTagsData = new ArrayList<TagsInfoBean>();
	/** 默认的标签数量 */
	private int defaultTagNum;
	/** 是否首次加载本页 */
	private boolean isFirstLoad = true;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_not_join_user, null);
	}

	@Override
	protected void initViews() {
		userNick = (TextView) findViewById(R.id.not_join_nick);
		userCode = (TextView) findViewById(R.id.not_join_number);
		btnInvite = (Button) findViewById(R.id.not_join_invite_btn);
		tagLayout = (LinearLayout) findViewById(R.id.not_join_tags);
		tagLayout.setOnClickListener(listener);
		btnInvite.setOnClickListener(listener);
		if (getIntent().hasExtra(UtilRequest.FORM_NICK)) {
			nick = getIntent().getStringExtra(UtilRequest.FORM_NICK);
		}
		if (getIntent().hasExtra(UtilRequest.FORM_CODE)) {
			code = getIntent().getStringExtra(UtilRequest.FORM_CODE);
		}
		if (getIntent().hasExtra(UtilRequest.FORM_UID)) {
			currentUid = getIntent().getStringExtra(UtilRequest.FORM_UID);
		}
		if (!Util.isBlankString(nick) && !Util.isBlankString(code) && !Util.isBlankString(currentUid)) {
			String showNick = "";
			showNick = "手机联系人：" + nick;
			String showCode = "手机号：" + code;
			userCode.setText(showCode);
			userCode.setVisibility(View.VISIBLE);
			userNick.setText(showNick);
		} else {
			ToastUtil.showToast(mContext, "数据异常，请稍后再试！");
			finish();
		}
		refreshTags();
		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		UtilRequest.getAlternativeTagList(mContext, mHandler);
		UtilRequest.getTagsList(mContext, currentUid, mHandler);
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_ALTERNATIVE_TAG_LIST:// 推荐标签
				J_Response response = (J_Response) msg.obj;
				if (response.retcode == 1) {
					try {
						JSONArray array = new JSONArray(response.data);
						// 清空原数据，更新为新数据
						recommendTagsData.clear();
						for (int i = 0; i < array.length(); i++) {
							JSONObject tag = array.getJSONObject(i);
							TagsInfoBean bean = new TagsInfoBean();
							bean.tid = tag.optString("tid");
							bean.name = tag.optString("title");
							bean.clickNum = tag.optInt("bind");
							bean.isClicked = tag.optInt("oper");
							bean.isSelected = 1;// 默认为选中状态
							recommendTagsData.add(bean);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				break;
			case NetTaskIDs.TASKID_TAG_LIST:
				// 获取标签列表
				DialogUtils.dismissDialog();
				J_Response response2 = (J_Response) msg.obj;
				if (response2.retcode == 1) {
					try {
						JSONArray array = new JSONArray(response2.data);
						// 清空原数据，更新为新数据
						tagsData.clear();
						for (int i = 0; i < array.length(); i++) {
							JSONObject tag = array.getJSONObject(i);
							TagsInfoBean bean = new TagsInfoBean();
							bean.tid = tag.optString("tid");
							bean.name = tag.optString("title");
							bean.clickNum = tag.optInt("bind");
							bean.isClicked = tag.optInt("oper");
							bean.updateTime = tag.optLong("ctime") * 1000;
							tagsData.add(bean);
						}
						if (isFirstLoad) {
							defaultTagNum = tagsData.size();
							isFirstLoad = false;
						}
						// 刷新列表
						refreshTags();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				break;
			case NetTaskIDs.TASKID_TAG_CLICK:
				// 点击标签
				J_Response response3 = (J_Response) msg.obj;
				if (response3.retcode == 1) {
					try {
						JSONObject data = new JSONObject(response3.data);
						String tid = data.optString("tid");
						for (int i = 0; i < tagsData.size(); i++) {
							TagsInfoBean bean = tagsData.get(i);
							if (bean.tid.equals(tid)) {
								bean.clickNum = data.optInt("bind");
								bean.isClicked = data.optInt("oper");
								bean.updateTime = System.currentTimeMillis();
								tagsData.set(i, bean);
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				// 刷新标签列表
				refreshTags();
				break;
			default:
				break;
			}
		};
	};

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 返回按钮
				finish();
				break;
			case R.id.item_tag_add:// 添加标签
				if (defaultTagNum <= 3) {
					AddTagDialog dialog = new AddTagDialog(mContext, R.style.dialog, currentUid, recommendTagsData, tagsData);
					dialog.setCallBack(new DialogCallBack() {

						@Override
						public void onCallBack(int id, Object object) {
							switch (id) {
							case R.id.add_tag_dialog:// 添加标签的返回
								TagsInfoBean bean = (TagsInfoBean) object;
								tagsData.add(bean);
								refreshTags();
								break;

							default:
								break;
							}
						}
					});
					dialog.show();
				} else {
					new EditTextDialog(mContext, R.style.dialog).setType(1).setCallBack(new OnSelectCallBack() {
						@Override
						public void onCallBack(String value1, String value2, String value3) {
							if (value1.equals("1")) {
								// 确定
								UtilRequest.addNewTag(mContext, currentUid + "", value2, mHandler);
							}
						}
					}).show();
				}
				break;
			case R.id.not_join_invite_btn:// 邀请按钮
				Util.sendSMS(code, mContext);
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 
	 * @Title: refreshTags
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void refreshTags() {
		// 移除当前标签容器中的所有标签，重新刷新添加
		textViews = new View[tagsData.size() + 1];
		Collections.sort(tagsData, new TagListComparator());
		for (int i = 0; i < tagsData.size(); i++) {
			final TagsInfoBean bean = tagsData.get(i);

			View tagView = View.inflate(mContext, R.layout.item_tag_layer, null);
			LinearLayout item_tag_box = (LinearLayout) tagView.findViewById(R.id.item_tag_box);
			TextView item_tag_click_num = (TextView) tagView.findViewById(R.id.item_tag_click_num);
			TextView item_tag_name = (TextView) tagView.findViewById(R.id.item_tag_name);
			// 点击次数
			item_tag_click_num.setText(bean.clickNum + "");
			// 标签名字
			item_tag_name.setText(bean.name);
			item_tag_name.setSingleLine(true);
			if (bean.isClicked == 1) {
				// 禁用状态
				item_tag_box.setBackgroundResource(R.drawable.bg_tag_disabled);
				if (bean.clickNum <= 0) {
					item_tag_click_num.setVisibility(View.GONE);
				} else {
					item_tag_click_num.setBackgroundResource(R.drawable.bg_tag_num_disabled);
				}
			} else if (bean.clickNum >= 5) {
				// 热门标签
				item_tag_box.setBackgroundResource(R.drawable.bg_tag_hot);
				item_tag_click_num.setBackgroundResource(R.drawable.bg_tag_num_hot);
			} else if (bean.clickNum <= 0) {
				// 没有点击数字，普通标签，隐藏数字内容
				item_tag_box.setBackgroundResource(R.drawable.bg_tag_normal);
				item_tag_click_num.setVisibility(View.GONE);
			} else {
				// 普通标签
				item_tag_box.setBackgroundResource(R.drawable.bg_tag_normal);
				item_tag_click_num.setBackgroundResource(R.drawable.bg_tag_num_normal);
			}
			// 设置点击状态
			// 好友（1度，2度）或者是用户本人才可以点击
			tagView.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					UtilRequest.clickTag(mContext, currentUid + "", bean.tid, mHandler);
				}
			});
			textViews[i] = tagView;
		}
		View item = View.inflate(mContext, R.layout.item_tag_add_layer, null);
		TextView tag = (TextView) item.findViewById(R.id.item_tag_name);
		ImageView add = (ImageView) item.findViewById(R.id.item_tag_add);
		add.setOnClickListener(listener);
		tag.setText("加标签");
		textViews[tagsData.size() + 1] = item;
		// 添加标签到页面，并获得标签的总行数
		if (textViews.length > 0 && textViews[0] != null && textViews[0] instanceof View) {
			Util.populateText(tagLayout, textViews, mContext, getResources().getDimensionPixelSize(R.dimen.global_px30dp), true);
		} else {
			tagLayout.removeAllViews();
			tagLayout.addView(item);
		}
	}
}
