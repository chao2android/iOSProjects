//
//  JYShareToFriendCell.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYCreatGroupFriendModel;

@interface JYShareToFriendCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;//头像
@property (nonatomic, strong) UILabel *titleLab;//昵称
@property (nonatomic, strong) UILabel *countLab;//共同好友数量
@property (nonatomic, strong) UIImageView *singleImageView;//单身
@property (nonatomic, strong) UIImageView *sexImgView;//性别
@property (nonatomic, strong) UIView *personInfoBg;//背景
@property (nonatomic, strong) UIImageView *selectView;//被选择

- (void)layoutSubviewsWithData:(JYCreatGroupFriendModel*)model;

@end
