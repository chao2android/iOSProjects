//
//  HomeViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "HomeViewController.h"
#import "CoolListView.h"
#import "MoneyHomeView.h"
#import "MyHomeView.h"
#import "MessageListViewController.h"
#import "OptionViewController.h"
#import "QRScanViewController.h"
#import "PopPhotoView.h"
#import "LoginViewController.h"
#import "ThemeListView.h"
#import "MyCustomListView.h"
#import "UpLoadPhotoViewController.h"
#import "ValidCheckManager.h"

@interface HomeViewController ()

@end

static HomeViewController *gHomeCtrl = nil;

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        gHomeCtrl = self;
    }
    return self;
}

+ (UIViewController *)mRootCtrl {
    return gHomeCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowFirstView) name:kMsg_Logout object:nil];
    mTabView = [[TabbarView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50) withImageArray:@[@"mtabbar_1",@"mtabbar_2",@"mtabbar_3",@"mtabbar_4",]];
    mTabView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    mTabView.delegate = self;
    [self.view addSubview:mTabView];
    
    [self OnTabSelect:mTabView];
    
    [[ValidCheckManager Share] CheckValid];
}

- (void)ShowFirstView
{
    mTabView.miIndex = 0;
    [self OnTabSelect:mTabView];
}

- (void)OnPhotoClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    PopPhotoView *popView = [[PopPhotoView alloc] initWithFrame:window.bounds];
    popView.delegate = self;
    popView.OnPopSelect = @selector(OnPopPhotoSelect:);
    [window addSubview:popView];
}

- (void)OnPopPhotoSelect:(NSNumber *)number {
    if (!kkIsLogin) {
        LoginViewController *ctrl = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        return;
    }
    if ([number intValue] == 0) {
        UpLoadPhotoViewController *upLoadPhoto = [[UpLoadPhotoViewController alloc] init];
        upLoadPhoto.theTitleText = @"街拍上传";
        [self.navigationController pushViewController:upLoadPhoto animated:YES];
    }
    else {
        QRScanViewController *ctrl = [[QRScanViewController alloc] init];
        ctrl.mBackCtrl = self;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

//系统消息
- (void)OnMsgClick {
    MessageListViewController *tViewCtrl=[[MessageListViewController alloc] init];
    [self.navigationController pushViewController:tViewCtrl animated:YES];
}

//设置
- (void)OnOptionClick {
    OptionViewController *tViewCtrl=[[OptionViewController alloc] init];
    [self.navigationController pushViewController:tViewCtrl animated:YES];
}

- (void)RefreshNavBar:(int)index {
    [self ClearNavItem];
    if (index == 0) {
        self.title = @"主题配搭系列";
        [self AddRightImageBtn:[UIImage imageNamed:@"2.png"] target:self action:@selector(OnPhotoClick)];
    }
    else if (index == 1) {
        self.title = @"定制主页";
        [self AddRightImageBtn:[UIImage imageNamed:@"2.png"] target:self action:@selector(OnPhotoClick)];
    }
    else if (index == 2) {
        self.title = @"晒酷主页";
        [self AddRightImageBtn:[UIImage imageNamed:@"2.png"] target:self action:@selector(OnPhotoClick)];
    }
    else if (index == 3) {
        self.title = @"我的";
        [self AddLeftImageBtn:[UIImage imageNamed:@"150.png"] target:self action:@selector(OnMsgClick)];
        [self AddRightImageBtn:[UIImage imageNamed:@"151.png"] target:self action:@selector(OnOptionClick)];
    }
}

- (BOOL)CanSelectTab:(TabbarView *)sender :(int)index {
    if (index == 2 || index == 3) {
        if (!kkIsLogin) {
            LoginViewController *ctrl = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
            return NO;
        }
    }
    return YES;
}

- (void)OnTabSelect:(TabbarView *)sender {
    int index = sender.miIndex;
    
    int iHeight = 50;
    [self RefreshNavBar:index];
    
    for (int i = 0; i < 4; i ++) {
        BaseListView *view = (BaseListView *)[self.view viewWithTag:i+2000];
        if (view) {
            view.hidden = (index != i);
            if (index == 3) {
                [((MyHomeView *)[self.view viewWithTag:index+2000]) refreshHomeView];
            }
        }
        else if (index == i) {
            if (index == 0) {
                //主题
                ThemeListView *themeView = [[ThemeListView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-iHeight)];
                themeView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                themeView.mRootCtrl = self;
                themeView.tag = i+2000;
                [self.view addSubview:themeView];
            }
            else if (index == 1) {
                MyCustomListView *listView = [[MyCustomListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-iHeight)];
                listView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                listView.mRootCtrl = self;
                listView.tag = i+2000;
                [self.view addSubview:listView];
                [listView LoadCustomList];
            }
            else if (index == 2) {
                CoolListView *listView = [[CoolListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-iHeight)];
                listView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                listView.mRootCtrl = self;
                listView.tag = i+2000;
                [self.view addSubview:listView];
                
                listView.type = 4;
                listView.pageIndex = 1;
                [listView loadData];
                //[listView LoadCoolList];
            }
            else if (index == 3) {
                MyHomeView *listView = [[MyHomeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-iHeight)];
                listView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                listView.mRootCtrl = self;
                listView.tag = i+2000;
                [self.view addSubview:listView];
//                [listView LoadCustomList];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
