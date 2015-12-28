//
//  PopAlertView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PopAlertView.h"

@implementation PopAlertView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)ShowAlert:(NSString *)alertImage {
    UIImage *image = [UIImage imageNamed:alertImage];
    mImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-image.size.width/2)/2, self.frame.size.height-image.size.height/2, image.size.width/2, image.size.height/2)];
    mImageView.image = image;
    [self addSubview:mImageView];
    
    mCenter = mImageView.center;
    
    [self UpAnimate];
}

- (void)UpAnimate {
    [UIView animateWithDuration:0.5 animations:^{
        mImageView.center = CGPointMake(mCenter.x, mCenter.y-5);
    } completion:^(BOOL bFinish) {
        [self DownAnimate];
    }];
}

- (void)DownAnimate {
    [UIView animateWithDuration:0.5 animations:^{
        mImageView.center = mCenter;
    } completion:^(BOOL bFinish) {
        [self UpAnimate];
    }];
}

@end
