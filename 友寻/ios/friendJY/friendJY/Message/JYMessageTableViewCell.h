//
//  JYMessageTableViewCell.h
//  friendJY
//
//  Created by 高斌 on 15/4/14.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYMessageModel.h"

@interface JYMessageTableViewCell : UITableViewCell
{
    UIImageView *_avatarView;
    UILabel *_nickLab;
    UILabel *_msgLab;
    UIImageView *_countBg;
    UILabel *_countLab;
    UILabel *_timeLab;
    UIImageView *_line;
    UIImageView * noUnreadTip;//未读不提醒标记
}

@property (nonatomic, strong) JYMessageModel *msgModel;

- (void)layoutWithModel:(JYMessageModel *)msgModel;

@end
