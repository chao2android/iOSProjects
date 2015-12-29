package com.iyouxun.j_libs.json.parser;

import com.iyouxun.j_libs.net.request.J_Request;

public abstract class J_JsonParser {

	public abstract Object parsJson(String jsonStr, J_Request request) throws Exception;

}
