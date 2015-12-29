package com.iyouxun.utils;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;
import android.telephony.TelephonyManager;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.Contact;

public class SIMCardInfo {
	private static TelephonyManager telephonyManager;
	private final Context mContext;

	private String IMSI;

	public SIMCardInfo(Context context) {
		mContext = context;
		telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
	}

	/**
	 * Role:get phone number
	 */
	public String getNativePhoneNumber() {
		String NativePhoneNumber = "";
		NativePhoneNumber = telephonyManager.getLine1Number();
		if (null == NativePhoneNumber) {
			NativePhoneNumber = "";
		}
		if (NativePhoneNumber.length() > 11) {
			NativePhoneNumber = NativePhoneNumber.substring(NativePhoneNumber.length() - 11, NativePhoneNumber.length());
		}
		return NativePhoneNumber;
	}

	/**
	 * Role:Telecom service providers获取手机服务商信息 <BR>
	 * 需要加入权限<uses-permission
	 * android:name="android.permission.READ_PHONE_STATE"/> <BR>
	 * 
	 */
	public String getProvidersName() {
		String ProvidersName = null;
		// 返回唯一的用户ID;就是这张卡的编号神马的
		IMSI = telephonyManager.getSubscriberId();
		// IMSI号前面3位460是国家，紧接着后面2位00 02是中国移动，01是中国联通，03是中国电信。
		if (IMSI.startsWith("46000") || IMSI.startsWith("46002")) {
			ProvidersName = mContext.getString(R.string.sms_pay_operator_china_mobile);
		} else if (IMSI.startsWith("46001")) {
			ProvidersName = mContext.getString(R.string.sms_pay_operator_china_unicom2);
		} else if (IMSI.startsWith("46003")) {
			ProvidersName = mContext.getString(R.string.sms_pay_operator_china_telecom);
		}
		return ProvidersName;
	}

	/**
	 * 读取手机联系人数据
	 * 
	 * @return ArrayList<Contact> 返回类型
	 * @param @return 参数类型
	 * @author likai
	 */
	public ArrayList<Contact> getContact() {

		ArrayList<Contact> mContacts = new ArrayList<Contact>();
		Uri uri = ContactsContract.CommonDataKinds.Phone.CONTENT_URI;
		String[] proj = { J_Consts.DISPLAY_NAME, J_Consts.SORT_KEY, ContactsContract.CommonDataKinds.Phone.NUMBER };
		Cursor cursor = J_Application.context.getContentResolver().query(uri, proj, null, null, J_Consts.SORT_KEY);
		if (cursor.moveToFirst()) {
			do {
				String name = cursor.getString(0);
				String sortKey = getSortKey(cursor.getString(1));
				String mNumber = cursor.getString(2);
				mNumber = formatNumber(mNumber);
				Contact contact = new Contact();
				contact.setName(name);
				contact.setNumber(mNumber);
				contact.setSortKey(sortKey);
				mContacts.add(contact);
			} while (cursor.moveToNext());
		}
		cursor.close();

		return mContacts;
	}

	/**
	 * 获取sort key的首个字符，如果是英文字母就直接返回，否则返回#。
	 * 
	 * @param sortKeyString 数据库中读取出的sort key
	 * @return 英文字母或者#
	 */
	@SuppressLint("DefaultLocale")
	private String getSortKey(String sortKeyString) {
		String key = sortKeyString.substring(0, 1).toUpperCase();
		if (key.matches("[A-Z]")) {
			return key;
		}
		return "#";
	}

	/***
	 * @param number从数据库中获取到的号码
	 * @return 去掉+86开头或者86开头或者中间的空格
	 */
	private String formatNumber(String number) {
		if (number == null || "".equals(number.trim())) {
			return "";
		}

		if (number.startsWith("+")) {
			number = number.replace("+", "");
		}

		number = number.replace(" ", "");

		if (number.startsWith("86")) {
			number = number.substring(2);
		}

		return number;
	}
}
