package com.iyouxun.j_libs.activities;

import com.iyouxun.j_libs.utils.J_HomeKeyWatcher;
import com.iyouxun.j_libs.utils.J_HomeKeyWatcher.OnHomePressedListener;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

public abstract class J_BaseFragmentActivity extends FragmentActivity {
	private Context context;
	private J_HomeKeyWatcher homeKeyWatcher;
	private static boolean IS_GO_BACKGROUND = false;
	private static boolean IS_APP_RUNNING = false;

	@Override
	protected void onCreate(Bundle arg0) {
		super.onCreate(arg0);
		context = this;
		if (!IS_APP_RUNNING) {
			IS_APP_RUNNING = true;
			onAppStart();
		}

		homeKeyWatcher = new J_HomeKeyWatcher(context);
		homeKeyWatcher.setOnHomePressedListener(new OnHomePressedListener() {
			@Override
			public void onHomePressed() {
				// Log.i("PPP", "程序进入后台");
				IS_GO_BACKGROUND = true;
				onAppGoBackground();
			}

			@Override
			public void onHomeLongPressed() {

			}
		});
	}

	@Override
	protected void onResume() {
		super.onResume();
		if (IS_GO_BACKGROUND) {
			IS_GO_BACKGROUND = false;
			// Log.i("PPP", "程序进入前台");
			onAppBringToFront();
		}
		homeKeyWatcher.startWatch();
	}

	@Override
	protected void onPause() {
		super.onPause();
		homeKeyWatcher.stopWatch();
	}

	protected void onAppQuit() {
	}

	protected abstract void onAppStart();

	protected abstract void onAppGoBackground();

	protected abstract void onAppBringToFront();

}
