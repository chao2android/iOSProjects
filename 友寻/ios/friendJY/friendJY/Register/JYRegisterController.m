//
//  JYRegisterController.m
//  friendJY
//
//  Created by 高斌 on 15/3/2.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYRegisterController.h"
#import "JYRegisterAgreementController.h"
#import "JYAppDelegate.h"
#import "JYHttpServeice.h"
#import "JYRegisterInfoController.h"
#import "JYLoginController.h"

@interface JYRegisterController ()
{
    NSTimer *_timer;
}
@end

@implementation JYRegisterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self setTitle:@"加入友寻"];
        _seconds = kReacquireCodeWaitSecond;
        
    }
    
    return self;
}

- (void)dealloc
{
    [_agreeBtn removeObserver:self forKeyPath:@"selected" context:KVO_CONTEXT_AGREE_BTN_SELECTED_CHANGED];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
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
    
    //密码
    UIImageView *passwordBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, textBgImage.bottom+28, kScreenWidth, 44)];
    [passwordBgImage setBackgroundColor:kTextColorWhite];
    [self.view addSubview:passwordBgImage];
    
    NSString *passwordStr = [NSString stringWithFormat:@"密码"];
    CGSize passwordStrSize = [passwordStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *passwordLab = [[UILabel alloc] initWithFrame:CGRectMake(15, passwordBgImage.top+14, passwordStrSize.width, 16)];
    [passwordLab setText:passwordStr];
    [passwordLab setBackgroundColor:[UIColor clearColor]];
    [passwordLab setTextAlignment:NSTextAlignmentCenter];
    [passwordLab setFont:[UIFont systemFontOfSize:14.0f]];
    [passwordLab setTextColor:kTextColorBlack];
    [self.view addSubview:passwordLab];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(passwordLab.right+34, passwordBgImage.top, kScreenWidth-15-passwordLab.width-34-15, 44)];
    [_passwordTextField setBorderStyle:UITextBorderStyleNone];
    [_passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_passwordTextField setBackgroundColor:[UIColor clearColor]];
    [_passwordTextField setPlaceholder:@"设置密码(限6~20个字符)"];
    [_passwordTextField setDelegate:self];
    [_passwordTextField setSecureTextEntry:YES];
    [_passwordTextField setReturnKeyType:UIReturnKeyDone];
//    [_passwordTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:_passwordTextField];
    
    //是否显示密码
    UIButton *showPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showPasswordBtn setFrame:CGRectMake(_passwordTextField.right+5, _passwordTextField.top-5, 50, 30)];
    [showPasswordBtn setBackgroundColor:[UIColor lightGrayColor]];
    [showPasswordBtn addTarget:self action:@selector(showPasswordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [showPasswordBtn setSelected:NO];
    [showPasswordBtn setHidden:YES];
    [self.view addSubview:showPasswordBtn];
    
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
    
    UIImageView *line_5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, passwordBgImage.top, kScreenWidth, 1)];
    [line_5 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_5];
    
    UIImageView *line_6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, passwordBgImage.bottom, kScreenWidth, 1)];
    [line_6 setBackgroundColor:kBorderColorGray];
    [self.view addSubview:line_6];
    
    //完成
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeBtn setFrame:CGRectMake(15, passwordBgImage.bottom+50, kScreenWidth-30, 44)];
    UIImage *completeBtnAvailableImage = [[UIImage imageNamed:@"login_confirm_btn_available.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_completeBtn setBackgroundImage:completeBtnAvailableImage forState:UIControlStateNormal];
    UIImage *completeBtnUnavailableImage = [[UIImage imageNamed:@"login_confirm_btn_unavailable.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_completeBtn setBackgroundImage:completeBtnUnavailableImage forState:UIControlStateDisabled];
    [_completeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_completeBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_completeBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_completeBtn setEnabled:NO];
    [self.view addSubview:_completeBtn];
    
    UIView *agreeBg = [[UIView alloc] initWithFrame:CGRectMake(15, _completeBtn.bottom+15, kScreenWidth, 40)];
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeBtn setFrame:CGRectMake(0, 0, 15, 15)];
    [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"register_agree_btn_normal.png"] forState:UIControlStateNormal];
    [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"register_agree_btn_selected.png"] forState:UIControlStateSelected];
    [_agreeBtn addTarget:self action:@selector(_agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_agreeBtn setSelected:YES];
    [agreeBg addSubview:_agreeBtn];
    //监听
    [_agreeBtn addObserver:self forKeyPath:@"selected" options:0 context:KVO_CONTEXT_AGREE_BTN_SELECTED_CHANGED];
    
    NSString *iAgreeStr = @"同意";
    CGSize iAgreeStrSize = [iAgreeStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *iAgreeLab = [[UILabel alloc] initWithFrame:CGRectMake(_agreeBtn.right+5, _agreeBtn.top, iAgreeStrSize.width, iAgreeStrSize.height)];
    [iAgreeLab setBackgroundColor:[UIColor clearColor]];
    [iAgreeLab setFont:[UIFont systemFontOfSize:14.0f]];
    [iAgreeLab setTextColor:kTextColorGray];
    [iAgreeLab setText:iAgreeStr];
    [iAgreeLab setUserInteractionEnabled:NO];
    [agreeBg addSubview:iAgreeLab];
//    同意会员注册协议，并开启同步手机通讯录
    NSString *registAgreementStr = @"<会员注册协议>";
    CGSize registAgreementSize = [registAgreementStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *registAgreementLab = [[UILabel alloc] initWithFrame:CGRectMake(iAgreeLab.right, iAgreeLab.top, registAgreementSize.width, registAgreementSize.height)];
    [registAgreementLab setBackgroundColor:[UIColor clearColor]];
    [registAgreementLab setFont:[UIFont systemFontOfSize:14.0f]];
    [registAgreementLab setTextColor:kTextColorBlue];
    [registAgreementLab setText:registAgreementStr];
    [registAgreementLab setUserInteractionEnabled:YES];
    [registAgreementLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registAgreementLabTap:)]];
    [agreeBg addSubview:registAgreementLab];
    
//    服务协议，并同意开启同步手机通讯录
    NSString *iAgreeStr2 = @",并开启同步手机通讯录";
    CGSize iAgreeStrSize2 = [iAgreeStr2 sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *iAgreeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(registAgreementLab.right, _agreeBtn.top, iAgreeStrSize2.width, iAgreeStrSize2.height)];
    [iAgreeLab2 setBackgroundColor:[UIColor clearColor]];
    [iAgreeLab2 setFont:[UIFont systemFontOfSize:14.0f]];
    [iAgreeLab2 setTextColor:kTextColorGray];
    [iAgreeLab2 setText:iAgreeStr2];
    [iAgreeLab2 setUserInteractionEnabled:NO];
    [agreeBg addSubview:iAgreeLab2];
    
    [agreeBg setFrame:CGRectMake((kScreenWidth - iAgreeLab2.right)/2, _completeBtn.bottom+15, iAgreeLab2.right, _agreeBtn.height)];
    [self.view addSubview:agreeBg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bgTap:(UITapGestureRecognizer *)tap
{
    [_phoneNumberTextField resignFirstResponder];
    [_verCodeTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)registAgreementLabTap:(UITapGestureRecognizer *)tap
{
    JYRegisterAgreementController *registerAgreementController = [[JYRegisterAgreementController alloc] init];
    [self.navigationController pushViewController:registerAgreementController animated:YES];
}

- (void)getCodeBtnClick:(UIButton *)btn
{
    if (_timer) {
        return;
    }
    _getCodeBtn.enabled = NO;
    if ([JYHelpers isPhoneNumber:_phoneNumberTextField.text]) {
        
        //检查手机号
        [self requestMobileExists];
        
    } else {
        _getCodeBtn.enabled = YES;
        [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
    }
}

- (void)showPasswordBtnClick:(UIButton *)btn
{
    if (btn.selected) {
        [btn setSelected:NO];
        [_passwordTextField setSecureTextEntry:YES];
    } else {
        [btn setSelected:YES];
        [_passwordTextField setSecureTextEntry:NO];
    }
}

- (void)completeBtnClick:(UIButton *)btn
{
//    JYRegisterInfoController *registerInfoController = [[JYRegisterInfoController alloc] init];
//    [self.navigationController pushViewController:registerInfoController animated:YES];
//    return;
    
    
    //检查手机号
    if (![JYHelpers isPhoneNumber:_phoneNumberTextField.text])
    {
        [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
        return;
    }
    
    //检查验证码
    if (_verCodeTextField.text.length != 6) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"验证码需为6位字符，请检查"];
        return;
    }
    
    //检查密码
    if ((_passwordTextField.text.length<6) || (_passwordTextField.text.length>20))
    {
        [[JYAppDelegate sharedAppDelegate] showTip:@"密码需为6-20位字符，请检查"];
        return;
    }
    NSRange _rang = [_passwordTextField.text rangeOfString:@" "];
    if (_rang.location != NSNotFound)
    {
        [[JYAppDelegate sharedAppDelegate] showTip:@"密码中不能包含空格，请检查"];
        return;
    }
    
    [self requestValMobileCode];
    
    /*
    
    //检查手机号
    if (![JYHelpers isPhoneNumber:_phoneNumberTextField.text])
    {
        [[JYAppDelegate sharedAppDelegate] showTip:@"手机号输入有误，请检查"];
        return;
    }
    
    //检查密码
    if (_passwordTextField.text.length<6)
    {
        [[JYAppDelegate sharedAppDelegate] showTip:@"密码需为6-20位字符，请检查"];
        return;
    }
    NSRange _rang = [_passwordTextField.text rangeOfString:@" "];
    if (_rang.location != NSNotFound)
    {
        [[JYAppDelegate sharedAppDelegate] showTip:@"密码中不能包含空格，请检查"];
        return;
    }
    
    [self requestCheckVerificationCode];
    
    */
}

- (void)_agreeBtnClick:(UIButton *)btn
{
    [btn setSelected:!btn.selected];
    //
}

- (void)timerFireMethod:(NSTimer *)timer
{
    if (_seconds == 1) {
        [timer invalidate];
        _timer = nil;
        _seconds = kReacquireCodeWaitSecond;
//        [_getCodeBtn setSelected:NO];
//        [_getCodeBtn setBackgroundColor:kTextColorBlue];
        [_getCodeLab setText:@"重新发送"];
        [_getCodeBtn setEnabled:YES];
    } else {
        _seconds--;
//        [_getCodeBtn setSelected:YES];
//        [_getCodeBtn setBackgroundColor:kTextColorGray];
        NSString *title = [NSString stringWithFormat:@"%ld秒后可重新发送",(long)_seconds];
        [_getCodeLab setText:title];
        [_getCodeBtn setEnabled:NO];
    }
}
- (void)gotoLogin{
    JYLoginController *loginVC = [[JYLoginController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == KVO_CONTEXT_AGREE_BTN_SELECTED_CHANGED) {
        
        BOOL isPhoneNumber = [JYHelpers isPhoneNumber:_phoneNumberTextField.text];
        BOOL isCodeLengthStandard = (_verCodeTextField.text.length == 6);
        
        //规范手机号 验证码 密码 完成按钮才能点击
        if (isPhoneNumber && isCodeLengthStandard && _agreeBtn.selected)
        {
            [_completeBtn setEnabled:YES];
        } else {
            [_completeBtn setEnabled:NO];
        }
    }
}

#pragma mark - notification

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    
    BOOL isPhoneNumber = [JYHelpers isPhoneNumber:_phoneNumberTextField.text];
    BOOL isCodeLengthStandard = (_verCodeTextField.text.length > 0);
    
    //规范手机号 验证码 密码 完成按钮才能点击
    if (isPhoneNumber && isCodeLengthStandard && _agreeBtn.selected)
    {
        [_completeBtn setEnabled:YES];
    } else {
        [_completeBtn setEnabled:NO];
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
    
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:formDict options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    NSDictionary *postDict = [NSDictionary dictionaryWithObject:jsonString forKey:@"form"];
//    [parametersDict setObject:jsonString forKey:@"form"];

    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            //手机号可以注册
            [self requestGetCheckCode];
            
        } else if (iRetcode == -1) {
            
            //手机号已经注册
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPhoneNumberAlreadyRegisterPleaseLogin];
            [self performSelector:@selector(gotoLogin) withObject:nil afterDelay:1.0];
            
        } else if (iRetcode == -2) {
            
            _getCodeBtn.enabled = YES;
            //手机号不合法
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:kPleaseEnterValidPhoneNumber];
        } else {
            _getCodeBtn.enabled = YES;

        }
        
    } failure:^(id error) {
        _getCodeBtn.enabled = YES;
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
    /*
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            //手机号可以注册
            
            
        } else if (iRetcode == -1) {
            
            //手机号已经注册
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:@"手机号已注册，可直接登录"];
            
        } else if (iRetcode == -2) {
            
            //手机号不合法
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
            [[JYAppDelegate sharedAppDelegate] showTip:@"请输入有效的手机号码"];
        } else {}
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    */
}

//获取验证码
- (void)requestGetCheckCode
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"register" forKey:@"mod"];
    [parametersDict setObject:@"get_check_code" forKey:@"func"];

    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:_phoneNumberTextField.text forKey:@"mobile"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            NSLog(@"成功");
            [[JYAppDelegate sharedAppDelegate] showTip:kVerificationCodeSentSuccess];
            [_getCodeBtn setEnabled:NO];
            
            _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            
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
    
    /*
    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            NSLog(@"成功");
            [[JYAppDelegate sharedAppDelegate] showTip:kVerificationCodeSentSuccess];
            [_getCodeBtn setEnabled:NO];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        } else if (iRetcode == -1) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"每天最多发送三次"];
        } else if (iRetcode == -2) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"您已经发过很多次验证码了，请稍后再试"];
        } else if (iRetcode == -3) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"发送失败稍后重试"];
        } else {}
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    */
}

//验证验证码
- (void)requestValMobileCode
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"register" forKey:@"mod"];
    [parametersDict setObject:@"valMobileCode" forKey:@"func"];
    [parametersDict setObject:_phoneNumberTextField.text forKey:@"mobile"];
    [parametersDict setObject:_verCodeTextField.text forKey:@"mobile_code"];
    
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:_phoneNumberTextField.text forKey:@"mobile"];
    [formDict setObject:_verCodeTextField.text forKey:@"mobile_code"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            NSInteger iData = [[responseObject objectForKey:@"data"] integerValue];
            
            if (iData == 1) {
                
                //验证成功
                //[[JYAppDelegate sharedAppDelegate] showTip:@"验证成功"];
                
                JYRegisterInfoController *registerInfoController = [[JYRegisterInfoController alloc] init];
                [registerInfoController setPhoneNumber:_phoneNumberTextField.text];
                [registerInfoController setVerificationCode:_verCodeTextField.text];
                [registerInfoController setPassword:_passwordTextField.text];
                [self.navigationController pushViewController:registerInfoController animated:YES];
                
            } else {
                
                //验证失败
                [[JYAppDelegate sharedAppDelegate] showTip:@"验证码输入有误"];
            
            }
            
            
        } else {
        
        }
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
    
    /*
    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            JYRegisterInfoController *registerInfoController = [[JYRegisterInfoController alloc] init];
            registerInfoController.phoneNumber = _phoneNumberTextField.text;
            registerInfoController.password = _passwordTextField.text;
            registerInfoController.verificationCode = _verCodeTextField.text;
            [self.navigationController pushViewController:registerInfoController animated:YES];
            
        } else {
        
            [[JYAppDelegate sharedAppDelegate] showTip:@"验证码验证不成功"];
        
        }
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    */
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //手机号不能超过11位
    if ([textField isEqual:_phoneNumberTextField] && textField.text.length == 11 && ![string isEqualToString:@""]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"手机号不能超过11位"];
        return NO;
    }
    //    验证码不能超过6位
    if ([textField isEqual:_verCodeTextField] && textField.text.length == 6 && ![string isEqualToString:@""]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"验证码不能超过6位"];
        return NO;
    }
    if ([textField isEqual:_passwordTextField] && textField.text.length == 20 && ![string isEqualToString:@""]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"密码不能超过20位"];
        return NO;
    }
    return YES;
}


@end
