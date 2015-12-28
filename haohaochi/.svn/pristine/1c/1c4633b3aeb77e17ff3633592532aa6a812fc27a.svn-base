//
//  CirclePageView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CirclePageView.h"

@implementation CirclePageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        int iWidth = 22;
        int iOffset = 19;
        int iTotalWidth = iWidth*6+iOffset*5;
        
        mBackView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-iTotalWidth)/2, (frame.size.height-iWidth)/2, iTotalWidth, iWidth)];
        mBackView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:mBackView];
        
        int iLeft = 0;
        for (int i = 0; i < 6; i ++) {
            UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(iLeft, 0, iWidth, iWidth)];
            imageView.image = [UIImage imageNamed:@"f_timeflag3"];
            imageView.tag = 1000+i;
            [mBackView addSubview:imageView];
            
            iLeft += iWidth;
            
            if (i < 5) {
                UIImageView *lineView =[[UIImageView alloc] initWithFrame:CGRectMake(iLeft, iWidth/2, iOffset, 1)];
                lineView.image = [UIImage imageNamed:@"f_timeline"];
                [mBackView addSubview:lineView];
                
                iLeft += iOffset;
            }
        }
    }
    return self;
}

- (void)setMiCurIndex:(int)value {
    _miCurIndex = value;
    [self RefreshView];
}

- (void)RefreshView {
    for (int i = 0; i < 6; i ++) {
        UIImageView *imageView = (UIImageView *)[mBackView viewWithTag:i+1000];
        if (imageView) {
            if (i < 5) {
                if (i == self.miCurIndex) {
                    imageView.image = [UIImage imageNamed:@"f_timeflag2"];
                }
                else {
                    imageView.image = [UIImage imageNamed:@"f_timeflag1"];
                }
            }
            else {
                imageView.image = [UIImage imageNamed:@"f_timeflag3"];
            }
        }
    }
}

@end
