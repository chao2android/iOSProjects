//
//  TimeTableViewCell.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/23.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
#import "DxyCustom.h"
#import "ReDianModel.h"
#import "ImageModel.h"
@interface TimeTableViewCell : UITableViewCell
{
    NetImageView * titleImageView;
    UILabel * descriptionLabel;
    UILabel * timeLabel;
    UIImageView * audioImageView;

}

- (void)setUIConfigWithModel:(ReDianModel *)model;

@end
