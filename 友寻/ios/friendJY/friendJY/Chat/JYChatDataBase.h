//
//  JYChatDataBase.h
//  friendJY
//
//  Created by 高斌 on 15/3/23.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "JYChatModel.h"
#import "JYMessageModel.h"

@interface JYChatDataBase : NSObject
{
    FMDatabase *_db;
    NSArray * _g_chat_tables_sql;
    NSArray * _g_chat_tables;
}

+ (JYChatDataBase *)sharedInstance;


#pragma mark - DB OPEARTION

- (void)createEditableCopyOfDatabaseIfNeeded:(NSString*)filePath;

- (BOOL)openDB;

- (void)closeDB;

- (BOOL)isOpened;

//每一个uid都会是数据库，
- (void)deleteDB:(NSString *)uid;

// 删除表
- (BOOL)deleteTable:(NSString *)tableName;

#pragma mark - 对聊天用户的操作

#pragma mark - 对一个用户数据进行插入
- (BOOL)insertOneUser:(JYMessageModel *)dic;

#pragma mark - 对一个用户进行更新操作
- (BOOL)updateOneUser:(JYMessageModel *)dic;
- (BOOL)updateGroupName:(NSString *)group_id title:(NSString *)title;
- (NSInteger) getUserUnreadCount:(NSInteger) num;
- (BOOL) clearGroupUserUnreadCount:(NSString *)group_id;
- (BOOL) clearNormalUserUnreadCount:(NSString *)oid;
//是否要显示消息提醒数
- (BOOL) updateIsShowNum:(NSString * )group_id is_show_num:(NSString *)is_show_num;
#pragma mark - 获取一个用户
- (NSMutableDictionary *)getOneUser:(NSString *)oid type:(int) type;

#pragma mark - 获取一组用户,默认是10,取多少页数据,按时间排序
- (NSMutableArray *)getListUser:(NSInteger)page;

#pragma mark - 获取一个用户
- (BOOL)deleteOneUser:(NSString *)oid;

- (BOOL)deleteOneGroupUser:(NSString *)group_id;

- (BOOL)updateChatFriendLastTimer:(NSString *)timer oid:(NSString *)oid content:(NSString *)content msgType:(NSString *)msgType;

- (BOOL)updateGroupChatFriendLastTimer:(NSString *)timer group_id:(NSString *)group_id content:(NSString *)content msgType:(NSString *)msgType;

- (BOOL)updateChatFriendUnreadNum:(NSInteger)num
                              oid:(NSString *)oid;

- (NSString *)setChatFriendUnreadNumToZero:(NSString *)oid;

#pragma mark - 获取用户未读聊天记录整数
- (NSInteger)getChatFriendNureadMessageCount;

//群组消息提醒
- (BOOL) updateGroupUserListHint:(NSString *)group_id hint:(NSString *)hint;
#pragma mark - 聊天记录的操作
//- (long long int)insertOneChatLog:(NSDictionary *)dic;

//- (NSMutableArray *)getListChatLog:(NSString *)oid
//                               iid:(NSString *)iid
//                          pageSize:(NSInteger)pageSize;
- (NSMutableArray *)getListChatLogWithFromUid:(NSString *)oid
                                          iid:(NSString *)iid
                                     pageSize:(NSInteger)pageSize;

- (BOOL)updateOneChatLog:(NSDictionary *)dic;

#pragma mark - 发送成功后发送聊天信息,只能新发送的msg更新，因为新插入的id都不是正常服务器返回的iid
- (BOOL)updateChatMsgId:(NSString *)insertId
                 msg_id:(NSString *)msg_id
               sendTime:(NSString *)sendTime;

#pragma mark - 发送失败，更新聊天状态
- (BOOL)updateChatStatusFailed:(NSString *)insertId;

- (BOOL)updateChatStatusToReaded:(NSString *)iid;

- (BOOL)updateOneChatLogContent:(NSString *)msgId
                        content:(NSString *)content
                   content_type:(NSString *)content_type;

- (BOOL) deleteOneChatLog:(NSString *)iid;



- (NSDictionary *)getOneChatLog:(NSString *)msgId;

- (NSString *)getChatLogCount:(NSString *)oid;

#pragma mark - 当前用户正在发送的数据，状态完部转为发送失败
- (BOOL)userSendingLogToSendFailure:(NSString *)oid;

#pragma mark - gao

#pragma mark - 获取新消息
- (NSArray *)getNewMsgWithFromUid:(NSString *)fromUid
                         sendTime:(NSString *)sendTime;
#pragma mark - 获取历史消息
- (NSArray *)getHistoryMsgWithFromUid:(NSString *)fromUid
                             sendTime:(NSString *)sendTime;

#pragma mark - 插入一条聊天记录
- (NSString *)insertOneChatLog:(NSDictionary *)msgDict;

#pragma mark - 更新一条聊天记录
- (BOOL)updateOneChatLogWithMsgDict:(NSDictionary *)msgDict;

//向chat_log表中插入一条记录

#pragma mark - 1
- (void)insertOneChatMsgIntoChatLogWithModel:(JYChatModel *)chatModel;
- (void)updateChatLogOneChatMsgWithModel:(JYChatModel *)chatModel;
- (void)updateChatLogOneChatMsgWithModel:(JYChatModel *)chatModel
                                     iid:(NSString *)iid;
- (NSMutableArray *)getChatMsgListFromChatLogWithModel:(JYChatModel *)chatModel;
- (NSString *)getChatLogId;
- (void)updateVoiceChatMsgReadStatus:(NSString *)iid readStatus:(NSString *)readStatus;
#pragma mark - 2
- (void)insertOneChatMsgIntoGroupChatLogWithModel:(JYChatModel *)chatModel;
- (void)updateGroupChatLogOneChatMsgWithModel:(JYChatModel *)chatModel;
- (void)updateGroupChatLogOneChatMsgWithModel:(JYChatModel *)chatModel iid:(NSString *)iid;
- (NSMutableArray *)getChatMsgListFromGroupChatLogWithModel:(JYChatModel *)chatModel;
- (NSString *)getGroupChatLogId;
- (NSString *)getGroupChatLogLastIid:(NSString *)group_id;
- (void)updateGourpVoiceChatMsgReadStatus:(NSString *)group_id readStatus:(NSString *)readStatus;

@end
