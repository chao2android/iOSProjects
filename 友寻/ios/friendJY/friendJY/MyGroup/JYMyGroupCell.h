//
//  JYMyGroupCellTableViewCell.h
//  friendJY
//
//  Created by 高斌 on 15/4/16.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYMyGroupModel.h"

@interface JYMyGroupCell : UITableViewCell
{
    UIImageView *_bgImage;
    UIButton *_exitBtn;
    UIImageView *_avatarView;
    UILabel *_titleLab;
    UILabel *_introLab;
    UIButton *_refresh;
    JYMyGroupModel * _myGroupModel;
}

- (void)RefreshLogoImage:(UIImage *)image;
- (void)layoutWithModel:(JYMyGroupModel *)groupModel;

@end
