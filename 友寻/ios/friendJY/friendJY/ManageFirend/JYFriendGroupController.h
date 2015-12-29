//
//  JYFriendGroupController.h
//  friendJY
//
//  Created by 高斌 on 15/3/12.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
typedef void(^BackAction) ();

@interface JYFriendGroupController : JYBaseController<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_noGroupBg;
    UIButton *_createGroupBtn;
    UITableView *_table;
}
@property (nonatomic, strong) NSMutableArray *groupList;
@property (nonatomic, copy) BackAction backBlock;

@end
