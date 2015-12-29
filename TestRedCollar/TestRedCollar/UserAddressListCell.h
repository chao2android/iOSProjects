//
//  UserAddressListCell.h
//  TestRedCollar
//
//  Created by miracle on 14-7-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAddressListCell : UITableViewCell

@property (nonatomic, retain) UILabel *userName;
@property (nonatomic, retain) UILabel *userAddress;
@property (nonatomic, strong) UIImageView *checkImage;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL onButtonClick;

@end
