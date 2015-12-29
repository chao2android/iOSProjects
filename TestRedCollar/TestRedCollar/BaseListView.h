//
//  BaseListView.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BaseADViewController.h"

@interface BaseListView : UIView {
    MBProgressHUD *mLoadView;
}

@property (nonatomic, assign) BaseADViewController *mRootCtrl;
@property (nonatomic, assign) UIViewController *mParentCtrl;

- (void)GoBack;
- (void)StartLoading;
- (void)StopLoading;
- (void)showMsg:(NSString *)msg;

@end
