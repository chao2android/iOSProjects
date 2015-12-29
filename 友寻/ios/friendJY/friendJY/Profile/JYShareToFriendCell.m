//
//  JYShareToFriendCell.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYShareToFriendCell.h"
#import "JYCreatGroupFriendModel.h"
#import <UIImageView+WebCache.h>

@implementation JYShareToFriendCell
@synthesize personInfoBg;
@synthesize selectView;

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
- (void)initSubviews{
    
    personInfoBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
    [personInfoBg setBackgroundColor:[UIColor clearColor]];
    [personInfoBg setTag:1234];
    [self addSubview:personInfoBg];
    //头像
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 30, 30)];
    [_icon setTag:101];
    [_icon setUserInteractionEnabled:YES];
    [_icon setBackgroundColor:[UIColor lightGrayColor]];
    [_icon.layer setMasksToBounds:YES];
    [_icon.layer setCornerRadius:15];
    [personInfoBg addSubview:_icon];
    
    _singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 12, 12)];
    [_singleImageView setBackgroundColor:[UIColor clearColor]];
    [_singleImageView setImage:[UIImage imageNamed:@"msg_single"]];
    [_singleImageView setHidden:YES];
    [personInfoBg addSubview:_singleImageView];
    
    //昵称
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + 10, 0, 100, 24)];
    [_titleLab setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [_titleLab setFont:[UIFont systemFontOfSize:15.0f]];
    [personInfoBg addSubview:_titleLab];
    
    _sexImgView = [[UIImageView alloc] init];
    [_sexImgView setBackgroundColor:[UIColor clearColor]];
    [personInfoBg addSubview:_sexImgView];
    
    //        共同好友
    _countLab = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + 10, _titleLab.bottom, 120, 20)];
    [_countLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
    [_countLab setFont:[UIFont systemFontOfSize:13.0f]];
    [_countLab setTag:103];
    [personInfoBg addSubview:_countLab];
    
    //        选中状态
    selectView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (44 - 14)/2, 17, 14)];
    [selectView setUserInteractionEnabled:YES];
    [selectView setImage:[UIImage imageNamed:@"set_choose"]];
    [self addSubview:selectView];
    [selectView setHidden:YES];
    [selectView setTag:104];
    
    //        一度好友标签
    UIImageView *tagView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 41, 0, 41, 41)];
    [tagView setImage:[UIImage imageNamed:@"set_one_tag"]];
    [tagView setUserInteractionEnabled:YES];
    [tagView setTag:105];
    [self addSubview:tagView];

}

- (void)layoutSubviewsWithData:(JYCreatGroupFriendModel *)model{
    
    [_countLab setText:[NSString stringWithFormat:@"%@个共同好友",model.mutualNums]];
//    CGSize size = [JYHelpers getTextWidthAndHeight:model.nick fontSize:15];
    CGFloat width = [JYHelpers getTextWidthAndHeight:model.nick fontSize:15].width;
    if (width + _icon.right+10 > kScreenWidth-15-41-12) {
        width = kScreenWidth - 15 - 41 - _icon.right-10 - 12;
    }
    [_titleLab setFrame:CGRectMake(_icon.right + 10, 0, width, 24)];
    //    [titleLab setBackgroundColor:[UIColor orangeColor]];
    if (![JYHelpers isEmptyOfString:model.mark]) {
        [_titleLab setText:model.mark];
    }else{
        [_titleLab setText:model.nick];
    }
    
//    [_titleLab setFrame:CGRectMake(_icon.right + 10, 0, size.width, 24)];
//    [_titleLab setText:model.nick];
    
    [_sexImgView setFrame:CGRectMake(_titleLab.right, (_titleLab.height - 12)/2, 12, 12)];
    NSString *sexImgPath = @"set_female";
    if ([model.sex isEqualToString:@"1"]) {
        sexImgPath = @"set_male";
    }
    [_sexImgView setImage:[UIImage imageNamed:sexImgPath]];
    
    if ([model.marriage isEqualToString:@"1"]) {
        [_singleImageView setHidden:NO];
    }else{
        [_singleImageView setHidden:YES];
    }
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"pic_morentouxiang_man.png"]];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
