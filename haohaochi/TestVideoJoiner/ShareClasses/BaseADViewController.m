//
//  BaseADViewController.m
//  TestDialogue
//
//  Created by Hepburn Alex on 13-2-6.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"

#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp)
#define MB_DEALLOC()
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#define MB_DEALLOC() [super dealloc]
#endif


@interface BaseADViewController ()

@end

@implementation BaseADViewController

@synthesize mlbTitle, delegate, OnGoBack, mTopColor, mTopImage, mLoadMsg, mTitleColor, mbLightNav, mFontSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mbStatusBarHidden = NO;
        mbLightNav = YES;
        mFontSize = 20;
        self.mTopImage = [UIImage imageNamed:IOS_7?@"topbar7.png":@"topbar.png"];
        self.mTopColor = kDefault_Color;
        self.mTitleColor = [UIColor blackColor];
    }
    return self;
}

- (void)GoHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)GoBack {
    if (delegate && OnGoBack) {
        SafePerformSelector([delegate performSelector:OnGoBack withObject:self]);
    }
    UIViewController *topCtrl = self.navigationController.topViewController;
    if (topCtrl == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)RefreshNavColor {
    if (mTopColor) {
        if (IOS_7) {
            self.navigationController.navigationBar.barTintColor = mTopColor;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
        else {
            self.navigationController.navigationBar.tintColor = mTopColor;
        }
    }
    if (mTopImage) {
        [self.navigationController.navigationBar setBackgroundImage:mTopImage forBarMetrics:UIBarMetricsDefault];
    }
    if (mTitleColor) {
        mlbTitle.textColor = self.mTitleColor;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    if (IOS_7) {
        //去掉边缘化 适配
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (!mbLightNav) {
            self.navigationController.navigationBar.translucent = NO;
        }
    }
    [self RefreshNavColor];

    mlbTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-100, 44)];
    mlbTitle.backgroundColor = [UIColor clearColor];
    mlbTitle.font = [UIFont fontWithName:@"Helvetica-Light" size:mFontSize];
    mlbTitle.textAlignment = NSTextAlignmentCenter;
    mlbTitle.textColor = self.mTitleColor;
    mlbTitle.text = self.title;
    self.navigationItem.titleView = mlbTitle;
    MB_RELEASE(mlbTitle);
    
    
    [self AddLeftImageBtn:nil target:nil action:nil];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mlbMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-40)/2, self.view.frame.size.width, 40)];
    mlbMsg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    mlbMsg.backgroundColor = [UIColor clearColor];
    mlbMsg.font = [UIFont systemFontOfSize:16];
    mlbMsg.textColor = [UIColor darkGrayColor];
    mlbMsg.text = @"暂无数据";
    mlbMsg.textAlignment = NSTextAlignmentCenter;
    mlbMsg.hidden = YES;
    [self.view addSubview:mlbMsg];
}

- (void)ClearNavItem {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (UIButton *)GetImageButton:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    int iWidth = image.size.width/2;
    int iHeight = image.size.height/2;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((40-iWidth)/2, (40-iHeight)/2, iWidth, iHeight);
    imageView.tag = 1300;
    [rightBtn addSubview:imageView];
    MB_RELEASE(imageView);
    
    return rightBtn;
}

- (UIBarButtonItem *)GetImageBarItem:(UIImage *)image target:(id)target action:(SEL)action scale:(float)scale {
    int iBtnWidth = IOS_7?30:40;
    int iWidth = image.size.width/scale;
    int iHeight = image.size.height/scale;
    if (iWidth>iBtnWidth) {
        iBtnWidth = iWidth;
    }
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, iBtnWidth, 40);
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((iBtnWidth-iWidth)/2, (40-iHeight)/2, iWidth, iHeight);
    imageView.tag = 1300;
    [rightBtn addSubview:imageView];
    MB_RELEASE(imageView);
    
    return MB_AUTORELEASE([[UIBarButtonItem alloc] initWithCustomView:rightBtn]);
}

- (UIBarButtonItem *)GetTextBarItem:(NSString *)name target:(id)target action:(SEL)action {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:name forState:UIControlStateNormal];
    [rightBtn setTitleColor:self.mTitleColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return MB_AUTORELEASE([[UIBarButtonItem alloc] initWithCustomView:rightBtn]);
}

- (void)AddLeftImageBtn:(UIImage *)image target:(id)target action:(SEL)action {
    [self AddLeftImageBtn:image target:target action:action scale:2.0];
}

- (void)AddLeftImageBtn:(UIImage *)image target:(id)target action:(SEL)action scale:(float)scale {
    self.navigationItem.leftBarButtonItem = [self GetImageBarItem:image target:target action:action scale:scale];
}

- (void)AddRightImageBtn:(UIImage *)image target:(id)target action:(SEL)action {
    [self AddRightImageBtn:image target:target action:action scale:2.0];
}

- (void)AddRightImageBtn:(UIImage *)image target:(id)target action:(SEL)action scale:(float)scale  {
    self.navigationItem.rightBarButtonItem = [self GetImageBarItem:image target:target action:action scale:scale];
}

- (void)AddRightImageBtns:(NSArray *)array {
    if (!array || array.count == 0) {
        return;
    }
    UIView *view = MB_AUTORELEASE([[UIView alloc] initWithFrame:CGRectMake(0, 0, array.count*40, 40)]);
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [array objectAtIndex:i];
        btn.frame = CGRectMake(i*40, 0, 40, 40);
        [view addSubview:btn];
    }
    self.navigationItem.rightBarButtonItem = MB_AUTORELEASE([[UIBarButtonItem alloc] initWithCustomView:view]);
}

- (void)AddRightTextBtn:(NSString *)name target:(id)target action:(SEL)action {
    self.navigationItem.rightBarButtonItem = [self GetTextBarItem:name target:target action:action];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    mlbTitle.text = title;
}

- (void)AddTitleView:(UIView *)titleView {
    self.navigationItem.titleView = titleView;
}

- (UIView *)GetInputAccessoryView {
    UIView *inputView = MB_AUTORELEASE([[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)]);
    inputView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(inputView.frame.size.width-50, 0, 50, inputView.frame.size.height);
    btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
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

- (void)dealloc {
    self.mTopColor = nil;
    self.mTopImage = nil;
    self.mLoadMsg = nil;
    MB_DEALLOC();
}

- (void)ShowLogo:(int)iOffset {
    if (mLogoView) {
        return;
    }
    int iWidth = 150;
    int iHeight = 130;
    mLogoView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-iWidth)/2, (self.view.frame.size.height-iHeight)/2+iOffset, iWidth, iHeight)];
    mLogoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    mLogoView.image = [UIImage imageNamed:@"default_logo.png"];
    [self.view addSubview:mLogoView];
}

- (void)HideLogo {
    if (mLogoView) {
        [mLogoView removeFromSuperview];
        mLogoView = nil;
    }
}

- (void)StartLoading
{
    if (mLoadView) {
        return;
    }
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
        mLoadView.labelText = mLoadMsg;
    }
    [self.view addSubview:mLoadView];
    MB_RELEASE(mLoadView);
    
    [mLoadView show:YES];
}

- (void)StopLoading
{
    [mLoadView hide:YES];
    mLoadView = nil;
}

- (void)showMsg:(NSString *)msg
{
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:mLoadView];
    MB_RELEASE(mLoadView);
    
	mLoadView.mode = MBProgressHUDModeCustomView;
	mLoadView.labelText = msg;
	[mLoadView show:YES];
	[mLoadView hide:YES afterDelay:1];
    mLoadView = nil;
}

- (void)HideStatusBar:(BOOL)hide {
    mbStatusBarHidden = hide;
    if (IOS_7) {
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }
    else {
        [UIApplication sharedApplication].statusBarHidden = hide;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return mbStatusBarHidden;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[SelectTabBar Share].hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ShowMsgLabel {
    [self.view bringSubviewToFront:mlbMsg];
    mlbMsg.hidden = NO;
}

- (void)HideMsgLabel {
    mlbMsg.hidden = YES;
}

@end
