//
//  MRZoomScrollView.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MRZoomScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView *imageView;
    BOOL ImageBool;
    CGRect aRect;
    CGRect aRect1;
    int heig;
}
- (void)abcd;

@property (nonatomic, retain) UIImageView *imageView;
- (id)initWithFrame:(CGRect)frame viewImage:(UIImage *)aimage heti:(int)aHeti;
@end
