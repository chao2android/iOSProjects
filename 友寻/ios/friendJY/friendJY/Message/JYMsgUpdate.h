//
//  JYMsgUpdate.h
//  friendJY
//
//  Created by 高斌 on 15/3/23.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYMsgUpdate : NSObject

@property (nonatomic,strong) NSMutableArray *msgListData; //共享聊天首页用户列表的数据

+ (JYMsgUpdate *)sharedInstance;

- (void)updateNewUnreadMessageCount;

- (void)getDynamicMsgContentWhenAnswerToChat;

- (void)updateAllUserMessageList;

- (void)getSysMsgCount;

- (void)bindServiceWhenReceviceBaiduBindid;


@end
