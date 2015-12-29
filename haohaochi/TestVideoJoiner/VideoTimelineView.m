//
//  VideoTimelineView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoTimelineView.h"
#import "VideoListManager.h"
#import "VideoPageView.h"

#define SCROLL_WIDTH 320

@implementation VideoTimelineView

@synthesize delegate, OnPageSelect, OnFinishSelect, OnAddressSelect, OnGoBack;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kMsg_RefreshTimeline object:nil];
        
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        
        UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        topView.image = [UIImage imageNamed:@"f_topbar"];
        topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        topView.userInteractionEnabled = YES;
        [self addSubview:topView];
        
        UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, topView.frame.size.width, 1)];
        shadowView.image = [UIImage imageNamed:@"f_shadow"];
        shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [topView addSubview:shadowView];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 67, 30);
        [backBtn setImage:[UIImage imageNamed:@"p_cancelbtn"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:backBtn];

        mFinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mFinishBtn.frame = CGRectMake(self.frame.size.width-67, 0, 67, 30);
        mFinishBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [mFinishBtn setBackgroundImage:[UIImage imageNamed:@"p_commitbtn"] forState:UIControlStateNormal];
        [mFinishBtn setBackgroundImage:[UIImage imageNamed:@"p_commitbtn2"] forState:UIControlStateDisabled];
        [mFinishBtn addTarget:self action:@selector(OnFinishClick) forControlEvents:UIControlEventTouchUpInside];
        mFinishBtn.enabled = NO;
        [topView addSubview:mFinishBtn];
        
        float fTop = 30+(MIN(KscreenHeigh, KscreenWidth)-240-30)/2;
        mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, fTop, self.frame.size.width, 240)];
        mScrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        mScrollView.showsHorizontalScrollIndicator = NO;
        mScrollView.showsVerticalScrollIndicator = NO;
        mScrollView.canCancelContentTouches = YES;
        mScrollView.delegate = self;
        mScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:mScrollView];
        
        NSArray *values = @[@"3", @"6", @"3", @"9", @"3", @"6"];
        NSArray *titles = @[@"1st", @"2nd", @"3rd", @"4th", @"5th", @"6th"];
        NSArray *subtitles = @[@"Section:片头坐标", @"Section:大景开头", @"Section:中景推进", @"Section:小景叙事", @"Section:特景细节", @"Section:总结描述"];
        float fLeft = 15;
        for (int i = 0; i < titles.count; i ++) {
            VideoPageView *pageView = [[VideoPageView alloc] initWithFrame:CGRectMake(fLeft, 0, 320, mScrollView.frame.size.height)];
            [pageView addTarget:self action:@selector(OnPageClick:) forControlEvents:UIControlEventTouchUpInside];
            pageView.tag = i+1000;
            pageView.mlbName.text = [titles objectAtIndex:i];
            pageView.mlbSubName.text = [subtitles objectAtIndex:i];
            if (i > 0) {
                pageView.mlbDuration.text = [NSString stringWithFormat:@"%@秒", [values objectAtIndex:i]];
            }
            else {
                mAlertView = [[PopAlertView alloc] initWithFrame:CGRectMake((pageView.frame.size.width-80)/2, (pageView.frame.size.height)/2-110, 80, 75)];
                mAlertView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
                [pageView addSubview:mAlertView];
                
                [mAlertView ShowAlert:@"主轴提示"];
            }
            [mScrollView addSubview:pageView];
            fLeft += (320+15);
        }
        mScrollView.contentSize = CGSizeMake(fLeft, mScrollView.frame.size.height);
    }
    return self;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");
}

- (void)GoBack {
    if (delegate && OnGoBack) {
        SafePerformSelector([delegate performSelector:OnGoBack withObject:self]);
    }
}

- (void)reloadData:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    int index = [[dict objectForKey:@"index"] intValue];
    if (index > 4) {
        index = 4;
    }
    float fLeft = index*320;
    mScrollView.contentOffset = CGPointMake(fLeft, 0);
    [self reloadData];
}

- (void)OnFinishClick {
    if (delegate && OnFinishSelect) {
        SafePerformSelector([delegate performSelector:OnFinishSelect withObject:self]);
    }
}

- (void)reloadData {
    for (VideoPageView *subView in mScrollView.subviews) {
        if ([subView isKindOfClass:[VideoPageView class]]) {
            int index = (int)subView.tag-1000;
            if (index == 0) {
                if ([UserInfoManager Share].mWatermark) {
                    [subView ShowText:[UserInfoManager Share].mWatermark];
                }
                subView.mlbLength.text = @"";
            }
            else {
                UIImage *image = [[VideoListManager Share] ThumbAtIndex:index-1];
                if (image) {
                    [subView ShowImage:image];
                }
                else {
                    [subView ShowDefault];
                }
                int iTime = [[VideoListManager Share] GetTotalSeconds:index-1];
                subView.mlbLength.text = [NSString stringWithFormat:@"%d:%02d", iTime/60, iTime%60];
            }
        }
    }
    mFinishBtn.enabled = ([[VideoListManager Share] HasAllVideo] && [UserInfoManager Share].mWatermark);
    //test
//    
    mFinishBtn.enabled = YES;
}

- (void)OnPageClick:(TouchView *)sender {
    if (mAlertView) {
        [mAlertView removeFromSuperview];
        mAlertView = nil;
    }
    NSInteger index = sender.tag-1000;
    if (index == 0) {
        if (delegate && OnAddressSelect) {
            SafePerformSelector([delegate performSelector:OnAddressSelect withObject:self]);
        }
    }
    else {
        if (delegate && OnPageSelect) {
            SafePerformSelector([delegate performSelector:OnPageSelect withObject:[NSNumber numberWithInt:(int)index-1]]);
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
