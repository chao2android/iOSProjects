//
//  AZXGroupCameraCell.m
//  imAZXiPhone
//
//  Created by 高斌 on 14-9-16.
//  Copyright (c) 2014年 高斌. All rights reserved.
//

#import "JYGroupCameraCell.h"

@implementation JYGroupCameraCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _cameraImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
//        [_cameraImage setClipsToBounds:YES];
        [self.contentView addSubview:_cameraImage];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutWithModel
{
    [_cameraImage setFrame:CGRectMake(2.5, 2.5, 75, 75)];
    [_cameraImage setImage:[UIImage imageNamed:@"btn_fadongtai_paizhao.png"]];
}


@end
