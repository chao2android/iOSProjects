//
//  VideoPageView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoPageView.h"
#import "ImageMaskManager.h"

@implementation VideoPageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"p_videoback"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"p_videoback"] forState:UIControlStateHighlighted];
        
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height-52, self.frame.size.width-20, 30)];
        lbName.backgroundColor = [UIColor clearColor];
        lbName.font = [UIFont fontWithName:@"HelveticaNeue" size:29];
        lbName.textColor = [UIColor lightGrayColor];
        [self addSubview:lbName];
        
        self.mlbName = lbName;
        
        UILabel *lbSubName = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height-28, self.frame.size.width-20, 25)];
        lbSubName.backgroundColor = [UIColor clearColor];
        lbSubName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        lbSubName.textColor = [UIColor darkGrayColor];
        [self addSubview:lbSubName];
        
        self.mlbSubName = lbSubName;
        
        UILabel *lbLength = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-100, self.frame.size.height-28, 85, 25)];
        lbLength.backgroundColor = [UIColor clearColor];
        lbLength.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        lbLength.textColor = [UIColor darkGrayColor];
        lbLength.textAlignment = NSTextAlignmentRight;
        [self addSubview:lbLength];
        
        self.mlbLength = lbLength;
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
    self.mlbName.textColor = [UIColor lightGrayColor];
    self.mlbSubName.textColor = [UIColor darkGrayColor];
    
    [self setImage:[UIImage imageNamed:@"p_addbtn"] forState:UIControlStateNormal];

    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-42)/2, (self.frame.size.height-42)/2, 42, 42)];
    flagView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    flagView.tag = 3000;
    [self addSubview:flagView];
    
    UILabel *lbDuration = [[UILabel alloc] initWithFrame:CGRectMake(0, flagView.frame.size.height, flagView.frame.size.width, 30)];
    lbDuration.backgroundColor = [UIColor clearColor];
    lbDuration.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    lbDuration.textColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.5 alpha:1.0];
    lbDuration.textAlignment = NSTextAlignmentCenter;
    [flagView addSubview:lbDuration];
    
    self.mlbDuration = lbDuration;
}

- (void)ShowText:(NSString *)text {
    @autoreleasepool {
        UIView *view = [self viewWithTag:3000];
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    [self setImage:nil forState:UIControlStateNormal];
    self.mlbName.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.mlbSubName.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    int iFontSize = 30;
    if (text.length>0) {
        iFontSize = 250/text.length;
        if (iFontSize > 50) {
            iFontSize = 50;
        }
    }
    
    UILabel *lbSubName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-80)];
    lbSubName.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    lbSubName.backgroundColor = [UIColor clearColor];
    lbSubName.userInteractionEnabled = NO;
    lbSubName.textAlignment = NSTextAlignmentCenter;
    lbSubName.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:iFontSize];
    lbSubName.textColor = [UIColor blackColor];
    lbSubName.tag = 3000;
    lbSubName.text = text;
    [self addSubview:lbSubName];
    
    UILabel *lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(0, (lbSubName.frame.size.height)/2+33, lbSubName.frame.size.width, 30)];
    lbAddress.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lbAddress.backgroundColor = [UIColor clearColor];
    lbAddress.userInteractionEnabled = NO;
    lbAddress.textAlignment = NSTextAlignmentCenter;
    lbAddress.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:23];
    lbAddress.textColor = [UIColor darkGrayColor];
    lbAddress.text = kUserInfoManager.mAddInfo.city;
    [lbSubName addSubview:lbAddress];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lbSubName.frame.size.height+20-1, lbSubName.frame.size.width, 1)];
    lineView.image = [UIImage imageNamed:@"f_lineback"];
    [lbSubName addSubview:lineView];
}

- (void)ShowImage:(UIImage *)image {
    @autoreleasepool {
        UIView *view = [self viewWithTag:3000];
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    [self setImage:nil forState:UIControlStateNormal];
    self.mlbName.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.mlbSubName.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    if (image) {
        float fWidth = image.size.width;
        float fHeight = image.size.height;
        
        fWidth = MIN(fWidth, fHeight*4/3);
        image = [NetImageView getSubImage:image :CGRectMake(0, 0, fWidth, fHeight)];
    }
    
    NetImageView *imageView = [[NetImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-60)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    imageView.mImageType = TImageType_CutFill;
    imageView.backgroundColor = [UIColor blackColor];
    imageView.userInteractionEnabled = NO;
    imageView.tag = 3000;
    [self addSubview:imageView];
    imageView.mDefaultImage = image;
    [imageView ShowLocalImage];
    
    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, 5)];
    flagView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    flagView.image = [UIImage imageNamed:@"f_topcover"];
    [imageView addSubview:flagView];
}

@end
