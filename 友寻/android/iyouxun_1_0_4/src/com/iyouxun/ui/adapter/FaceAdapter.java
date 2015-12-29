package com.iyouxun.ui.adapter;

import java.util.List;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.iyouxun.R;
import com.iyouxun.ui.views.ChatEmoji;
import com.iyouxun.utils.Util;

/**
 * 
 ****************************************** 
 * @文件名称 : FaceAdapter.java
 * @文件描述 : 表情填充器
 ****************************************** 
 * 
 */
public class FaceAdapter extends BaseAdapter {
	private final List<ChatEmoji> data;
	private final LayoutInflater inflater;
	private int size = 0;
	public Context context;
	public int sizetest;// 表情列表框中的表情大小
	public int currentType;// 表情类型1、默认，2、emoji，3、动态

	public FaceAdapter(Context context, List<ChatEmoji> list, int type) {
		this.inflater = LayoutInflater.from(context);
		this.context = context;
		this.currentType = type;
		this.sizetest = Util.getBoxFaceSize(context, type);// 表情列表框中的表情大小
		this.data = list;
		this.size = list.size();
	}

	@Override
	public int getCount() {
		return this.size;
	}

	@Override
	public Object getItem(int position) {
		return data.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ChatEmoji emoji = data.get(position);
		ViewHolder viewHolder = null;
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = inflater.inflate(R.layout.inputbox_face_item, null);
			viewHolder.iv_face = (ImageView) convertView.findViewById(R.id.item_iv_face);
			viewHolder.item_iv_box = (RelativeLayout) convertView.findViewById(R.id.item_iv_box);

			int showLeft = 0;
			int showRight = 0;
			int showTop = 0;
			int showBottom = 0;
			switch (currentType) {
			case 1:
				showLeft = 0;
				showRight = 0;
				showTop = context.getResources().getDimensionPixelSize(R.dimen.global_px10dp);
				showBottom = context.getResources().getDimensionPixelSize(R.dimen.global_px10dp);
				break;
			case 2:
				showLeft = 0;
				showRight = 0;
				showTop = context.getResources().getDimensionPixelSize(R.dimen.global_px10dp);
				showBottom = context.getResources().getDimensionPixelSize(R.dimen.global_px10dp);
				break;
			case 3:
				showLeft = 0;
				showRight = 0;
				showTop = context.getResources().getDimensionPixelSize(R.dimen.global_px15dp);
				showBottom = context.getResources().getDimensionPixelSize(R.dimen.global_px15dp);
				break;
			default:
				break;
			}
			viewHolder.iv_face.setLayoutParams(new RelativeLayout.LayoutParams(sizetest, sizetest));
			viewHolder.item_iv_box.setPadding(showLeft, showTop, showRight, showBottom);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		if (TextUtils.isEmpty(emoji.getCharacter())) {
			convertView.setBackgroundDrawable(null);
			viewHolder.iv_face.setImageDrawable(null);
		} else {
			viewHolder.iv_face.setTag(emoji);
			viewHolder.iv_face.setImageResource(emoji.getId());
		}

		return convertView;
	}

	private class ViewHolder {
		public RelativeLayout item_iv_box;
		public ImageView iv_face;
	}
}