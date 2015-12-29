package com.iyouxun.location;

import java.math.BigDecimal;

import com.iyouxun.data.beans.LocationInfo;

public class J_LocationPoint {
	public LocationInfo locationInfo;
	/**
	 * 经度
	 */
	private double longitude = -1;
	/**
	 * 纬度
	 */
	private double latitude = -1;

	public J_LocationPoint() {

	}

	/**
	 * 
	 * @param longitude 经度
	 * @param latitude 纬度
	 */
	public J_LocationPoint(double longitude, double latitude) {
		this.longitude = longitude;
		this.latitude = latitude;
	}

	public String getLongitude() {
		BigDecimal bd1 = new BigDecimal(longitude);
		return bd1.setScale(4, BigDecimal.ROUND_DOWN).toString();
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public String getLatitude() {
		BigDecimal bd2 = new BigDecimal(latitude);
		return bd2.setScale(4, BigDecimal.ROUND_DOWN).toString();
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

}
