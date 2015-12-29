//
//  PageScrollView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PageScrollView.h"
#import "TouchView.h"

@implementation PageScrollView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        mScrollView.delegate = self;
        mScrollView.pagingEnabled = YES;
        [self addSubview:mScrollView];
        
        int iWidth = mScrollView.frame.size.width;
        int iHeight = mScrollView.frame.size.height;
        for (int i = 0; i < 3; i ++) {
            TouchView *imageView = [[TouchView alloc] initWithFrame:CGRectMake(iWidth*i, 0, iWidth, iHeight)];
            imageView.delegate = self;
            imageView.OnViewClick = @selector(OnPageSelectClick:);
            imageView.tag = i+1300;
            imageView.image = [UIImage imageNamed:@"6.png"];
            [mScrollView addSubview:imageView];
        }
        mScrollView.contentSize = CGSizeMake(iWidth*3, iHeight);
        
        mPageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, iHeight-20, iWidth, 20)];
        mPageCtrl.numberOfPages = 3;
        mPageCtrl.currentPage = 0;
        [self addSubview:mPageCtrl];
    }
    return self;
}

- (void)OnPageSelectClick:(TouchView *)sender {
    self.miIndex = sender.tag-1300;
    if (delegate && [delegate respondsToSelector:@selector(OnPageScrollSelect:)]) {
        [delegate OnPageScrollSelect:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    mPageCtrl.currentPage = round(mScrollView.contentOffset.x/mScrollView.frame.size.width);
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
