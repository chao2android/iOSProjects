//
//  ScrollPageView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollPageView;

@protocol ScrollPageViewDelegate <NSObject>

- (UIView *)ScrollPageView:(ScrollPageView *)sender viewAtIndex:(NSInteger)index;
- (NSInteger)NumberOfPageViews:(ScrollPageView *)sender ;
- (float)WidthOfPageView:(ScrollPageView *)sender;
- (void)ScrollPageView:(ScrollPageView *)sender scrollToPage:(NSInteger)index;

@end

@interface ScrollPageView : UIView<UIScrollViewDelegate> {

}

@property (nonatomic, assign) UIScrollView *mScrollView;
@property (nonatomic, readonly) NSArray *mPageViews;
@property (nonatomic, assign) id<ScrollPageViewDelegate> delegate;
@property (nonatomic, assign) NSInteger pageIndex;

- (void)reloadData;

@end