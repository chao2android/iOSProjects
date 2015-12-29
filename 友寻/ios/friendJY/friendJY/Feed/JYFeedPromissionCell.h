//
//  JYFeedPromissionCell.h
//  friendJY
//
//  Created by ouyang on 4/23/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedModel.h"

@class JYFriendGroupModel;
@interface JYFeedPromissionCell : UITableViewCell
@property (nonatomic,strong) JYFriendGroupModel *mydata;
@property (nonatomic,assign) NSInteger cRow; //当前是第几行
@property (nonatomic,assign) BOOL isExpand; //是否展开

@end
