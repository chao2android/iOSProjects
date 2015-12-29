//
//  ShopCarCell.h
//  TestRedCollar
//
//  Created by miracle on 14-7-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarModel.h"
@interface ShopCarCell : UITableViewCell
{
    UIImageView *_sImage;
    UILabel *_sName;
    UILabel *_sPrice;
    UILabel *_sLining;
    UILabel *_sNumber;
}
@property (nonatomic,assign) int index;
@property (nonatomic,strong) UIButton *deleBtn;
@property (nonatomic,strong) UIButton *designBtn;
@property (nonatomic,assign) SEL onDelete;
@property (nonatomic,assign) SEL onDesign;
@property (nonatomic,assign) SEL addBtnClick;
@property (nonatomic,assign) SEL cutBtnClick;
@property (nonatomic,assign) id delegate;
@property (nonatomic, strong) UIImageView *sImage;
@property (nonatomic, strong) UILabel *sName;
@property (nonatomic, strong) UILabel *sPrice;
@property (nonatomic, strong) UILabel *sLining;
@property (nonatomic, strong) UILabel *sNumber;
@property (nonatomic, strong) UIButton *cutBtn;

- (void)LoadContent:(ShoppingCarModel *)model;
@end
