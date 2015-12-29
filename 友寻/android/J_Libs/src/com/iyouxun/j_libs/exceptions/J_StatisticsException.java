package com.iyouxun.j_libs.exceptions;

public class J_StatisticsException extends Exception {
	
	public J_StatisticsException() {
    }

    public J_StatisticsException(String detailMessage) {
        super(detailMessage);
    }

    public J_StatisticsException(String detailMessage, Throwable throwable) {
        super(detailMessage, throwable);
    }

}
