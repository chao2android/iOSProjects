//
//  JYManageMobileFriendCell.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/25.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYManageMobileFriendCell.h"

@implementation JYManageMobileFriendCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 30, 30)];
        [icon setTag:101];
        [icon setImage:[UIImage imageNamed:@"pic_morentouxiang_man"]];
        [icon setUserInteractionEnabled:YES];
        [icon setBackgroundColor:[UIColor lightGrayColor]];
        [icon.layer setMasksToBounds:YES];
        [icon.layer setCornerRadius:15];
        [self addSubview:icon];
        
        //昵称
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 10, 5, 100, 24)];
        [titleLab setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
        [titleLab setFont:[UIFont systemFontOfSize:15.0f]];
        [self addSubview:titleLab];
        
        //        共同好友
        countLab = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 10, titleLab.bottom, 120, 20)];
        [countLab setTextColor:[JYHelpers setFontColorWithString:@"#848484"]];
        [countLab setText:@"他还没有加入友寻"];
        [countLab setFont:[UIFont systemFontOfSize:13.0f]];
        [countLab setTag:103];
        [self addSubview:countLab];
        
//        inviteLab = [UIButton buttonWithType:UIButtonTypeCustom];
        inviteLab = [[UILabel alloc] init];
        [inviteLab setFrame:CGRectMake(kScreenWidth - 15 - 60, 5, 60, self.height)];
//        [inviteLab setTitle:@"邀请" forState:UIControlStateNormal];
        [inviteLab setText:@"邀请"];
//        [inviteLab setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
        [inviteLab setTextColor:[JYHelpers setFontColorWithString:@"#2695ff"]];
//        [inviteLab.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [inviteLab setFont:[UIFont systemFontOfSize:15.0f]];
        [self addSubview:inviteLab];
    }
    return self;
}

- (void)layoutSubviewsWithMobileFriendInfoDic:(NSDictionary *)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([[dic objectForKey:@"truename"] isKindOfClass:[NSString class]]) {
            [titleLab setText:dic[@"truename"]];
        }else{
            [titleLab setText:@"No name"];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
