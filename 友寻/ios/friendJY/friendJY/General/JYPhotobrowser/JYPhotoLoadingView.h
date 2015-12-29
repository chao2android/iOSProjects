//
//  AZXPhotoLoadingView.h
//  imAZXiPhone
//
//  Created by coder_zhang on 14-8-4.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinProgress 0.0001

@interface JYPhotoLoadingView : UIView

@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure;


@end
