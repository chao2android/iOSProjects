package com.iyouxun.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;

/**
 * 解析语音文件长度 AMR文件操作
 */
public class AmrFile {
	// 给出文件长度
	public static long getFileLength(String file) {
		long length = -1;
		File f = new File(file);
		try {
			FileInputStream fis = new FileInputStream(f);
			try {
				length = fis.available();
				fis.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return length;
	}

	/**
	 * 得到amr的时长
	 * 
	 * @param file
	 * @return
	 * @throws IOException
	 */
	public static long getAmrDuration(File file) throws IOException {
		long duration = -1;
		int[] packedSize = { 12, 13, 15, 17, 19, 20, 26, 31, 5, 0, 0, 0, 0, 0, 0, 0 };
		RandomAccessFile randomAccessFile = null;
		try {
			randomAccessFile = new RandomAccessFile(file, "rw");
			long length = file.length();// 文件的长度
			int pos = 6;// 设置初始位置
			int frameCount = 0;// 初始帧数
			int packedPos = -1;
			// ///////////////////////////////////////////////////
			byte[] datas = new byte[1];// 初始数据值
			while (pos <= length) {
				randomAccessFile.seek(pos);
				if (randomAccessFile.read(datas, 0, 1) != 1) {
					duration = length > 0 ? ((length - 6) / 650) : 0;
					break;
				}
				packedPos = (datas[0] >> 3) & 0x0F;
				pos += packedSize[packedPos] + 1;
				frameCount++;
			}
			// ///////////////////////////////////////////////////
			duration += frameCount * 20;// 帧数*20
		} finally {
			if (randomAccessFile != null) {
				randomAccessFile.close();
			}
		}
		return duration;
	}

	// 按文件给出声音长度(毫秒)
	public static long getVoiceLength(String file) {
		long voiceframelength = -1;
		long flength = -1;
		long voicelength = -1;
		File f = new File(file);
		try {
			FileInputStream fis = new FileInputStream(f);
			try {
				flength = fis.available();
				byte[] data = new byte[10];
				fis.read(data, 0, 10);
				switch (data[6]) {
				case 0x04:
					voiceframelength = 13;
					break;
				case 0x0c:
					voiceframelength = 14;
					break;
				case 0x14:
					voiceframelength = 16;
					break;
				case 0x1c:
					voiceframelength = 18;
					break;
				case 0x24:
					voiceframelength = 20;
					break;
				case 0x2c:
					voiceframelength = 21;
					break;
				case 0x34:
					voiceframelength = 27;
					break;
				case 0x3c:
					voiceframelength = 32;
					break;
				}
				fis.close();
				voicelength = (flength - 6) / voiceframelength / 50;
			} catch (IOException e) {
				voicelength = -1;
				e.printStackTrace();
			}
		} catch (FileNotFoundException e) {
			voicelength = -1;
			e.printStackTrace();
		}
		return voicelength * 1000;

	}

	// 格式化输出声音长度(时:分:秒)
	public static String getVoiceLengthByString(String file) {
		long voicelength = getVoiceLength(file);
		String voicestr = "";
		if (voicelength / 3600 > 0) {
			voicestr = String.format("%d:%d:%d", voicelength / 3600, voicelength / 60, voicelength % 60);
		} else if (voicelength / 60 > 0 && voicelength / 3600 == 0) {
			voicestr = String.format("%d:%d", voicelength / 60, voicelength % 60);
		} else if (voicelength > 0) {
			voicestr = String.format("%d\"", voicelength);
		} else {
			return "1\"";
		}
		return voicestr;
	}

	// 格式化输出声音长度(时:分:秒)
	public static String getVoiceLengthToString(long voicelength) {
		String voicestr = "";
		if (voicelength / 3600 > 0) {
			voicestr = String.format("%d:%d:%d", voicelength / 3600, voicelength / 60, voicelength % 60);
		} else if (voicelength / 60 > 0 && voicelength / 3600 == 0) {
			voicestr = String.format("%d:%d", voicelength / 60, voicelength % 60);
		} else if (voicelength > 0) {
			voicestr = String.format("%d\"", voicelength);
		} else {
			return "1\"";
		}
		return voicestr;
	}
}
