//
//  ImageScrollView.h
//  MicroVideo
//
//  Created by wei on 12-10-24.
//  Copyright (c) 2012年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView *mScrollView;
    UIPageControl *mPageControl;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnScrollClick;

@end
