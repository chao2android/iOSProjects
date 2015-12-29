package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.text.SpannableString;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.SystemMsgInfoBean;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.views.FaceConversionUtil;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.TimeUtil;
import com.iyouxun.utils.Util;

/**
 * 动态提醒消息列表adapter
 * 
 * @ClassName: NewsMsgListViewAdapter
 * @author likai
 * @date 2015-3-9 上午10:21:50
 * 
 */
public class NewsMsgListViewAdapter extends BaseAdapter {
	private ArrayList<SystemMsgInfoBean> datas = new ArrayList<SystemMsgInfoBean>();
	private final Context mContext;

	public NewsMsgListViewAdapter(Context mContext) {
		this.mContext = mContext;
	}

	public void setData(ArrayList<SystemMsgInfoBean> datas) {
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_news_msg_layout, null);
			vh.newsMsgAvatar = (ImageView) convertView.findViewById(R.id.newsMsgAvatar);
			vh.newsContent = (TextView) convertView.findViewById(R.id.newsContent);
			vh.newsContentImg = (ImageView) convertView.findViewById(R.id.newsContentImg);
			vh.newsMsgTime = (TextView) convertView.findViewById(R.id.newsMsgTime);
			vh.newsMsgNick = (TextView) convertView.findViewById(R.id.newsMsgNick);
			vh.newsMsgContent = (TextView) convertView.findViewById(R.id.newsMsgContent);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}
		// 一条item的内容
		SystemMsgInfoBean msg = datas.get(position);

		// 头像
		vh.containerAvatar = J_NetManager.getInstance().loadIMG(vh.containerAvatar, msg.avatar, vh.newsMsgAvatar,
				R.drawable.pic_default_square, R.drawable.pic_default_square);

		// 昵称
		vh.newsMsgNick.setText(msg.nick);

		// 时间
		vh.newsMsgTime.setText(TimeUtil.getStandardDate(String.valueOf(msg.time)));

		// 消息描述
		SpannableString desc = new SpannableString("");
		switch (msg.type) {
		case 17:
			desc = new SpannableString("赞了你的动态");
			break;
		case 18:
			desc = new SpannableString("转播了你的动态");
			break;
		case 19:
			desc = FaceConversionUtil.getInstace().getExpressionStringAll(mContext, "评论了你的动态:" + msg.commentContent);
			break;
		case 20:
			desc = FaceConversionUtil.getInstace().getExpressionStringAll(mContext, "回复了你的评论:" + msg.commentContent);
			break;
		default:
			break;
		}
		vh.newsMsgContent.setText(desc);

		// 动态内容
		switch (msg.feedType) {
		case 100:// 文字动态
		case 500:// 转播文字动态
			vh.newsContent.setVisibility(View.VISIBLE);
			vh.newsContentImg.setVisibility(View.GONE);
			vh.newsContent.setText(StringUtils.getLimitSubstringWithMore(msg.feedContent, 6));
			break;
		case 101:// 图片动态
		case 501:// 转播图片动态
			if (!Util.isBlankString(msg.feedImgUrl)) {
				// 默认显示图片
				vh.newsContent.setVisibility(View.GONE);
				vh.newsContentImg.setVisibility(View.VISIBLE);
				vh.containerFeed = J_NetManager.getInstance().loadIMG(vh.containerFeed, msg.feedImgUrl, vh.newsContentImg,
						R.drawable.pic_default_square, R.drawable.pic_default_square);
			} else {
				// 图片不存在，只显示内容
				vh.newsContent.setVisibility(View.VISIBLE);
				vh.newsContentImg.setVisibility(View.GONE);
				vh.newsContent.setText(StringUtils.getLimitSubstringWithMore(msg.feedContent, 6));
			}
			break;
		default:
			break;
		}

		return convertView;
	}

	private class ViewHolder {
		public ImageContainer containerAvatar;
		public ImageContainer containerFeed;

		public ImageView newsMsgAvatar;
		public TextView newsContent;
		public ImageView newsContentImg;

		public TextView newsMsgTime;
		public TextView newsMsgNick;
		public TextView newsMsgContent;
	}
}
