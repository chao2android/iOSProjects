//
//  GCPagingView.m
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "GCPagingView.h"

#define TIME_INTERVAL 2.5

@implementation GCPagingView

@synthesize mRecycleList, mVisibleList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        self.mRecycleList = [[NSMutableArray alloc] initWithCapacity:10];
        self.mVisibleList = [[NSMutableArray alloc] initWithCapacity:10];
        
        mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        mScrollView.backgroundColor = [UIColor clearColor];
        mScrollView.delegate = self;
        mScrollView.pagingEnabled = YES;
        mScrollView.contentSize = CGSizeMake(3*mScrollView.frame.size.width, mScrollView.frame.size.height);
        mScrollView.contentOffset = CGPointMake(mScrollView.frame.size.width, 0);
        mScrollView.showsHorizontalScrollIndicator=NO;
        [self addSubview:mScrollView];
        
        mPageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 20)];
        mPageCtrl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        mPageCtrl.userInteractionEnabled = NO;
        [self addSubview:mPageCtrl];
        
        miOffsetIndex = 1;
        _isAutoPlay = YES;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"GCPagingView dealloc");
    [self stopAutoScroll];
    self.mRecycleList = nil;
    self.mVisibleList = nil;
}

- (void)reloadData{
    [self stopAutoScroll];
    
    _pageCount = [_delegate numberOfPagesInPagingView:self];
    
    @autoreleasepool {
        for (UIView *pageView in mVisibleList){
            [mRecycleList addObject:pageView];
            [pageView removeFromSuperview];
        }
        [mVisibleList removeAllObjects];
    }
    
    if (_pageCount == 1) {
        _isAutoPlay = NO;
        mScrollView.scrollEnabled = NO;
        mPageCtrl.numberOfPages = 0;
        
        UIView *pageView = [_delegate GCPagingView:self viewAtIndex:0];
        pageView.frame = CGRectMake(mScrollView.frame.size.width, 0, mScrollView.frame.size.width, mScrollView.frame.size.height);
        [mVisibleList addObject:pageView];
        [mScrollView addSubview:pageView];
        return;
    }
    
    _curIndex = 0;
    miOffsetIndex = 1;
    mScrollView.contentOffset = CGPointMake(mScrollView.frame.size.width, 0);
    mScrollView.scrollEnabled = YES;
    
    mPageCtrl.currentPage = 0;
    mPageCtrl.numberOfPages = _pageCount;
    
    [self refreshAllView];
    
    if (_isAutoPlay) {
        _theTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(autoScrollView) userInfo:nil repeats:YES];
    }
}

- (void)autoScrollView{
    if (_pageCount <= 1) {
        return;
    }
    if (!mScrollView.isDecelerating && !mScrollView.isDragging) {
        [mScrollView setContentOffset:CGPointMake(2*mScrollView.frame.size.width, 0) animated:YES];
    }
}

- (void)stopAutoScroll{
    if (_theTimer) {
        [_theTimer invalidate];
        _theTimer = nil;
    }
}


- (void)startAutoScroll{
    mScrollView.scrollEnabled = YES;
    [self stopAutoScroll];
    _isAutoPlay = YES;
    _theTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(autoScrollView) userInfo:nil repeats:YES];
}


- (void)refreshAllView{
    if (_pageCount == 0) {
        return;
    }
    mPageCtrl.currentPage = _curIndex;
    
    @autoreleasepool {
        NSMutableArray *removeArray = [NSMutableArray array];
        NSInteger iFirst = miOffsetIndex-1?miOffsetIndex-1:0;
        NSInteger iLast = miOffsetIndex+1;
        for(UIView *tView in mVisibleList){
            if (tView.frame.origin.x<iFirst*mScrollView.frame.size.width || tView.frame.origin.x>iLast*mScrollView.frame.size.width) {
                [removeArray addObject:tView];
                [mRecycleList addObject:tView];
                [tView removeFromSuperview];
            }
        }
        [mVisibleList removeObjectsInArray:removeArray];
    }
    
    
    if (mVisibleList.count == 0) {
        NSInteger lastIndex = [self getRealIndexValue:_curIndex-1];
        NSInteger nextIndex = [self getRealIndexValue:_curIndex+1];
        UIView *pageView = [_delegate GCPagingView:self viewAtIndex:lastIndex];
        [mVisibleList addObject:pageView];
        
        pageView = [_delegate GCPagingView:self viewAtIndex:_curIndex];
        [mVisibleList addObject:pageView];
        
        pageView = [_delegate GCPagingView:self viewAtIndex:nextIndex];
        [mVisibleList addObject:pageView];
    }
    else {
        if (miOffsetIndex == 0) {
            NSInteger lastIndex = [self getRealIndexValue:_curIndex-1];
            UIView *tView = [_delegate GCPagingView:self viewAtIndex:lastIndex];
            [mVisibleList insertObject:tView atIndex:0];
        }
        else {
            if (_delegate && [_delegate respondsToSelector:@selector(GCPagingView:viewAtIndex:)]) {
                NSInteger nextIndex = [self getRealIndexValue:_curIndex+1];
                UIView *tView = [_delegate GCPagingView:self viewAtIndex:nextIndex];
                [mVisibleList addObject:tView];

            }
        }
    }
    
    for (int i=0; i<3; i++) {
        UIView *pageView = mVisibleList[i];
        pageView.frame = CGRectMake(i*mScrollView.frame.size.width, 0, mScrollView.frame.size.width, mScrollView.frame.size.height);
        [mScrollView addSubview:pageView];
    }
    mScrollView.contentOffset=CGPointMake(mScrollView.frame.size.width, 0);
}

- (NSInteger)getRealIndexValue:(NSInteger)aIndex{
    if (aIndex < 0) {
        return _pageCount-1;
    }
    if (aIndex >= _pageCount) {
        return 0;
    }
    return aIndex;
}

- (UIView *)dequeueReusablePage{
    if (mRecycleList.count>0) {
        UIView *pageView = mRecycleList[0];
        [mRecycleList removeObject:pageView];
        return pageView;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float fOffX=scrollView.contentOffset.x;
    if (fOffX>=2*scrollView.frame.size.width) {
        _curIndex = [self getRealIndexValue:_curIndex+1];
        miOffsetIndex = 2;
        [self refreshAllView];
    }
    if (fOffX <= 0) {
        _curIndex = [self getRealIndexValue:_curIndex-1];
        miOffsetIndex = 0;
        [self refreshAllView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
