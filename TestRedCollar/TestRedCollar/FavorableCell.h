//
//  FavorableCell.h
//  TestRedCollar
//
//  Created by miracle on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavorableCell : UITableViewCell
{
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_timeLabel;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) UILabel *timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Type:(NSInteger)type;

@end
