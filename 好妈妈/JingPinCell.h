//
//  JingPinCell.h
//  好妈妈
//
//  Created by iHope on 14-1-15.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface JingPinCell : UITableViewCell
@property (retain,nonatomic)AsyncImageView * iconImageView1;
@property (retain,nonatomic)AsyncImageView * iconImageView2;
@property (retain,nonatomic)AsyncImageView * iconImageView3;

@property (retain,nonatomic)UILabel * titleLabel1;
@property (retain,nonatomic)UILabel * titleLabel2;
@property (retain,nonatomic)UILabel * titleLabel3;

@end
