//
//  PhotoScrollView.m
//  TJLike
//
//  Created by MC on 15-4-1.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "PhotoScrollView.h"
#import "UIImageView+WebCache.h"

@interface PhotoScrollView ()


@end

@implementation PhotoScrollView
{
    UIScrollView *mScrollView;
    
    NSMutableArray *imageArray;
    NSMutableArray *textArray;
    
    int totalPage;
    int mPage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        imageArray = [[NSMutableArray alloc]initWithCapacity:10];
        textArray = [[NSMutableArray alloc]initWithCapacity:10];
        
        mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        mScrollView.delegate = self;
        mScrollView.showsHorizontalScrollIndicator = YES;
        mScrollView.showsVerticalScrollIndicator = YES;
        mScrollView.bounces = NO;
        mScrollView.pagingEnabled = YES;
        [self addSubview:mScrollView];
    }
    return self;
}

- (void)setMlInfo:(NewsListInfo *)newMlInfo{
    [imageArray removeAllObjects];
    [textArray removeAllObjects];
    NSArray *array = newMlInfo.tuwen;
    totalPage = array.count;
    for (int i = 0; i<array.count; i++) {
        NSString *pic = array[i][@"pic"];
        [imageArray addObject:pic];
        NSString *description = array[i][@"description"];
        [textArray addObject:description];
    }
    mPage = 0;
    self.curPageText = [NSString stringWithFormat:@"%d/%d %@",mPage+1,totalPage,textArray[mPage]];
    mScrollView.contentSize = CGSizeMake(array.count*SCREEN_WIDTH,0);
    
    for (int i = 0; i < array.count; i++) {
        UIScrollView *scrollView = (UIScrollView *)[mScrollView viewWithTag:i+5000];
        if (!scrollView) {
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, -64, mScrollView.frame.size.width, mScrollView.frame.size.height-120)];
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.delegate = self;
            scrollView.minimumZoomScale = 1.0;
            scrollView.maximumZoomScale = 2.0;  //放大比例；
            scrollView.zoomScale = 1.0;
            scrollView.tag = i+5000;
            [mScrollView addSubview:scrollView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            imageView.tag = 500;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]]];
            [scrollView addSubview:imageView];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.curPageText = [NSString stringWithFormat:@"%d/%d %@",mPage+1,totalPage,textArray[mPage]];
    NSLog(@"_curPageText---->%@",_curPageText);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //根据偏移量计算是哪个图片；
    if (scrollView == mScrollView){
        mPage = (scrollView.contentOffset.x/scrollView.frame.size.width);
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView != mScrollView){
        UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:500];
        return imageView;
    }
    return nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
