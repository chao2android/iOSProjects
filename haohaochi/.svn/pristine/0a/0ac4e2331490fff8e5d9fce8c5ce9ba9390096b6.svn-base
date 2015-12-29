//
//  SubPageView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-28.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SubPageView.h"

@implementation SubPageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"p_subback"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"p_subback"] forState:UIControlStateHighlighted];
        
        [self ShowDefault];
    }
    return self;
}

- (void)ShowDefault {
    @autoreleasepool {
        UIView *view = [self viewWithTag:3000];
        if (view) {
            [view removeFromSuperview];
        }
    }

    [self setImage:[UIImage imageNamed:@"p_addbtn"] forState:UIControlStateNormal];
}

- (void)ShowImage:(UIImage *)image {
    @autoreleasepool {
        UIView *view = [self viewWithTag:3000];
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    [self setImage:nil forState:UIControlStateNormal];
    if (image) {
        float fWidth = image.size.width;
        float fHeight = image.size.height;
        
        fWidth = MIN(fWidth, fHeight*4/3);
        image = [NetImageView getSubImage:image :CGRectMake(0, 0, fWidth, fHeight)];
    }
    
    NetImageView *imageView = [[NetImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    imageView.mImageType = TImageType_CutFill;
    imageView.backgroundColor = [UIColor blackColor];
    imageView.userInteractionEnabled = NO;
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.tag = 3000;
    [self addSubview:imageView];
    imageView.mDefaultImage = image;
    [imageView ShowLocalImage];
}

@end
