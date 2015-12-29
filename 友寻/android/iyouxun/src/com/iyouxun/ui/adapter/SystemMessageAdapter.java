package com.iyouxun.ui.adapter;

import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.R;
import com.iyouxun.data.beans.SystemMsgInfoBean;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.utils.Util;
import com.iyouxun.utils.WorkLocation;

import java.util.ArrayList;

public class SystemMessageAdapter extends BaseAdapter {
	private final ArrayList<SystemMsgInfoBean> datas;
	private final Context mContext;
	private final OnClickListener listener;

	public SystemMessageAdapter(Context mContext, ArrayList<SystemMsgInfoBean> datas, OnClickListener listener) {
		this.datas = datas;
		this.mContext = mContext;
		this.listener = listener;
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
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = View.inflate(mContext, R.layout.item_system_message, null);
			holder.nick = (TextView) convertView.findViewById(R.id.system_message_nick);
			holder.apply = (TextView) convertView.findViewById(R.id.system_message_group_apply);
			holder.area = (TextView) convertView.findViewById(R.id.system_message_area);
			holder.avatar = (CircularImage) convertView.findViewById(R.id.system_message_user_avatar);
			holder.btnAgree = (TextView) convertView.findViewById(R.id.system_message_btn_agree);
			holder.btnRefuse = (TextView) convertView.findViewById(R.id.system_message_btn_refuse);
			holder.friend = (TextView) convertView.findViewById(R.id.system_message_mutual_friend);
			holder.time = (TextView) convertView.findViewById(R.id.system_message_time);
			holder.content = (TextView) convertView.findViewById(R.id.system_message_content_text);
			holder.thumbnail = (ImageView)convertView.findViewById(R.id.system_message_thumbnail);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.apply.setVisibility(View.GONE);
		holder.btnRefuse.setVisibility(View.GONE);
		holder.btnAgree.setVisibility(View.GONE);
		holder.friend.setVisibility(View.GONE);
		holder.area.setVisibility(View.GONE);
		holder.content.setVisibility(View.GONE);
		holder.thumbnail.setVisibility(View.GONE);
		holder.btnRefuse.setEnabled(true);
		holder.btnAgree.setEnabled(true);
		holder.btnRefuse.setText(R.string.str_refuse);
		holder.btnAgree.setText(R.string.str_add);
		SystemMsgInfoBean bean = datas.get(position);
		holder.nick.setText(bean.nick);
		String showTime = Util.getFormatDateTime2(mContext, bean.time);
		holder.time.setText(showTime);
		if (!Util.isBlankString(bean.avatar)) {
			holder.container = J_NetManager.getInstance().loadIMG(holder.container, bean.avatar, holder.avatar,
					R.drawable.icon_avatar, R.drawable.icon_avatar);
		} else {
			holder.avatar.setImageResource(R.drawable.icon_avatar);
		}
		switch (bean.type) {
		case 11:// 申请加入群消息
			holder.apply.setText("申请加入 " + bean.groupName);
			if (bean.relation == 1) {
				holder.friend.setText(R.string.you_friend);
			} else if (bean.relation == 2) {
				holder.friend.setText(R.string.you_indirect_friend);
			} else if (!Util.isBlankString(bean.friendnick)) {
				holder.friend.setText("与" + bean.friendnick + "是好友");
			} else {
				holder.friend.setText(R.string.no_relation_for_group_number);
			}
			holder.apply.setVisibility(View.VISIBLE);
			holder.friend.setVisibility(View.VISIBLE);
			if (bean.sysytemMsgStatus == 0 || bean.sysytemMsgStatus == 1) {// 未处理消息
				if (bean.acceptType == -1) {
					holder.btnAgree.setVisibility(View.VISIBLE);
					holder.btnRefuse.setVisibility(View.VISIBLE);
					holder.btnRefuse.setText(R.string.str_refuse);
				} else if (bean.acceptType == 1) {
					holder.btnAgree.setVisibility(View.VISIBLE);
					holder.btnRefuse.setVisibility(View.GONE);
					holder.btnAgree.setEnabled(false);
					holder.btnAgree.setText(R.string.had_add);
				} else if (bean.acceptType == 2) {
					holder.btnAgree.setVisibility(View.GONE);
					holder.btnRefuse.setVisibility(View.VISIBLE);
					holder.btnRefuse.setEnabled(false);
					holder.btnRefuse.setText(R.string.had_refuse);
				}
			} else if (bean.sysytemMsgStatus == 2) {// 已读消息已处理
				holder.btnAgree.setVisibility(View.GONE);
				holder.btnRefuse.setVisibility(View.VISIBLE);
				holder.btnRefuse.setEnabled(false);
				holder.btnRefuse.setText(R.string.has_dealt);
			} else if (bean.sysytemMsgStatus == 3) {// 已读消息已接受
				holder.btnAgree.setVisibility(View.VISIBLE);
				holder.btnRefuse.setVisibility(View.GONE);
				holder.btnAgree.setEnabled(false);
				holder.btnAgree.setText(R.string.had_add);
			} else if (bean.sysytemMsgStatus == 4) {// 已读消息已拒绝
				holder.btnAgree.setVisibility(View.GONE);
				holder.btnRefuse.setVisibility(View.VISIBLE);
				holder.btnRefuse.setEnabled(false);
				holder.btnRefuse.setText(R.string.had_refuse);
			}
			break;
		case 12:// 退群消息
			holder.content.setText(bean.nick + "已退出 " + bean.groupName);
			holder.content.setVisibility(View.VISIBLE);
			break;
		case 13:// 接受加入群
			holder.content.setText("同意你加入 " + bean.groupName);
			holder.content.setVisibility(View.VISIBLE);
			break;
		case 14:// 拒绝好友加入群
			holder.content.setText("谢绝你加入 " + bean.groupName);
			holder.content.setVisibility(View.VISIBLE);
			break;
		case 15:// 群主踢人
			holder.content.setText("你已被请出 " + bean.groupName);
			holder.content.setVisibility(View.VISIBLE);
			break;
		case 22:// 别人给我打标签
			holder.content.setText(bean.nick + "给你打了新的标签 \"" + bean.tagName + "\"");
			holder.content.setVisibility(View.VISIBLE);
			break;
		case 23:// 好友申请
			holder.content.setText("申请成为你的好友");
			holder.content.setVisibility(View.VISIBLE);
			if (Util.isBlankString(bean.friendlists)) {
				holder.friend.setText("0个共同好友");
			} else {
				holder.friend.setText("共同好友：" + bean.friendlists);
			}
			holder.friend.setVisibility(View.VISIBLE);
			if (bean.sysytemMsgStatus == 0 || bean.sysytemMsgStatus == 1) {// 未处理消息
				if (bean.acceptType == -1) {
					holder.btnRefuse.setVisibility(View.VISIBLE);
					holder.btnAgree.setVisibility(View.VISIBLE);
					holder.btnRefuse.setText(R.string.str_ignore);
				} else if (bean.acceptType == 1) {
					holder.btnRefuse.setVisibility(View.GONE);
					holder.btnAgree.setVisibility(View.VISIBLE);
					holder.btnAgree.setEnabled(false);
					holder.btnAgree.setText(R.string.had_add);
				} else if (bean.acceptType == 2) {
					holder.btnAgree.setVisibility(View.GONE);
					holder.btnRefuse.setVisibility(View.VISIBLE);
					holder.btnRefuse.setEnabled(false);
					holder.btnRefuse.setText(R.string.has_ignore);
				}
			} else if (bean.sysytemMsgStatus == 2) {// 已读消息已处理
				holder.btnAgree.setVisibility(View.GONE);
				holder.btnRefuse.setVisibility(View.VISIBLE);
				holder.btnRefuse.setEnabled(false);
				holder.btnRefuse.setText(R.string.has_dealt);
			} else if (bean.sysytemMsgStatus == 3) {// 已读消息已接受
				holder.btnRefuse.setVisibility(View.GONE);
				holder.btnAgree.setVisibility(View.VISIBLE);
				holder.btnAgree.setEnabled(false);
				holder.btnAgree.setText(R.string.had_add);
			} else if (bean.sysytemMsgStatus == 4) {// 已读消息已忽略
				holder.btnAgree.setVisibility(View.GONE);
				holder.btnRefuse.setVisibility(View.VISIBLE);
				holder.btnRefuse.setEnabled(false);
				holder.btnRefuse.setText(R.string.has_ignore);
			}
			break;
		case 24:// 新好友加入
			holder.nick.setText("新好友加入");
			holder.content.setText(bean.nick + "( 通讯录好友：" + bean.uname + " )加入了，去个他贴个标签吧");
			holder.content.setVisibility(View.VISIBLE);
			break;
		case 25:// 赞照片
			holder.content.setText(R.string.praise_your_photo);
			holder.content.setVisibility(View.VISIBLE);
			holder.thumbnailContainer = J_NetManager.getInstance().loadIMG(holder.thumbnailContainer,bean.photoThumbnail,holder.thumbnail,R.drawable.error_no_data,R.drawable.error_no_data);
			holder.thumbnail.setVisibility(View.VISIBLE);
		default:
			break;
		}
		if (!Util.isBlankString(bean.privonce) && !bean.privonce.equals("0")) {
			int privonceIndex = WorkLocation.getLocationIndexWithCode(bean.privonce);
			int cityIndex = WorkLocation.getSubLocationIndexWithCode(privonceIndex, bean.city);
			String privonce = WorkLocation.getLocationNameWithIndex(privonceIndex);
			String city = WorkLocation.getSubLocationNameWithIndex(privonceIndex, cityIndex, false);
			holder.area.setVisibility(View.VISIBLE);
			if (!privonce.equals(city)) {
				holder.area.setText(privonce + " " + city);
			} else {
				holder.area.setText(privonce);
			}
		}
		holder.btnAgree.setTag(position);
		holder.btnRefuse.setTag(position);
		holder.nick.setTag(position);
		holder.avatar.setTag(position);
		holder.btnAgree.setOnClickListener(listener);
		holder.btnRefuse.setOnClickListener(listener);
		holder.nick.setOnClickListener(listener);
		holder.avatar.setOnClickListener(listener);
		return convertView;
	}

	private class ViewHolder {
		private TextView nick;// 用户昵称
		private TextView time;// 消息时间
		private TextView area;// 用户区域
		private TextView friend;// 共同好友
		private TextView apply;// 群组申请
		private TextView btnRefuse;// 谢绝按钮
		private TextView btnAgree;// 添加按钮
		private CircularImage avatar;// 用户头像
		private TextView content;// 显示内容
		private ImageContainer container;
		private ImageView thumbnail;//缩略图
		private ImageContainer thumbnailContainer;
	}

}
