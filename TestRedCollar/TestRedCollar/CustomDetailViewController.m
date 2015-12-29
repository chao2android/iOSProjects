//
//  CustomDetailViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CustomDetailViewController.h"
#import "BuyCarViewController.h"
#import "CoolShareView.h"
#import "AlbumSaveView.h"

@interface CustomDetailViewController ()

@end

@implementation CustomDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)GoBack {
    if (mTimer) {
        [mTimer invalidate];
        mTimer = nil;
    }
    [super GoBack];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    
    int iTop = IOS_7?20:0;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, iTop, self.view.frame.size.width, 44)];
    [self.view addSubview:topView];

    UIButton *backBtn = [self GetImageButton:[UIImage imageNamed:@"35.png"] target:self action:@selector(GoBack)];
    backBtn.frame = CGRectMake(10, 2, 40, 40);
    [topView addSubview:backBtn];
    
    UIButton *saveBtn = [self GetImageButton:[UIImage imageNamed:@"36.png"] target:self action:@selector(OnSaveClick)];
    saveBtn.frame = CGRectMake(self.view.frame.size.width-100, 2, 40, 40);
    [topView addSubview:saveBtn];
    
    UIButton *shareBtn = [self GetImageButton:[UIImage imageNamed:@"37.png"] target:self action:@selector(OnShareClick)];
    shareBtn.frame = CGRectMake(self.view.frame.size.width-50, 2, 40, 40);
    [topView addSubview:shareBtn];
    
    UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-92, self.view.frame.size.width, 92)];
    botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    botView.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    [self.view addSubview:botView];
    
    mTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mTypeBtn.frame = CGRectMake((botView.frame.size.width-40)/2, 0, 40, 30);
    [mTypeBtn addTarget:self action:@selector(OnTypeClick) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:mTypeBtn];
    
    MaterialSelectView *selectView = [[MaterialSelectView alloc] initWithFrame:CGRectMake(0, 27, botView.frame.size.width, 50)];
    selectView.delegate = self;
    [botView addSubview:selectView];
    [botView sendSubviewToBack:selectView];
    
    iTop = (self.view.frame.size.height-400)/2;
    mImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-216)/2, iTop, 216, 301)];
    mImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    mImageView.image = [UIImage imageNamed:@"43_2.png"];
    [self.view addSubview:mImageView];
    
    UIButton *buybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buybtn.frame = CGRectMake(self.view.frame.size.width-130, self.view.frame.size.height-140, 120, 32);
    buybtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [buybtn setBackgroundImage:[UIImage imageNamed:@"38.png"] forState:UIControlStateNormal];
    [buybtn setTitle:@"￥2800   立即定制" forState:UIControlStateNormal];
    [buybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buybtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [buybtn addTarget:self action:@selector(OnBuyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buybtn];
    
    [self OnTypeImageChange];

    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(OnTypeImageChange) userInfo:Nil repeats:YES];
}

- (void)OnBuyClick {
    BuyCarViewController *ctrl = [[BuyCarViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)OnMaterialSelect:(MaterialSelectView *)sender {
    NSString *imagename = [NSString stringWithFormat:@"%d_2.png", sender.miIndex+43];
    @autoreleasepool {
        mImageView.image = [UIImage imageNamed:imagename];
    }
}

- (void)OnTypeClick {
    UIActionSheet *actView = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"面料", @"里料", @"款式", @"其他", nil];
    [actView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }
    else if (buttonIndex == 1) {
        
    }
    else if (buttonIndex == 2) {
        
    }
    else if (buttonIndex == 3) {
        
    }
}

- (void)OnTypeImageChange {
    static int index = 0;
    @autoreleasepool {
        NSString *imagename = [NSString stringWithFormat:@"40-%d", index+1];
        [mTypeBtn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    }
    index = (index+1)%3;
}

- (void)OnSaveClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    AlbumSaveView *shareView = [[AlbumSaveView alloc] initWithFrame:window.bounds];
    [window addSubview:shareView];
}

- (void)OnShareClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CoolShareView *shareView = [[CoolShareView alloc] initWithFrame:window.bounds];
    [window addSubview:shareView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (IOS_7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    if (IOS_7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
