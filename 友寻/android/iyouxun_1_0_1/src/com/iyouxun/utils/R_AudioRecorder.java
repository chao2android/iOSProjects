package com.iyouxun.utils;

import java.io.File;
import java.io.IOException;

import com.iyouxun.consts.J_Consts;
import android.media.MediaRecorder;
import android.media.MediaRecorder.OnErrorListener;

/**
 * 录制语音
 */
public class R_AudioRecorder {
	/**
	 * 单声道
	 */
	public static final int AUDIO_CHANNEL_SINGLE = 1;
	/**
	 * 多声道/双声道
	 */
	public static final int AUDIO_CHANNEL_MORE = 2;
	private MediaRecorder recorder;
	private static R_AudioRecorder self;

	private R_AudioRecorder() {
	};

	public static R_AudioRecorder getInstance() {
		if (self == null) {
			self = new R_AudioRecorder();
		}
		return self;
	}

	/**
	 * 该方法默认单声道、采样率3000，类似微信等语音录制可直接调用
	 * 
	 * @param path 要保存的文件的绝对地址，如果文件已经存在则会被替换
	 * @throws IllegalStateException
	 * @throws IOException
	 */
	public void startRecord(String path) throws IllegalStateException, IOException {
		record(path, AUDIO_CHANNEL_SINGLE, 3000);
	}

	/**
	 * 开始语音录制
	 * 
	 * @param path 要保存的文件的绝对地址 如果文件已经存在那么会被替换
	 * @param channel 声道配置，1为单声道，2为多声道
	 * @param rate 采样率 一般4000
	 * @throws IllegalStateException
	 * @throws IOException
	 */
	public void startRecord(String path, int channel, int rate) throws IllegalStateException, IOException {
		record(path, channel, rate);
	}

	private void record(String path, int channel, int rate) throws IllegalStateException, IOException {

		File file = new File(path);

		if (file.exists()) {
			file.delete();
		}

		file.createNewFile();

		if (recorder != null) {
			stopRecord();
		}

		recorder = new MediaRecorder();
		recorder.setAudioSource(MediaRecorder.AudioSource.MIC);
		recorder.setOutputFormat(MediaRecorder.OutputFormat.AMR_NB);
		recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
		recorder.setAudioChannels(channel);
		recorder.setAudioEncodingBitRate(rate);
		recorder.setMaxDuration(J_Consts.RECORD_MAX_TIME);
		recorder.setOutputFile(path);
		recorder.setOnErrorListener(new OnErrorListener() {

			@Override
			public void onError(MediaRecorder mr, int what, int extra) {
				DLog.i("AAA", "record error");
			}
		});
		recorder.prepare();
		recorder.start();
	}

	/**
	 * 停止录制并释放
	 */
	public void stopRecord() {
		if (recorder != null) {
			recorder.stop();
			recorder.release();
			recorder = null;
		}
	}

}
