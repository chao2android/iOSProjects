//
//  JYGuidePageControl.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/4.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYGuidePageControl : UIView

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, strong) UIImage *pageImage;
@property (nonatomic, strong) UIImage *currentPageImage;

@end
