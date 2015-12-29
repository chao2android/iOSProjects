//
//  JYMsgUpdate.m
//  friendJY
//
//  Created by 高斌 on 15/3/23.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYMsgUpdate.h"
#import "JYHelpers.h"
#import "BPush.h"
#import "JYHttpServeice.h"
#import "JYMessageModel.h"
#import "JYChatDataBase.h"

@implementation JYMsgUpdate

static JYMsgUpdate *_instance;
+ (JYMsgUpdate *)sharedInstance
{
    @synchronized(self) {
        
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
            // Allocate/initialize any member variables of the singleton class here
            // example
            //_instance.member = @"";
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
            _instance = [super allocWithZone:zone];
            return _instance;  // assignment and return on first allocation
        }
    }
    
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)updateNewUnreadMessageCount{
    
    [self getSysMsgCount];

}

- (void)getDynamicMsgContentWhenAnswerToChat{
    
    NSLog(@"getDynamicMsgContentWhenAnswerToChat");
}

- (void)updateAllUserMessageList{
    
    NSLog(@"updateAllUserMessageList");
}

//获取最新的聊天数
- (void)getSysMsgCount{
    
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"countnew" forKey:@"func"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            
            
            
            //存储返回回来的最新数字
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kRefreshNewUnreadMessageCount];
            
            [self getMessageUserList];
        }
        
    } failure:^(id error) {
        
        //        [_table doneLoadingTableViewData];
        
    }];
 
}


//绑定百度push服务
- (void) bindServiceWhenReceviceBaiduBindid{
    NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindBaiduPushInfomation"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    NSString *userid = [info valueForKey:BPushRequestUserIdKey];
    NSString *channelid = [info valueForKey:BPushRequestChannelIdKey];
    
    
    if(![JYHelpers isEmptyOfString:ToString(uid)] && ![JYHelpers isEmptyOfString:userid] && ![JYHelpers isEmptyOfString:channelid]){
        
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"push" forKey:@"mod"];
        [parametersDict setObject:@"set_pushid" forKey:@"func"];
        
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:userid forKey:@"pushid"];
        [postDict setObject:channelid forKey:@"channelid"];
        [postDict setObject:@"4" forKey:@"devicetype"];
        
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(id error) {
            NSLog ( @"operation: %@" , error );
            
        }];
    }
    
}

- (void) getMessageUserList{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"get_all_chat_msg_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"1" forKey:@"page"];
    //    [postDict setObject:@"1" forKey:@"type"];
    [postDict setObject:@"20" forKey:@"pageSize"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *dataList = [responseObject objectForKey:@"data"];
            if (dataList.count > 0) {
                for (int i=0; i<dataList.count; i++) {
                    NSDictionary *infoDict = [dataList objectAtIndex:i];
                    JYMessageModel *msgModel = [[JYMessageModel alloc] initWithDataDic:infoDict];
                    if ([msgModel.group_id integerValue] >0 && [msgModel.hint intValue] == 1) {
                        msgModel.newcount = @"0";
                    }
                    [[JYChatDataBase sharedInstance] insertOneUser:msgModel];
                    
                    JYChatModel *chatModel = [[JYChatModel alloc] init];
                    chatModel.iid = msgModel.iid;
                    chatModel.msgType = msgModel.msgtype;
                    chatModel.avatar = msgModel.avatar;
                    chatModel.logo = msgModel.logo;
                    chatModel.chatMsg = msgModel.content;
                    chatModel.fromUid = msgModel.oid;
                    chatModel.nick = msgModel.nick;
                    chatModel.title = msgModel.title;
                    chatModel.sex = msgModel.sex;
                    chatModel.time = msgModel.sendtime;
                    chatModel.sendStatus = @"2";
                    chatModel.readStatus = @"0";
                    chatModel.sendType = msgModel.type;
                    chatModel.ext = msgModel.ext;
                    if ([msgModel.msgtype intValue] == 2 || [msgModel.msgtype intValue] == 4) {
                        chatModel.fileUrl = infoDict[@"ext"][@"voice"];
                        chatModel.voiceLength = infoDict[@"ext"][@"dur"];
                    }else if([msgModel.msgtype intValue] == 3 || [msgModel.msgtype intValue] == 5) {
                        chatModel.fileUrl = infoDict[@"ext"][@"voice"];
                        //                        chatModel.voiceLength = @"0";
                        chatModel.fileUrl = infoDict[@"ext"][@"pic200"];
                        
                    }
                    
                    if (msgModel.group_id) {
                        
                        chatModel.groupId = msgModel.group_id;
                        chatModel.isGroup = YES;
                        
                        [[JYChatDataBase sharedInstance] insertOneChatMsgIntoGroupChatLogWithModel:chatModel];
                    }else{
                        chatModel.groupId = @"";
                        chatModel.isGroup = NO;
                        [[JYChatDataBase sharedInstance] insertOneChatMsgIntoChatLogWithModel:chatModel];
                    }
                }
                NSInteger unreadMsgCount = [[JYChatDataBase sharedInstance] getUserUnreadCount:20];
                NSDictionary *msgDic = [[[NSUserDefaults standardUserDefaults] objectForKey:kRefreshNewUnreadMessageCount] mutableCopy];
                [msgDic setValue:[NSString stringWithFormat:@"%ld", (long)unreadMsgCount] forKey:@"unread_chat"];
                //存储返回回来的最新数字
                [[NSUserDefaults standardUserDefaults] setObject:msgDic forKey:kRefreshNewUnreadMessageCount];
                
                
            }
        } else {
            
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        //刷新tabbar的数字
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTabBarUnreadNumberNotification object:nil];
    } failure:^(id error) {
        
        //        [_table doneLoadingTableViewData];
        
    }];
}
@end
