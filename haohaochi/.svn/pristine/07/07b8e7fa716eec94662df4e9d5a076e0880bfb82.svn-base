//
//  BaseADView.m
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-17.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADView.h"

@implementation BaseADView

@synthesize mLoadMsg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    self.mLoadMsg = nil;
}

- (void)ShowLogo:(int)iOffset {
    if (mLogoView) {
        return;
    }
    int iWidth = 150;
    int iHeight = 130;
    mLogoView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-iWidth)/2, (self.frame.size.height-iHeight)/2+iOffset, iWidth, iHeight)];
    mLogoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    mLogoView.image = [UIImage imageNamed:@"default_logo.png"];
    [self addSubview:mLogoView];
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
    mLoadView = [[MBProgressHUD alloc] initWithView:self];
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
        mLoadView.labelText = mLoadMsg;
    }
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
