//
//  JYForgotPwdController.h
//  friendJY
//
//  Created by 高斌 on 15/3/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYForgotPwdController : JYBaseController<UITextFieldDelegate>
{
    UITextField *_phoneNumberTextField;
    UIButton *_getCodeBtn;
    UILabel *_getCodeLab;
    UITextField *_verCodeTextField;
    UITextField *_newPwdTextField;
    UITextField *_confirmPwdTextField;
    UIButton *_submitBtn;
    
    NSInteger _seconds;

}

@end
