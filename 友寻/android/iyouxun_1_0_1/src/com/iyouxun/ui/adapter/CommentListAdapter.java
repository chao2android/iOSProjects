package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.text.SpannableString;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.R;
import com.iyouxun.data.beans.CommentInfoBean;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.views.FaceConversionUtil;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.TimeUtil;

/**
 * 评论列表adapter
 * 
 * @ClassName: CommentListAdapter
 * @author likai
 * @date 2015-3-24 上午11:21:14
 * 
 */
public class CommentListAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<CommentInfoBean> datas = new ArrayList<CommentInfoBean>();

	public CommentListAdapter(Context mContext) {
		this.mContext = mContext;
	}

	public void setData(ArrayList<CommentInfoBean> datas) {
		this.datas = datas;
	}

	@Override
	public int getCount() {
		return datas.size();
	}

	@Override
	public Object getItem(int position) {
		return datas.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder vh = new ViewHolder();
		if (convertView == null) {
			convertView = View.inflate(mContext, R.layout.item_comment_list_layout, null);
			vh.itemCommentAvatar = (ImageView) convertView.findViewById(R.id.itemCommentAvatar);
			vh.itemCommentTime = (TextView) convertView.findViewById(R.id.itemCommentTime);
			vh.itemCommentContent = (TextView) convertView.findViewById(R.id.itemCommentContent);
			vh.itemCommentNick = (TextView) convertView.findViewById(R.id.itemCommentNick);
			vh.itemCommentToNick = (TextView) convertView.findViewById(R.id.itemCommentToNick);
			vh.iemCommentBack = (TextView) convertView.findViewById(R.id.iemCommentBack);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		final CommentInfoBean bean = datas.get(position);

		// 头像
		vh.container = J_NetManager.getInstance().loadIMG(vh.container, bean.avatar, vh.itemCommentAvatar,
				R.drawable.icon_avatar, R.drawable.icon_avatar);
		vh.itemCommentAvatar.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
				profileIntent.putExtra("uid", bean.uid);
				mContext.startActivity(profileIntent);
			}
		});
		// 时间
		vh.itemCommentTime.setText(TimeUtil.getStandardDate(bean.time));
		// 内容
		SpannableString commentContent = FaceConversionUtil.getInstace().getExpressionStringAll(mContext, bean.content);
		vh.itemCommentContent.setText(commentContent);
		// 标题
		if (bean.replyUid > 0) {
			// 回复他人的评论
			vh.iemCommentBack.setVisibility(View.VISIBLE);
			vh.itemCommentToNick.setVisibility(View.VISIBLE);

			vh.itemCommentNick.setText(StringUtils.getLimitSubstringWithMore(bean.nick, 5));
			vh.itemCommentNick.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", bean.uid);
					mContext.startActivity(profileIntent);
				}
			});
			vh.itemCommentToNick.setText(StringUtils.getLimitSubstringWithMore(bean.replyNick, 5));
			vh.itemCommentToNick.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", bean.replyUid);
					mContext.startActivity(profileIntent);
				}
			});
		} else {
			// 评论动态
			vh.iemCommentBack.setVisibility(View.GONE);
			vh.itemCommentToNick.setVisibility(View.GONE);

			vh.itemCommentNick.setText(bean.nick);
			vh.itemCommentNick.setTextColor(mContext.getResources().getColor(R.color.text_normal_blue));
			vh.itemCommentNick.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", bean.uid);
					mContext.startActivity(profileIntent);
				}
			});
		}

		return convertView;
	}

	private class ViewHolder {
		public ImageContainer container;

		public ImageView itemCommentAvatar;
		public TextView itemCommentTime;

		public TextView itemCommentContent;

		public TextView iemCommentBack;
		public TextView itemCommentNick;
		public TextView itemCommentToNick;
	}

	/**
	 * 隐藏span连接的文本默认背景色
	 * 
	 * @Title: avoidHintColor
	 * @return void 返回类型
	 * @param @param view 参数类型
	 * @author likai
	 * @throws
	 */
	private void avoidHintColor(View view) {
		if (view instanceof TextView) {
			((TextView) view).setHighlightColor(mContext.getResources().getColor(android.R.color.transparent));
		}
	}
}
