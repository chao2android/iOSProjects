//
//  QzcyCell.h
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface QzcyCell : UITableViewCell
@property (retain,nonatomic) AsyncImageView * mainImageView;
@property (retain,nonatomic) UILabel * titleLabel;
@property (retain,nonatomic) UILabel * tiaojianLabel;
@property (retain,nonatomic) UILabel * timeLabel;
@property (retain,nonatomic) UILabel * subLabel;
@property (retain,nonatomic) UILabel * qzLabel;
@property (retain,nonatomic) UILabel * gzLabel;
@property (retain,nonatomic) UILabel * fsLabel;
@property (retain,nonatomic) UILabel * scLabel;
@property (retain,nonatomic) UIButton * cellButton;
@property (retain,nonatomic) UIButton * guanzhuButton;
@end
