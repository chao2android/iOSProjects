//
//  JYGuidePageControl.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/4.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGuidePageControl.h"

@implementation JYGuidePageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages = numberOfPages;
   
//    UIToolbar
    CGFloat width = self.height;
    CGFloat padding = (self.width - width*_numberOfPages)/(_numberOfPages - 1);
    
    for (int i = 0 ; i < _numberOfPages; i++) {

        UIImageView *itemView = [[UIImageView alloc] initWithFrame:CGRectMake((width+padding)*i, 0, width, width)];
        [itemView setImage:_pageImage];
        [itemView setTag:100+i];
        [itemView setUserInteractionEnabled:YES];
        [self addSubview:itemView];
    }
}
- (void)setCurrentPage:(NSInteger)currentPage{
    UIImageView *lastView = (UIImageView*)[self viewWithTag:_currentPage+100];
    UIImageView *currentView = (UIImageView*)[self viewWithTag:currentPage+100];
    [lastView setImage:_pageImage];
    NSString *imageName = [NSString stringWithFormat:@"guide_point_%ld",(long)currentPage+1];
//    [UIView animateWithDuration:.2 animations:^{
        [currentView setImage:[UIImage imageNamed:imageName]];
//    }];
    _currentPage = currentPage;
}
@end
