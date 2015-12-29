package com.iyouxun.j_libs.managers;

import java.util.HashMap;
import java.util.Map.Entry;

import android.content.Context;
import android.view.LayoutInflater;

import com.iyouxun.j_libs.R;
import com.iyouxun.j_libs.advert.Advertisement;
import com.iyouxun.j_libs.advert.BillBoard;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.j_libs.utils.J_CommonUtils;

public class J_AdvertManager {
	
	public interface onAdvertClickListener{
		public void onAdvertClicked(String channel , Advertisement advert);
	}
	
	private static J_AdvertManager self = null ;
	
	private onAdvertClickListener advertClickListener = null;
	
	private HashMap<String, BillBoard> boards = null ;
	
	private J_AdvertManager(){
		boards = new HashMap<String, BillBoard>();
	}
	
	public static J_AdvertManager getInstance(){
		if(self == null){
			self = new J_AdvertManager();
		}
		return self ;
	}
	
	public void setOnAdvertClickListener(onAdvertClickListener advertClickListener){
		this.advertClickListener = advertClickListener ;
	}
	
	public onAdvertClickListener getOnAdvertClickListener(){
		return advertClickListener ;
	}
	
	/**
	 * 创建一个新的布告板
	 * @param context
	 * @param name          布告板的名称，用于根据名称获取布告板使用
	 * @return
	 */
	public BillBoard createNewBoard(Context context,String name){
		BillBoard billBoard = (BillBoard) LayoutInflater.from(context).inflate(R.layout.ad_view, null);
		boards.put(name, billBoard);
		return billBoard ;
	}
	
	public BillBoard getBillBoardByName(String name){
		return boards.get(name);
	}
	
	
	public void destroyAllBoards(){
		for(Entry<String, BillBoard> entry : boards.entrySet()){
			entry.getValue().clearCache() ;
			boards.remove(entry);
		}
	}
	
	public void destroyBoardsByKey(String key){
		if(boards.containsKey(key)){
			boards.get(key).clearCache();
			boards.remove(key);
		}
	}
	
	
	public void sendAdvertFeedback(J_Request request){
		J_NetManager.getInstance().sendRequest(request);
	}
	
	public int parserViewStatus(String status){
		if(J_CommonUtils.isEmpty(status)){
			return BillBoard.AD_STATUS_HIDDEN ;
		}
		
		if(status.equals("show")){
			return BillBoard.AD_STATUS_SHOW ;
		}
		if(status.equals("hidden")){
			return BillBoard.AD_STATUS_HIDDEN ;
		}
		if(status.equals("default")){
			return BillBoard.AD_STATUS_DEFAULT ;
		}
		
		return BillBoard.AD_STATUS_HIDDEN ;
		
	}

}
