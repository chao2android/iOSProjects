package com.iyouxun.utils;

import java.io.IOException;

import com.iyouxun.J_Application;
import com.iyouxun.j_libs.log.J_Log;
import android.content.Context;
import android.graphics.drawable.AnimationDrawable;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.widget.ImageView;

/**
 * 语音播放
 */
public class R_AudioPlayer {

	private SensorManager _sensorManager = null; // 传感器管理器
	private Sensor mProximiny = null; // 传感器实例
	private float f_proximiny; // 当前传感器距离
	private SensorEventListener mSensorListener;

	private static R_AudioPlayer audioPlayer;

	private MediaPlayer mediaPlayer;
	private final AudioManager manager;

	private OnFinishCallback callback;

	private R_AudioPlayer() {
		manager = (AudioManager) J_Application.context.getSystemService(Context.AUDIO_SERVICE);
	}

	public static String path = "";
	public static boolean isPlaying = false;

	public static R_AudioPlayer getInstance() {
		if (audioPlayer == null) {
			audioPlayer = new R_AudioPlayer();
		}
		return audioPlayer;
	}

	// public boolean isPlaying(){
	// if(audioPlayer != null){
	// return audioPlayer.isPlaying();
	// }
	// return false ;
	// }

	/**
	 * 播放指定的音频文件
	 * 
	 * @param path 文件所在路径
	 * @param imageView 语音播放动画标识图标
	 * @param callback 播放结束回调
	 * @param isComMsg 消息来源：发送:false // 接收:true
	 * @throws IllegalArgumentException
	 * @throws SecurityException
	 * @throws IllegalStateException
	 * @throws IOException
	 */
	public void playFile(String path, final ImageView imageView, final OnFinishCallback callback, final boolean isComMsg)
			throws IllegalArgumentException, SecurityException, IllegalStateException, IOException {

		this.path = path;
		if (mediaPlayer != null) {
			stopPlayAndRelease();
		} else {// 读取传感器
			// 读取缓存的录音播放模式：听筒或是正常播放
			// if (DataUtil.getStringXmlData(J_Application.context, "uid",
			// "voicestatus").equals("all")) {
			_sensorManager = (SensorManager) J_Application.context.getSystemService(Context.SENSOR_SERVICE);
			_sensorManager.registerListener(mSensorListener, mProximiny, SensorManager.SENSOR_DELAY_NORMAL);
			mProximiny = _sensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY);
			mSensorListener = new SensorEventListener() {
				@Override
				public void onAccuracyChanged(Sensor sensor, int accuracy) {
				}

				@Override
				public void onSensorChanged(SensorEvent event) {
					if (event.sensor.getType() != Sensor.TYPE_PROXIMITY)
						return;
					f_proximiny = event.values[0];
					J_Log.v("-->  " + f_proximiny + "  |  " + mProximiny.getMaximumRange());
					if (f_proximiny > mProximiny.getMaximumRange()) {
						setOpenSpeaker(true);
					} else {
						setOpenSpeaker(false);
					}
				}
			};
			setOpenSpeaker(true);
			// } else {
			// setOpenSpeaker(false);
			// }
		}

		this.callback = callback;

		if (imageView != null) {
			/*
			 * 用于播放界面内可见的语音,如果imageView为null,则播放语音的位置不在可见区域内,
			 * 此时只播放语音,不对View进行处理.
			 */
			if (isComMsg) {
				// imageView.setBackgroundResource(R.anim.record_anim);
			} else {
				// imageView.setBackgroundResource(R.anim.record_anim);
			}
			imageView.setImageBitmap(null);
			final AnimationDrawable animationDrawable = (AnimationDrawable) imageView.getBackground();
			animationDrawable.start();

			mediaPlayer = new MediaPlayer();
			mediaPlayer.setOnCompletionListener(new OnCompletionListener() {

				@Override
				public void onCompletion(MediaPlayer mp) {
					if (mediaPlayer != null) {
						mediaPlayer.stop();
						mediaPlayer.release();
						mediaPlayer = null;
						animationDrawable.stop();
						if (isComMsg) {
							// imageView.setImageResource(R.drawable.audio_running1);
						} else {
							// imageView.setImageResource(R.drawable.audio_running2);
						}

						imageView.setBackgroundDrawable(null);
						callback.onPlayFinish();
					}

				}
			});
		} else {/* 用于播放界面内不可见的语音 */
			mediaPlayer = new MediaPlayer();
			mediaPlayer.setOnCompletionListener(new OnCompletionListener() {
				@Override
				public void onCompletion(MediaPlayer mp) {
					if (mediaPlayer != null) {
						mediaPlayer.stop();
						mediaPlayer.release();
						mediaPlayer = null;
						callback.onPlayFinish();
					}
				}
			});
		}

		// File file = new File(path);
		// FileInputStream stream = new FileInputStream(file);
		mediaPlayer.setDataSource(path);
		mediaPlayer.prepare();
		isPlaying = true;
		mediaPlayer.start();

	}

	/**
	 * 播放完成回调接口
	 */
	public interface OnFinishCallback {
		public abstract void onPlayFinish();
	}

	/**
	 * 停止Mediaplayer的播放行为
	 */
	public void stopPlayAndRelease() {
		if (mediaPlayer != null && mediaPlayer.isPlaying()) {
			mediaPlayer.stop();
			mediaPlayer.release();
			mediaPlayer = null;
			isPlaying = false;
		}
	}

	/**
	 * 停止播放
	 * 
	 * @param imageView 需要设置的图片
	 * @param isComMsg 设置为接受或者发送
	 */
	public void stopPlay(ImageView imageView, boolean isComMsg) {

		if (imageView != null) {
			imageView.setBackgroundDrawable(null);
			if (isComMsg) {
				// imageView.setImageResource(R.drawable.audio_running1);
			} else {
				// imageView.setImageResource(R.drawable.audio_running1);
			}

		}

		if (mediaPlayer != null && mediaPlayer.isPlaying()) {
			mediaPlayer.stop();
			mediaPlayer.release();
			mediaPlayer = null;

		}
		AudioManager manager = (AudioManager) J_Application.context.getSystemService(Context.AUDIO_SERVICE);
		// manager.setMode(AudioManager.MODE_NORMAL);
		if (mSensorListener != null)
			_sensorManager.unregisterListener(mSensorListener);
		isPlaying = false;
	}

	// public void stopPlayAndRelease(AnimationDrawable animationDrawable,
	// imageView){
	// if(mediaPlayer != null && mediaPlayer.isPlaying()){
	// mediaPlayer.stop();
	// mediaPlayer.release();
	// mediaPlayer = null ;
	// animationDrawable.stop();
	// imageView.setImageResource(R.drawable.voice_logo);
	// imageView.setBackgroundDrawable(null);
	//
	// }
	// }
	public void setOpenSpeaker(boolean isOpen) {
		if (isOpen) {
			manager.setMode(AudioManager.MODE_NORMAL);
		} else {
			manager.setMode(AudioManager.MODE_IN_CALL);
		}

	}
}
