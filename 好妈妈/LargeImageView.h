//
//  LargeImageView.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-18.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"

@interface LargeImageView : UIView<UIScrollViewDelegate> {
    NetImageView *mImageView;
    UIScrollView *mScrollView;
    UIActivityIndicatorView *mActView;
}

@property (nonatomic, assign) float mMaxZoomScale;

- (void)ShowImage:(NSString *)headimage;

@end
