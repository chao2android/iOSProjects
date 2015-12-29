//
//  OrderCell.h
//  TestRedCollar
//
//  Created by miracle on 14-7-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"

@interface OrderCell : UITableViewCell
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) NetImageView *image;
@property (nonatomic, strong) UILabel *consignee;
//@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UILabel *orderMoney;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *status;
@end
