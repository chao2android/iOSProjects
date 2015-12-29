//
//  AmendPasswordViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-8-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AmendPasswordViewController.h"
#import "AutoAlertView.h"
#import "JSON.h"

@interface AmendPasswordViewController ()

@end

@implementation AmendPasswordViewController

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
	// Do any additional setup after loading the view.
    
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    int iTop = 15;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, self.view.frame.size.width, 150)];
    imageView.image = [[UIImage imageNamed:@"f_whiteback"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    iTop += imageView.frame.size.height;
    
    for (int i = 0; i < 3; i ++) {
        if (i > 0) {
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50*i, imageView.frame.size.width, 1)];
            lineView.image = [UIImage imageNamed:@"51.png"];
            [imageView addSubview:lineView];
        }
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(15, 5+i*50, 210, 40)];
        textfield.inputAccessoryView = [self GetInputAccessoryView];
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [imageView addSubview:textfield];
        
        if (i == 0) {
            mPassword = textfield;
            mPassword.placeholder = @"输入旧密码";
            mPassword.secureTextEntry = YES;
        }
        else if (i == 1) {
            mPassword2 = textfield;
            mPassword2.placeholder = @"输入新密码";
            mPassword2.secureTextEntry = YES;
        }
        else if (i == 2) {
            mPassword3 = textfield;
            mPassword3.placeholder = @"再次输入新密码";
            mPassword3.secureTextEntry = YES;
        }
    }
    
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

- (void)OnRegisterClick
{
    if (!mPassword.text || mPassword.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写旧密码"];
        return;
    }
    if (!mPassword2.text || mPassword2.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写新密码"];
        return;
    }
    if (mPassword2.text.length < 6) {
        [AutoAlertView ShowAlert:@"提示" message:@"密码长度不小于6位"];
        return;
    }
    if (!mPassword3.text || mPassword3.text.length == 0 || ![mPassword3.text isEqualToString:mPassword2.text]) {
        [AutoAlertView ShowAlert:@"提示" message:@"两次输入密码不一致"];
        return;
    }
    [self RegisterUser];
}

- (void)dealloc
{
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
    [dict setObject:@"modifyPassWord" forKey:@"act"];
    [dict setObject:mPassword.text forKey:@"oldPassWord"];
    [dict setObject:mPassword2.text forKey:@"newPassWord"];
    [dict setObject:kkToken forKey:@"token"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"dict---->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        int iStatus = [[dict objectForKey:@"statusCode"] intValue];
        if (iStatus == 0) {
            [AutoAlertView ShowAlert:@"提示" message:@"密码修改成功"];
            kkUserDict = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_Logout object:nil userInfo:nil];
            [self GoHome];
        }
        else {
            //NSString *msg = [dict objectForKey:@"msg"];
            [AutoAlertView ShowAlert:@"提示" message:@"旧密码输入错误"];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
