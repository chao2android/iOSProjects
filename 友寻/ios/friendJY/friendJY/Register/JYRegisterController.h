//
//  JYRegisterController.h
//  friendJY
//
//  Created by 高斌 on 15/3/2.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYRegisterController : JYBaseController<UITextFieldDelegate>
{
//    UIImageView *_textBgImage;
    UITextField *_phoneNumberTextField;
    UITextField *_passwordTextField;
    UITextField *_verCodeTextField;
    UIButton *_getCodeBtn;
    UILabel *_getCodeLab;
    UIButton *_completeBtn;
    UIButton *_agreeBtn;
    
    NSInteger _seconds;

}

@end
