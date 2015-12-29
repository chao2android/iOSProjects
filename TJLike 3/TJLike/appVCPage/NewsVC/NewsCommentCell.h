//
//  NewsCommentCell.h
//  TJLike
//
//  Created by MC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCommentInfo.h"

@interface NewsCommentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *goodView;
@property (nonatomic, strong) UILabel *goodNum;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *sepeLine;

- (void)LoadContent:(NewsCommentInfo *)list;

+ (int)HeightOfContent:(NewsCommentInfo *)list;

@end
