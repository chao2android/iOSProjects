//
//  RootTableViewCell.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/23.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
#import "DxyCustom.h"
#import "ReDianModel.h"
@interface RootTableViewCell : UITableViewCell
{
    NetImageView * titleImageView;
    UILabel * titleLabel;
    UILabel * descriptionLabel;
    UILabel * timeLabel;
    UIImageView * audioImageView;
    UILabel * hotLabel;
    UIImageView * timeImageView;
}

- (void)setUIConfigWithModel:(ReDianModel *)model;

@end
