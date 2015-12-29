//
//  TuijianquanziCell.h
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 1510Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ImageTextLabel.h"
@interface TuijianquanziCell : UITableViewCell
@property (retain,nonatomic)AsyncImageView * mainImageView;
@property (retain,nonatomic)ImageTextLabel * titleLabel;
@property (retain,nonatomic)ImageTextLabel * synopsisLabel;
@property (retain,nonatomic)UIButton * symbolButton;
@property (retain,nonatomic)UILabel * numLabel;
@property (retain,nonatomic)UIImageView * tishiImageView;
@end
