//
//  JYMyGroupCellTableViewCell.m
//  friendJY
//
//  Created by 高斌 on 15/4/16.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYMyGroupCell.h"
#import "UIImageView+WebCache.h"
#import "JYHttpServeice.h"

@implementation JYMyGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
        [_bgImage setBackgroundColor:[UIColor whiteColor]];
        _bgImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgImage];
        
        //头像
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatarView setBackgroundColor:[UIColor lightGrayColor]];
        [_avatarView setClipsToBounds:YES];
        [_avatarView.layer setCornerRadius:25.0f];
        [_bgImage addSubview:_avatarView];
        
        //昵称
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLab setBackgroundColor:[UIColor clearColor]];
        [_titleLab setTextColor:kTextColorBlack];
        [_titleLab setFont:[UIFont systemFontOfSize:16.0f]];
        [_titleLab setTextAlignment:NSTextAlignmentLeft];
//        [_titleLab setLineBreakMode:NSLineBreakByWordWrapping];
        [_bgImage addSubview:_titleLab];
        
        //介绍
        _introLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_introLab setBackgroundColor:[UIColor clearColor]];
        [_introLab setTextColor:kTextColorGray];
        [_introLab setFont:[UIFont systemFontOfSize:12.0f]];
        [_introLab setTextAlignment:NSTextAlignmentLeft];
//        [_introLab setLineBreakMode:NSLineBreakByWordWrapping];
        [_bgImage addSubview:_introLab];
        
        //加入按钮
        _refresh = [UIButton buttonWithType:UIButtonTypeCustom];
        _refresh.hidden = YES;
//        _refresh.enabled = NO;
        _refresh.frame = CGRectMake(kScreenWidth -60, 40, 40, 20);
        _refresh.backgroundColor = [UIColor clearColor];
        _refresh.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_refresh setTitle:@"加入" forState:UIControlStateNormal];
        [_refresh setTitleColor:kTextColorBlue forState:UIControlStateNormal];
        [_refresh addTarget:self action:@selector(enjoinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgImage addSubview:_refresh];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 64.0f, kScreenWidth-15.0f, 1.0f)];
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
- (void)RefreshLogoImage:(UIImage *)image{
    _avatarView.image = image;
}
- (void)layoutWithModel:(JYMyGroupModel *)groupModel
{
    _myGroupModel = groupModel;
    [_avatarView setFrame:CGRectMake(15, 7.5, 50, 50)];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:groupModel.logo]];
    
    [_titleLab setFrame:CGRectMake(_avatarView.right+13, 15, kScreenWidth-15-_avatarView.width-13-15, 18)];
    [_titleLab setText:groupModel.title];
    
    NSString *introStr = [NSString stringWithFormat:@"共%ld人，%ld个好友", (long)[groupModel.total integerValue], (long)[groupModel.friend_num integerValue]];
    _introLab.text = introStr;
    [_introLab setFrame:CGRectMake(_titleLab.left, _titleLab.bottom+8, _titleLab.width-40, 16)];
    [_introLab setBackgroundColor:[UIColor clearColor]];
    if ([groupModel.isRecommand intValue] == 1) {
        _refresh.hidden = NO;
        _refresh.enabled = YES;
    }else{
        _refresh.hidden = YES;
        _refresh.enabled = NO;
    }
    
}

- (void) enjoinBtnClick:(UIButton *)but{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyGroupEnjoinSuccessNotification object:self userInfo:@{@"group_id":_myGroupModel.group_id,@"touid":_myGroupModel.uid}];
    
    
}

@end
