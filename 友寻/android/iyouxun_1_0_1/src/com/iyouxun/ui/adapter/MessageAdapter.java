package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.R;
import com.iyouxun.data.chat.ChatConstant;
import com.iyouxun.data.chat.MessageListCell;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: MessageAdapter
 * @Description: 消息页面数据适配器
 * @author donglizhi
 * @date 2015年3月13日 下午4:44:24
 * 
 */
public class MessageAdapter extends BaseAdapter {
	private final ArrayList<MessageListCell> showData;
	private final Context mContext;

	public MessageAdapter(ArrayList<MessageListCell> datas, Context context) {
		showData = datas;
		mContext = context;
	}

	@Override
	public int getCount() {
		return showData.size();
	}

	@Override
	public Object getItem(int position) {
		return position;
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		// 联系人信息列表
		MessageListCell userinfo = showData.get(position);
		ViewHolder holder = null;
		if (convertView == null) {
			convertView = LayoutInflater.from(mContext).inflate(R.layout.item_message_list, null);
			holder = new ViewHolder();
			holder.userAvatar = (CircularImage) convertView.findViewById(R.id.message_list_avatar);
			holder.arrow = (ImageView) convertView.findViewById(R.id.message_list_arrow);
			holder.lastMsg = (TextView) convertView.findViewById(R.id.message_list_last_msg);
			holder.msgDate = (TextView) convertView.findViewById(R.id.message_list_date);
			holder.msgTip = (TextView) convertView.findViewById(R.id.message_list_new_msg_tip);
			holder.userNick = (TextView) convertView.findViewById(R.id.message_list_nick);
			holder.msgStatusImg = (ImageView) convertView.findViewById(R.id.message_list_msg_status);
			holder.systemIcon = (ImageView) convertView.findViewById(R.id.message_list_system_icn);
			holder.hint = (ImageView) convertView.findViewById(R.id.message_list_msg_hint);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		if (position < 2) {
			// 系统信息列表
			holder.systemIcon.setVisibility(View.VISIBLE);
			holder.userAvatar.setVisibility(View.GONE);
			holder.hint.setVisibility(View.GONE);
			if (position == 0) {// 我的群组图标
				holder.systemIcon.setImageResource(R.drawable.icn_manage_friends);
			} else if (position == 1) {// 系统消息图标
				holder.systemIcon.setImageResource(R.drawable.icn_system_msg);
				userinfo.timeStamp = SharedPreUtil.getSystemTime();
				String showTime = Util.getFormatDateTime3(mContext, userinfo.timeStamp);
				holder.msgDate.setText(showTime);
				userinfo.item_countnew = SharedPreUtil.getSystemChange();
				if (userinfo.item_countnew > 0) {
					holder.msgDate.setVisibility(View.VISIBLE);
					holder.lastMsg.setVisibility(View.VISIBLE);
				} else {
					holder.msgDate.setVisibility(View.GONE);
					holder.lastMsg.setVisibility(View.INVISIBLE);
				}
			}
			String countnewStr = String.valueOf(userinfo.item_countnew);
			int countnew = userinfo.item_countnew;
			if (countnew > 0 && userinfo.hint == 0) {
				if (countnew >= 99) {
					countnewStr = "99+";
				}
				holder.msgTip.setText(countnewStr);
				holder.msgTip.setVisibility(View.VISIBLE);
			} else {
				holder.msgTip.setVisibility(View.GONE);
			}
			holder.userNick.setText(userinfo.nick);
			holder.arrow.setVisibility(View.VISIBLE);
			holder.msgStatusImg.setVisibility(View.GONE);
			holder.lastMsg.setText(userinfo.content);
			// 时间设置
			String showTime = Util.getFormatDateTime3(mContext, userinfo.timeStamp);
			holder.msgDate.setText(showTime);
		} else {
			holder.lastMsg.setVisibility(View.VISIBLE);
			holder.msgDate.setVisibility(View.VISIBLE);
			holder.userAvatar.setVisibility(View.VISIBLE);
			holder.systemIcon.setVisibility(View.GONE);
			holder.arrow.setVisibility(View.GONE);
			// 加载头像
			if (Util.isBlankString(userinfo.avatar)) {
				userinfo.avatar = "";
			}
			holder.container = J_NetManager.getInstance().loadIMG(holder.container, userinfo.avatar, holder.userAvatar,
					R.drawable.icon_avatar, R.drawable.icon_avatar);
			// 新信息提醒
			String countnewStr = String.valueOf(userinfo.newmsg);
			int countnew = userinfo.newmsg;
			if (countnew > 0 && userinfo.hint == 0) {
				if (countnew >= 99) {
					countnewStr = "99+";
				}
				holder.msgTip.setText(countnewStr);
				holder.msgTip.setVisibility(View.VISIBLE);
			} else {
				holder.msgTip.setVisibility(View.GONE);
			}
			if (userinfo.hint == 0) {
				holder.hint.setVisibility(View.GONE);
			} else {
				holder.hint.setVisibility(View.VISIBLE);
			}
			final String nickName = userinfo.nick;
			final String oid = userinfo.oid;
			holder.userNick.setText(nickName);// 昵称
			// 根据信息状态显示发送图标信息
			holder.msgStatusImg.setVisibility(View.GONE);
			if (userinfo.status > 0) {
				switch (userinfo.status) {
				case ChatConstant.MSG_SYNCHRONIZING:
				case ChatConstant.MSG_SYNCHRONIZE_FAILED:// 发送失败
					holder.msgStatusImg.setImageDrawable(mContext.getResources().getDrawable(R.drawable.icn_msg_send_fail));
					holder.msgStatusImg.setVisibility(View.VISIBLE);
					break;
				default:
					break;
				}
			}
			// 聊天内容中的表情转换
			String currContent = "";
			if (!TextUtils.isEmpty(userinfo.content)) {
				currContent = Util.replaceEnter(userinfo.content).trim();
			}
			// 私信内容可见时，截取最后一条私信最多9字，超过时以“…”截断
			// if (currContent.length() > 9) {
			// currContent = TextUtils.substring(currContent, 0, 9) + "...";
			// }
			holder.lastMsg.setText(currContent);// 聊天内容
			// 时间设置
			String showTime = Util.getFormatDateTime3(mContext, userinfo.timeStamp);
			holder.msgDate.setText(showTime);
		}
		return convertView;
	}

	private class ViewHolder {
		TextView msgTip;// 新消息提醒
		CircularImage userAvatar;// 用户头像
		ImageView arrow;// 进入图标
		TextView userNick;// 用户昵称
		TextView msgDate;// 消息时间
		TextView lastMsg;// 最后一条消息
		ImageView msgStatusImg;// 消息发送状态
		ImageContainer container;
		ImageView systemIcon;// 系统图标
		ImageView hint;// 拒收群消息
	}
}
