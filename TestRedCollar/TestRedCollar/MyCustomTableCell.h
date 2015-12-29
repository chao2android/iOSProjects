//
//  MyCustomTableCell.h
//  TestRedCollar
//
//  Created by MC on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchView.h"
#import "GoodsListModel.h"
#import "NetImageView.h"

@interface MyCustomTableCell : UITableViewCell

@property (retain,nonatomic) UIImageView *imgView1;
@property (retain,nonatomic) UIImageView *imgView2;
@property (retain,nonatomic) UIImageView *imgBg1;
@property (retain,nonatomic) UIImageView *imgBg2;
@property (retain,nonatomic) NetImageView *netImg1;
@property (retain,nonatomic) NetImageView *netImg2;
@property (retain,nonatomic) UILabel *nameLabel1;
@property (retain,nonatomic) UILabel *nameLabel2;
@property (retain,nonatomic) UILabel *desLabel1;
@property (retain,nonatomic) UILabel *desLabel2;
@property (retain,nonatomic) UILabel *favLabel1;
@property (retain,nonatomic) UILabel *favLabel2;
@property (retain,nonatomic) UILabel *voluLabel1;
@property (retain,nonatomic) UILabel *voluLabel2;
@property (assign,nonatomic) id delegate;
@property (assign,nonatomic) SEL OnCustomSelect;
@property (assign,nonatomic) int miIndex;

- (void)loadContent1:(GoodsListModel *)model;
- (void)loadContent2:(GoodsListModel *)model;
- (void)loadContent:(NSArray *)array;
@end




