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
