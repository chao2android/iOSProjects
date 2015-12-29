//
//  GCPagingView.h
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCPagingViewDelegate;

@interface GCPagingView : UIView<UIScrollViewDelegate>
{
    UIPageControl *mPageCtrl;
    UIScrollView *mScrollView;
    NSTimer *_theTimer;
    NSInteger miOffsetIndex;
}

@property (nonatomic, strong) NSMutableArray *mRecycleList;
@property (nonatomic, strong) NSMutableArray *mVisibleList;
@property (nonatomic, assign) id<GCPagingViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger pageCount;
@property (nonatomic, readonly) NSInteger curIndex;
@property (nonatomic, assign) BOOL isAutoPlay;


- (void)reloadData;
- (UIView *)dequeueReusablePage;
- (void)startAutoScroll;
- (void)stopAutoScroll;
@end


@protocol GCPagingViewDelegate <NSObject>

- (NSInteger)numberOfPagesInPagingView:(GCPagingView*)pagingView;
- (UIView*)GCPagingView:(GCPagingView*)pagingView viewAtIndex:(NSInteger)index;

@optional

- (void)GCPagingView:(GCPagingView*)pagingView pageChangeToIndex:(NSInteger)index;



@end
