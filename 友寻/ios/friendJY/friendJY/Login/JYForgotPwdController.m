//
//  JYForgotPwdController.m
//  friendJY
//
//  Created by 高斌 on 15/3/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYForgotPwdController.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"

@interface JYForgotPwdController ()

@end

@implementation JYForgotPwdController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"忘记密码"];
        
        _seconds = kReacquireCodeWaitSecond;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)]];
    
    //TextField背景图片
    UIImageView *textBgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [textBgImage setFrame:CGRectMake(0, 34, kScreenWidth, 88)];
    [textBgImage setBackgroundColor:kTextColorWhite];
    //    UIImage *textBgImg = [[UIImage imageNamed:@"register_bg_shurukuang_lianghang.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 110, 5, 5)];
    //    [textBgImage setImage:textBgImg];
    [self.view addSubview:textBgImage];
    
    //中国 +86
    NSString *chinaStr = [NSString stringWithFormat:@"中国 +86"];
    CGSize chinaStrSize = [chinaStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *chinaLab = [[UILabel alloc] initWithFrame:CGRectMake(15, textBgImage.top+14, chinaStrSize.width, 16)];
    [chinaLab setText:chinaStr];
    [chinaLab setBackgroundColor:[UIColor clearColor]];
    [chinaLab setTextAlignment:NSTextAlignmentCenter];
    [chinaLab setFont:[UIFont systemFontOfSize:14.0f]];
    [chinaLab setTextColor:kTextColorBlack];
    [self.view addSubview:chinaLab];
    
    //手机号
    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(chinaLab.right+40, textBgImage.top, kScreenWidth-15-chinaLab.width-40-10, 44)];
    [_phoneNumberTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_phoneNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_phoneNumberTextField setBorderStyle:UITextBorderStyleNone];
    [_phoneNumberTextField setBackgroundColor:[UIColor clearColor]];
    [_phoneNumberTextField setPlaceholder:kPleaseEnterPhoneNumber];
    [_phoneNumberTextField setDelegate:self];
    [self.view addSubview:_phoneNumberTextField];
    
    //验证码
    _verCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, textBgImage.top+44, kScreenWidth-15-120, 44)];
    [_verCodeTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_verCodeTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_verCodeTextField setBorderStyle:UITextBorderStyleNone];
    [_verCodeTextField setBackgroundColor:[UIColor clearColor]];
    [_verCodeTextField setPlaceholder:@"验证码"];
    [_verCodeTextField setDelegate:self];
    [self.view addSubview:_verCodeTextField];
    
    //获取验证码
    _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getCodeBtn setFrame:CGRectMake(_verCodeTextField.right, textBgImage.top+44, 120, 44)];
    //    [_getCodeBtn setBackgroundColor:kTextColorBlue];
    [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"register_get_code_btn_enable.png"] forState:UIControlStateNormal];
    [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"register_get_code_btn_disenable.png"] forState:UIControlStateDisabled];
    //    [_getCodeBtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
    [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCodeBtn];
    
    _getCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _getCodeBtn.width, _getCodeBtn.height)];
    [_getCodeLab setBackgroundColor:[UIColor clearColor]];
    [_getCodeLab setFont:[UIFont systemFontOfSize:14.0f]];
    [_getCodeLab setTextColor:[UIColor whiteColor]];
    [_getCodeLab setText:@"获取验证码"];
    [_getCodeLab setTextAlignment:NSTextAlignmentCenter];
    [_getCodeBtn addSubview:_getCodeLab];
    
    UIImageView *line_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.top, kScreenWidth, 1)];
    [line_1 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_1];
    
    UIImageView *line_2 = [[UIImageView alloc] initWithFrame:CGRectMake(chinaLab.right+20, textBgImage.top+5, 1, 34)];
    [line_2 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_2];
    
    UIImageView *line_3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.top+44, kScreenWidth-120, 1)];
    [line_3 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_3];
    
    UIImageView *line_4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.bottom, kScreenWidth-120, 1)];
    [line_4 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_4];
    
    //密码背景图片
    UIImageView *passwordBgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [passwordBgImage setFrame:CGRectMake(0, textBgImage.bottom+34, kScreenWidth, 88)];
    [passwordBgImage setBackgroundColor:kTextColorWhite];
    [self.view addSubview:passwordBgImage];
    
    NSString *newPwdStr = [NSString stringWithFormat:@"新密码"];
    CGSize newPwdStrSize = [newPwdStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *newPwdLab = [[UILabel alloc] initWithFrame:CGRectMake(15, passwordBgImage.top, newPwdStrSize.width, newPwdStrSize.height)];
    [newPwdLab setCenter:CGPointMake(newPwdLab.center.x, passwordBgImage.top+22)];
    [newPwdLab setText:newPwdStr];
    [newPwdLab setBackgroundColor:[UIColor clearColor]];
    [newPwdLab setTextAlignment:NSTextAlignmentLeft];
    [newPwdLab setFont:[UIFont systemFontOfSize:14.0f]];
    [newPwdLab setTextColor:kTextColorGray];
    [self.view addSubview:newPwdLab];
    
    //输入新密码
    _newPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, passwordBgImage.top, kScreenWidth-100-15, 44)];
    [_newPwdTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_newPwdTextField setKeyboardType:UIKeyboardTypeDefault];
    [_newPwdTextField setBorderStyle:UITextBorderStyleNone];
    [_newPwdTextField setReturnKeyType:UIReturnKeyDone];
    [_newPwdTextField setBackgroundColor:[UIColor clearColor]];
    [_newPwdTextField setSecureTextEntry:YES];
    [_newPwdTextField setPlaceholder:@"新密码"];
    [_newPwdTextField setDelegate:self];
    [self.view addSubview:_newPwdTextField];
    
    NSString *confirmPwdStr = [NSString stringWithFormat:@"确认新密码"];
    CGSize confirmPwdStrSize = [confirmPwdStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *confirmPwdLab = [[UILabel alloc] initWithFrame:CGRectMake(15, passwordBgImage.bottom-22, confirmPwdStrSize.width, confirmPwdStrSize.height)];
    [confirmPwdLab setCenter:CGPointMake(confirmPwdLab.center.x, passwordBgImage.bottom-22)];
    [confirmPwdLab setText:confirmPwdStr];
    [confirmPwdLab setBackgroundColor:[UIColor clearColor]];
    [confirmPwdLab setTextAlignment:NSTextAlignmentLeft];
    [confirmPwdLab setFont:[UIFont systemFontOfSize:14.0f]];
    [confirmPwdLab setTextColor:kTextColorGray];
    [self.view addSubview:confirmPwdLab];
    
    //确认新密码
    _confirmPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(_newPwdTextField.left, passwordBgImage.top+44, _newPwdTextField.width, 44)];
    [_confirmPwdTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_confirmPwdTextField setKeyboardType:UIKeyboardTypeDefault];
    [_confirmPwdTextField setBorderStyle:UITextBorderStyleNone];
    [_confirmPwdTextField setReturnKeyType:UIReturnKeyDone];
    [_confirmPwdTextField setBackgroundColor:[UIColor clearColor]];
    [_confirmPwdTextField setSecureTextEntry:YES];
    [_confirmPwdTextField setPlaceholder:@"确认密码"];
    [_confirmPwdTextField setDelegate:self];
    [self.view addSubview:_confirmPwdTextField];
    
    UIImageView *line_5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, passwordBgImage.top, kScreenWidth, 1)];
    [line_5 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_5];
    
    UIImageView *line_6 = [[UIImageView alloc] initWithFrame:CGRectMake(15, passwordBgImage.top+44, kScreenWidth-15, 1)];
    [line_6 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_6];
    
    UIImageView *line_7 = [[UIImageView alloc] initWithFrame:CGRectMake(0, passwordBgImage.bottom, kScreenWidth, 1)];
    [line_7 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_7];
    
    //完成
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setFrame:CGRectMake(15, passwordBgImage.bottom+50, kScreenWidth-30, 44)];
    UIImage *submitBtnAvailableImage = [[UIImage imageNamed:@"login_confirm_btn_available.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_submitBtn setBackgroundImage:submitBtnAvailableImage forState:UIControlStateNormal];
    UIImage *submitBtnUnavailableImage = [[UIImage imageNamed:@"login_confirm_btn_unavailable.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_submitBtn setBackgroundImage:submitBtnUnavailableImage forState:UIControlStateDisabled];
    [_submitBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_submitBtn setEnabled:NO];
    [self.view addSubview:_submitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)bgTap:(UITapGestureRecognizer *)tap
{
    [_phoneNumberTextField resignFirstResponder];
    [_verCodeTextField resignFirstResponder];
    [_newPwdTextField resignFirstResponder];
    [_confirmPwdTextField resignFirstResponder];
}

- (void)getCodeBtnClick:(UIButton *)btn
{
    if ([JYHelpers isPhoneNumber:_phoneNumberTextField.text]) {
        
        //检查手机号
        [self requestMobileExists];
        
    } else {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
    }
}

- (void)submitBtnClick:(UIButton *)btn
{
    if ([_newPwdTextField.text isEqualToString:_confirmPwdTextField.text]) {
        if (_newPwdTextField.text.length < 6) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"密码不能小于6位"];
        }else{
            [self requestSetNewPassword];
        }
    }else{
        [[JYAppDelegate sharedAppDelegate] showTip:@"两次密码输入不一致"];
    }
    
}

- (void)timerFireMethod:(NSTimer *)timer
{
    if (_seconds == 1) {
        [timer invalidate];
        _seconds = kReacquireCodeWaitSecond;
        [_getCodeLab setText:@"获取验证码"];
        [_getCodeBtn setEnabled:YES];
    } else {
        _seconds--;
        NSString *title = [NSString stringWithFormat:@"重新发送%ld",(long)_seconds];
        [_getCodeLab setText:title];
        [_getCodeBtn setEnabled:NO];
    }
}

#pragma mark - request

//判断手机是否存在
- (void)requestMobileExists
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"register" forKey:@"mod"];
    [parametersDict setObject:@"mobile_exists" forKey:@"func"];
    
    
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:_phoneNumberTextField.text forKey:@"mobile"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            //手机号没有注册
            [[JYAppDelegate sharedAppDelegate] showTip:@"该账号不存在，请检查或注册新账号"];
            
        } else if (iRetcode == -1) {
            
            //手机号已经注册
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [self requestFindPasswordGetCheckcode];
            
        } else if (iRetcode == -2) {
            
            //手机号不合法
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
        } else {}
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
}

//获取验证码
- (void)requestFindPasswordGetCheckcode
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"login" forKey:@"mod"];
    [parametersDict setObject:@"find_password_get_checkcode" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_phoneNumberTextField.text forKey:@"mobile"];

    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            NSLog(@"成功");
            [[JYAppDelegate sharedAppDelegate] showTip:kVerificationCodeSentSuccess];
            [_getCodeBtn setEnabled:NO];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            
        } else if (iRetcode == -1) {
            
            //手机号已经注册
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPhoneNumberAlreadyRegisterPleaseLogin];
            
        } else if (iRetcode == -2) {
            
            //手机号不合法
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
            
        } else {}
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
}

- (void)requestSetNewPassword
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"login" forKey:@"mod"];
    [parametersDict setObject:@"set_new_password" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_phoneNumberTextField.text forKey:@"mobile"];
    [postDict setObject:_verCodeTextField.text forKey:@"code"];
    [postDict setObject:_newPwdTextField.text forKey:@"new"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            //密码修改成功
            [[JYAppDelegate sharedAppDelegate] showTip:@"密码修改成功"];
            [self requestLogin];
            
        }else if (iRetcode == -3){
            [[JYAppDelegate sharedAppDelegate] showTip:@"验证码输入错误"];
        }else if (iRetcode == -2){
            [[JYAppDelegate sharedAppDelegate] showTip:@"手机号尚未注册"];
        }else {
            
            //密码修改失败
            [[JYAppDelegate sharedAppDelegate] showTip:@"密码修改失败"];
            
        }
        
    } failure:^(id error) {
        
        
    }];

}

- (void)requestLogin
{
    //下面两行，是清除保存的cookies的信息，只有当登录操作时才有
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"sessionCookies"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"login" forKey:@"mod"];
    [parametersDict setObject:@"login" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_phoneNumberTextField.text forKey:@"name"];
    [postDict setObject:_newPwdTextField.text forKey:@"password"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetmean = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetmean == 1) {
            
            //登录成功
            NSString *token = [[responseObject objectForKey:@"data"] objectForKey:@"token"];
            NSString *uid = ToString([[responseObject objectForKey:@"data"] objectForKey:@"uid"]);
            
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAutoLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject: cookiesData forKey: @"sessionCookies"];
            
            //从cookies中获取uid
            NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
            for (int i=0; i<cookies.count; i++) {
                NSHTTPCookie *cookie = [cookies objectAtIndex:i];
                NSLog(@"%@:%@", cookie.name, cookie.value);
                
                if ([cookie.name isEqualToString:@"RAW_HASH"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject: cookie.value forKey:@"RAW_HASH"];
                    
                } else if ([cookie.name isEqualToString:@"COMMON_HASH"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject: cookie.value forKey:@"COMMON_HASH"];
                    
                }
                
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil userInfo:nil];
            
        } else if (iRetmean == -1) {
            
            //密码错误
            [[JYAppDelegate sharedAppDelegate] showTip:@"密码错误"];
            
        } else if (iRetmean == -2) {
            
            //拉黑
            [[JYAppDelegate sharedAppDelegate] showTip:@"拉黑"];
            
        } else {}
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_verCodeTextField] && _verCodeTextField.text.length + string.length > 6) {
        //验证码6位
        return NO;
    }else if ([textField isEqual:_phoneNumberTextField] && _phoneNumberTextField.text.length + string.length > 11){//手机号11位
        return NO;
    }else if ([textField isEqual:_newPwdTextField] && (_newPwdTextField.text.length + string.length) > 20){
        //新密码20位
        return NO;
    }else if ([textField isEqual:_confirmPwdTextField] && (_confirmPwdTextField.text.length + string.length) > 20){
        //新密码20位
        return NO;
    }
    return YES;
}
@end



