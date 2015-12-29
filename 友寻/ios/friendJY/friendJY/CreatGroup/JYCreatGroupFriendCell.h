//
//  JYCreatGroupFriendCell.h
//  friendJY
//
//  Created by 高斌 on 15/4/15.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYCreatGroupFriendModel.h"

@interface JYCreatGroupFriendCell : UITableViewCell
{
    UIImageView *_bgImage;
    
    UIImageView *_singleView;
    UILabel *_nickLab;
    UIImageView *_sexView;
    UILabel *_mutualFriendLab;
    UIImageView *_selectedView;
    UIImageView *_closeView;
}

@property (nonatomic,strong) UIImageView *avatarView;

- (void)layoutWithModel:(JYCreatGroupFriendModel *)friendModel;

@end
