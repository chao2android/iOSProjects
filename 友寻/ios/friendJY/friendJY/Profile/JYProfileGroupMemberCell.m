//
//  JYProfileGroupMemberCell.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileGroupMemberCell.h"
#import "JYGroupMemberModel.h"
#import <UIImageView+WebCache.h>

@implementation JYProfileGroupMemberCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 20)];
        [_avatarView.layer setCornerRadius:_avatarView.width/2];
        [_avatarView.layer setMasksToBounds:YES];
        [_avatarView setUserInteractionEnabled:YES];
        [self addSubview:_avatarView];
        
        _ownerView = [[UIImageView alloc] initWithFrame:_avatarView.bounds];
        [_ownerView setUserInteractionEnabled:YES];
        [_ownerView setBackgroundColor:[UIColor clearColor]];
        [self insertSubview:_ownerView aboveSubview:_avatarView];
        
        _nickLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatarView.bottom, _avatarView.width, 20)];
        [_nickLab setTextColor:kTextColorBlue];
        [_nickLab setTextAlignment:NSTextAlignmentCenter];
        [_nickLab setLineBreakMode:NSLineBreakByTruncatingTail];
        [_nickLab setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_nickLab];
        
        _singleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_singleView setBackgroundColor:[UIColor clearColor]];
        [_singleView setImage:[UIImage imageNamed:@"msg_single"]];
        [self addSubview:_singleView];
        [_singleView setHidden:YES];
        
//        _sexView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _avatarView.bottom-12, 12, 12)];
//        [_sexView setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:_sexView];
        
    }
    return self;
}

- (void)relayoutSubViewDataWithMember:(JYGroupMemberModel *)member{
    if ([JYHelpers isEmptyOfString:member.avatar]) {
        [_avatarView setImage:[UIImage imageNamed:@"pic_morentouxiang_man"]];
    }else{
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:member.avatar]];
    }
    [_nickLab setText:member.nick];
//    _avatarView.image = [UIImage imageNamed:@"msg_nan"];
    if (member.isOwner) {
        [_ownerView setImage:[UIImage imageNamed:@"profile_group_owner"]];
//        [self bringSubviewToFront:_ownerView];
    }else{
        [_ownerView setImage:nil];
    }
    if ([member.marriage isEqualToString:@"1"]) {
        [_singleView setHidden:NO];
    }else{
        [_singleView setHidden:YES];
    }
    
    if ([member.sex isEqualToString:@"1"]) {
        [_nickLab setTextColor:kTextColorBlue];
//        [_sexView setImage:[UIImage imageNamed:@"msg_nan"]];
    }else{
        [_nickLab setTextColor:[JYHelpers setFontColorWithString:@"#fa544f"]];
//        [_sexView setImage:[UIImage imageNamed:@"msg_nv"]];
    }
}
@end
