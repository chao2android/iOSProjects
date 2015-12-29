//
//  JYGroupMemberViewController.h
//  friendJY
//
//  Created by aaa on 15/5/28.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYBaseController.h"
#import "JYCreatGroupFriendModel.h"

typedef void(^AddFinish)(NSArray *haveJionUsers) ;
typedef void (^DeleFinish)(JYCreatGroupFriendModel *haveDeleModel);

@interface JYGroupMemberViewController : JYBaseController

@property (nonatomic, assign) BOOL isMy;
@property (nonatomic, copy)NSMutableArray *memberData;
@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, copy)AddFinish addFinishBlock;
@property (nonatomic, copy)DeleFinish deleFinishBlock;

@end
