//
//  JYLoginController.h
//  friendJY
//
//  Created by 高斌 on 15/3/2.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYLoginController : JYBaseController<UITextFieldDelegate>
{
    UITextField *_usernameTextField;
    UITextField *_passwordTextField;
    UIButton *_loginBtn;
    UIButton *_weChatLoginBtn;
    UIButton *_sinaLoginBtn;
    UIButton *_qqLoginBtn;
    LOGIN_TYPE _loginType;
    NSString *_state;
}

@end
