//
//  AZXBaseController.m
//  imAZXiPhone
//
//  Created by GAO on 14-6-30.
//  Copyright (c) 2014年 GAO. All rights reserved.
//

#import "JYBaseController.h"
#import "ProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface JYBaseController ()
{
    UIImageView *navBaseView;
//    __weak ASIFormDataRequest *_requestStatist; // 统计
}

// 是否添加返回按钮
@property (nonatomic,assign) BOOL isBackButton;

@end

@implementation JYBaseController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 禁用 iOS7 返回手势
    if (SYSTEM_VERSION >= 7.0f) {
        
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


//    [self.navigationController setNavigationBarHidden:YES];
    
    if (SYSTEM_VERSION >= 7.0f) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    // 子控制器个数大于1，则添加返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        self.isBackButton = YES;
    }
    
    // 添加返回按钮
    if (self.isBackButton) {
        // 创建返回的按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 60, 44);
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
    }
    
//    [self _initNavView];
    
    self.view.backgroundColor = [JYHelpers setFontColorWithString:@"#edf1f4"];

    self.autoSizeScaleX = kScreenWidth/320;
    self.autoSizeScaleY = kScreenHeight/568;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)backBtnClick:(UIButton *)btn
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)backAction
{
    if (self.isBackButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setViewControllerTitle:(NSString *)title
{
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:100];
    titleLabel.text = title;
}

- (void)hiddenNavView:(BOOL)hidden
{
    if (!hidden) {
//        [self _initNavView];
        navBaseView.hidden = NO;
        
    }
}

- (void)_initNavView
{
    // 导航栏背景视图
    if (SYSTEM_VERSION >= 7.0f) {
        
        navBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight + 20)];
    } else {
        navBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
    }
    
    navBaseView.userInteractionEnabled = YES;
    navBaseView.hidden = NO;
    navBaseView.image = [UIImage imageNamed:@"nav_bg.png"];
    [self.view addSubview:navBaseView];
    
    // 导航栏左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (SYSTEM_VERSION >= 7.0f) {
        leftBtn.frame = CGRectMake(0, 10 + 20, 60, 21);
    } else {
        leftBtn.frame = CGRectMake(0, 10, 60, 21);
    }
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_fanhui.png"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_fanhui.png"] forState:UIControlStateHighlighted];
    [navBaseView addSubview:leftBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 100;
    if (SYSTEM_VERSION >= 7.0f) {
        titleLabel.frame = CGRectMake(50, 11.5 + 20, kScreenWidth-100, 20);
    } else {
        titleLabel.frame = CGRectMake(50, 11.5, kScreenWidth-100, 20);
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [JYHelpers setFontColorWithString:@"#ffffff"];
    //    titleLabel.text = @"最近访问";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [navBaseView addSubview:titleLabel];

}


- (void)showProgressHUD:(NSString *)message toView:(UIView *)view
{
//    if (SYSTEM_VERSION >= 7.0f) {
//        [ProgressHUD show:message];
//    } else {
        [MBProgressHUD showMessag:message toView:view];
//    }
}

- (void)showSuccessProgressHUD:(NSString *)message toView:(UIView *)view
{
    if (SYSTEM_VERSION >= 7.0f) {
        [ProgressHUD showSuccess:message];
    } else {
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
}

- (void)dismissProgressHUDtoView:(UIView *)view
{
//    if (SYSTEM_VERSION >= 7.0f) {
//        [ProgressHUD dismiss];
//    } else {
        [MBProgressHUD hideHUDForView:view animated:YES];
//    }
}



// 统计
//- (void)_requestStatistics:(NSString *)numid needUid:(int)needNum
//{
//    /**
//	 * @Title: add_focus
//	 * @Description: 统计
//     * @URL: http:/ /client.izhenxin.dev/cmiajax/?mod=register_ios&func=reg_step_checkpoint&num=id&uniq=uid
//	 * @date 2014-9-28
//	 */
//    
//    __weak ASIFormDataRequest *_requestStatist;
//    
//    NSString *uidStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
//    
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"register_ios" forKey:@"mod"];
//    [parametersDict setObject:@"reg_step_checkpoint" forKey:@"func"];
//    if (needNum == 1) {
//        [parametersDict setObject:uidStr forKey:@"uniq"];
//    }
//    [parametersDict setObject:numid forKey:@"num"];
////    [_requestStatist clearDelegatesAndCancel];
//    _requestStatist = [ASIFormDataRequest requestWithURL:[AZXHttpServeice urlWithParametersDict:parametersDict]];
//    [_requestStatist startAsynchronous];
//    
//}


@end
