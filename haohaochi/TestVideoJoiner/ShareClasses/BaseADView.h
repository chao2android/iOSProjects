//
//  BaseADView.h
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-17.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseADView : UIView {
    
    MBProgressHUD *mLoadView;
    UIImageView *mLogoView;
}

@property (nonatomic, retain) NSString *mLoadMsg;

- (void)StartLoading;
- (void)StopLoading;

- (void)HideLogo;
- (void)ShowLogo:(int)iOffset;

@end
