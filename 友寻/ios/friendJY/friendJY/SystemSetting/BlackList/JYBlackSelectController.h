//
//  JYBlackSelectController.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/30.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYBlackSelectController : JYBaseController
{
    UITableView *_table;
    UIImageView *_filterBg;
        UILabel *_selectedNameLab;
    UIButton *_inviteBtn;
    NSMutableArray *_selectedListArr;
}
@property (nonatomic, strong) NSMutableArray *selectMembers;

@property (nonatomic, strong) NSMutableArray *nameList;

@property (nonatomic, strong) NSMutableArray *indexArr;

@property (nonatomic, strong) NSMutableArray *friendList;

@property (nonatomic, copy) void (^selectDone)(NSArray *list);


@end

