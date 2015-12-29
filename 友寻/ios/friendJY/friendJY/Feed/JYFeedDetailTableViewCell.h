//
//  JYFeedDetailTableViewCell.h
//  friendJY
//
//  Created by ouyang on 4/7/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedDetailModel.h"

@interface JYFeedDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) JYFeedDetailModel *feedModel;


- (void)LoadContent;

@end
