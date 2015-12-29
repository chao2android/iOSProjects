package com.iyouxun.utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import android.content.Context;
import android.os.Environment;

import com.iyouxun.J_Application;
import com.iyouxun.j_libs.J_SDK;

/**
 * Log统一管理工具类
 * 
 * @author JustMe
 * 
 */
public class DLog {
	/**
	 * 开发阶段设为true
	 */
	public static boolean printLog = J_SDK.getConfig().LOG_ENABLE;
	private static boolean printClassLog = printLog;

	public static boolean D = printLog;
	public static boolean V = printLog;
	public static boolean I = printLog;
	public static boolean W = printLog;
	public static boolean E = printLog;

	public final static String FILE_DIR_NAME = "Log";
	public final static String FILE_NAME = "Iyouxun.log";

	public static void d(String tag, String msg) {
		if (!D || msg == null) {
			return;
		}
		android.util.Log.d(tag, msg);
	}

	public static void d(String tag, String msg, Throwable tr) {
		if (!D || msg == null) {
			return;
		}
		android.util.Log.d(tag, msg, tr);
	}

	public static void v(String tag, String msg) {
		if (!V || msg == null) {
			return;
		}
		android.util.Log.v(tag, msg);
	}

	public static void v(String tag, String msg, Throwable tr) {
		if (!V || msg == null) {
			return;
		}
		android.util.Log.v(tag, msg, tr);
	}

	public static void i(String tag, String msg) {
		if (!I || msg == null) {
			return;
		}
		android.util.Log.i(tag, msg);
	}

	public static void i(String msg) {
		if (!I || msg == null) {
			return;
		}
		android.util.Log.i(getStackTraceName(), msg);
	}

	public static void i(String tag, String msg, Throwable tr) {
		if (!I || msg == null) {
			return;
		}
		android.util.Log.i(tag, msg, tr);
	}

	public static void w(String tag, String msg) {
		if (!W || msg == null) {
			return;
		}
		android.util.Log.w(tag, msg);
	}

	public static void w(String tag, Throwable tr) {
		if (!W) {
			return;
		}
		android.util.Log.w(tag, tr);
	}

	public static void w(String tag, String msg, Throwable tr) {
		if (!W) {
			return;
		}
		android.util.Log.w(tag, msg, tr);
	}

	public static void e(String tag, String msg) {
		if (!E || msg == null) {
			return;
		}
		android.util.Log.e(tag, msg);
	}

	public static void e(String msg) {
		if (!E || msg == null) {
			return;
		}
		android.util.Log.e(getStackTraceName(), msg);
	}

	public static void e(String tag, String msg, Throwable tr) {
		if (!E && tr != null) {
			return;
		}
		android.util.Log.e(tag, msg, tr);
	}

	public static void e(Throwable tr) {
		if (!E || tr == null) {
			return;
		}
		tr.printStackTrace();
	}

	public static String getStackTraceName() {
		if (!printClassLog) {
			return "";
		}
		StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
		String stackTraceName = null;
		if (stackTrace.length > 4) {
			stackTraceName = stackTrace[4].getClassName() + stackTrace[4].getMethodName();
		}
		return stackTraceName;
	}

	/**
	 * 将日志写到程序的文件里面
	 */
	public static void writeToFile(String msg) {
		try {
			File fileDir = J_Application.context.getDir(FILE_DIR_NAME, Context.MODE_PRIVATE);
			String filePath = fileDir.getAbsolutePath() + File.separator + FILE_NAME;
			StreamUtil.saveStringToFile(msg, filePath);
		} catch (IOException e) {
			i("", "书写日志发生错误：" + e.toString());
		}
	}

	/**
	 * 将日志写到SD卡里面
	 */
	public static void writeToSDCard(String msg) {
		writeToSDCard(null, msg);
	}

	/**
	 * 将日志写到SD卡里面，同时输出log日志
	 */
	public static void writeToSDCard(String tag, String msg) {
		if (printLog && msg != null) {
			if (tag != null) {
				DLog.i(tag, msg);
			}

			FileWriter fw = null;
			try {
				File file = new File(Environment.getExternalStorageDirectory() + "/" + FILE_NAME);
				if (!file.exists()) {
					file.createNewFile();
				} else if (file.length() > 10 * 1024) {
					file.delete();
					file.createNewFile();
				}
				fw = new FileWriter(file, true);
				fw.write(TimeUtil.getTimeStamp() + " : " + msg + "\r\n");
			} catch (Exception e) {
				i("", "书写日志发生错误：" + e.toString());
			} finally {
				try {
					if (fw != null) {
						fw.close();
					}
				} catch (IOException e) {
				}
			}
		}
	}

}
