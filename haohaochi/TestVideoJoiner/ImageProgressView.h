//
//  ImageProgressView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageProgressView : UIView<UIGestureRecognizerDelegate> {
    UIImageView *mFlagView;
    UIImageView *mBackView;
    CGPoint mStartPoint;
}

@property (nonatomic, assign) int miProgressIndex;

@end
