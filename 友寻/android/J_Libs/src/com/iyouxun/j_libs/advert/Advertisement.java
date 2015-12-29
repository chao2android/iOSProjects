package com.iyouxun.j_libs.advert;

import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.j_libs.utils.J_CommonUtils;

public class Advertisement {
	public static final int TYPE_IMG = 1 ;    //图片 支持Gif
	public static final int TYPE_TEXT = 2 ;   //文字
	public static final int TYPE_WEB = 3 ;   //网页广告
	public static final int TYPE_GIF = 4 ;    //图片 支持Gif
	
	public int showType = -1 ;
	public String actionType = "";
	public String imageUrl = "";
	public String status = "";
	public String target = "";
	public String ad_id = "";
	public String content = "";
	
	public String uid = "";
	public String location = "";
	public String clientVer = "";
	public String clientID = "";
	public String channelID = "";
	public String screenWidth = "";
	public String screenHeight = "";
	public String pin = "";
	public String product = "";
	
	public String jsonData = "";
    
	public String webUrl;
	
    public Advertisement (){}
    public Advertisement (String jsonStr){
    	analysis(jsonStr);
    }
    
    
    public void analysis(String jsonStr){
			try {
				JSONObject rtnJson = new JSONObject(jsonStr);
				analysis(rtnJson);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			
    }
    
//	{"retcode":1,"status":"show",
//	"adlist":[{"actionType":"www","showType":1,
//	"target":"http://w.jiayuan.com/mkt/adwwwclk?uid=86271357&" +
//	"location=location1_top&product=2&ad_id=1216&clientVer=4.10&clientID=13&channelID=000&" +
//	"screenWidth=720&screenHeight=1184&pin=E3061A3FC6584A81D43FEC3E8DEA5429_86271357",
//	"ad_id":1216,"imageUrl":"http://images1.jyimg.com/w4/wap/i/p/images/mkt/zan/03.png"}],"play_model":0}
    public void analysis(JSONObject rtnJson){
    	jsonData = rtnJson.toString();
    	try {
    			actionType = rtnJson.getString("actionType");//www 或者 view
    			showType = rtnJson.getInt("showType");// 1 图片   2文字  3Gif   4wevView
    			if(showType == TYPE_IMG || showType == TYPE_GIF){
    				imageUrl = rtnJson.getString("imageUrl");
    			}else if(showType == TYPE_TEXT){
    				content = rtnJson.getString("content");
    			}else if(showType == TYPE_WEB){
    				webUrl= rtnJson.getString("webUrl");
    			}
    			target = rtnJson.getString("target");//往哪跳
    			ad_id = rtnJson.getString("ad_id");
    			
    			if(!J_CommonUtils.isEmpty(actionType) && actionType.equals("www")){
    				HashMap<String, String> pMap = new HashMap<String, String>();
        			String params = target.substring(target.lastIndexOf("?")+1, target.length());
        			String[] param = params.split("&");
        			for(int i = 0 ; i < param.length ; i++){
        				String subParam = param[i];
        				String[] kv = subParam.split("=");
        				pMap.put(kv[0], kv[1]);
        			}
        			
        			if(!J_CommonUtils.isEmpty(pMap.get("uid"))){
        				uid = pMap.get("uid");
        			}
        			if(!J_CommonUtils.isEmpty(pMap.get("product"))){
        				product = pMap.get("product");
        			}
        			if(!J_CommonUtils.isEmpty(pMap.get("location"))){
        				location = pMap.get("location");
        			}
        			if(!J_CommonUtils.isEmpty(pMap.get("clientVer"))){
        				clientVer = pMap.get("clientVer");
        			}
        			if(!J_CommonUtils.isEmpty(pMap.get("clientID"))){
        				clientID = pMap.get("clientID");
        			}
        			if(!J_CommonUtils.isEmpty(pMap.get("channelID"))){
        				channelID = pMap.get("channelID");
        			}
        			if(!J_CommonUtils.isEmpty(pMap.get("screenWidth"))){
        				screenWidth = pMap.get("screenWidth");
        			}
        			if(!J_CommonUtils.isEmpty(pMap.get("screenHeight"))){
        				screenHeight = pMap.get("screenHeight");
        			}
        			if(!J_CommonUtils.isEmpty(pMap.get("pin"))){
        				pin = pMap.get("pin");
        			}
    			}
    			//先判断是否为www，如果是则跳转网页    View客户端内部，target
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
    
    @Override
    public String toString() {
    	return "jsonData = "+jsonData+"\n"+
    		   "uid = "+uid+"\n"+
    		   "actionType = "+actionType+"\n"+
    		   "showType = "+showType+"\n"+
    		   "imageUrl = "+imageUrl+"\n"+
    		   "content = "+content+"\n"+
    		   "target = "+target+"\n"+
    		   "ad_id = "+ad_id+"\n"+
    		   "product = "+product+"\n"+
    		   "location = "+location+"\n"+
    		   "clientVer = "+clientVer+"\n"+
    		   "clientID = "+clientID+"\n"+
    		   "channelID = "+channelID+"\n"+
    		   "screenWidth = "+screenWidth+"\n"+
    		   "screenHeight = "+screenHeight+"\n"+
    		   "pin = "+pin;
    }

}
