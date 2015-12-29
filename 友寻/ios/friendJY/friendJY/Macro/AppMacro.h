//
//  AppMacro.h
//  imAZXiPhone
//
//  Created by GAO on 14-6-30.
//  Copyright (c) 2014年 GAO. All rights reserved.
//

//这个文件放app相关的宏定义
#ifndef imAZXiPhone_AppMacro_h
#define imAZXiPhone_AppMacro_h

//基本URL

//#define HTTP_PREFIX @"http://client.izhenxin.dev/cmiajax/" //测试
//#define HTTP_PREFIX @"http://client.izhenxin.com/cmiajax/" //预上线
//#define HTTP_PREFIX @"http://c.izhenxin.com/cmiajax/" //数据请求基本URL

#if 0//1 测试 0正式

#define YX_HOST @"http://c.friendly.dev" //测试
#define HTTP_PREFIX @"http://c.friendly.dev/cmiajax/" //测试
#define JY_SOCKET_HOST @"120.132.40.45" //测试

#else

#define YX_HOST @"http://m.iyouxun.com" //正试
#define HTTP_PREFIX @"http://m.iyouxun.com/cmiajax/" //正试
#define JY_SOCKET_HOST @"120.132.40.16" //正试

#endif


//socket的host
#define JY_HOST_PORT (8080)

//字体颜色
//#define kTextColorBlack @"#303030"
//#define kTextColorBlue @"#2695FF"
//#define kTextColorGray @"#848484"
//#define kTextColorWhite @"#FFFFFF"
#define kTextColorBlack     [JYHelpers setFontColorWithString:@"#303030"]
#define kTextColorBlue      [JYHelpers setFontColorWithString:@"#2695FF"]
#define kTextColorGray      [JYHelpers setFontColorWithString:@"#848484"]
#define kTextColorWhite     [JYHelpers setFontColorWithString:@"#FFFFFF"]
#define kBorderColorGray    [JYHelpers setFontColorWithString:@"#E2E5E7"]
#define kTextColorLightGray [JYHelpers setFontColorWithString:@"#b9b9b9"]

#define kReacquireCodeWaitSecond 60 //重新获取验证码等待时间

//KVO_CONTEXT
#define KVO_CONTEXT_AGREE_BTN_SELECTED_CHANGED @"KVO_CONTEXT_AGREE_BTN_SELECTED_CHANGED"
#define KVO_EMOJI_BTN_SELECTED_CHANGED @"KVO_EMOJI_BTN_SELECTED_CHANGED"
#define KVO_SEND_IMAGE_BTN_SELECTED_CHANGED @"KVO_SEND_IMAGE_BTN_SELECTED_CHANGED"
#define KVO_INPUT_TEXTVIEW_RESPONDER_STATUS_CHANGED @"KVO_INPUT_TEXTVIEW_RESPONDER_STATUS_CHANGED"




#define kRequestWaiting @"加载中"
#define kRequestFinish @"加载完成"
#define kRequestLoginSuccess @"登录成功"
#define kRequestRegistSuccess @"注册成功"
#define kNetworkConnectionFailure @"网络连接失败"
#define kVerificationCodeSentSuccess @"验证码已发送，请查收!"
#define kUDPushSoundOption        @"PushSoundActivate"                // 声音提示
#define kUDPushShakeOption        @"PushShakeActivate"                // 振动提示
#define kPleaseEnterPhoneNumber @"请输入手机号码"
#define kPleaseEnterValidPhoneNumber @"请输入有效的手机号码"
#define kPhoneNumberAlreadyRegisterPleaseLogin @"手机号已注册，可直接登录"
#define kPhoneNumberNotExistPleaseRegister @"账号不存在，请检查或注册新账号"
#define kHoldPressAndSpeak @"按住说话"
#define kReleaseAndOver @"松开结束"
#define kRefreshNewUnreadMessageCount @"refreshNewUnreadMessageCount" //刷新未读信息数



/*******个人资料开始******/
#define kAvatarUpdateSuccess @"头像上传成功"

/*******个人资料结束******/




typedef enum {
    //以下是枚举成员
    normalLogin = 0,
    weChatLogin,
    sinaLogin,
    qqLogin,
}LOGIN_TYPE;


#endif
