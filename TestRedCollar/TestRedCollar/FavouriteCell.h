//
//  FavouriteCell.h
//  TestRedCollar
//
//  Created by miracle on 14-7-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"

@interface FavouriteCell : UITableViewCell

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) NetImageView *fImageView;
@property (nonatomic, strong) UILabel *fTitle;
@property (nonatomic, strong) UILabel *fPrice;
@property (nonatomic, strong) UILabel *fTime;
@property (nonatomic, strong) UILabel *fFavourite;
@property (nonatomic, strong) UIImageView *backgroundView;

@end
