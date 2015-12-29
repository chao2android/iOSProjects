//
//  LikeSubView.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "LikeSubView.h"

@implementation LikeSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (int)HeightOfContent:(NSString *)aName {
    int iHeight = 37;
    UIImage *image = [UIImage imageNamed:aName];
    iHeight += (153*image.size.height/image.size.width);
    return iHeight;
}

@end
