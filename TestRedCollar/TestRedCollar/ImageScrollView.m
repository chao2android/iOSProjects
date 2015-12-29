//
//  ImageScrollView.m
//  MicroVideo
//
//  Created by wei on 12-10-24.
//  Copyright (c) 2012年 wei. All rights reserved.
//

#import "ImageScrollView.h"

@implementation ImageScrollView

@synthesize delegate, OnScrollClick;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        mScrollView.delegate = self;
        mScrollView.bounces = NO;
        mScrollView.pagingEnabled = YES;
        [mScrollView setShowsVerticalScrollIndicator:NO];
        [mScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:mScrollView];
        
        mPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width-120)/2, self.frame.size.height-20, 120, 20)];
        mPageControl.userInteractionEnabled = NO;
        mPageControl.backgroundColor = [UIColor clearColor];
        mPageControl.currentPage = 0;
        mPageControl.numberOfPages = 4;
        mPageControl.hidden = YES;
        [self addSubview:mPageControl];
        
        int iHeight = IsiPad?160:80;
        
        for (int i=0; i<4; i++) {
            NSString *imagename = [NSString stringWithFormat:@"loading%02d.jpg", i+1];
            NSLog(@"img---->%@",imagename);
            if (IsiPhone5) {
                imagename = [NSString stringWithFormat:@"loading%02d-2.jpg", i+1];
                NSLog(@"img2---->%@",imagename);
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*mScrollView.frame.size.width, 0, mScrollView.frame.size.width, mScrollView.frame.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageNamed:imagename];
            [mScrollView addSubview:imageView];
            
            if (i==3) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(65, self.frame.size.height-iHeight-20, self.frame.size.width-135, iHeight);
                [btn addTarget:self action:@selector(onButtonPressed) forControlEvents:UIControlEventTouchDown];
                [imageView addSubview:btn];
            }
        }
        mScrollView.contentSize = CGSizeMake(4*mScrollView.frame.size.width, mScrollView.frame.size.height);
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    mPageControl.currentPage = round(scrollView.contentOffset.x/scrollView.frame.size.width);
}

- (void)onButtonPressed {
    if (delegate && OnScrollClick) {
        [delegate performSelector:OnScrollClick withObject:self];
    }
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
