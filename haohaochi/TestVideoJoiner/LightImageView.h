//
//  LightImageView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightImageView : UIView {
    UIView *mLightView;
    UIView *mAnimateView;
}

@property (nonatomic, assign) BOOL mbAnimating;

- (void)StopAnimate;
- (void)StartAnimate;

@end
