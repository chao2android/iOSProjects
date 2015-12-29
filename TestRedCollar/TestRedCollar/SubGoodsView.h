//
//  subGoodsView.h
//  TestRedCollar
//
//  Created by MC on 14-7-8.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleListModel.h"
@interface SubGoodsView : UIView
@property (retain,nonatomic) UIImageView *imgView;
@property (retain,nonatomic) UILabel *nameLabel;
@property (retain,nonatomic) UILabel *desLabel;


@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL didSelected;

- (void)loadContent:(NSDictionary *)dict;
@end
