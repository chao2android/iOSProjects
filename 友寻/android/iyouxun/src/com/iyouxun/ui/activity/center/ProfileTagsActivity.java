package com.iyouxun.ui.activity.center;

import java.util.ArrayList;
import java.util.Collections;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Handler;
import android.os.Message;
import android.text.Html;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
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
import com.iyouxun.utils.DialogUtils;
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
	private TextView profile_tags_change;// 换一批
	private LinearLayout profile_tags_recom_box;// 推荐标签列表
	private TextView profile_tags_nums;
	private TextView profile_tags_del_nums;
	private TextView profile_tags_recom_empty;// 空推荐标签

	// 标签数据
	private final ArrayList<TagsInfoBean> tagsData = new ArrayList<TagsInfoBean>();
	// 推荐标签数据
	private final ArrayList<TagsInfoBean> recommAllTagsData = new ArrayList<TagsInfoBean>();
	// 推荐标签数据
	private final ArrayList<TagsInfoBean> recommTagsData = new ArrayList<TagsInfoBean>();
	// 标签视图数组
	private View[] textViews;
	// 推荐标签视图数组
	private View[] recomTextViews;

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
		profile_tags_change = (TextView) findViewById(R.id.profile_tags_change);
		profile_tags_recom_box = (LinearLayout) findViewById(R.id.profile_tags_recom_box);
		profile_tags_nums = (TextView) findViewById(R.id.profile_tags_nums);
		profile_tags_del_nums = (TextView) findViewById(R.id.profile_tags_del_nums);
		profile_tags_recom_empty = (TextView) findViewById(R.id.profile_tags_recom_empty);

		profile_tags_add_button.setOnClickListener(listener);
		profile_tags_change.setOnClickListener(listener);

		// 获取标签列表
		getTagsList();
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_ALTERNATIVE_TAG_LIST:
				// 获取到推荐标签列表
				J_Response responseTag = (J_Response) msg.obj;
				if (responseTag.retcode == 1) {
					try {
						JSONArray tagArray = new JSONArray(responseTag.data);
						if (tagArray.length() > 0) {
							for (int i = 0; i < tagArray.length(); i++) {
								JSONObject tagObj = tagArray.optJSONObject(i);
								TagsInfoBean bean = new TagsInfoBean();
								bean.name = tagObj.optString("title");
								bean.tid = tagObj.optString("tid");

								if (!isRecommTagHave(bean)) {
									recommAllTagsData.add(bean);
								}
							}
						}

						refreshRecommTags(true);// 刷新推荐列表
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				dismissLoading();
				break;
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

							// 从当前推荐列表中删除该tag
							for (int j = 0; j < recommTagsData.size(); j++) {
								if (recommTagsData.get(j).name.equals(bean.name)) {
									recommTagsData.remove(j);
								}
							}

							// 刷新标签列表
							refreshTags();

							// 刷新推荐标签列表
							refreshRecommTags(false);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else if (response.retcode == -2) {
					ToastUtil.showToast(mContext, "添加失败：包含敏感词！");
				} else {
					ToastUtil.showToast(mContext, "添加失败");
				}
				dismissLoading();
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

				// 获取新推荐标签
				getAlternativeTagList();
				break;

			default:
				break;
			}
		}
	};

	/**
	 * 查询该标签是否已经存在
	 * 
	 * @Title: isRecommTagHave
	 * @return boolean 返回类型
	 * @param @param bean
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	private boolean isRecommTagHave(TagsInfoBean bean) {
		boolean isHave = false;
		for (int i = 0; i < recommTagsData.size(); i++) {
			if (bean != null && !Util.isBlankString(bean.name) && recommTagsData.get(i).name.equals(bean.name)) {
				isHave = true;
			}
		}
		for (int j = 0; j < tagsData.size(); j++) {
			if (bean != null && !Util.isBlankString(bean.name) && tagsData.get(j).name.equals(bean.name)) {
				isHave = true;
			}
		}
		return isHave;
	}

	/**
	 * 获取标签列表
	 * 
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
	 * 获取推荐标签列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getAlternativeTagList() {
		UtilRequest.getAlternativeTagList(mContext, mHandler);
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
				ImageView item_tag_close = (ImageView) tagView.findViewById(R.id.item_tag_close);
				// 显示删除按钮
				item_tag_close.setVisibility(View.VISIBLE);
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
				// 设置点击状态-删除
				item_tag_box.setOnClickListener(new OnClickListener() {
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
		// 总标签数量
		profile_tags_nums.setText(Html.fromHtml("共 <font color=\"#2695FF\">" + tagsData.size() + "</font> 个标签"));
		// 已删除标签数量
		profile_tags_del_nums.setText("已删除 " + getDelTagNum() + " 个标签");
	}

	/**
	 * TODO 刷新推荐标签列表
	 * 
	 * @return void 返回类型
	 * @param isReGet 是否重新获取一组新推荐标签
	 * @author likai
	 * @throws
	 */
	private void refreshRecommTags(boolean isReGet) {
		if (isReGet) {
			// 需要重新获取一组新tag
			recommTagsData.clear();
			// 随机打算顺序
			Collections.shuffle(recommAllTagsData);
			for (int i = 0; i < recommAllTagsData.size(); i++) {
				TagsInfoBean bean = recommAllTagsData.get(i);
				if (!isRecommTagHave(bean)) {
					recommTagsData.add(bean);
				}
				if (recommTagsData.size() >= 6) {
					break;
				}
			}
		} else {
			// 补充缺失的标签
			if (recommTagsData.size() < 6) {
				for (int i = 0; i < recommAllTagsData.size(); i++) {
					TagsInfoBean tmpBean = recommAllTagsData.get(i);
					if (!isRecommTagHave(tmpBean)) {
						recommTagsData.add(tmpBean);
					}
					if (recommTagsData.size() >= 6) {
						break;
					}
				}
			}
		}
		// 移除当前标签容器中的所有标签，重新刷新添加
		if (recommTagsData.size() > 0) {
			profile_tags_recom_box.removeAllViews();
			recomTextViews = new View[recommTagsData.size()];
			for (int i = 0; i < recommTagsData.size(); i++) {
				final TagsInfoBean bean = recommTagsData.get(i);

				View tagView = View.inflate(mContext, R.layout.item_tag_add_layer, null);
				LinearLayout item_tag_box = (LinearLayout) tagView.findViewById(R.id.item_tag_box);
				TextView item_tag_name = (TextView) tagView.findViewById(R.id.item_tag_name);
				ImageView item_tag_add = (ImageView) tagView.findViewById(R.id.item_tag_add);
				// 显示添加按钮
				item_tag_add.setVisibility(View.VISIBLE);
				// 标签名字
				item_tag_name.setText(bean.name);
				item_tag_name.setSingleLine(true);
				// 设置点击状态-添加
				item_tag_box.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						showLoading("添加中...");
						// 添加新标签
						UtilRequest.addNewTag(mContext, J_Cache.sLoginUser.uid + "", bean.name, mHandler);
					}
				});

				recomTextViews[i] = tagView;
			}
			if (recomTextViews.length > 0 && recomTextViews[0] != null) {
				Util.populateText(profile_tags_recom_box, recomTextViews, mContext,
						getResources().getDimensionPixelSize(R.dimen.global_px30dp), true);
			}
		} else {
			profile_tags_recom_box.removeAllViews();
			profile_tags_recom_box.addView(profile_tags_recom_empty);
		}
	}

	/**
	 * 获取将要删除的标签数量
	 * 
	 * @return int 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	private int getDelTagNum() {
		int totalNum = 0;
		for (int i = 0; i < tagsData.size(); i++) {
			if (tagsData.get(i).isSelected == 0) {
				totalNum++;
			}
		}
		return totalNum;
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
			case R.id.profile_tags_change:
				// 换一批推荐标签
				refreshRecommTags(true);
				break;
			case R.id.titleLeftButton:
				// 返回检查编辑状态
				backForSave();
				break;
			case R.id.profile_tags_add_button:
				new EditTextDialog(mContext, R.style.dialog).setType(1).setCallBack(new OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if (value1.equals("1")) {
							// 确定-添加标签
							showLoading("添加中...");
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

	/**
	 * 返回保存
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void backForSave() {
		final StringBuilder sb = new StringBuilder();
		int deleteNum = 0;
		for (int i = 0; i < tagsData.size(); i++) {
			TagsInfoBean bean = tagsData.get(i);
			if (bean.isSelected == 0) {
				if (sb.length() > 0) {
					sb.append(",");
				}
				sb.append(bean.tid);
				deleteNum++;
			}
		}
		if (sb.length() > 0) {
			DialogUtils.showPromptDialog(mContext, "提醒", "本次编辑将删除" + deleteNum + "个标签，是否继续？", new OnSelectCallBack() {
				@Override
				public void onCallBack(String value1, String value2, String value3) {
					if (value1.equals("0")) {
						showLoading();
						UtilRequest.deleteTag(mContext, sb.toString(), mHandler);
					}
				}
			});
		} else {
			finish();
		}
	}
}
