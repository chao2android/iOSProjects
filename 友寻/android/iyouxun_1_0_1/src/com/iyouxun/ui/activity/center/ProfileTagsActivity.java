package com.iyouxun.ui.activity.center;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.TagsInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.dialog.EditTextDialog;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 标签管理页面
 * 
 * @ClassName: ProfileTagsActivity
 * @author likai
 * @date 2015-2-28 下午2:36:40
 * 
 */
public class ProfileTagsActivity extends CommTitleActivity {
	private LinearLayout profile_tags_box;
	private TextView profile_tags_add_button;
	private TextView profile_tags_info;

	// 标签数据
	private final ArrayList<TagsInfoBean> tagsData = new ArrayList<TagsInfoBean>();
	// 标签视图数组
	private View[] textViews;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("标签");
		titleLeftButton.setText("返回");
		titleLeftButton.setOnClickListener(listener);
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_profile_tags, null);
	}

	@Override
	protected void initViews() {
		profile_tags_box = (LinearLayout) findViewById(R.id.profile_tags_box);
		profile_tags_add_button = (TextView) findViewById(R.id.profile_tags_add_button);
		profile_tags_info = (TextView) findViewById(R.id.profile_tags_info);

		profile_tags_add_button.setOnClickListener(listener);

		// 获取标签列表
		getTagsList();
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_DEL_TAG:
				// 删除标签
				finish();
				break;
			case NetTaskIDs.TASKID_ADD_TAG:
				// 添加成功
				J_Response response = (J_Response) msg.obj;
				if (response.retcode == 1) {
					ToastUtil.showToast(mContext, "添加成功");
					try {
						if (response.data.equals("-1")) {
							ToastUtil.showToast(mContext, "添加失败：标签已经存在");
						} else {
							JSONObject data = new JSONObject(response.data);

							TagsInfoBean bean = new TagsInfoBean();
							bean.tid = data.optString("tid");
							bean.name = data.optString("title");
							bean.isClicked = data.optInt("oper");
							bean.isSelected = 1;// 默认为选中状态
							tagsData.add(bean);
							// 刷新标签列表
							refreshTags();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else if (response.retcode == -2) {
					ToastUtil.showToast(mContext, "添加失败：包含敏感词！");
				} else {
					ToastUtil.showToast(mContext, "添加失败");
				}
				break;
			case NetTaskIDs.TASKID_TAG_LIST:
				// 获取标签列表
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
							bean.isSelected = 1;// 默认为选中状态
							tagsData.add(bean);
						}
						// 刷新列表
						refreshTags();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				dismissLoading();
				break;

			default:
				break;
			}
		}
	};

	/**
	 * 获取标签列表
	 * 
	 * @Title: getTagsList
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getTagsList() {
		showLoading("加载中...");
		UtilRequest.getTagsList(mContext, J_Cache.sLoginUser.uid + "", mHandler);
	}

	/**
	 * 刷新标签列表
	 * 
	 * @Title: refreshTags
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void refreshTags() {
		// 移除当前标签容器中的所有标签，重新刷新添加
		if (tagsData.size() > 0) {
			profile_tags_box.removeAllViews();
			textViews = new View[tagsData.size()];
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
				if (bean.isSelected == 0) {
					// 未选中状态
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
				tagView.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						setTagStatus(bean);
					}
				});

				textViews[i] = tagView;
			}
			if (textViews.length > 0 && textViews[0] != null) {
				Util.populateText(profile_tags_box, textViews, mContext,
						getResources().getDimensionPixelSize(R.dimen.global_px30dp), true);
			}
		}
		int totalSelectTags = 0;
		// 设置选中数量
		for (int i = 0; i < tagsData.size(); i++) {
			TagsInfoBean bean = tagsData.get(i);
			if (bean.isSelected == 1) {
				// 选中
				totalSelectTags++;
			}
		}
		profile_tags_info.setText("已选" + totalSelectTags + "个标签");
	}

	/**
	 * 设置标签选中状态
	 * 
	 * @Title: setTagStatus
	 * @return void 返回类型
	 * @param @param bean 参数类型
	 * @author likai
	 * @throws
	 */
	private void setTagStatus(TagsInfoBean bean) {
		for (int i = 0; i < tagsData.size(); i++) {
			TagsInfoBean tmpBean = tagsData.get(i);
			if (tmpBean.tid.equals(bean.tid)) {
				if (tmpBean.isSelected == 0) {
					tmpBean.isSelected = 1;
				} else {
					tmpBean.isSelected = 0;
				}
				tagsData.set(i, tmpBean);
			}
		}
		refreshTags();
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				// 返回检查编辑状态
				StringBuilder sb = new StringBuilder();
				for (int i = 0; i < tagsData.size(); i++) {
					TagsInfoBean bean = tagsData.get(i);
					if (bean.isSelected == 0) {
						if (sb.length() > 0) {
							sb.append(",");
						}
						sb.append(bean.tid);
					}
				}
				if (sb.length() > 0) {
					showLoading();
					UtilRequest.deleteTag(mContext, sb.toString(), mHandler);
				} else {
					finish();
				}
				break;
			case R.id.profile_tags_add_button:
				new EditTextDialog(mContext, R.style.dialog).setType(1).setCallBack(new OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if (value1.equals("1")) {
							// 确定-添加标签
							UtilRequest.addNewTag(mContext, J_Cache.sLoginUser.uid + "", value2, mHandler);
						}
					}
				}).show();
				break;

			default:
				break;
			}
		}
	};

}
