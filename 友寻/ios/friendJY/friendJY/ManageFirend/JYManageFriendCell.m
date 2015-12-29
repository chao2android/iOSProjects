//
//  JYManageFriendCell.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/16.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYManageFriendCell.h"
#import "JYCreatGroupFriendModel.h"
#import <UIImageView+WebCache.h>
#import "JYHttpServeice.h"

@implementation JYManageFriendCell

@synthesize personInfoBg;
@synthesize icon;
@synthesize titleLab;
@synthesize countLab;
@synthesize selectView;
@synthesize singleImageView;
@synthesize sexImgView;
@synthesize tagView;

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        personInfoBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
        [personInfoBg setBackgroundColor:[UIColor clearColor]];
        [personInfoBg setTag:1234];
        [self addSubview:personInfoBg];
        //头像
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 30, 30)];
        [icon setTag:101];
        [icon setUserInteractionEnabled:YES];
        [icon setBackgroundColor:[UIColor lightGrayColor]];
        [icon.layer setMasksToBounds:YES];
        [icon.layer setCornerRadius:15];
        [personInfoBg addSubview:icon];
        
        singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 12, 12)];
        [singleImageView setBackgroundColor:[UIColor clearColor]];
        [singleImageView setImage:[UIImage imageNamed:@"msg_single"]];
        [singleImageView setHidden:YES];
        [personInfoBg addSubview:singleImageView];
        
        //昵称
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 10, 5, 100, 24)];
        [titleLab setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
        [titleLab setFont:[UIFont systemFontOfSize:15.0f]];
        [personInfoBg addSubview:titleLab];
        
        sexImgView = [[UIImageView alloc] init];
        [sexImgView setBackgroundColor:[UIColor clearColor]];
        [personInfoBg addSubview:sexImgView];
        
        //        共同好友
        countLab = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 10, titleLab.bottom, 120, 20)];
        [countLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
        [countLab setFont:[UIFont systemFontOfSize:13.0f]];
        [countLab setTag:103];
        [personInfoBg addSubview:countLab];
        //        选中状态
        selectView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (54 - 14)/2, 17, 14)];
        [selectView setUserInteractionEnabled:YES];
        [selectView setImage:[UIImage imageNamed:@"set_choose"]];
        [self addSubview:selectView];
        [selectView setHidden:YES];
        [selectView setTag:104];
        //        一度好友标签
        tagView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 41, 0, 41, 41)];
//        [tagView setImage:[UIImage imageNamed:@"set_one_tag"]];
        [tagView setUserInteractionEnabled:YES];
        [tagView setTag:105];
        [self addSubview:tagView];
    }
    return self;
}
- (void)layoutCellWithModel:(JYCreatGroupFriendModel *)model{
    if ([JYHelpers integerValueOfAString:model.gid] != 100) {
        
        [countLab setText:[NSString stringWithFormat:@"%@个共同好友",model.mutualNums]];
        CGFloat width = [JYHelpers getTextWidthAndHeight:model.nick fontSize:15].width;
        if (width + icon.right+10 > kScreenWidth-15-41-12) {
            width = kScreenWidth - 15 - 41 - icon.right-10 - 12;
        }
        [titleLab setFrame:CGRectMake(icon.right + 10, 5, width, 24)];
    //    [titleLab setBackgroundColor:[UIColor orangeColor]];
        if (![JYHelpers isEmptyOfString:model.mark]) {
            [titleLab setText:model.mark];
        }else{
            [titleLab setText:model.nick];
        }
        
        [sexImgView setFrame:CGRectMake(titleLab.right, 5+(titleLab.height - 12)/2, 12, 12)];
    //    [sexImgView setBackgroundColor:[UIColor blueColor]];
        NSString *sexImgPath = @"set_female";
        if ([model.sex isEqualToString:@"1"]) {
            sexImgPath = @"set_male";
        }
        [sexImgView setImage:[UIImage imageNamed:sexImgPath]];
        
        if ([model.marriage isEqualToString:@"1"]) {
            [singleImageView setHidden:NO];
        }else{
            [singleImageView setHidden:YES];
        }
        
        [icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"pic_morentouxiang_man.png"]];
    }else{//未加入友寻好友
        [icon setImage:[UIImage imageNamed:@"pic_morentouxiang_man.png"]];
        [titleLab setText:model.nick];
        [countLab setText:@"TA还未加入友寻"];
        [sexImgView setHidden:YES];
        [singleImageView setHidden:YES];
    
    }
    
    if ([model.is_friend isEqualToString:@"1"]) {
        [tagView setImage:[UIImage imageNamed:@"set_one_tag"]];
    }else if ([model.is_friend isEqualToString:@"2"]){
        [tagView setImage:[UIImage imageNamed:@"set_two_tag"]];
    }else{
        [tagView setImage:nil];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
