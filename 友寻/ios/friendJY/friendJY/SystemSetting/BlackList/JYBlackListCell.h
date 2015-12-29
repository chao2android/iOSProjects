//
//  JYBlackListCell.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/3.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYCreatGroupFriendModel;

@interface JYBlackListCell : UITableViewCell
{
    UIImageView *avatar;
    UIImageView *singleView;
    UIImageView *sexImageView;
    UILabel *nickLab;
    UILabel *mutualNumsLab;
    UIImageView *tagView;
}

- (void)layoutSubviewsWithModel:(JYCreatGroupFriendModel*)model;

@end
