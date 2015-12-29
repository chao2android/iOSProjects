//
//  JYSaveGroupCell.h
//  friendJY
//
//  Created by 高斌 on 15/3/13.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYFriendModel.h"
@class JYCreatGroupFriendModel;

@interface JYSaveGroupFriendCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *deleteFlag;

- (void)layoutWithFriendModel:(JYCreatGroupFriendModel*)model;

@end
