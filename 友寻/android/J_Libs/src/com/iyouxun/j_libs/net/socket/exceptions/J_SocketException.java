package com.iyouxun.j_libs.net.socket.exceptions;


public class J_SocketException extends RuntimeException {

    public J_SocketException(String message) {
        super(message);
    }

    public J_SocketException(Throwable e) {
        super(e);
    }

    public J_SocketException(String message, Throwable cause) {
        super(message, cause);
    }
}
