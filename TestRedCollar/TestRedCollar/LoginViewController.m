//
//  LoginViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AutoAlertView.h"
#import "JSON.h"
//#import "ForgetViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    int iTop = 15;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, self.view.frame.size.width, 100)];
    imageView.image = [[UIImage imageNamed:@"f_whiteback"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    iTop += (imageView.frame.size.height+30);
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, imageView.frame.size.width-10, 1)];
    lineView.image = [UIImage imageNamed:@"51.png"];
    [imageView addSubview:lineView];
    
    for (int i = 0; i < 2; i ++) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.size.width-30, 15+i*50, 20, 20)];
        iconView.image = [UIImage imageNamed:(i == 0)?@"f_loginuser":@"f_loginpas"];
        [imageView addSubview:iconView];
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(15, 5+i*50, 210, 40)];
        textfield.inputAccessoryView = [self GetInputAccessoryView];
        textfield.placeholder = (i == 0)?@"手机号":@"密码";
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [imageView addSubview:textfield];
        if (i == 1) {
            mPassword = textfield;
            mPassword.secureTextEntry = YES;
        }
        else {
            mUserName = textfield;
            mUserName.autocorrectionType = UITextAutocorrectionTypeNo;
        }
    }
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15, iTop, self.view.frame.size.width-30, 44);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"f_redbtn"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(OnLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    iTop += (loginBtn.frame.size.height+5);
    
    UILabel *lbText = [[UILabel alloc] initWithFrame:CGRectMake(0, iTop, 240, 30)];
    lbText.backgroundColor = [UIColor clearColor];
    lbText.font = [UIFont systemFontOfSize:14];
    lbText.textAlignment = UITextAlignmentRight;
    lbText.text = @"还没有注册？";
    [self.view addSubview:lbText];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(235, iTop, 65, 32);
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:Default_Color forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerBtn addTarget:self action:@selector(OnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
//    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    forgetBtn.frame = CGRectMake(235, iTop+25, 65, 32);
//    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
//    [forgetBtn setTitleColor:Default_Color forState:UIControlStateNormal];
//    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [forgetBtn addTarget:self action:@selector(OnForgetClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:forgetBtn];
    
//    iTop += 40;
//    
//    lbText = [[UILabel alloc] initWithFrame:CGRectMake(15, iTop, 240, 30)];
//    lbText.backgroundColor = [UIColor clearColor];
//    lbText.font = [UIFont systemFontOfSize:15];
//    lbText.text = @"合作网站账号登录：";
//    [self.view addSubview:lbText];
//    
//    iTop += 40;
//    
//    for (int i = 0; i < 3; i ++) {
//        NSString *imagename = [NSString stringWithFormat:@"f_share%02d.png", i+1];
//        UIButton *thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        thirdBtn.frame = CGRectMake(30+i*50, iTop, 35, 35);
//        [thirdBtn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
//        [thirdBtn addTarget:self action:@selector(OnThirdClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:thirdBtn];
//    }
}

- (void)OnRegisterClick {
    RegisterViewController *ctrl = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

//- (void)OnForgetClick
//{
//    ForgetViewController *forgetVC = [[ForgetViewController alloc] init];
//    [self.navigationController pushViewController:forgetVC animated:YES];
//}

- (void)OnLoginClick {
    if (!mUserName.text || mUserName.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写用户名"];
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
    [self.view endEditing:YES];
    [self LoginToServer];
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

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoginToServer {
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
    [dict setObject:@"login" forKey:@"act"];
    [dict setObject:mUserName.text forKey:@"phoneNum"];
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
            kkUserDict = [dict objectForKey:@"User"];
            kkToken = [dict objectForKey:@"token"];
            kkUserID = [dict objectForKey:@"id"];
            kkServe_type = [dict objectForKey:@"serve_type"];
            [self GoBack];
        }
        else if (iStatus == 10000) {
            
        }
        else {
            NSString *msg = [dict objectForKey:@"msg"];
            [AutoAlertView ShowAlert:@"提示" message:msg];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)OnThirdClick {
    
}

/*
 参数名	参数描述	备注
 phoneNum	手机号（或Email）
 password	密码
 输出参数
 statusCode	操作结果	0 成功
 1密码与手机号（或Email）不匹配，请重试
 Token	用户合法标识	如果用户在别处改密码了，可以变化，代表需要用户重新登录
 User	用户的基本信息	具体见下述
 User（用户）
 参数名	参数描述	备注
 Id	用户token
 headImgUrl	用户头像Url
 nickname	昵称
 phoneNum	手机号
 password	密码
 Score	积分
 lastUpdateTime 	最后登录时间
 
 调用例子：http://rctailor.ec51.com.cn/soaapi/soap/user.php?act=login&phoneNum=admin&passWord=admin123
 */

@end
