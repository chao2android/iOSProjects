//
//  JYContactNameCollectionView.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/28.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYContactNameCollectionView.h"
#import "JYPhoneContactsModel.h"

@implementation JYContactNameCollectionView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:kTextColorBlue];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_nameLabel];
        
        [self setContentSize:CGSizeMake(self.width, self.height)];
        [self setShowsVerticalScrollIndicator:NO];
        [self setShowsHorizontalScrollIndicator:NO];
        
    }
    return self;
}

- (void)relayoutLabelWithStr:(NSString *)str{
    CGFloat width = [str sizeWithFont:[UIFont systemFontOfSize:15]].width;
    [_nameLabel setWidth:width];
    [_nameLabel setText:str];
    [self setContentSize:CGSizeMake(width, self.height)];
    if (width>self.width) {
        [UIView animateWithDuration:.2 animations:^{
            [self setContentOffset:CGPointMake(width-self.width, 0)];
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
