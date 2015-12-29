//
//  JYCreatGroupController.h
//  friendJY
//
//  Created by 高斌 on 15/4/14.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYCreatGroupController : JYBaseController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_table;
//    NSMutableArray *_nameList;
    NSMutableArray *_friendsList;
    NSInteger _friendsCount;
    NSMutableArray *_selectedFriendsList;
    UILabel *_selectedCountLab;
}

@property (nonatomic, assign) BOOL isFromGroupSetting;
@property (nonatomic, strong) NSMutableArray *nameList;
@property (nonatomic, strong) NSArray *indexArray;
@property (nonatomic, strong) NSMutableArray *friendsList;

@end
