//
//  RegisterViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "RegisterViewController.h"
#import "AutoAlertView.h"
#import "JSON.h"

@interface RegisterViewController () {
    UIButton *mSelectBtn;
}

@end

@implementation RegisterViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    int iTop = 15;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, self.view.frame.size.width, 200)];
    imageView.image = [[UIImage imageNamed:@"f_whiteback"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    iTop += imageView.frame.size.height;
    
    for (int i = 0; i < 4; i ++) {
        if (i > 0) {
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50*i, imageView.frame.size.width, 1)];
            lineView.image = [UIImage imageNamed:@"51.png"];
            [imageView addSubview:lineView];
        }
        
        if (i < 2) {
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.size.width-30, 15+i*50, 20, 20)];
            iconView.image = [UIImage imageNamed:(i == 0)?@"f_loginuser":@"f_loginpas"];
            [imageView addSubview:iconView];
        }

        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(15, 5+i*50, 210, 40)];
        textfield.inputAccessoryView = [self GetInputAccessoryView];
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [imageView addSubview:textfield];
        if (i == 0) {
            mMobile = textfield;
            mMobile.placeholder = @"手机号";
        }
        else if (i == 1) {
            mPassword = textfield;
            mPassword.placeholder = @"设置登录密码";
            mPassword.secureTextEntry = YES;
        }
        else if (i == 2) {
            mPassword2 = textfield;
            mPassword2.placeholder = @"再次输入密码";
            mPassword2.secureTextEntry = YES;
        }
        else if (i == 3) {
            mSMSCode = textfield;
            mSMSCode.placeholder = @"填写验证码";
        }
    }
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(self.view.frame.size.width-100, imageView.frame.size.height-50, 100, 50);
    [checkBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkBtn setTitleColor:Default_Color forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [checkBtn addTarget:self action:@selector(CheckValidSMS) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:checkBtn];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 50)];
    lineView.image = [UIImage imageNamed:@"f_line02"];
    [checkBtn addSubview:lineView];
    
    mSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mSelectBtn.frame = CGRectMake(20, iTop+10, 30, 30);
    [mSelectBtn setBackgroundImage:[UIImage imageNamed:@"f_select01"] forState:UIControlStateNormal];
    [mSelectBtn setBackgroundImage:[UIImage imageNamed:@"f_select02"] forState:UIControlStateSelected];
    [mSelectBtn addTarget:self action:@selector(OnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mSelectBtn];
    
    UILabel *lbText = [[UILabel alloc] initWithFrame:CGRectMake(50, iTop+10, 240, 30)];
    lbText.backgroundColor = [UIColor clearColor];
    lbText.font = [UIFont systemFontOfSize:14];
    lbText.textColor = Default_Color;
    lbText.text = @"我已阅读《RCTAILOR用户注册协议》";
    [self.view addSubview:lbText];
    
    iTop += 60;
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15, iTop, self.view.frame.size.width-30, 44);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"f_redbtn"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(OnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)OnSelectClick:(UIButton *)sender {
    mSelectBtn.selected = !mSelectBtn.selected;
    
}

- (void)OnRegisterClick {
    if (!mMobile.text || mMobile.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写手机号"];
        return;
    }
    if (!mPassword.text || mPassword.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写密码"];
        return;
    }
    if (mPassword.text.length < 6) {
        [AutoAlertView ShowAlert:@"提示" message:@"密码长度不小于6位"];
        return;
    }
    if (!mPassword2.text || mPassword2.text.length == 0 || ![mPassword2.text isEqualToString:mPassword.text]) {
        [AutoAlertView ShowAlert:@"提示" message:@"两次输入密码不一致"];
        return;
    }
    if (!mSMSCode.text || mSMSCode.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入验证码"];
        return;
    }
    if (!self.mCode || ![self.mCode isEqualToString:mSMSCode.text]) {
        [AutoAlertView ShowAlert:@"提示" message:@"验证码不正确"];
        return;
    }
    [self RegisterUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self Cancel];
}

#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)RegisterUser {
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"register" forKey:@"act"];
    [dict setObject:mMobile.text forKey:@"phoneNum"];
    [dict setObject:mPassword.text forKey:@"passWord"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"statusCode"] intValue];
        if (iStatus == 0) {
            kkToken = [dict objectForKey:@"token"];
            kkUserDict = [dict objectForKey:@"User"];
            [self GoBack];
        }
        else {
            NSString *msg = [dict objectForKey:@"msg"];
            [AutoAlertView ShowAlert:@"提示" message:msg];
        }
    }
}

- (void)CheckValidSMS {
    if (!mMobile.text || mMobile.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写手机号"];
        return;
    }
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnCheckFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"verifyPhoneNum" forKey:@"act"];
    [dict setObject:mMobile.text forKey:@"phoneNum"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnCheckFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"statusCode"] intValue];
        NSString *msg = [dict objectForKey:@"msg"];
        if (iStatus == 0) {
            self.mCode = [NSString stringWithFormat:@"%@", [dict objectForKey:@"verificationCode"]];
            msg = @"已发送验证码，请查收";
        }
        [AutoAlertView ShowAlert:@"提示" message:msg];
    }
}


- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

/*
 
 参数名	参数描述	备注
 phoneNum	手机号（或Email）
 Password	密码
 输出参数
 statusCode	操作结果	0 成功；1 失败；2号码已注
 Token	用户合法标识	成功时返回。如果用户在别处改密码了，可以变化，代表需要用户重新登录
 User	用户	成功时返回。
 
 调用例子：/rctailor.ec51.com.cn/soaapi/soap/user.php?act=register&phoneNum=13975645362&passWord=admin123
 
 verifyPhoneNum
 输入参数
 参数名	参数描述	备注
 phoneNum	手机号
 输出参数
 statusCode	操作结果	0 成功；1 失败；
 verificationCode	注册验证码
 
 
 调用例子：
 //rctailor.ec51.com.cn/soaapi/soap/user.php?act=verifyPhoneNum&phoneNum=18611111111
 */

@end
