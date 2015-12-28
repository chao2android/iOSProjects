//
//  ModifyPasswordViewController.m
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "AutoAlertView.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"修改密码"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    
    int iTop = 64;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, self.view.frame.size.width, 150)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    iTop += imageView.frame.size.height;
    
    for (int i = 0; i < 3; i ++) {
        if (i > 0) {
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50*i, imageView.frame.size.width, 0.5)];
            lineView.backgroundColor = [UIColor lightGrayColor];
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
    [loginBtn setBackgroundColor:[UIColor grayColor]];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(OnRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}


- (void)OnRegisterClick{
    
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
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/UpdateUserInfo"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:UserManager.userInfor.userId forKey:@"uid"];
    [dict setObject:mPassword.text forKey:@"oldpassword"];
    [dict setObject:mPassword2.text forKey:@"password"];
    
    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
        NSLog(@"修改信息----》%@",info);
        [AutoAlertView ShowMessage:@"修改成功"];
        [self.naviController popViewControllerAnimated:YES];
        
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
    }];
}
- (UIView *)GetInputAccessoryView
{
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    inputView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(inputView.frame.size.width-50, 0, 50, inputView.frame.size.height);
    [btn setTitle:@"隐藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(OnHideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:btn];
    
    return inputView;
}
- (void)OnHideKeyboard {
    [self.view endEditing:NO];
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

@end
