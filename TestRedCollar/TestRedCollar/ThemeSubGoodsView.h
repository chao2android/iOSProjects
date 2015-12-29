//
//  ThemeSubGoodsView.h
//  TestRedCollar
//
//  Created by MC on 14-7-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleListModel.h"
@interface ThemeSubGoodsView : UIView
{
    UIImageView *imgView;
    UILabel *nameLabel;
    //UILabel *desLabel;
    UILabel *priceLabel;
    
}
@property (nonatomic, assign) SEL showBiao;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL didSelected;
@property (nonatomic, assign) SEL designBtnClick;
@property (nonatomic, assign) SEL seleSize;
@property (retain, nonatomic) UILabel *sizeLabel;

- (void)loadContent:(SingleListModel *)model;
@end
