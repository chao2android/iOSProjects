//
//  QuanZi_Cell.h
//  好妈妈
//
//  Created by liuguozhu on 18/9/13.
//  Copyright (c) 2013 1510Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ImageTextLabel.h"
@interface QuanZi_Cell : UITableViewCell

@property (nonatomic, retain) AsyncImageView* headerImage ;
@property (nonatomic, retain) UILabel* label2;
@property (nonatomic, retain) UILabel* titleLabel4;
@property (retain,nonatomic) ImageTextLabel * titleLabel;
@property (nonatomic, retain) AsyncImageView* subImage1 ;
@property (nonatomic, retain) AsyncImageView* subImage2;
@property (nonatomic, retain) AsyncImageView* subImage3;
@property (nonatomic, retain) AsyncImageView* subImage4;
@property (nonatomic, retain) AsyncImageView* subImage5;

//@property (nonatomic, assign) id delegate;
@end
