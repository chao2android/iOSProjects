//
//  JYMessageTableViewCell.m
//  friendJY
//
//  Created by 高斌 on 15/4/14.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JYHelpers.h"

@implementation JYMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        
        //头像
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatarView setBackgroundColor:[UIColor lightGrayColor]];
        [_avatarView setClipsToBounds:YES];
        [_avatarView.layer setCornerRadius:25.0f];
        [self.contentView addSubview:_avatarView];
        
        //昵称
        _nickLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nickLab setBackgroundColor:[UIColor clearColor]];
        [_nickLab setTextColor:kTextColorBlack];
        [_nickLab setFont:[UIFont systemFontOfSize:16.0f]];
        [_nickLab setTextAlignment:NSTextAlignmentLeft];
//        [_nickLab setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:_nickLab];
        
        //消息
        _msgLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_msgLab setBackgroundColor:[UIColor clearColor]];
        [_msgLab setTextColor:kTextColorGray];
        [_msgLab setFont:[UIFont systemFontOfSize:12.0f]];
        [_msgLab setTextAlignment:NSTextAlignmentLeft];
//        [_msgLab setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:_msgLab];
        
        //数量
        _countBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_countBg setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_countBg];
        
        _countLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_countLab setBackgroundColor:[UIColor clearColor]];
        [_countLab setTextColor:kTextColorWhite];
        [_countLab setFont:[UIFont systemFontOfSize:12.0f]];
        [_countLab setTextAlignment:NSTextAlignmentLeft];
        [_countLab setLineBreakMode:NSLineBreakByWordWrapping];
        [_countBg addSubview:_countLab];
        
        //时间
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLab setBackgroundColor:[UIColor clearColor]];
        [_timeLab setTextColor:kTextColorGray];
        [_timeLab setFont:[UIFont systemFontOfSize:14.0f]];
        [_timeLab setTextAlignment:NSTextAlignmentLeft];
        [_timeLab setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:_timeLab];
        
        noUnreadTip = [[UIImageView alloc] initWithFrame:CGRectZero];
        [noUnreadTip setBackgroundColor:[UIColor clearColor]];
        noUnreadTip.image = [UIImage imageNamed:@"msgNuredTip"];
        [self.contentView addSubview:noUnreadTip];
        
        
        _line = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_line setBackgroundColor:kTextColorGray];
        [self.contentView addSubview:_line];

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

- (void)layoutWithModel:(JYMessageModel *)msgModel
{
    [self setMsgModel:msgModel];
    
    //时间
    NSString *timeStr = [JYHelpers unixToDate:[_msgModel.sendtime doubleValue]];
    CGSize timeSize = [timeStr sizeWithFont:[UIFont systemFontOfSize:14.0f]
                          constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                              lineBreakMode:NSLineBreakByWordWrapping];
    [_timeLab setFrame:CGRectMake(kScreenWidth-timeSize.width-15, 15, timeSize.width, timeSize.height)];
    [_timeLab setText:timeStr];
    
    if ([msgModel.hint intValue] == 1) {
        noUnreadTip.frame = CGRectMake(_timeLab.right - 17, _timeLab.bottom+10, 17, 13);
    }else{
        noUnreadTip.frame = CGRectZero;
    }
    
    //头像
    [_avatarView setFrame:CGRectMake(15, 7.5, 50, 50)];
    
    
    //昵称
    int nickWith = _timeLab.left-_avatarView.right-20;
    if ([_msgModel.group_id integerValue] > 0) {//群组和普通分开
        [_nickLab setFrame:CGRectMake(_avatarView.right+13, 15, nickWith, 20)];
        [_nickLab setText:_msgModel.title];
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:self.msgModel.logo]];
    }else{
        [_nickLab setFrame:CGRectMake(_avatarView.right+13, 15, nickWith, 20)];
        [_nickLab setText:_msgModel.nick];
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:self.msgModel.avatar]];
    }
    
    //消息内容
//    CGSize msgSize = [_msgModel.msgContent sizeWithFont:[UIFont systemFontOfSize:14.0f]
//                                               forWidth:(kScreenWidth-15-_avatarView.width-13-15)
//                                          lineBreakMode:NSLineBreakByWordWrapping];
    [_msgLab setFrame:CGRectMake(_avatarView.right+13, _nickLab.bottom+5, kScreenWidth-_avatarView.right - 30, 16.0f)];
    if([_msgModel.msgtype intValue] == 2 || [_msgModel.msgtype intValue] == 4){
        [_msgLab setText:@"[语音消息]"];
    }else if([_msgModel.msgtype intValue] == 3 || [_msgModel.msgtype intValue] == 5){
        [_msgLab setText:@"[图片消息]"];
    }else{
        [_msgLab setText:_msgModel.content];
    }
    
    
    //数量
    CGSize countSize = [_msgModel.newcount sizeWithFont:[UIFont systemFontOfSize:12.0f]
                                   constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    [_countLab setFrame:CGRectMake(0, 0, countSize.width, countSize.height)];
    [_countLab setText:_msgModel.newcount];
    
    [_countBg setFrame:CGRectMake(0, 0, _countLab.width+10, _countLab.height+3)];
    UIImage *countBgImage = [[UIImage imageNamed:@"msgCountBg"] stretchableImageWithLeftCapWidth:9 topCapHeight:9];
    [_countBg setImage:countBgImage];
    [_countLab setCenter:CGPointMake(_countBg.width/2, _countLab.height/2)];
    [_countBg setCenter:CGPointMake(_avatarView.right-5, _avatarView.top+4)];
    if ([_msgModel.newcount integerValue] == 0) {
        [_countBg setHidden:YES];
    } else {
        [_countBg setHidden:NO];
    }
    
    //线
    [_line setFrame:CGRectMake(15.0f, 64.0f, kScreenWidth-15.0f, 1.0f)];
    [_line setBackgroundColor:kBorderColorGray];
}

@end
