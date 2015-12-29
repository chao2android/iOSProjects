//
//  ForgetViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ForgetViewController.h"
#import "AutoAlertView.h"

@interface ForgetViewController ()

@end

@implementation ForgetViewController

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
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    int iTop = 15;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, self.view.frame.size.width, 100)];
    imageView.image = [[UIImage imageNamed:@"f_whiteback"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    iTop += (imageView.frame.size.height+15);
    
    for (int i = 0; i < 2; i ++) {
        if (i > 0) {
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50*i, imageView.frame.size.width-10, 1)];
            lineView.image = [UIImage imageNamed:@"51.png"];
            [imageView addSubview:lineView];
        }

        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 5+i*50, 210, 40)];
        textfield.inputAccessoryView = [self GetInputAccessoryView];
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [imageView addSubview:textfield];
        if (i == 0) {
            mUserName = textfield;
            mUserName.placeholder = @"请输入您的手机号";
            
            mCodeBtn = [[CheckCodeButton alloc] initWithFrame:CGRectMake(imageView.frame.size.width-87, 9, 77, 32)];
            mCodeBtn.mTitleColor = [UIColor blackColor];
            mCodeBtn.delegate = self;
            mCodeBtn.image = [UIImage imageNamed:@"l_checkcode"];
            [imageView addSubview:mCodeBtn];
        }
        else if (i == 1) {
            mCode = textfield;
            mCode.placeholder = @"输入6位短信验证码";
        }
    }

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15, iTop, self.view.frame.size.width-30, 48);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"f_redbtn"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(OnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (BOOL)GetCheckCode {
    if (!mUserName.text || mUserName.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入手机号"];
        return NO;
    }
    if (mUserName.text.length != 11) {
        [AutoAlertView ShowAlert:@"提示" message:@"手机号必须是11位"];
        return NO;
    }
    return YES;
}

- (void)OnRegisterClick {
    if (!mUserName.text || mUserName.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入您的手机号"];
        return;
    }
    if (!mCode.text || mCode.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入6位短信验证码"];
        return;
    }
    [self GoBack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
