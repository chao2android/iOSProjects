/**
 * 
 * @Package com.iyouxun.ui.activity.setting
 * @author likai
 * @date 2015-6-5 下午2:32:12
 * @version V1.0
 */
package com.iyouxun.ui.activity.setting;

import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.ImageLoadListener;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.ProfileUtils;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * 我的二维码
 * 
 * @author likai
 * @date 2015-6-5 下午2:32:12
 * 
 */
public class SettingMyQRCodeActivity extends CommTitleActivity {
	private ImageView my_qr_code_iv;// 二维码图片
	private ImageView userAvatar;// 用户头像
	private ImageView userSex;// 用户性别
	private TextView userNick;// 用户昵称
	private TextView userMarriage;// 情感状态
	private TextView userLocation;// 用户区域

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("我的二维码");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_my_qrcode, null);
	}

	@Override
	protected void initViews() {
		my_qr_code_iv = (ImageView) findViewById(R.id.my_qr_code_iv);
		userAvatar = (ImageView) findViewById(R.id.my_qr_code_avatar);
		userSex = (ImageView) findViewById(R.id.my_qr_code_sex);
		userNick = (TextView) findViewById(R.id.my_qr_code_nick);
		userMarriage = (TextView) findViewById(R.id.my_qr_code_marriage);
		userLocation = (TextView) findViewById(R.id.my_qr_code_location);
		J_NetManager.getInstance().loadIMG(null, SharedPreUtil.getLoginInfo().avatarUrl200, userAvatar, new ImageLoadListener() {

			@Override
			public void onLoadFinish() {
				// 二维码地址
				String contents = J_Consts.SHARE_URL_USER + SharedPreUtil.getLoginInfo().uid;
				// 生成二维码
				Util.createQRImageWidthAvatar(contents, my_qr_code_iv);
			}
		}, R.drawable.icon_avatar, R.drawable.icon_avatar);
		// 性别
		if (J_Cache.sLoginUser.sex == 0) {
			// 女
			userSex.setImageResource(R.drawable.icon_famale_b);
		} else {
			// 男
			userSex.setImageResource(R.drawable.icon_male_b);
		}
		// 婚姻状况
		userMarriage.setText(ProfileUtils.getMarriage(J_Cache.sLoginUser.marriage));
		// 位置信息
		if (!Util.isBlankString(J_Cache.sLoginUser.locationName) && !Util.isBlankString(J_Cache.sLoginUser.subLocationName)) {
			userLocation.setVisibility(View.VISIBLE);
			userLocation.setText(J_Cache.sLoginUser.locationName + " " + J_Cache.sLoginUser.subLocationName);
		} else {
			userLocation.setVisibility(View.GONE);
		}
		// 昵称
		userNick.setText(J_Cache.sLoginUser.nickName);
	}
}
