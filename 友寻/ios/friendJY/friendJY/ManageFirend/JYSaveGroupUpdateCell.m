//
//  JYSaveGroupUpdateCell.m
//  friendJY
//
//  Created by 高斌 on 15/3/13.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYSaveGroupUpdateCell.h"
#import "JYCreatGroupFriendModel.h"

@implementation JYSaveGroupUpdateCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_avatarView.layer setMasksToBounds:YES];
        [_avatarView.layer setCornerRadius:25];
        [self.contentView addSubview:_avatarView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatarView.bottom, self.width, self.height - _avatarView.height)];
        [_titleLab setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_titleLab];
        
    }
    return self;
}


@end
