//
//  AZXGroupImageCell.m
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-12.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYAlbumCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@implementation JYAlbumCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.image = [JYHelpers imageWithName:@"pic_morentouxiang_man"]; //男的默认图标
        [self.contentView addSubview:_imageView];
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

- (void)layoutWithModel:(JYAlbumModel *)localImageModel
{
    [_imageView setFrame:CGRectMake(0, 0, 70, 70)];
    if (localImageModel.pic100 != nil) {
        [_imageView setImageWithURL:[NSURL URLWithString:localImageModel.pic100]];
     
    } else {
        [_imageView setImage:nil];
    }
    
    
//    [_checkmarkBtn setFrame:CGRectMake(55+2.5, 2.5, 20, 20)];
//    [_checkmarkBtn setSelected:localImageModel.selected];
}

@end
