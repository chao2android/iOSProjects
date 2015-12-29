//
//  WriteTableViewCell.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/25.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DxyCustom.h"
#import "CommintModel.h"
@interface WriteTableViewCell : UITableViewCell
{

    UILabel * nameLabel;
    UILabel * descriptionLabel;
}

- (void)setUIConfigWithModel:(CommintModel *)model;
@end
