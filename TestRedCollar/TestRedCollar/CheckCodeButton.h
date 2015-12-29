//
//  CheckCodeButton.h
//  掌上社区
//
//  Created by Hepburn Alex on 14-4-2.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckCodeButton;

@protocol CheckCodeButtonDelegate <NSObject>

- (BOOL)GetCheckCode;

@end

@interface CheckCodeButton : UIImageView {
    UIButton *mCheckBtn;
    NSTimer *mTimer;
}

@property (nonatomic, assign) UIColor *mTitleColor;
@property (nonatomic, assign) id<CheckCodeButtonDelegate> delegate;

- (void)StartCheck;
- (void)Cancel;

@end
