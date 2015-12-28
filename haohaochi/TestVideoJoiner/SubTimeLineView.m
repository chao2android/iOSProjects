//
//  SubTimeLineView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-28.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SubTimeLineView.h"
#import "SubPageView.h"
#import "VideoListManager.h"
#import "VideoRecordView.h"
#import "VideoCutViewController.h"

@interface SubTimeLineView () {
    UIScrollView *mScrollView;
}

@end

@implementation SubTimeLineView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kMsg_RefreshTimeline object:nil];
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        
        UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        topView.image = [UIImage imageNamed:@"f_topbar"];
        topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:topView];
        
        UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, topView.frame.size.width, 1)];
        shadowView.image = [UIImage imageNamed:@"f_shadow"];
        shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [topView addSubview:shadowView];

        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.frame.size.width-100, 30)];
        lbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.textColor = [UIColor whiteColor];
        [self addSubview:lbTitle];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width-67, 0, 67, 30);
        btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [btn setBackgroundImage:[UIImage imageNamed:@"p_commitbtn"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(OnSaveClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-30)];
        mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mScrollView.showsHorizontalScrollIndicator = NO;
        mScrollView.showsVerticalScrollIndicator = NO;
        mScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:mScrollView];
        
        float fTop = (MIN(KscreenHeigh, KscreenWidth)-100-30)/2;
        float fLeft = 22;
        for (int i = 0; i < 5; i ++) {
            SubPageView *pageView = [[SubPageView alloc] initWithFrame:CGRectMake(fLeft, fTop, 130, 100)];
            [pageView addTarget:self action:@selector(OnPageClick:) forControlEvents:UIControlEventTouchUpInside];
            pageView.tag = i+1000;
            [mScrollView addSubview:pageView];
            fLeft += 145;
        }
        mScrollView.contentSize = CGSizeMake(fLeft, mScrollView.frame.size.height);
        
    }
    return self;
}

- (void)OnPageClick:(SubPageView *)sender {
    NSInteger index = sender.tag-1000;
    NSArray *array = [[VideoListManager Share] VideosAtIndex:self.miIndex];
    if (array && array.count > 0 && index < array.count) {
        NSMutableDictionary *tmpdict = [array objectAtIndex:index];
        if (tmpdict) {
            VideoCutViewController *ctrl = [[VideoCutViewController alloc] init];
            ctrl.mDict = tmpdict;
            ctrl.miIndex = self.miIndex;
            ctrl.miSubIndex = (int)index;
            [self.mRootCtrl presentViewController:ctrl animated:YES completion:nil];
        }
    }
    else {
        [self RecordVideo:[NSNumber numberWithInt:self.miIndex]];
    }
}

- (void)RecordVideo:(NSNumber *)value {
    float fWidth = [UIScreen mainScreen].bounds.size.width;
    float fHeight = [UIScreen mainScreen].bounds.size.height;
    float fNewWidth = MAX(fWidth, fHeight);
    float fNewHeight = MIN(fWidth, fHeight);
    
    VideoRecordView *recordView = [[VideoRecordView alloc] initWithFrame:CGRectMake(0, 0, fNewWidth, fNewHeight)];
    recordView.mMediaManager = self.mMediaManager;
    recordView.mMediaManager.delegate = recordView;
    recordView.mbAppend = YES;
    
    [self RotateView:recordView];
    [self.mMediaManager TakeVideo:YES controlView:recordView animated:YES];
    recordView.mRootCtrl = self.mMediaManager.mPicker;
    if (value) {
        int index = [value intValue];
        NSArray *array = [[VideoListManager Share] VideosAtIndex:index];
        [recordView reloadData:array index:index];
        [_mMediaManager ChangeCameraDevice:NO];
    }
}

- (void)RotateView:(UIView *)backView {
    NSLog(@"%@", backView);
    
    float fWidth = [UIScreen mainScreen].bounds.size.width;
    float fHeight = [UIScreen mainScreen].bounds.size.height;
    float fNewWidth = MAX(fWidth, fHeight);
    float fNewHeight = MIN(fWidth, fHeight);
    
    backView.center = CGPointMake(fNewHeight/2, fNewWidth/2);
    
    CGAffineTransform at = CGAffineTransformMakeRotation(M_PI/2);//先顺时钟旋转90
    backView.transform = at;
}

- (void)reloadData {
    NSLog(@"reloadData");
    for (SubPageView *subView in mScrollView.subviews) {
        if ([subView isKindOfClass:[SubPageView class]]) {
            int index = (int)subView.tag-1000;
            UIImage *image = [[VideoListManager Share] SubThumbAtIndex:self.miIndex subindex:index];
            if (image) {
                [subView ShowImage:image];
            }
            else {
                [subView ShowDefault];
            }
        }
    }
}

- (void)OnSaveClick {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSDictionary *userinfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.miIndex] forKey:@"index"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RefreshTimeline object:nil userInfo:userinfo];
    
    [self removeFromSuperview];
}

- (void)dealloc {
}

@end
