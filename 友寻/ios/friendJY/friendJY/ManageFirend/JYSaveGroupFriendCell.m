//
//  JYSaveGroupCell.m
//  friendJY
//
//  Created by 高斌 on 15/3/13.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYSaveGroupFriendCell.h"
#import "JYCreatGroupFriendModel.h"
#import <UIImageView+WebCache.h>

@implementation JYSaveGroupFriendCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_avatarView.layer setMasksToBounds:YES];
        [_avatarView.layer setCornerRadius:25];
        [self.contentView addSubview:_avatarView];
        
        _deleteFlag = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-18, 0, 18, 18)];
        [_deleteFlag setBackgroundColor:[UIColor clearColor]];
        [_deleteFlag setImage:[UIImage imageNamed:@"feedPicDelBtn"]];
        [_deleteFlag setHidden:YES];
        [self.contentView addSubview:_deleteFlag];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatarView.bottom, self.width, self.height - _avatarView.height)];
        [_titleLab setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_titleLab];
        
    }
    return self;
}

- (void)layoutWithFriendModel:(JYCreatGroupFriendModel *)model{
    
    [_deleteFlag setHidden:YES];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"pic_morentouxiang_man"]];
    [_titleLab setText:model.nick];
    [_titleLab setTextColor:[JYHelpers setFontColorWithString:@"#2695ff"]];
}

@end

