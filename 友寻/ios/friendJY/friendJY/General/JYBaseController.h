//
//  AZXBaseController.h
//  imAZXiPhone
//
//  Created by GAO on 14-6-30.
//  Copyright (c) 2014年 GAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYBaseController : UIViewController

@property (nonatomic,assign) float autoSizeScaleX;
@property (nonatomic,assign) float autoSizeScaleY;
- (void)showProgressHUD:(NSString *)message toView:(UIView *)view;
- (void)showSuccessProgressHUD:(NSString *)message toView:(UIView *)view;
- (void)dismissProgressHUDtoView:(UIView *)view;

- (void)setViewControllerTitle:(NSString *)title;
- (void)hiddenNavView:(BOOL)hidden;


// 统计
//- (void)_requestStatistics:(NSString *)numid needUid:(int)needNum;

- (void)backAction;

@end
