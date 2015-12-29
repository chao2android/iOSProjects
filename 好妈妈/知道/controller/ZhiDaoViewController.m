//
//  ZhiDaoViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "ZhiDaoViewController.h"
#import "TuijianViewController.h"
#import "JinghuaViewController.h"
#import "FenleiViewController.h"
#import "SearViewController.h"

#import "contentViewController.h"
#import "detailsViewController.h"
#import "VersionManager.h"
#import "GrowingInfoView.h"
#import "HuiYuanZhiFuViewController.h"
#import "GerzxViewController.h"

@interface ZhiDaoViewController ()

@end

@implementation ZhiDaoViewController

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
    if (IOS_7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [[VersionManager Share] CheckAppVersion:NO];

      //memuTag = 0;
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=YES;
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    
    mNavView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    mNavView.backgroundColor = [UIColor blackColor];
    mNavView.userInteractionEnabled = YES;
    mNavView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:mNavView];
    [mNavView release];
    
    int iWidth = 189;
    int iHeight = 30;
    int iLeft = (Screen_Width-iWidth)/2;
    int iTop = mNavView.frame.size.height-38;
    
    //新改
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(11), (Screen_Width-200), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"今天";
    [mNavView addSubview:navigationLabel];
    [navigationLabel release];
     
//    mNavTabBar = [[NavTabBar alloc] initWithFrame:CGRectMake(iLeft, iTop, iWidth, iHeight)];
//    mNavTabBar.delegate = self;
//    [mNavView addSubview:mNavTabBar];
//    [mNavTabBar release];
    
    //[self RefreshNavButton:0];
    
    //新加
    mLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mLeftBtn.frame = CGRectMake(5, KUIOS_7(6), 45, 30.5);
    [mLeftBtn addTarget:self action:@selector(OnUserInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [mLeftBtn setImage:[UIImage imageNamed:@"f_userbtn.png"] forState:UIControlStateNormal];
    [mNavView addSubview:mLeftBtn];
    
    mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mRightBtn.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [mRightBtn setTitle:@"会员" forState:UIControlStateNormal];
    [mRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [mRightBtn setBackgroundImage:[UIImage imageNamed:@"钮.png"] forState:UIControlStateNormal];
    [mRightBtn addTarget:self action:@selector(OnVipClick) forControlEvents:UIControlEventTouchUpInside];
    [mNavView addSubview:mRightBtn];
    
    /*
    TuijianViewController *tjCtrl = [[TuijianViewController alloc]init];
    tjCtrl.nav = self.navigationController;
    tjCtrl.view.tag = 20000;
    tjCtrl.view.frame = CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height -104);
    [self.view addSubview:tjCtrl.view];
    */
    MOBCLICK(kMob_Growing);
    GrowingInfoView *infoView = [[GrowingInfoView alloc] initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-104)];
    infoView.mRootCtrl = self;
    infoView.tag = 20000;
    [self.view addSubview:infoView];
    [infoView release];
    
    if ([UserInfoManager Share].mMsgID) {
        contentViewController *ctrl = [[contentViewController alloc]init];
        ctrl.contentID = [UserInfoManager Share].mMsgID;
        [self.navigationController pushViewController:ctrl animated:YES];
        [ctrl release];
        [UserInfoManager Share].mMsgID = nil;
    }
}
/*
- (void)RefreshNavButton:(int)index {
    if (mLeftBtn) {
        [mLeftBtn removeFromSuperview];
        mLeftBtn = nil;
    }
    if (mRightBtn) {
        [mRightBtn removeFromSuperview];
        mRightBtn = nil;
    }
    if (index == 0) {
        mLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mLeftBtn.frame = CGRectMake(5, KUIOS_7(6), 45, 30.5);
        [mLeftBtn addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
        [mLeftBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_18" ofType:@"png"]] forState:UIControlStateNormal];
        [mNavView addSubview:mLeftBtn];
        
        mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mRightBtn.frame = CGRectMake(Screen_Width-57, KUIOS_7(6), 52, 30.5);
        [mRightBtn setTitle:@"最新" forState:UIControlStateNormal];
        [mRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        mRightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [mRightBtn setBackgroundImage:[UIImage imageNamed:@"001_19.png"] forState:UIControlStateNormal];
        [mRightBtn addTarget:self action:@selector(RightMenth:) forControlEvents:UIControlEventTouchUpInside];
        [mNavView addSubview:mRightBtn];
    }
    else {
        mLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mLeftBtn.frame = CGRectMake(5, KUIOS_7(6), 45, 30.5);
        [mLeftBtn addTarget:self action:@selector(OnUserInfoClick) forControlEvents:UIControlEventTouchUpInside];
        [mLeftBtn setImage:[UIImage imageNamed:@"f_userbtn.png"] forState:UIControlStateNormal];
        [mNavView addSubview:mLeftBtn];
        
        mRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mRightBtn.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
        [mRightBtn setTitle:@"会员" forState:UIControlStateNormal];
        [mRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        mRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [mRightBtn setBackgroundImage:[UIImage imageNamed:@"钮.png"] forState:UIControlStateNormal];
        [mRightBtn addTarget:self action:@selector(OnVipClick) forControlEvents:UIControlEventTouchUpInside];
        [mNavView addSubview:mRightBtn];
    }
}
*/
- (void)OnVipClick {
    HuiYuanZhiFuViewController *ctrl = [[HuiYuanZhiFuViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)OnUserInfoClick {
    GerzxViewController * ctrl = [[GerzxViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

//- (void)OnNavTabSelect:(NavTabBar *)sender {
//    [self RefreshNavButton:sender.miIndex];
//    if (sender.miIndex == 0) {
//        [self RefreshView:0];
//    }
//    else {
//        [self RefreshGrowingView];
//    }
//}

- (void)RightMenth:(UIButton *)but
{
    if (!memu) {
        memu = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width - 90, KUIOS_7(40), 80, 100)];
        memu.image = [UIImage imageNamed:@"001_20.png"];
        memu.userInteractionEnabled=YES;
        [self.view addSubview:memu];
        [memu release];
        
        bgMemu = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10+30*memuTag, 70, 30)];
        bgMemu.image = [UIImage imageNamed:@"001_21.png"];
        [memu addSubview:bgMemu];
        [bgMemu release];
        
        NSArray *arr = [NSArray arrayWithObjects:@"最新",@"精华",@"分类", nil];
        for (int i = 0; i < 3; i++) {
            UIButton *memuBut = [UIButton buttonWithType:UIButtonTypeCustom];
            [memuBut setTitle:arr[i] forState:UIControlStateNormal];
            [memuBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            memuBut.titleLabel.font = [UIFont systemFontOfSize:14] ;
            memuBut.frame = CGRectMake(5, 10+30*i, 70, 30);
            memuBut.tag = 10000 +i;
            [memuBut addTarget:self action:@selector(clicked_memuBut:) forControlEvents:UIControlEventTouchUpInside];
            [memu addSubview:memuBut];
        }
        
    }
    else{
        [memu removeFromSuperview];
        memu = nil;
    }
}

- (void)clicked_memuBut :(UIButton *)but{
    [self RefreshView:but.tag - 10000];
}

/*
- (void)RefreshGrowingView {
    if (memu) {
        [memu removeFromSuperview];
        memu = nil;
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIView *listView = [self.view viewWithTag:20000];
    if (listView) {
        [listView removeFromSuperview];
    }
    [pool release];
    
    MOBCLICK(kMob_Growing);
    GrowingInfoView *infoView = [[GrowingInfoView alloc] initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-104)];
    infoView.mRootCtrl = self;
    infoView.tag = 20000;
    [self.view addSubview:infoView];
    [infoView release];
}
*/
- (void)RefreshView:(int)butTag {
    memuTag = butTag;
    if (memu) {
        [memu removeFromSuperview];
        memu = nil;
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIView *listView = [self.view viewWithTag:20000];
    if (listView) {
        [listView removeFromSuperview];
    }
    [pool release];
    
    
    if (butTag == 0) {
        [mRightBtn setTitle:@"最新" forState:UIControlStateNormal];
        
        TuijianViewController *Ctrl = [[TuijianViewController alloc]init];
        Ctrl.nav = self.navigationController;
        
        Ctrl.view.tag = 20000;
        Ctrl.view.frame = CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height -104);
        [self.view addSubview:Ctrl.view];
    }else if (butTag == 1){
        [mRightBtn setTitle:@"精华" forState:UIControlStateNormal];
        
        JinghuaViewController *Ctrl = [[JinghuaViewController alloc]init];
        Ctrl.nav = self.navigationController;
        
        Ctrl.view.tag = 20000;
        Ctrl.view.frame = CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height -104);
        [self.view addSubview:Ctrl.view];
    }else{
        [mRightBtn setTitle:@"分类" forState:UIControlStateNormal];
        
        FenleiViewController *Ctrl = [[FenleiViewController alloc]init];
        Ctrl.nav = self.navigationController;
        
        Ctrl.view.tag = 20000;
        Ctrl.view.frame = CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height -104);
        [self.view addSubview:Ctrl.view];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
}


-(void)backup{
  SearViewController *ctrl = [[[SearViewController alloc ]init]autorelease];
  [self.navigationController pushViewController:ctrl animated:YES];
  
}


@end
