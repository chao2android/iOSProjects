//
//  TJLoginRegisterViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/3.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJLoginRegisterViewController.h"
#import "WTVTextField.h"
#import "TJRegistViewController.h"
#import "TJLoginViewModel.h"

@interface TJLoginRegisterViewController ()

@property (nonatomic, strong) TJLoginViewModel *viewModel;

@property (nonatomic, strong) UIImageView   *backImageView;

@property (nonatomic, strong) UIImageView   *headImageView;

@property (nonatomic, strong) WTVTextField   *phoneTextField;

@property (nonatomic, strong) WTVTextField   *passWordTextField;

@property (nonatomic, strong) UIButton      *btnLogin;

@property (nonatomic, strong) UIButton      *btnRegister;

@property (nonatomic, strong) UIButton      *btnWeibo;

@property (nonatomic, strong) UIButton      *btnForget;

@property(nonatomic,assign)EnterType enterType;

@end

@implementation TJLoginRegisterViewController

- (instancetype)init:(EnterType)enterType
{
    self = [super init];
    if (self) {
        self.enterType=enterType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel = [[TJLoginViewModel alloc] init];
    [self buildUI];
}

- (void)buildUI
{
    
    _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [_backImageView setImage:[UIImage imageNamed:@"user_login_bg"]];
    [self.view addSubview:_backImageView];
    
    UIButton *btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnReturn setFrame:CGRectMake(20, 30, 20, 28)];
    [btnReturn setImage:[UIImage imageNamed:@"appui_fanhui_"] forState:UIControlStateNormal];
    [[btnReturn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.enterType == EnterType_Push) {
            [self.naviController popToRootViewControllerAnimated:YES];
        }
        else if (self.enterType == EnterType_PresentPor)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        if (self.loginFinish) {
             self.loginFinish(nil);
        }
       
        
    }];
    [self.view addSubview:btnReturn];
    
    UIImage *headImg = [UIImage imageNamed:@"head_img"];
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headImg.size.width, headImg.size.width)];
    [_headImageView setImage:headImg];

    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = headImg.size.width/2;
    [_headImageView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/4)];
    [self.view addSubview:_headImageView];
    
    
    UIImage * textImg = [UIImage imageNamed:@"sign_11_"];
    _phoneTextField = [[WTVTextField alloc] initWithFrame:CGRectMake(0, _headImageView.frame.size.height + _headImageView.frame.origin.y +40 *SCREEN_PHISICAL_SCALE, textImg.size.width/2, textImg.size.height/2)];
    [_phoneTextField setBackground:textImg];
    [_phoneTextField setCenter:CGPointMake(SCREEN_WIDTH/2, _phoneTextField.center.y)];
    _phoneTextField.borderStyle=UITextBorderStyleNone;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImage *phoneImg = [UIImage imageNamed:@"sign_6_"];
    UIImageView *phoneLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, phoneImg.size.width/2, phoneImg.size.height/2)];
    [phoneLeftView setImage:phoneImg];
    _phoneTextField.placeholder = @"手机号";
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextField.leftView = phoneLeftView;
    _phoneTextField.returnKeyType=UIReturnKeyNext;
    _phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneTextField];
    
    _passWordTextField = [[WTVTextField alloc] initWithFrame:CGRectMake(0, _phoneTextField.frame.size.height + _phoneTextField.frame.origin.y +20, textImg.size.width/2, textImg.size.height/2)];
    [_passWordTextField setBackground:textImg];
    [_passWordTextField setCenter:CGPointMake(SCREEN_WIDTH/2, _passWordTextField.center.y)];
    _passWordTextField.borderStyle=UITextBorderStyleNone;
    _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordTextField.secureTextEntry = YES;
    _passWordTextField.placeholder = @"请输入密码";
    UIImage *passImg = [UIImage imageNamed:@"sign_5_"];
    UIImageView *passLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, passImg.size.width/2, passImg.size.height/2)];
    [passLeftView setImage:passImg];
    _passWordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passWordTextField.leftView = passLeftView;
    _passWordTextField.returnKeyType=UIReturnKeyGo;
    _passWordTextField.keyboardType=UIKeyboardTypeASCIICapable;
    [self.view addSubview:_passWordTextField];
    
    UIImage *loginImg = [UIImage imageNamed:@"sign_9_"];
    _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];

    [_btnLogin setBackgroundImage:loginImg forState:UIControlStateNormal];
    [_btnLogin setTitle:@"登陆" forState:UIControlStateNormal];
    [_btnLogin setFrame:CGRectMake(0, _passWordTextField.frame.size.height + _passWordTextField.frame.origin.y +20, textImg.size.width/2, textImg.size.height/2)];
    [_btnLogin setCenter:CGPointMake(SCREEN_WIDTH/2, _btnLogin.center.y)];
    [self.view addSubview:_btnLogin];
    [[_btnLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [_viewModel postLoginUserInfo:_phoneTextField.text andPassWord:_passWordTextField.text finish:^{
            
            if (self.loginFinish) {
                self.loginFinish(nil);
            }
        } failed:^(NSString *error) {
            
        }];
    }];
    
    UIImageView *regImagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _btnLogin.frame.size.height + _btnLogin.frame.origin.y +20, textImg.size.width/2, textImg.size.height/2)];
    [regImagView setImage:loginImg];
    [regImagView setCenter:CGPointMake(SCREEN_WIDTH/2, regImagView.center.y)];
    [self.view addSubview:regImagView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, regImagView.frame.size.height - 10)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [line setCenter:CGPointMake(regImagView.frame.size.width/2, regImagView.frame.size.height/2)];
    [regImagView addSubview:line];
    regImagView.userInteractionEnabled = YES;
    
    UIImage *rePhoneImg = [UIImage imageNamed:@"sign_7_"];
    UIImage *reWeiboImg = [UIImage imageNamed:@"sign_8_"];
    
    _btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRegister setFrame:CGRectMake(0, 0, regImagView.frame.size.width/2, regImagView.frame.size.height)];
    [_btnRegister setTitle:@"手机注册" forState:UIControlStateNormal];
    [_btnRegister setImage:rePhoneImg forState:UIControlStateNormal];
    
    
    [[_btnRegister rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        TJRegistViewController *registVC = [[TJRegistViewController alloc] init:PageType_Register];
        [self.naviController pushViewController:registVC animated:YES];
        
    }];
    
    _btnWeibo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnWeibo setImage:reWeiboImg forState:UIControlStateNormal];
    [_btnWeibo setFrame:CGRectMake(regImagView.frame.size.width/2, 0, regImagView.frame.size.width/2, regImagView.frame.size.height)];
    [_btnWeibo setTitle:@"微博授权" forState:UIControlStateNormal];
    [[_btnWeibo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    
    [regImagView addSubview:_btnRegister];
    [regImagView addSubview:_btnWeibo];
    
    _btnForget = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnForget setFrame:CGRectMake(0, regImagView.frame.size.height + regImagView.frame.origin.y +20, textImg.size.width/2, textImg.size.height/2)];
    [_btnForget setTitle:@"忘记密码>>" forState:UIControlStateNormal];
    [_btnForget setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnForget.center = CGPointMake(SCREEN_WIDTH/2, _btnForget.center.y);
    [self.view addSubview:_btnForget];
    
    [[_btnForget rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        TJRegistViewController *registVC = [[TJRegistViewController alloc] init:PageType_Forget];
        [self.naviController pushViewController:registVC animated:YES];
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.naviController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.naviController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
      
      
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
//        @strongify(self)
        
    } completion:nil];
  
}



@end
