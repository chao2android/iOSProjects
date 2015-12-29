//
//  BaseListView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseListView.h"

@implementation BaseListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    }
    return self;
}

- (void)GoBack
{
    if (self.mParentCtrl) {
        [self.mRootCtrl.navigationController popToViewController:self.mParentCtrl animated:YES];
    }
    else {
        [self.mRootCtrl.navigationController popViewControllerAnimated:YES];
    }
}

- (void)StartLoading
{
    mLoadView = [[MBProgressHUD alloc] initWithView:self];
	mLoadView.labelText = @"正在加载...";
    [self addSubview:mLoadView];
    [mLoadView show:YES];
}

- (void)StopLoading
{
    [mLoadView hide:YES];
    mLoadView = nil;
}


- (void)goLoading{
    
    isLoadingView= [[UIView alloc]initWithFrame:self.bounds];
    isLoadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:isLoadingView];
    
    //isLoadingView.tag = 80;
    UIImageView *isContinuingImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 280, 172)];
    isContinuingImage.alpha = 0.8;
    isContinuingImage.image = [UIImage imageNamed:@"w.png"];
    [isLoadingView addSubview:isContinuingImage];
    
    
}
- (void)stopLoading{
    [isLoadingView removeFromSuperview];
    isLoadingView= nil;
}





- (void)showMsg:(NSString *)msg
{
    mLoadView = [[MBProgressHUD alloc] initWithView:self];
	[self addSubview:mLoadView];
	mLoadView.mode = MBProgressHUDModeCustomView;
	mLoadView.labelText = msg;
	[mLoadView show:YES];
	[mLoadView hide:YES afterDelay:1];
    mLoadView = nil;
}

@end
