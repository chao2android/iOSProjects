//
//  PinglunCell.h
//  好妈妈
//
//  Created by iHope on 13-10-30.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsyncImageView;
@class ImageTextLabel;
@interface PinglunCell : UITableViewCell
@property (retain,nonatomic)UIImageView * backImageView;
@property (retain,nonatomic)AsyncImageView * touxiangImageView;
@property (retain,nonatomic)UILabel * titleLabel;
@property (retain,nonatomic)UILabel * typeLabel;
@property (retain,nonatomic)ImageTextLabel * contentLabel;
@property (retain,nonatomic)UILabel * timeLabel;
//@property (retain,nonatomic)
@end
