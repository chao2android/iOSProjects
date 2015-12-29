//
//  HuatiCell.h
//  好妈妈
//
//  Created by iHope on 13-9-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//   话题

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@class ImageTextLabel;
@interface HuatiCell : UITableViewCell
@property (retain,nonatomic)ImageTextLabel * titleLabel;
@property (retain,nonatomic)UILabel * timeLabel;
@property (retain,nonatomic)UILabel * contentLabel;
@property (retain,nonatomic)UILabel * qzNameLabel;
@property (retain,nonatomic)UILabel * xingLabel;
@property (retain,nonatomic)UILabel * pinglunLabel;
@property (retain,nonatomic)AsyncImageView * mainImageView;
@property (retain,nonatomic)UIImageView * xingImageView;
@property (retain,nonatomic)UIImageView * pinglunImageView;
@property (retain,nonatomic) UIImageView * backImageView;

@end
