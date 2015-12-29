//
//  TJBBSHotsCommendCellTableViewCell.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/2.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJBBSHotsCommendCelldelegate <NSObject>

- (void)pressHotRecommend:(int)index;

@end

@interface TJBBSHotsCommendCell : UITableViewCell

@property (nonatomic, weak)id <TJBBSHotsCommendCelldelegate> delegate;
- (void)bindModel:(id)item;

@end
