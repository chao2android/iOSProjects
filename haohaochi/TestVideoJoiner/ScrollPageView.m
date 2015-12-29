//
//  ScrollPageView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ScrollPageView.h"

@implementation ScrollPageView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pageIndex = 0;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.mScrollView = scrollView;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    NSInteger iCount = [delegate NumberOfPageViews:self];
    float fWidth = [delegate WidthOfPageView:self];
    float fLeft = (self.mScrollView.frame.size.width-fWidth)/2;
    for (int i = 0; i < iCount; i ++) {
        UIView *view = [self.mScrollView viewWithTag:i+1000];
        if (view) {
            view.frame = CGRectMake(fLeft, 0, fWidth-1, self.frame.size.height);
        }
        fLeft += fWidth;
    }
    [self RefreshScrollAlpha];
    self.mScrollView.contentSize = CGSizeMake(self.mScrollView.frame.size.width*iCount, self.mScrollView.frame.size.height);
    
    float fOffset = self.mScrollView.frame.size.width*_pageIndex;
    self.mScrollView.contentOffset = CGPointMake(fOffset, 0);
}

- (void)reloadData {
    @autoreleasepool {
        for (UIView *subview in self.mScrollView.subviews) {
            if (subview.tag >= 1000) {
                [subview removeFromSuperview];
            }
        }
    }
    NSInteger iCount = [delegate NumberOfPageViews:self];
    float fWidth = [delegate WidthOfPageView:self];
    float fLeft = (self.mScrollView.frame.size.width-fWidth)/2;
    for (int i = 0; i < iCount; i ++) {
        UIView *view = [delegate ScrollPageView:self viewAtIndex:i];
        if (view) {
            view.tag = 1000+i;
            view.frame = CGRectMake(fLeft, 0, fWidth-1, self.frame.size.height);
            [self.mScrollView addSubview:view];
        }
        fLeft += fWidth;
    }
    [self RefreshScrollAlpha];
    self.mScrollView.contentSize = CGSizeMake(self.mScrollView.frame.size.width*iCount, self.mScrollView.frame.size.height);
}

- (void)RefreshScrollAlpha {
    NSLog(@"RefreshScrollAlpha:%d", (int)_pageIndex);
    for (UIView *subview in self.mScrollView.subviews) {
        if (subview.tag >= 1000) {
            if (subview.tag-1000 == _pageIndex) {
                subview.alpha = 1.0;
            }
            else {
                subview.alpha = 0.5;
            }
        }
    }
}

- (void)setPageIndex:(NSInteger)value {
    NSLog(@"setPageIndex:%d", (int)value);
    _pageIndex = value;
    float fOffset = self.mScrollView.frame.size.width*value;
    self.mScrollView.contentOffset = CGPointMake(fOffset, 0);
    [self MoveSubviewWithOffset:fOffset];
    [self RefreshScrollAlpha];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageIndex = round(self.mScrollView.contentOffset.x/self.mScrollView.frame.size.width);
    [self RefreshScrollAlpha];
    if (delegate) {
        [delegate ScrollPageView:self scrollToPage:_pageIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self MoveSubviewWithOffset:scrollView.contentOffset.x];
    
    _pageIndex = round(self.mScrollView.contentOffset.x/self.mScrollView.frame.size.width);
}

- (void)MoveSubviewWithOffset:(float)fOffset {
    float fWidth = [delegate WidthOfPageView:self];
    float fLeftOffset = ((fOffset/self.mScrollView.frame.size.width)+0.5)*(self.mScrollView.frame.size.width-fWidth);
    //NSLog(@"fLeftOffset:%f", fLeftOffset);
    for (UIView *subview in self.mScrollView.subviews) {
        if (subview.tag >= 1000) {
            NSInteger index = subview.tag-1000;
            float fLeft = fLeftOffset+index*fWidth;
            subview.frame = CGRectMake(fLeft, 0, fWidth-1, self.frame.size.height);
        }
    }
}

- (NSArray *)mPageViews {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (UIView *subview in self.mScrollView.subviews) {
        if (subview.tag >= 1000) {
            [array addObject:subview];
        }
    }
    return array;
}

@end
