package com.iyouxun.auth;

import java.io.UnsupportedEncodingException;

import com.iyouxun.j_libs.encrypt._3DES;

public class Security {

	static{
		System.loadLibrary("jyn");
	}
	
	private static Security self = null ;
	private Security(){}
	public static Security getInstance(){
		if(self == null){
			self = new Security();
		}
		return self ;
	}
	
	public native byte[] getNewCode(String oldCode,String other);
	public native byte[] getKey();
	public native String getAlgorithm();
	
	public String getAuthCode(String oldCode,String other) throws UnsupportedEncodingException{
		
		byte[] dd = hexStringToBytes(oldCode);
		byte[] encoded2 = _3DES.decryptMode(getKey(), dd, getAlgorithm());
		return  bytesToHexString(getNewCode(new String(encoded2,"utf-8"),other));
		
	}
	
	public String getSecureCode(String code) throws UnsupportedEncodingException{
		byte[] dd = hexStringToBytes(code);
		byte[] encoded2 = _3DES.decryptMode(getKey(), dd, getAlgorithm());
		return new String(encoded2,"utf-8");
	}
	
	
	
	public static String bytesToHexString(byte[] src){  
	    StringBuilder stringBuilder = new StringBuilder("");  
	    if (src == null || src.length <= 0) {  
	        return null;  
	    }  
	    for (int i = 0; i < src.length; i++) {  
	        int v = src[i] & 0xFF;  
	        String hv = Integer.toHexString(v);  
	        if (hv.length() < 2) {  
	            stringBuilder.append(0);  
	        }  
	        stringBuilder.append(hv);  
	    }  
	    return stringBuilder.toString();  
	}  
	/** 
	 * Convert hex string to byte[] 
	 * @param hexString the hex string 
	 * @return byte[] 
	 */  
	public static byte[] hexStringToBytes(String hexString) {  
	    if (hexString == null || hexString.equals("")) {  
	        return null;  
	    }  
	    hexString = hexString.toUpperCase();  
	    int length = hexString.length() / 2;  
	    char[] hexChars = hexString.toCharArray();  
	    byte[] d = new byte[length];  
	    for (int i = 0; i < length; i++) {  
	        int pos = i * 2;  
	        d[i] = (byte) (charToByte(hexChars[pos]) << 4 | charToByte(hexChars[pos + 1]));  
	    }  
	    return d;  
	} 
	
	private static byte charToByte(char c) {  
	    return (byte) "0123456789ABCDEF".indexOf(c);  
	} 
	
}
