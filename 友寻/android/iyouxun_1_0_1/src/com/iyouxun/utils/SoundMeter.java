package com.iyouxun.utils;

import java.io.IOException;

import android.content.Context;
import android.media.MediaRecorder;
import android.os.Environment;

import com.iyouxun.j_libs.file.FileStore;
import com.iyouxun.j_libs.managers.J_FileManager;

public class SoundMeter {
	private static final double EMA_FILTER = 0.6;
	private MediaRecorder mRecorder = null;
	private double mEMA = 0.0;
	private FileStore fs;
	private final Context context;

	public SoundMeter(Context ctx) {
		this.context = ctx;
		if (fs == null) {
			fs = J_FileManager.getInstance().getFileStore();
		}
	}

	/**
	 * 开始录音
	 * 
	 * */
	public void start(String name) {
		if (!Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED)) {
			return;
		}
		if (mRecorder == null) {
			mRecorder = new MediaRecorder();
		}
		try {
			mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);// 设置麦克风
			mRecorder.setOutputFormat(MediaRecorder.OutputFormat.RAW_AMR);// 设置输出文件格式
			mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
			// 设置存储目录
			String savePath = fs.getFileSdcardAndRamPathOnly(name, null);
			// 设置输出的音频文件地址
			mRecorder.setOutputFile(savePath);
			// 准备
			mRecorder.prepare();
			// 开始
			mRecorder.start();
			mEMA = 0.0;
		} catch (IOException e) {
			e.printStackTrace();
			mRecorder.reset();
			mRecorder.release();
			mRecorder = null;
			return;
		}
	}

	/**
	 * 停止
	 * 
	 * */
	public void stop() {
		if (mRecorder != null) {
			mRecorder.stop();
			mRecorder.release();
			mRecorder = null;
		}
	}

	/**
	 * 暂停
	 * 
	 * */
	public void pause() {
		if (mRecorder != null) {
			mRecorder.stop();
		}
	}

	/**
	 * 开始
	 * 
	 * */
	public void start() {
		if (mRecorder != null) {
			mRecorder.start();
		}
	}

	/**
	 * 获取振幅
	 * 
	 * */
	public double getAmplitude() {
		if (mRecorder != null) {
			return (mRecorder.getMaxAmplitude() / 2700.0);
		} else {
			return 0;
		}
	}

	/**
	 * 
	 * 
	 * */
	public double getAmplitudeEMA() {
		double amp = getAmplitude();
		mEMA = EMA_FILTER * amp + (1.0 - EMA_FILTER) * mEMA;
		return mEMA;
	}
}
