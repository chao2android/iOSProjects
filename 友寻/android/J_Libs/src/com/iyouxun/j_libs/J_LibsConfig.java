package com.iyouxun.j_libs;

import android.os.Environment;

import com.iyouxun.j_libs.json.parser.J_JsonParser;

public class J_LibsConfig {
	/**
	 * 当前接口环境 1:测试环境，2：预上线，3：正式
	 */
	public int API_SETTING = 1;

	/**
	 * 临时文件保存路径
	 */
	public static String TEMP_FILE_DIR = Environment.getExternalStorageDirectory() + "/iyouxun/";
	/**
	 * 文件存储根目录
	 * 
	 * */
	public static String FILE_STORE_ROOT_PATH = "iyouxun/";
	/**
	 * 文件存储目录
	 */
	public static String FILE_STORE_PATH = "iyouxun/fileStores";
	/**
	 * Json解析器
	 */
	private J_JsonParser j_JsonParser = null;
	/**
	 * 是否允许打印LOG
	 */
	public boolean LOG_ENABLE = true;
	/**
	 * LOG的TAG
	 */
	public String LOG_TAG = "J_Libs";
	/**
	 * 默认开启crash的日志抓取
	 */
	public boolean CRASH_LOG_ENABLE = true;
	/**
	 * 崩溃日志保存的路径
	 */
	public String CRASH_LOG_PATH = Environment.getExternalStorageDirectory() + "/iyouxun/log";
	/**
	 * 崩溃日志的TAG
	 */
	public String CRASH_LOG_TAG = "J_Crash";

	// ------------------以下为软件版本信息----------------------
	/**
	 * 客户端ID
	 */
	public String CLIENT_ID = "";
	/**
	 * 客户端渠道号
	 */
	public String CHANNEL_ID = "";
	/**
	 * 客户端版本号
	 */
	public String APP_VERSION = "";
	/**
	 * 运营商CODE
	 */
	public String OPERATOR_CODE = "";
	/**
	 * 客户端IMEI
	 */
	public String DEVICE_IMEI = "";
	/**
	 * 手机型号
	 */
	public String MOBILE_MODEL = "";
	/**
	 * 系统版本号
	 */
	public String SYSTEM_VERSION = "";
	/**
	 * 使用者UID，（例如：APP正在使用该SDK，则UID为登陆用户的UID）
	 */
	public String USER_ID = "";
	/**
	 * 屏幕宽度
	 */
	public String SCREEN_WIDTH = "";
	/**
	 * 屏幕长度
	 */
	public String SCREEN_HEIGHT = "";

	/**
	 * 获取当前Json解析器
	 * 
	 * @return
	 */
	public J_JsonParser getJ_JsonParser() {
		return j_JsonParser;
	}

	/**
	 * 设置当前Json解析器
	 * 
	 * @param j_JsonParser
	 */
	public void setJ_JsonParser(J_JsonParser j_JsonParser) {
		this.j_JsonParser = j_JsonParser;
	}

}
