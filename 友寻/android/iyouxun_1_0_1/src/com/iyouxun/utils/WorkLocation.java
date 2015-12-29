package com.iyouxun.utils;

import com.iyouxun.J_Application;
import com.iyouxun.R;

/**
 * 地区操作类
 * 
 * @ClassName: WorkLocation
 * @author likai
 * @date 2015-3-3 下午3:28:16
 * 
 */
public class WorkLocation {
	/*
	 * Location
	 */
	public static int getLocationIndexWithName(String name) {
		String[] locName = J_Application.context.getResources().getStringArray(R.array.work_location_array);
		for (int i = 0; i < locName.length; i++) {
			if (locName[i].equalsIgnoreCase(name))
				return i;
		}
		return 0;
	}

	public static int getLocationIndexWithCode(String code) {
		String[] locCode = J_Application.context.getResources().getStringArray(R.array.work_location_code_array);
		for (int i = 0; i < locCode.length; i++) {
			if (locCode[i].equalsIgnoreCase(code))
				return i;
		}
		return -1;
	}

	public static String getLocationNameWithIndex(int index) {
		String[] locName = J_Application.context.getResources().getStringArray(R.array.work_location_array);
		if (index >= 0 && index < locName.length) {
			return locName[index];
		} else {
			return "";
		}
		// return locName[index >= 0 && index < locName.length ? index : 0];
	}

	public static String getLocationCodeWithIndex(int index) {
		if (index < 0)
			return "0";
		String[] locCode = J_Application.context.getResources().getStringArray(R.array.work_location_code_array);
		return locCode[index >= 0 && index < locCode.length ? index : 0];
	}

	/*
	 * SubLocation
	 */
	public static int getSubLocationIndexWithName(int locIndex, String name) {
		String[] subLocName = J_Application.context.getResources().getStringArray(getSubLocationNameArrayId(locIndex));
		for (int i = 0; i < subLocName.length; i++) {
			if (subLocName[i].equalsIgnoreCase(name))
				return i;
		}
		return 0;
	}

	public static int getSubLocationIndexWithCode(int locIndex, String code) {
		String[] subLocName = J_Application.context.getResources().getStringArray(getSubLocationCodeArrayId(locIndex));
		for (int i = 0; i < subLocName.length; i++) {
			if (subLocName[i].equalsIgnoreCase(code))
				return i;
		}
		return -1;
	}

	public static String getSubLocationNameWithIndex(int locIndex, int subLocIndex, boolean judgeMunicipality) {
		if (judgeMunicipality) {
			switch (locIndex) {
			case 0:
			case 1:
			case 8:
			case 21:
				locIndex = 36;
				break;
			default:
			}
		}
		String[] subLocName = J_Application.context.getResources().getStringArray(getSubLocationNameArrayId(locIndex));
		if (subLocIndex >= 0 && subLocIndex < subLocName.length) {
			return subLocName[subLocIndex];
		} else {
			return "";
		}

	}

	public static String getSubLocationCodeWithIndex(int locIndex, int subLocIndex) {
		if (locIndex < 0)
			return "0";
		String[] subLocCode = J_Application.context.getResources().getStringArray(getSubLocationCodeArrayId(locIndex));
		return subLocCode[subLocIndex >= 0 && subLocIndex < subLocCode.length ? subLocIndex : 0];
	}

	/*
	 * Location: Index -> Name
	 */
	// 0 -> ����
	public static int getSubLocationNameArrayId(int locIndex) {
		switch (locIndex) {
		case 0:
			return R.array.work_location_name_array_0;
		case 1:
			return R.array.work_location_name_array_1;
		case 2:
			return R.array.work_location_name_array_2;
		case 3:
			return R.array.work_location_name_array_3;
		case 4:
			return R.array.work_location_name_array_4;
		case 5:
			return R.array.work_location_name_array_5;
		case 6:
			return R.array.work_location_name_array_6;
		case 7:
			return R.array.work_location_name_array_7;
		case 8:
			return R.array.work_location_name_array_8;
		case 9:
			return R.array.work_location_name_array_9;
		case 10:
			return R.array.work_location_name_array_10;
		case 11:
			return R.array.work_location_name_array_11;
		case 12:
			return R.array.work_location_name_array_12;
		case 13:
			return R.array.work_location_name_array_13;
		case 14:
			return R.array.work_location_name_array_14;
		case 15:
			return R.array.work_location_name_array_15;
		case 16:
			return R.array.work_location_name_array_16;
		case 17:
			return R.array.work_location_name_array_17;
		case 18:
			return R.array.work_location_name_array_18;
		case 19:
			return R.array.work_location_name_array_19;
		case 20:
			return R.array.work_location_name_array_20;
		case 21:
			return R.array.work_location_name_array_21;
		case 22:
			return R.array.work_location_name_array_22;
		case 23:
			return R.array.work_location_name_array_23;
		case 24:
			return R.array.work_location_name_array_24;
		case 25:
			return R.array.work_location_name_array_25;
		case 26:
			return R.array.work_location_name_array_26;
		case 27:
			return R.array.work_location_name_array_27;
		case 28:
			return R.array.work_location_name_array_28;
		case 29:
			return R.array.work_location_name_array_29;
		case 30:
			return R.array.work_location_name_array_30;
		case 31:
			return R.array.work_location_name_array_31;
		case 32:
			return R.array.work_location_name_array_32;
		case 33:
			return R.array.work_location_name_array_33;
		case 34:
			return R.array.work_location_name_array_34;
		case 35:
			return R.array.work_location_name_array_35;
		case 36:
			return R.array.work_location_name_array_36;
		case 37:
			return R.array.work_location_name_array_37;
		default:
			return R.array.work_location_name_array_37;
		}
	}

	/*
	 * Location: Index -> Code
	 */
	// 0 -> ����
	public static int getSubLocationCodeArrayId(int locIndex) {
		switch (locIndex) {
		case 0:
			return R.array.work_location_code_array_0;
		case 1:
			return R.array.work_location_code_array_1;
		case 2:
			return R.array.work_location_code_array_2;
		case 3:
			return R.array.work_location_code_array_3;
		case 4:
			return R.array.work_location_code_array_4;
		case 5:
			return R.array.work_location_code_array_5;
		case 6:
			return R.array.work_location_code_array_6;
		case 7:
			return R.array.work_location_code_array_7;
		case 8:
			return R.array.work_location_code_array_8;
		case 9:
			return R.array.work_location_code_array_9;
		case 10:
			return R.array.work_location_code_array_10;
		case 11:
			return R.array.work_location_code_array_11;
		case 12:
			return R.array.work_location_code_array_12;
		case 13:
			return R.array.work_location_code_array_13;
		case 14:
			return R.array.work_location_code_array_14;
		case 15:
			return R.array.work_location_code_array_15;
		case 16:
			return R.array.work_location_code_array_16;
		case 17:
			return R.array.work_location_code_array_17;
		case 18:
			return R.array.work_location_code_array_18;
		case 19:
			return R.array.work_location_code_array_19;
		case 20:
			return R.array.work_location_code_array_20;
		case 21:
			return R.array.work_location_code_array_21;
		case 22:
			return R.array.work_location_code_array_22;
		case 23:
			return R.array.work_location_code_array_23;
		case 24:
			return R.array.work_location_code_array_24;
		case 25:
			return R.array.work_location_code_array_25;
		case 26:
			return R.array.work_location_code_array_26;
		case 27:
			return R.array.work_location_code_array_27;
		case 28:
			return R.array.work_location_code_array_28;
		case 29:
			return R.array.work_location_code_array_29;
		case 30:
			return R.array.work_location_code_array_30;
		case 31:
			return R.array.work_location_code_array_31;
		case 32:
			return R.array.work_location_code_array_32;
		case 33:
			return R.array.work_location_code_array_33;
		case 34:
			return R.array.work_location_code_array_34;
		case 35:
			return R.array.work_location_code_array_35;
		case 36:
			return R.array.work_location_code_array_36;
		default:
			return R.array.work_location_code_array_0;
		}
	}

	public static boolean isMunicipality(int locIndex) {
		switch (locIndex) {
		case 0:
		case 1:
		case 8:
		case 21:
			return true;
		default:
			return false;
		}
	}
}
