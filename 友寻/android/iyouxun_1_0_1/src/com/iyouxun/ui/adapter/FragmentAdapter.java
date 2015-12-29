package com.iyouxun.ui.adapter;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.view.ViewGroup;

import com.iyouxun.utils.DLog;

public class FragmentAdapter extends FragmentStatePagerAdapter {

	private final String[] classNames;
	private final Context mContext;
	private final Bundle[] mBundles;

	public FragmentAdapter(FragmentManager fm, Context context, String[] classNames, Bundle[] bundles) {
		super(fm);
		this.classNames = classNames;
		mContext = context;
		mBundles = bundles;
	}

	@Override
	public Fragment getItem(int position) {
		DLog.i("TTT", "getItem()  " + position);
		if (mBundles == null) {
			return Fragment.instantiate(mContext, classNames[position]);
		} else {
			return Fragment.instantiate(mContext, classNames[position], mBundles[position]);
		}
	}

	@Override
	public void destroyItem(ViewGroup container, int position, Object object) {
		super.destroyItem(container, position, object);
		DLog.i("TTT", "destroyItem()  " + position);
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return classNames.length;
	}
}
