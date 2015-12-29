package com.iyouxun.utils;

import com.iyouxun.J_Application;
import com.iyouxun.R;

/**
 * 个人资料
 * 
 * @ClassName: ProfileUtils
 * @author likai
 * @date 2015-3-3 下午1:23:12
 * 
 */
public class ProfileUtils {
	public static String[] arr;

	// ----- Basic information ----//
	public static final int PROFILE_NAME = 1;
	public static final int PROFILE_SEX = 2;
	public static final int PROFILE_NICKNAME = 3;
	public static final int PROFILE_GROUP_ID = 4;
	public static final int PROFILE_BIRTHDAY = 5;
	public static final int PROFILE_BIRTHYEAR = 6;
	public static final int PROFILE_AGE = 21;

	/**
	 * 获取星座
	 * 
	 * @Title: getStar
	 * @return String 返回类型
	 * @param @param ctx
	 * @param @param star
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getStar(int key) {
		String result = "";
		arr = J_Application.context.getResources().getStringArray(R.array.profile_zodiac_array);
		if (key >= 1 && key <= arr.length) {
			result = arr[key - 1];
		}
		return result;
	}

	/**
	 * 通过星座名称获取星座code
	 * 
	 * @Title: getStarCodeFromStarName
	 * @return int 返回类型
	 * @param @param starName
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static int getStarCodeFromStarName(String starName) {
		int starCode = 1;
		arr = J_Application.context.getResources().getStringArray(R.array.profile_zodiac_array);
		for (int i = 0; i < arr.length; i++) {
			if (arr[i].equals(starName)) {
				starCode = i + 1;
			}
		}
		return starCode;
	}

	/**
	 * 获取生肖
	 * 
	 * @Title: getBirthPet
	 * @return String 返回类型
	 * @param @param ctx
	 * @param @param birthPet
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getBirthPet(int key) {
		String result = "";
		arr = J_Application.context.getResources().getStringArray(R.array.profile_chinese_zodiac_array);
		if (key >= 1 && key <= arr.length) {
			result = arr[key - 1];
		}
		return result;
	}

	/**
	 * 通过生肖名称获取生肖code
	 * 
	 * @Title: getBirthPetCodeFromName
	 * @return int 返回类型
	 * @param @param petName
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static int getBirthPetCodeFromName(String petName) {
		int petCode = 1;
		arr = J_Application.context.getResources().getStringArray(R.array.profile_chinese_zodiac_array);
		for (int i = 0; i < arr.length; i++) {
			if (arr[i].equals(petName)) {
				petCode = i + 1;
			}
		}
		return petCode;
	}

	/**
	 * 获取用户性别
	 * 
	 * @Title: getSex
	 * @return String 返回类型
	 * @param @param sex
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getSex(int sex) {
		arr = J_Application.context.getResources().getStringArray(R.array.profile_sex_array);
		return arr[sex];
	}

	/**
	 * 获取身高
	 * 
	 * @Title: getHeight
	 * @return String 返回类型
	 * @param @param height
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getHeight(int height) {
		String result = "";
		arr = J_Application.context.getResources().getStringArray(R.array.profile_height_array);
		if (height >= 1 && height <= arr.length) {
			result = arr[height - 1];
		}
		return result;
	}

	/**
	 * 获取体重
	 * 
	 * @Title: getWeight
	 * @return String 返回类型
	 * @param @param weight
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getWeight(int weight) {
		String result = "";
		arr = J_Application.context.getResources().getStringArray(R.array.profile_weight_array);
		if (weight >= 1 && weight <= arr.length) {
			result = arr[weight - 1];
		}
		return result;
	}

	/**
	 * 获取职业信息
	 * 
	 * @Title: getCareer
	 * @return String 返回类型
	 * @param @param career
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getCareer(int key) {
		String result = "";
		arr = J_Application.context.getResources().getStringArray(R.array.profile_career_array);
		if (key >= 1 && key <= arr.length) {
			result = arr[key - 1];
		}
		return result;
	}

	/**
	 * 获取情感状况
	 * 
	 * @Title: getMarriage
	 * @return String 返回类型
	 * @param @param marriage
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getMarriage(int key) {
		String result = "";
		arr = J_Application.context.getResources().getStringArray(R.array.profile_marriage_array);
		if (key >= 1 && key <= arr.length) {
			result = arr[key - 1];
		}
		return result;
	}

	/**
	 * 计算星座
	 * 
	 * @Title: star
	 * @return String 返回类型
	 * @param @param month
	 * @param @param day
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String computeStar(int month, int day) {
		String[] zodiac_array = J_Application.context.getResources().getStringArray(R.array.profile_zodiac_array);
		int zodiac = 0;
		String birthday_str = "";
		if (day < 10) {
			birthday_str = month + "0" + day;
		} else {
			birthday_str = month + "" + day;
		}
		int birthday = Util.getInteger(birthday_str);
		if (birthday > 320 && birthday < 420) {
			zodiac = 1;
		} else if (birthday > 419 && birthday < 521) {
			zodiac = 2;
		} else if (birthday > 520 && birthday < 622) {
			zodiac = 3;
		} else if (birthday > 621 && birthday < 723) {
			zodiac = 4;
		} else if (birthday > 722 && birthday < 823) {
			zodiac = 5;
		} else if (birthday > 822 && birthday < 923) {
			zodiac = 6;
		} else if (birthday > 922 && birthday < 1024) {
			zodiac = 7;
		} else if (birthday > 1023 && birthday < 1122) {
			zodiac = 8;
		} else if (birthday > 1121 && birthday < 1222) {
			zodiac = 9;
		} else if ((birthday > 1221 && birthday < 1232) || (birthday > 100 && birthday < 120)) {
			zodiac = 10;
		} else if (birthday > 119 && birthday < 219) {
			zodiac = 11;
		} else if (birthday > 218 && birthday < 321) {
			zodiac = 12;
		}

		return zodiac_array[zodiac - 1];
	}

	/**
	 * 计算生肖
	 * 
	 * @Title: sxiao
	 * @return String 返回类型
	 * @param @param year
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String computeBirthpet(int birth_year, int month, int day) {
		// 生肖数组
		String[] animal_array = J_Application.context.getResources().getStringArray(R.array.profile_chinese_zodiac_array);
		// 年份数组
		String[] springfestival_year_array = J_Application.context.getResources().getStringArray(
				R.array.profile_springfestival_year);
		// 年份对应的新年日期数组
		String[] springfestival_day_array = J_Application.context.getResources().getStringArray(
				R.array.profile_springfestival_monthday);

		// 计算出年份所在序列
		int yearIndex = 0;
		for (int i = 0; i < springfestival_year_array.length; i++) {
			if (Util.getInteger(springfestival_year_array[i]) == birth_year) {
				yearIndex = i;
			}
		}

		// 计算生日日期
		String birth_day = "";
		if (day < 10) {
			birth_day = month + "0" + day;
		} else {
			birth_day = month + "" + day;
		}
		int birthday = Util.getInteger(birth_day);

		// birth_year对应的新年日期
		int spring_day = Util.getInteger(springfestival_day_array[yearIndex]);

		// 获取真正计算属相生肖的年份
		int birth_year_lunar = 0;
		if (birthday < spring_day) {
			// 如果在新年前一天，为上一年生肖
			birth_year_lunar = birth_year - 1;
		} else {
			// 如果在新年一天及之后出生，为当年生肖
			birth_year_lunar = birth_year;
		}

		int animal = (birth_year_lunar - 1923 + 120) % 12;
		if (animal == 0) {
			animal = 12;
		}

		return animal_array[animal - 1];
	}

	/**
	 * 通过消息类型id获取该消息的文字含义
	 * 
	 * @Title: getSystemMsgInfoFromTypeId
	 * @return String 返回类型
	 * @param @param typeId
	 * @param 参数类型
	 * 
	 *            如：20=>"被回复评论"
	 * 
	 * @author likai
	 * @throws
	 */
	public static String getSystemMsgInfoFromTypeId(int typeId) {
		String[] titleInfos = J_Application.context.getResources().getStringArray(R.array.system_msg_info);
		if (typeId >= 0 && typeId < titleInfos.length) {
			return titleInfos[typeId];
		} else {
			return "";
		}
	}

	/**
	 * 通过消息类型id获取该消息对应的name
	 * 
	 * @Title: getSystemMsgTypeNameFromTypeId
	 * @return String 返回类型
	 * @param @param typeId
	 * @param @return 参数类型
	 * 
	 *        如：20=>"reply"
	 * 
	 * @author likai
	 * @throws
	 */
	public static String getSystemMsgTypeNameFromTypeId(int typeId) {
		String[] typeNames = J_Application.context.getResources().getStringArray(R.array.system_msg_type_info);
		if (typeId >= 0 && typeId < typeNames.length) {
			return typeNames[typeId];
		} else {
			return "";
		}
	}
}
