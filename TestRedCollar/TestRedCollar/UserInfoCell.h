//
//  UserInfoCell.h
//  TestRedCollar
//
//  Created by miracle on 14-8-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *nextImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tag:(NSInteger)firstTag;
@end
