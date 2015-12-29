//
//  AZXGroupImageCell.m
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-12.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYGroupImageCell.h"
#import "JYLocalImageModel.h"

@implementation JYGroupImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];
        [self.contentView addSubview:_imageView];
        
        _checkmarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkmarkBtn setFrame:CGRectZero];
        [_checkmarkBtn setBackgroundImage:[UIImage imageNamed:@"icn_fadongtai_weixuanze.png"] forState:UIControlStateNormal];
        [_checkmarkBtn setBackgroundImage:[UIImage imageNamed:@"icn_fadongtai_yixuanze.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:_checkmarkBtn];
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

- (void)layoutWithModel:(JYLocalImageModel *)localImageModel
{
    [_imageView setFrame:CGRectMake(2.5, 2.5, 75, 75)];
    if (localImageModel.thumbnailImage != nil) {
        [_imageView setImage:localImageModel.thumbnailImage];
    } else {
        [_imageView setImage:nil];
    }
    
    
    [_checkmarkBtn setFrame:CGRectMake(55+2.5, 2.5, 20, 20)];
    [_checkmarkBtn setSelected:localImageModel.selected];
}

@end
