package com.iyouxun.data.beans;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * 动态查看权限信息
 * 
 * @ClassName: NewsAuthInfoBean
 * @author likai
 * @date 2015-3-7 上午10:50:49
 * 
 */
public class NewsAuthInfoBean implements Serializable {
	/**
	 * @Fields serialVersionUID : TODO
	 */
	private static final long serialVersionUID = -3079024092083290748L;
	/** 权限类型（1:所有，2：指定分组） */
	public int lookAuthType = 1;
	/** 查看权限 */
	public ArrayList<String> lookAuth = new ArrayList<String>();
}
