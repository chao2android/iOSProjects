//
//  JYFindSecondFriendCell.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/20.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYFindSecondFriendCell.h"
#import "JYCreatGroupFriendModel.h"
#import <UIImageView+WebCache.h>

@implementation JYFindSecondFriendCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //头像
        avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 30, 30)];
        [avatar setTag:101];
        [avatar setUserInteractionEnabled:YES];
        [avatar setBackgroundColor:[UIColor lightGrayColor]];
        [avatar.layer setMasksToBounds:YES];
        [avatar.layer setCornerRadius:15];
        [self addSubview:avatar];
        
        singleView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 12, 12)];
        [singleView setBackgroundColor:[UIColor clearColor]];
        [singleView setImage:[UIImage imageNamed:@"msg_single"]];
        [singleView setHidden:YES];
        [self addSubview:singleView];
        
        //昵称
        nickLab = [[UILabel alloc] initWithFrame:CGRectMake(avatar.right + 10, 5, 100, 24)];
        [nickLab setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
        [nickLab setFont:[UIFont systemFontOfSize:15.0f]];
        [self addSubview:nickLab];
        
        sexImageView = [[UIImageView alloc] init];
        [sexImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:sexImageView];
        
        //        共同好友
        mutualNumsLab = [[UILabel alloc] initWithFrame:CGRectMake(avatar.right + 10, nickLab.bottom, 120, 20)];
        [mutualNumsLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
        [mutualNumsLab setFont:[UIFont systemFontOfSize:13.0f]];
        [mutualNumsLab setTag:103];
        [self addSubview:mutualNumsLab];
        
        tagView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 41, 0, 41, 41)];
        //        [tagView setImage:[UIImage imageNamed:@"set_one_tag"]];
        [tagView setUserInteractionEnabled:YES];
        [tagView setTag:105];
        [self addSubview:tagView];
    }
    return self;
}
- (void)layoutSubviewsWithModel:(JYCreatGroupFriendModel *)model{
//    NSLog(@"%@ %@ %@ %@",model.nick,model.friendUid,model.sex,model.mutualNums);
    [mutualNumsLab setText:[NSString stringWithFormat:@"%@个共同好友",model.mutualNums]];
    CGSize size = [JYHelpers getTextWidthAndHeight:model.nick fontSize:15];
    [nickLab setFrame:CGRectMake(avatar.right + 10, 5, size.width, 24)];
    [nickLab setText:model.nick];
    
    [sexImageView setFrame:CGRectMake(nickLab.right, 5+(nickLab.height - 12)/2, 12, 12)];
    NSString *sexImgPath = @"set_female";
    if ([model.sex isEqualToString:@"1"]) {
        sexImgPath = @"set_male";
    }
    [sexImageView setImage:[UIImage imageNamed:sexImgPath]];
    
    if ([model.marriage isEqualToString:@"1"]) {
        [singleView setHidden:NO];
    }else{
        [singleView setHidden:YES];
    }
    
    if ([model.is_friend isEqualToString:@"1"]) {
        [tagView setImage:[UIImage imageNamed:@"set_one_tag"]];
    }else if ([model.is_friend isEqualToString:@"2"]){
        [tagView setImage:[UIImage imageNamed:@"set_two_tag"]];
    }else{
        [tagView setImage:nil];
    }
    
    [avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"pic_morentouxiang_man.png"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
