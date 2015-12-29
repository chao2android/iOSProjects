//
//  JYLoginController.m
//  friendJY
//
//  Created by 高斌 on 15/3/2.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYLoginController.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "JYHttpServeice.h"
#import <ShareSDK/ShareSDK.h>
#import "JYAppDelegate.h"
#import "JYForgotPwdController.h"
#import "JYOpenRegisterController.h"
#import "JYRegisterController.h"
//#import "JYViewDelegate.h"
#import "Toast+UIView.h"

@interface JYLoginController ()

@end

@implementation JYLoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"登录"];
        
    }
    
    return self;
}
- (void)SetThirdBtnEnable:(BOOL) enable{
    _weChatLoginBtn.enabled = enable;
    _sinaLoginBtn.enabled = enable;
    _qqLoginBtn.enabled = enable;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController.viewControllers.count > 2) {
        NSArray *viewControllers = [NSArray arrayWithObjects:self.navigationController.viewControllers[0],self,nil];
        [self.navigationController setViewControllers:viewControllers];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)]];
    
    //TextField背景图片
    UIImageView *textBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 34, kScreenWidth, 88)];
//    UIImage *textBgImg = [[UIImage imageNamed:@"login_bg_shurukuang_lianghang.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 120, 5, 5)];
//    [textBgImage setImage:textBgImg];
    [textBgImage setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:textBgImage];
    
    //用户名
    UIImageView *phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.top, 59, 44)];
    [phoneIcon setImage:[UIImage imageNamed:@"login_phone_icon.png"]];
    [self.view addSubview:phoneIcon];
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneIcon.right, phoneIcon.top, kScreenWidth-59-15, 44)];
    [_usernameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_usernameTextField setBorderStyle:UITextBorderStyleNone];
    [_usernameTextField setBackgroundColor:[UIColor whiteColor]];
    [_usernameTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_usernameTextField setPlaceholder:@"手机号"];
    [_usernameTextField setDelegate:self];
    [self.view addSubview:_usernameTextField];
    
    //密码
    UIImageView *passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(phoneIcon.left, phoneIcon.bottom, 59, 44)];
    [passwordIcon setImage:[UIImage imageNamed:@"login_search_icon.png"]];
    [self.view addSubview:passwordIcon];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(passwordIcon.right, passwordIcon.top, kScreenWidth-59-15, 44)];
    [_passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_passwordTextField setBorderStyle:UITextBorderStyleNone];
    [_passwordTextField setBackgroundColor:[UIColor whiteColor]];
//    [_passwordTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_passwordTextField setPlaceholder:@"密码"];
    [_passwordTextField setSecureTextEntry:YES];
    [_passwordTextField setReturnKeyType:UIReturnKeyDone];
    [_passwordTextField setDelegate:self];
    [self.view addSubview:_passwordTextField];
    
    UIImageView *line_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.top, kScreenWidth, 1)];
    [line_1 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_1];
    
    UIImageView *line_2 = [[UIImageView alloc] initWithFrame:CGRectMake(59, textBgImage.top+44, kScreenWidth-59, 1)];
    [line_2 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_2];
    
    UIImageView *line_3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.bottom, kScreenWidth, 1)];
    [line_3 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_3];
    
    //登录
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setFrame:CGRectMake(15, textBgImage.bottom+34, kScreenWidth-30, 44)];
    UIImage *loginBtnAvailableImage = [[UIImage imageNamed:@"login_confirm_btn_available.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_loginBtn setBackgroundImage:loginBtnAvailableImage forState:UIControlStateNormal];
    UIImage *loginBtnUnavailableImage = [[UIImage imageNamed:@"login_confirm_btn_unavailable.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_loginBtn setBackgroundImage:loginBtnUnavailableImage forState:UIControlStateDisabled];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setEnabled:NO];
    [self.view addSubview:_loginBtn];
    
    
//    UIButton *forgotPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [forgotPasswordBtn setFrame:CGRectMake(kScreenWidth-15-80, _loginBtn.bottom+15, 80, 20)];
//    [forgotPasswordBtn setBackgroundColor:[UIColor redColor]];
//    [forgotPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
//    [forgotPasswordBtn setTitleColor:kTextColorGray forState:UIControlStateNormal];
////    [forgotPasswordBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, kScreenWidth-80)];
//    [forgotPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
//    [forgotPasswordBtn addTarget:self action:@selector(forgotPasswordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:forgotPasswordBtn];
    
    //注册账号
    NSString *registerStr = [NSString stringWithFormat:@"注册账号"];
    CGSize registerStrSize = [registerStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *registerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, _loginBtn.bottom+15, registerStrSize.width, registerStrSize.height)];
    [registerLab setBackgroundColor:[UIColor clearColor]];
    [registerLab setUserInteractionEnabled:YES];
    [registerLab setFont:[UIFont systemFontOfSize:14.0f]];
    [registerLab setTextColor:kTextColorBlue];
    [registerLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerLabTap:)]];
    [registerLab setText:registerStr];
    [self.view addSubview:registerLab];
    
    //忘记密码
    NSString *forgotPasswordStr = [NSString stringWithFormat:@"忘记密码"];
    CGSize forgotPasswordStrSize = [forgotPasswordStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *forgotPasswordLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-forgotPasswordStrSize.width-15, _loginBtn.bottom+15, forgotPasswordStrSize.width, forgotPasswordStrSize.height)];
    [forgotPasswordLab setBackgroundColor:[UIColor clearColor]];
    [forgotPasswordLab setUserInteractionEnabled:YES];
    [forgotPasswordLab setFont:[UIFont systemFontOfSize:14.0f]];
    [forgotPasswordLab setTextColor:kTextColorBlack];
    [forgotPasswordLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordLabTap:)]];
    [forgotPasswordLab setText:forgotPasswordStr];
    [self.view addSubview:forgotPasswordLab];
    
    //"其他账号登录"
//    UIImageView *otherLoginImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, kScreenWidth, 44)];
//    [otherLoginImage setImage:[UIImage imageNamed:@"login_bg_qitazhanghao.png"]];
//    [self.view addSubview:otherLoginImage];
    
    //其他账号登录
    NSString *otherLoginStr = [NSString stringWithFormat:@"使用其他社交账号登录"];
    CGSize otherLoginStrSize = [otherLoginStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *otherLoginLab = [[UILabel alloc] initWithFrame:CGRectMake(0, registerLab.bottom+45, otherLoginStrSize.width, otherLoginStrSize.height)];
    [otherLoginLab setCenter:CGPointMake(kScreenWidth/2, otherLoginLab.center.y)];
    [otherLoginLab setBackgroundColor:[UIColor clearColor]];
    [otherLoginLab setUserInteractionEnabled:YES];
    [otherLoginLab setFont:[UIFont systemFontOfSize:14.0f]];
    [otherLoginLab setTextColor:kTextColorGray];
    [otherLoginLab setText:otherLoginStr];
    [self.view addSubview:otherLoginLab];
    
    UIImageView *line_4 = [[UIImageView alloc] initWithFrame:CGRectMake(15, otherLoginLab.center.y, (kScreenWidth-15*4-otherLoginLab.width)/2, 1)];
    [line_4 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_4];
    
    UIImageView *line_5 = [[UIImageView alloc] initWithFrame:CGRectMake(otherLoginLab.right+15, line_4.top, line_4.width, 1)];
    [line_5 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_5];
    
    //微信账号登录
    _weChatLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_weChatLoginBtn setFrame:CGRectMake(0, otherLoginLab.bottom+30, 60, 60)];
    [_weChatLoginBtn setCenter:CGPointMake(kScreenWidth/2, _weChatLoginBtn.center.y)];
    [_weChatLoginBtn setBackgroundImage:[UIImage imageNamed:@"login_wechat.png"] forState:UIControlStateNormal];
    [_weChatLoginBtn addTarget:self action:@selector(weChatLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_weChatLoginBtn];
    
    //微博账号登录
    _sinaLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sinaLoginBtn setFrame:CGRectMake(_weChatLoginBtn.left-20-60, _weChatLoginBtn.top, 60, 60)];
    [_sinaLoginBtn setBackgroundImage:[UIImage imageNamed:@"login_sina.png"] forState:UIControlStateNormal];
    [_sinaLoginBtn addTarget:self action:@selector(sinaLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sinaLoginBtn];
    
    //QQ账号登录
    _qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_qqLoginBtn setFrame:CGRectMake(_weChatLoginBtn.right+20, _weChatLoginBtn.top, 60, 60)];
    [_qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"login_qq.png"] forState:UIControlStateNormal];
    [_qqLoginBtn addTarget:self action:@selector(qqLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_qqLoginBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bgTap:(UITapGestureRecognizer *)tap
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)loginBtnClick:(UIButton *)btn
{
    NSLog(@"login");

    [self requestLogin];
}
- (void)sinaLoginBtnClick:(UIButton *)btn
{
    [self SetThirdBtnEnable:NO];
    NSLog(@"微博登录");
    _loginType = sinaLogin;
    [self getUserInfoWithSinaWeibo];
}
- (void)weChatLoginBtnClick:(UIButton *)btn
{
    [self SetThirdBtnEnable:NO];
    NSLog(@"微信登录");
    _loginType = weChatLogin;
    [self getUserInfoWithWeChat];
}
- (void)qqLoginBtnClick:(UIButton *)btn
{
    [self SetThirdBtnEnable:NO];
    NSLog(@"QQ登录");
    _loginType = qqLogin;
    [self getUserInfoWithTencentQQ];
}


- (void)registerLabTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"注册");
    JYRegisterController *registerController = [[JYRegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}



- (void)forgotPasswordLabTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"忘记密码");
    JYForgotPwdController *forgotPwdController = [[JYForgotPwdController alloc] init];
    [self.navigationController pushViewController:forgotPwdController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getUserInfoWithWeChat
{
//    [[JYAppDelegate sharedAppDelegate] showTip:@"微信登录暂不可用，开发者账号未完成审核"];
//    return;
//    JYViewDelegate *viewDelegate = [[JYViewDelegate alloc] init];
    //判断下网络
    if (![JYHttpServeice NetworkStatues]) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [self SetThirdBtnEnable:YES];
        return;
    }
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result) {
                                   [self openRegisterWithUserInfo:userInfo];
                               }else{
                                   [[JYAppDelegate sharedAppDelegate] showTip:@"授权失败！"];
                               }
                               [self SetThirdBtnEnable:YES];
                           }];
    
}

- (void)getUserInfoWithSinaWeibo
{
    //判断下网络
    if (![JYHttpServeice NetworkStatues]) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [self SetThirdBtnEnable:YES];
        return;
    }
    
    id<ISSAuthOptions>authOptions = [ShareSDK authOptionsWithAutoAuth:NO allowCallback:YES scopes:nil powerByHidden:YES followAccounts:nil authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   [self openRegisterWithUserInfo:userInfo];
                               } else {
                                   //nothing
                                   [[JYAppDelegate sharedAppDelegate] showTip:@"授权失败！"];
                                   NSLog(@"错误描述:%@", [error errorDescription]);
                               }
                               [self SetThirdBtnEnable:YES];
                           }];
}

- (void)getUserInfoWithTencentQQ
{
    //判断下网络
    if (![JYHttpServeice NetworkStatues]) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [self SetThirdBtnEnable:YES];
        return;
    }
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        NSLog(@"userInfo %@", userInfo);
        if (result) {
            [self openRegisterWithUserInfo:userInfo];
            
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:@"授权失败！"];
            NSLog(@"错误描述:%@", [error errorDescription]);
            
        }
        [self SetThirdBtnEnable:YES];
    }];
}
- (void)openRegisterWithUserInfo:(id<ISSPlatformUser>)userInfo{
    
    NSString *type = @"0";
    switch (_loginType) {
        case sinaLogin:
            type = @"2";
            break;
        case weChatLogin:
            type = @"1";
            break;
        case qqLogin:
            type = @"3";
            break;
        default:
            break;
    }
    [self showProgressHUD:@"请稍等.." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"login",
                              @"func":@"is_bind_openid"
                              };
    NSDictionary *postDic = @{
                              @"type":type,
                              @"openid":[userInfo uid]
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"success"] boolValue]) {
                //已绑定过
                [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"data"] objectForKey:@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:ToString([[responseObject objectForKey:@"data"] objectForKey:@"uid"]) forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAutoLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
//                [[JYAppDelegate sharedAppDelegate] requestAutoLogin];
            }else{
            //没有绑定过
                JYOpenRegisterController *openRegController = [[JYOpenRegisterController alloc] init];
                [openRegController setSourceDic:[userInfo sourceData]];
                [openRegController setUid:[userInfo uid]];
                [openRegController setToken:[[userInfo credential] token]];
                [openRegController setLoginType:_loginType];
                [self.navigationController pushViewController:openRegController animated:YES];
            }
            [self dismissProgressHUDtoView:self.view];
            [self SetThirdBtnEnable:YES];
        }
    } failure:^(id error) {
        [self SetThirdBtnEnable:YES];
    }];
}
#pragma mark - notification

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    if ([JYHelpers isPhoneNumber:_usernameTextField.text])
    {
        if ((_passwordTextField.text.length>=6) && (_passwordTextField.text.length<=20)) {
            
            [_loginBtn setEnabled:YES];
        } else {
            
            [_loginBtn setEnabled:NO];
        }
    } else {
        [_loginBtn setEnabled:NO];
    }
}

#pragma mark - request

- (void)requestLogin
{
    //下面两行，是清除保存的cookies的信息，只有当登录操作时才有
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"sessionCookies"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"login" forKey:@"mod"];
    [parametersDict setObject:@"login" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_usernameTextField.text forKey:@"name"];
    [postDict setObject:_passwordTextField.text forKey:@"password"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetmean = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetmean == 1) {
            NSInteger status = [[[responseObject objectForKey:@"data"] objectForKey:@"status"] integerValue];
//            : 成功 1 加黑 -2; 密码错误 -1; 没注册 -3
            if (status == 1) {
                //登录成功
                NSString *token = [[responseObject objectForKey:@"data"] objectForKey:@"token"];
                NSString *uid = ToString([[responseObject objectForKey:@"data"] objectForKey:@"uid"]);
                
                [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setObject:_usernameTextField.text forKey:@"phone"];
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
            }else if(status == -1){//密码错误
                [[JYAppDelegate sharedAppDelegate] showTip:@"密码错误"];
            }else if (status == -3){//没有注册
                //[[JYAppDelegate sharedAppDelegate] showTip:@"账号不存在，请检查或注册新账号。"];
                [self.view makeToast:@"账号不存在，请检查或注册新账号。" duration:1.5 position:@"center"];
            }else if(status == -2){//加黑
                [[JYAppDelegate sharedAppDelegate] showTip:@"账号已被拉黑"];
            }
            
        } else if (iRetmean == -1) {
            
            //密码错误
            [[JYAppDelegate sharedAppDelegate] showTip:@"密码错误"];
            
        } else if (iRetmean == -2) {
            
            //拉黑
            [[JYAppDelegate sharedAppDelegate] showTip:@"拉黑"];
            
        } else{
            
        }
        
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        NSLog(@"%@", error);
    }];
}


- (void)requestState
{
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"login_ios" forKey:@"mod"];
//    [parametersDict setObject:@"doPrevetCall" forKey:@"func"];
//    
//    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
//        
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        
//        if (iRetcode == 1) {
//            _state = [responseObject objectForKey:@"data"];
//        
//            if (_loginType == weChatLogin) {
//                
//                //微信登录
//                [self getUserInfoWithWeChat];
//                
//            } else if (_loginType == sinaLogin) {
//                
//                //新浪登录
//                [self getUserInfoWithSinaWeibo];
//            
//            } else if (_loginType == qqLogin) {
//            
//                //QQ登录
//                [self getUserInfoWithTencentQQ];
//            
    
//            } else {}
//        
//        }
//        
//    } failure:^(id error) {
//        
//        
//        
//    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //手机号不能超过11位
    if ([textField isEqual:_usernameTextField] && textField.text.length == 11 && ![string isEqualToString:@""]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"手机号不能超过11位"];
        return NO;
    }
    if ([textField isEqual:_passwordTextField] && textField.text.length == 20 && ![string isEqualToString:@""]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"密码不能超过20位，请检查是否输入错误"];
        return NO;
    }
    //    验证码不能超过6位
//    if ([textField isEqual:_passwordTextField] && textField.text.length == 6 && ![string isEqualToString:@""]) {
//        [[JYAppDelegate sharedAppDelegate] showTip:@"验证码不能超过6位"];
//        return NO;
//    }
    return YES;
}

@end
