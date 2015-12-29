//
//  ImageArrayTableViewCell.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/23.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
#import "DxyCustom.h"
#import "ReDianModel.h"
@interface ImageArrayTableViewCell : UITableViewCell
{
    UILabel * titleLabel;
    UILabel * timeLabel;
    NetImageView * descriptionImageView;
    UIImageView * timeImageView;
    
    UILabel * hotLabel;

}

- (void)setUIConfigWithModel:(ReDianModel *)model;

@end
