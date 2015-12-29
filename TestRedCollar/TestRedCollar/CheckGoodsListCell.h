//
//  CheckGoodsListCell.h
//  TestRedCollar
//
//  Created by MC on 14-7-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarModel.h"
@interface CheckGoodsListCell : UITableViewCell
{
    UIImageView *img;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *linkLabel;
    UILabel *numberLabel;
}

- (void)loadContent:(ShoppingCarModel *)model;
@end
