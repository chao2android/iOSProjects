//
//  JYCreatGroupFriendCell.m
//  friendJY
//
//  Created by 高斌 on 15/4/15.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYCreatGroupFriendCell.h"
#import "UIImageView+WebCache.h"
#import "JYShareData.h"

@implementation JYCreatGroupFriendCell{
    NSString * friendUid;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    
        _selectedView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 17, 14)];
        [_selectedView setImage:[UIImage imageNamed:@"set_choose.png"]];
        [_selectedView setHidden:NO];
        [self.contentView addSubview:_selectedView];
        
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [_bgImage setUserInteractionEnabled:YES];
        [_bgImage setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_bgImage];
        
        _closeView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-55, 0, 41, 41)];
        //[_closeView setImage:[UIImage imageNamed:@"set_one_tag.png"]];
        [self.contentView addSubview:_closeView];
        
        //头像
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatarView setBackgroundColor:[UIColor lightGrayColor]];
        [_avatarView setClipsToBounds:YES];
        [_avatarView.layer setCornerRadius:15.0f];
        [_bgImage addSubview:_avatarView];
        
        _singleView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 3, 12, 12)];
        [_singleView setImage:[UIImage imageNamed:@"msg_single.png"]];
        [_singleView setBackgroundColor:[UIColor clearColor]];
        [_singleView setHidden:YES];
        [_bgImage addSubview:_singleView];
        
        //昵称
        _nickLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nickLab setBackgroundColor:[UIColor clearColor]];
        [_nickLab setTextColor:kTextColorBlack];
        [_nickLab setFont:[UIFont systemFontOfSize:16.0f]];
        [_nickLab setTextAlignment:NSTextAlignmentLeft];
//        [_nickLab setLineBreakMode:NSLineBreakByWordWrapping];
        [_bgImage addSubview:_nickLab];
        
        _sexView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_sexView setBackgroundColor:[UIColor clearColor]];
//        [_sexView setHidden:NO];
        [_bgImage addSubview:_sexView];
        
        _mutualFriendLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_mutualFriendLab setBackgroundColor:[UIColor clearColor]];
        [_mutualFriendLab setTextColor:kTextColorGray];
        [_mutualFriendLab setFont:[UIFont systemFontOfSize:14.0f]];
        [_mutualFriendLab setTextAlignment:NSTextAlignmentLeft];
        [_mutualFriendLab setLineBreakMode:NSLineBreakByWordWrapping];
        [_bgImage addSubview:_mutualFriendLab];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 43.0f, kScreenWidth-15.0f, 1.0f)];
        [line setBackgroundColor:kBorderColorGray];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutWithModel:(JYCreatGroupFriendModel *)friendModel
{
    _closeView.hidden = NO;
    if ([friendModel.relation intValue]== 1) {
        [_closeView setImage:[UIImage imageNamed:@"set_one_tag.png"]];
    }else if ([friendModel.relation intValue]== 2){
        [_closeView setImage:[UIImage imageNamed:@"set_two_tag.png"]];
    }else{
        _closeView.hidden = YES;
    }
    
    friendUid = friendModel.friendUid;
    if (friendModel.isSelected) {
        [_bgImage setOrigin:CGPointMake(32, 0)];
    } else {
        [_bgImage setOrigin:CGPointMake(0, 0)];
    }
   
    [_avatarView setFrame:CGRectMake(15, 7, 30, 30)];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:friendModel.avatar]];
    
    if ([friendModel.marriage integerValue] == 1) {
        [_singleView setHidden:NO];
    } else {
        [_singleView setHidden:YES];
    }
    
    //昵称
    CGSize nickSize = [friendModel.nick sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                          forWidth:kScreenWidth
                                     lineBreakMode:NSLineBreakByWordWrapping];
    
    [_nickLab setFrame:CGRectMake(_avatarView.right+13, 3.0f, nickSize.width>170?170:nickSize.width, 20)];
    [_nickLab setText:friendModel.nick];
    
    [_sexView setFrame:CGRectMake(_nickLab.right+5, 5, 12, 12)];
    if ([friendModel.sex integerValue] == 1) {
        [_sexView setImage:[UIImage imageNamed:@"msg_nan.png"]];
    } else {
        [_sexView setImage:[UIImage imageNamed:@"msg_nv.png"]];
    }
    
    NSString *mutualNumsStr = [NSString stringWithFormat:@"%@个共同好友", friendModel.mutualNums];
    if (!friendModel.mutualNums) {
        mutualNumsStr = [NSString stringWithFormat:@"%d个共同好友", friendModel.mfriend_num];
    }
    CGSize mutualNumsSize = [mutualNumsStr sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                            forWidth:MAXFLOAT
                                       lineBreakMode:NSLineBreakByWordWrapping];
    [_mutualFriendLab setFrame:CGRectMake(_avatarView.right+13, _nickLab.bottom+3, mutualNumsSize.width, mutualNumsSize.height)];
    [_mutualFriendLab setText:mutualNumsStr];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    //如果是自己不显示共同好友
    if ([friendUid isEqualToString:uid]) {
        _mutualFriendLab.hidden = YES;
    }else{
        _mutualFriendLab.hidden = NO;
    }
}

@end
