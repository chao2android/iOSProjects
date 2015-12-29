package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.SortInfoBean;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.utils.Util;

/**
 * 共同好友列表
 * 
 * @ClassName: SameFriendListAdapter
 * @author likai
 * @date 2015-3-5 下午6:02:27
 * 
 */
public class SameFriendListAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<SortInfoBean> datas = new ArrayList<SortInfoBean>();
	/** 0：共同好友，1：ta的好友 */
	private int type = 0;

	public SameFriendListAdapter(Context mContext, int type) {
		this.mContext = mContext;
		this.type = type;
	}

	public void setData(ArrayList<SortInfoBean> datas) {
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_same_friend_layout, null);
			vh.sameFriendUserAvatarLocal = (CircularImage) convertView.findViewById(R.id.sameFriendUserAvatarLocal);
			vh.sameFriendUserAvatar = (CircularImage) convertView.findViewById(R.id.sameFriendUserAvatar);
			vh.sameFriendUserNick = (TextView) convertView.findViewById(R.id.sameFriendUserNick);
			vh.sameFriendDimen = (ImageView) convertView.findViewById(R.id.sameFriendDimen);
			vh.sameFriendUserSameNum = (TextView) convertView.findViewById(R.id.sameFriendUserSameNum);
			vh.sortCatalog = (TextView) convertView.findViewById(R.id.sortCatalog);
			vh.sameFriendMarriage = (ImageView) convertView.findViewById(R.id.sameFriendMarriage);
			vh.item_line = convertView.findViewById(R.id.item_line);
			vh.sameFriendInvite = (TextView) convertView.findViewById(R.id.sameFriendInvite);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		final SortInfoBean user = datas.get(position);

		// 根据position获取分类的首字母的Char ascii值
		int section = getSectionForPosition(position);
		// 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
		if (position == getPositionForSection(section)) {
			vh.sortCatalog.setVisibility(View.VISIBLE);
			vh.sortCatalog.setText(user.sortLetter);
			vh.item_line.setVisibility(View.GONE);
		} else {
			vh.sortCatalog.setVisibility(View.GONE);
			vh.item_line.setVisibility(View.VISIBLE);
		}
		// 昵称
		vh.sameFriendUserNick.setText(user.name);
		// 好友注册情况，进行页面ui的更改
		if (user.isReg == 0) {
			// 未注册（只有是共同好友的情况，才会进行此操作）
			vh.sameFriendUserAvatar.setVisibility(View.GONE);
			vh.sameFriendUserAvatarLocal.setVisibility(View.VISIBLE);
			vh.sameFriendUserAvatarLocal.setImageResource(R.drawable.icon_avatar);// 头像
			vh.sameFriendDimen.setVisibility(View.GONE);// 隐藏维度
			vh.sameFriendInvite.setVisibility(View.VISIBLE);// 显示邀请
			vh.sameFriendInvite.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					// 发送短信
					Util.sendSMS(user.mobileNumber, mContext);
				}
			});
			// 隐藏性别
			vh.sameFriendUserNick.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
			// 隐藏共同好友数量
			vh.sameFriendUserSameNum.setVisibility(View.GONE);
			// 隐藏情感状态
			vh.sameFriendMarriage.setVisibility(View.GONE);
		} else {
			// 已注册
			// 头像
			vh.sameFriendUserAvatar.setVisibility(View.VISIBLE);
			vh.sameFriendUserAvatarLocal.setVisibility(View.GONE);
			vh.container = J_NetManager.getInstance().loadIMG(vh.container, user.avatar, vh.sameFriendUserAvatar,
					R.drawable.icon_avatar, R.drawable.icon_avatar);
			vh.sameFriendDimen.setVisibility(View.VISIBLE);// 显示维度
			vh.sameFriendInvite.setVisibility(View.GONE);// 隐藏邀请
			// 只有共同好友显示维度，ta的好友不显示维度
			if (user.friendDimen == 1) {
				vh.sameFriendDimen.setImageResource(R.drawable.icon_dimen_one);
			} else if (user.friendDimen == 2) {
				vh.sameFriendDimen.setImageResource(R.drawable.icon_dimen_two);
			} else {
				vh.sameFriendDimen.setVisibility(View.GONE);
			}
			// 性别
			if (user.sex == 0) {
				// 女
				vh.sameFriendUserNick.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.icon_famale_s, 0);
			} else {
				// 男
				vh.sameFriendUserNick.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.icon_male_s, 0);
			}
			// 共同好友数量
			vh.sameFriendUserSameNum.setVisibility(View.VISIBLE);
			vh.sameFriendUserSameNum.setText(user.sameFriendsNum + "个共同好友");
			if (user.marriage == 1) {
				// 单身
				vh.sameFriendMarriage.setVisibility(View.VISIBLE);
			} else {
				vh.sameFriendMarriage.setVisibility(View.GONE);
			}
		}

		return convertView;
	}

	private class ViewHolder {
		public ImageContainer container;

		public CircularImage sameFriendUserAvatarLocal;// 本地头像
		public CircularImage sameFriendUserAvatar;// 头像
		public TextView sameFriendUserNick;// 昵称
		public ImageView sameFriendDimen;// 好友维度
		public TextView sameFriendUserSameNum;// 共同好友数量
		public ImageView sameFriendMarriage;// 单身状态
		public View item_line;

		public TextView sameFriendInvite;// 好友邀请

		public TextView sortCatalog;// 序号字母
	}

	/**
	 * 根据ListView的当前位置获取分类的首字母的Char ascii值
	 */
	public int getSectionForPosition(int position) {
		return datas.get(position).sortLetter.charAt(0);
	}

	/**
	 * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
	 */
	public int getPositionForSection(int section) {
		for (int i = 0; i < getCount(); i++) {
			String sortStr = datas.get(i).sortLetter;
			char firstChar = sortStr.toUpperCase().charAt(0);
			if (firstChar == section) {
				return i;
			}
		}

		return -1;
	}
}
