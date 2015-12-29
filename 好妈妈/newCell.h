//
//  newCell.h
//  好妈妈
//
//  Created by iHope on 13-10-23.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageTextLabel;
#import "AsyncImageView.h"
@interface newCell : UITableViewCell
@property (retain,nonatomic) UIImageView * backImageView;
@property (retain,nonatomic) AsyncImageView * mainImageView;
@property (retain,nonatomic)ImageTextLabel * titleLabel;
@property (retain,nonatomic) UIImageView * tupianImageView;
@property (retain,nonatomic) UILabel * areaLabel;
@property (retain,nonatomic) UILabel * timeLabel;
@property (retain,nonatomic) UILabel * upTimeLabel;
@property (retain,nonatomic) UILabel * withPlacardLabel;
@end
