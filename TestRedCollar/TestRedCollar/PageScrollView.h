//
//  PageScrollView.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageScrollView;

@protocol PageScrollViewDelegate <NSObject>

- (void)OnPageScrollSelect:(PageScrollView *)sender;

@end

@interface PageScrollView : UIView<UIScrollViewDelegate> {
    UIScrollView *mScrollView;
    UIPageControl *mPageCtrl;
}

@property (nonatomic, assign) int miIndex;
@property (nonatomic, assign) id<PageScrollViewDelegate> delegate;

@end
