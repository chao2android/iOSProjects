//
//  JYManageMobileFriendCell.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/25.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYManageMobileFriendCell : UITableViewCell
{
    UIImageView *icon;
    UILabel *titleLab;
    UILabel *countLab;
    UILabel *inviteLab;
}

//@property (nonatomic, strong) UIButton *inviteBtn;
/*
 @brif 初始化视图 dic中又两个 key ：truename，mobile
 */
- (void)layoutSubviewsWithMobileFriendInfoDic:(NSDictionary*)dic;

@end
