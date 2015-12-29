//
//  JYGroupAddMemberViewController.h
//  friendJY
//
//  Created by aaa on 15/5/28.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYBaseController.h"

typedef void(^AddMemberFinish)(NSMutableArray *haveJionUsers);

@interface JYGroupAddMemberViewController : JYBaseController

@property (nonatomic, strong)NSMutableArray *oldMemberArray;
@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, copy)AddMemberFinish finishBlock;

@end
