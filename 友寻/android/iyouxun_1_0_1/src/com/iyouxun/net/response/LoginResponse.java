package com.iyouxun.net.response;

import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.j_libs.net.response.J_Response;

public class LoginResponse extends J_Response {
	public LoginUser userInfo;
	public String token;
	public int status;
}
