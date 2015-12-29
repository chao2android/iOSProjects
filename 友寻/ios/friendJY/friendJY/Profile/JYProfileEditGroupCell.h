//
//  JYProfileEditGroupCell.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYGroupModel;
@interface JYProfileEditGroupCell : UITableViewCell
//{
//@private
////    UILabel *_groupNameLabel;
////    UIImageView *_selectedView;
//}
@property (nonatomic, strong) UILabel *groupNameLabel;
@property (nonatomic, strong) UIImageView *selectedView;

- (void)relayoutSubviewsWithData:(JYGroupModel*)data;

@end
