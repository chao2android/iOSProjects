//
//  JYChatService.m
//  friendJY
//
//  Created by 高斌 on 15/3/20.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYChatService.h"
#import "NSDictionary+Additions.h"
#import "JYMsgUpdate.h"
#import "JYChatModel.h"
#import "JYChatDataBase.h"

@implementation JYChatService

static JYChatService *_instance;
+ (JYChatService *)sharedInstance
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

- (id)init{
    
    self = [super init];
    if (self) {
        //开始socket的联接
        self.clientSocket = [[JYChatSocket alloc] init];
        self.clientSocket.jyDelegate = self;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark -

//开始
- (void)startWork {
    
    NSLog(@"gao socket start work");
    [_clientSocket startWork];
}

//重新开始
//- (void)resumeWork {
//    
//    [_clientSocket startWork];
//}

//
- (void)stopWork {
    
    NSLog(@"gao socket stop work");
    [_clientSocket stopWork];
}

- (BOOL)isSocketConnected
{
    if ([self.clientSocket isConnected]) {
        NSLog(@"isConnected:YES");
    } else {
        NSLog(@"isConnected:NO");
    }
    
    return [self.clientSocket isConnected];
}

#pragma mark - chatModelWithDict

- (JYChatModel *)chatModelWithDict:(NSDictionary *)dict
{
    JYChatModel *chatModel = [[JYChatModel alloc] init];
    chatModel.groupId = [JYHelpers stringValueWithObject:[dict objectForKey:@"group_id"]];
    if (chatModel.groupId) {
        chatModel.isGroup = YES;
    } else {
        chatModel.isGroup = NO;
    }
    chatModel.iid = [JYHelpers stringValueWithObject:[dict objectForKey:@"iid"]];
    chatModel.avatar = [JYHelpers stringValueWithObject:[dict objectForKey:@"avatar"]];
    chatModel.logo = [JYHelpers stringValueWithObject:[dict objectForKey:@"logo"]];
    chatModel.msgType = [JYHelpers stringValueWithObject:[dict objectForKey:@"msgtype"]];
    chatModel.chatMsg = [JYHelpers stringValueWithObject:[dict objectForKey:@"chatmsg"]];
    if (chatModel.isGroup) {
        chatModel.fromUid = [JYHelpers stringValueWithObject:[dict objectForKey:@"uid"]];
    } else {
        chatModel.fromUid = [JYHelpers stringValueWithObject:[dict objectForKey:@"from"]];
    }
    chatModel.nick = [JYHelpers stringValueWithObject:[dict objectForKey:@"fromnick"]];
    chatModel.title = [JYHelpers stringValueWithObject:[dict objectForKey:@"title"]];
    chatModel.msgFrom = [JYHelpers stringValueWithObject:[dict objectForKey:@"msgfrom"]];
    chatModel.sex = [JYHelpers stringValueWithObject:[dict objectForKey:@"sex"]];
    chatModel.time = [JYHelpers stringValueWithObject:[dict objectForKey:@"sendtime"]];
    chatModel.sendStatus = [NSString stringWithFormat:@"2"];
    chatModel.readStatus = [NSString stringWithFormat:@"0"];
    chatModel.imgWidth = [NSString stringWithFormat:@""];
    chatModel.imgHeight = [NSString stringWithFormat:@""];
    chatModel.sendType = [JYHelpers stringValueWithObject:[dict objectForKey:@"msgtype"]];
    chatModel.is_sys_tip = [JYHelpers stringValueWithObject:[dict objectForKey:@"is_sys_tip"]];
    
    switch ([chatModel.msgType integerValue]) {
        case 0:
        case 1:
        {
            chatModel.fileUrl = [NSString stringWithFormat:@""];
        }
            break;
        case 2:
        case 4:
        {
            chatModel.fileUrl = dict[@"ext"][@"voice"];
            chatModel.voiceLength = [NSString stringWithFormat:@"%ld", (long)[dict[@"ext"][@"dur"] integerValue]];
        }
            break;
        case 3:
        case 5:
        {
            chatModel.fileUrl = [[dict objectForKey:@"ext"] objectForKey:@"pic0"];
        }
            break;
        default:
            break;
    }
    return chatModel;
}

#pragma mark - JYChatSocketDelegate

- (void)dealSocketReceiveMsg:(NSDictionary *)msgDict
{
    
    NSLog(@"dealSocketReceiveMsg:%@", msgDict);
    
    //收到消息后，先清除临时消息变量值
//    NSDictionary *msg = [NSDictionary dictionaryWithDictionary:theMsg];
    
    NSUInteger type = [msgDict getIntegerValueForKey:@"cmd" defaultValue:0];

    //收到聊天消息
    switch (type) {
        case 14:
        {
            //刷新系统未读数
            [[JYMsgUpdate sharedInstance] updateNewUnreadMessageCount];
        }
            break;
        case 13:
        {
            //连接失败
            [self stopWork];
            [self startWork];
            //[self resumeWork];
        }
            break;
        case 54:
        {
            [self dealConnectMsg:msgDict];
        }
            break;
        case 122:
        case 206://群聊接口
        {
            [self dealChatMsg:msgDict];
        }
            break;
        case 303: //系统消息
        {
//            [self _dealSystemtMsg:msg];
        }
            break;
        case 204: //接受好友加入群(只有群主操作)-通过之后，所有人都会接收到
        {
            NSDictionary *dataDict = [msgDict objectForKey:@"data"];
            NSString *myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSString *tips ;
            NSString *userId;
            if ([myuid integerValue] == [[dataDict objectForKey:@"t_uid"] integerValue]) {
                tips = @"你已经加入了群组，可以开始聊天啦";
                userId = dataDict[@"uid"];
            }else{
                tips = [NSString stringWithFormat:@"%@已经加入了本群",[dataDict objectForKey:@"t_nick"]];
                userId = dataDict[@"t_uid"];
            }
            
            NSLog(@"%@----%@",dataDict[@"nick"],dataDict[@"t_nick"]);
            NSDictionary * tipDic = @{@"data":@{@"group_id":dataDict[@"group_id"],@"logo":dataDict[@"logo"],@"avatar":dataDict[@"avatars"],@"nick":dataDict[@"nick"],@"title":dataDict[@"title"],@"uid":userId,@"is_sys_tip":@"1",@"chatmsg":tips,@"sendtime":[JYHelpers currentDateTimeInterval]}};
            
            [self dealChatMsg:tipDic];
        }
            break;
            
        case 208: //直接加入群
        {
            NSDictionary *dataDict = [msgDict objectForKey:@"data"];
            NSString *myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSString *tips ;
            NSString *userId;
            if ([myuid integerValue] == [[dataDict objectForKey:@"uid"] integerValue]) {
                tips = @"你已经加入了群组，可以开始聊天啦";
                userId = dataDict[@"muid"];
            }else{
                tips = [NSString stringWithFormat:@"%@已经加入了本群",[dataDict objectForKey:@"nick"]];
                userId = dataDict[@"uid"];
            }
            
            NSLog(@"%@----%@",dataDict[@"nick"],dataDict[@"mnick"]);
            NSDictionary * tipDic = @{@"data":@{@"group_id":dataDict[@"group_id"],@"logo":dataDict[@"logo"],@"avatar":dataDict[@"avatars"],@"nick":dataDict[@"nick"],@"title":dataDict[@"title"],@"uid":userId,@"is_sys_tip":@"1",@"chatmsg":tips,@"sendtime":[JYHelpers currentDateTimeInterval]}};
            
            [self dealChatMsg:tipDic];
        }
            break;
            
        case 207: //所有人可以邀请好友加入(一度)
        {
            NSDictionary *dataDict = [msgDict objectForKey:@"data"];
            NSString *myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSString *tips ;
            NSString *userId;
        
            if ([dataDict[@"join_nick"] length] > 10) {
                tips = [NSString stringWithFormat:@"%@...加入了本群", [dataDict[@"join_nick"] substringToIndex:10]];
            }else{
                tips = [NSString stringWithFormat:@"%@加入了本群", dataDict[@"join_nick"]];
            }
            if ([myuid integerValue] == [[dataDict objectForKey:@"uid"] integerValue]) {
                userId = [dataDict[@"join_array"] objectAtIndex:0];
            }else{
                userId = dataDict[@"uid"];
            }
            
          
            NSDictionary * tipDic = @{@"data":@{@"group_id":dataDict[@"group_id"],@"logo":dataDict[@"logo"],@"avatar":dataDict[@"avatars"],@"nick":dataDict[@"nick"],@"title":dataDict[@"title"],@"uid":userId,@"is_sys_tip":@"1",@"chatmsg":tips,@"sendtime":[JYHelpers currentDateTimeInterval]}};
            
            [self dealChatMsg:tipDic];
        }
            break;
        case 132: //提醒
        case 133: //页面通知类型
        case 135: //未读消息
        case 201: //广播
        
        case 205: //建群消息1
        
        
        case 301: //app  通知 单点聊天
        case 302: //发送群聊消息
        case 304://
        case 305://申请加入群消息-去审核1
        case 306://退群消息1
        case 307:
        case 308://群组拒绝好友申请1
        case 309://群主踢人(只有群主操作)1
        case 310://
        case 311://动态被赞
        case 312://转播你的动态
        case 313://评论了你的动态
        case 314://回复你的评论
        case 315://给用户新的一度好友打标签1
        case 316://用户A给自己打了标签XX-1
        case 317://好友申请1
        case 318://新好友加入1
        case 506:
        {
            //收到的信息的处理发通知出来，各自有需要的地方，做相应处理
             [[NSNotificationCenter defaultCenter] postNotificationName:kPushServiceDealSocketNotification object:nil userInfo:msgDict];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"dealSocketNotificationOfOther" object:nil userInfo:nil];
            [[JYMsgUpdate sharedInstance] updateNewUnreadMessageCount];
        }
            break;
    }
    
}


- (void)didDisconnect
{
    NSLog(@"diddisconnect");
//    NSString * uid = [UserManage shareInstance].uid;
//    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
//    if(![JYHelpers isEmptyOfString:uid]){
//        [self startWork];
//    }
}


- (void)dealChatMsg:(NSDictionary *)msgDict
{
    
//    JYChatModel *chatModel = [[JYChatModel alloc] initWithDataDic:[msgDict objectForKey:@"data"]];
    
    BOOL isHint = NO;
    NSLog(@"dealChatMsg:%@", msgDict);
    
    NSDictionary *dataDict = [msgDict objectForKey:@"data"];
    JYChatModel *chatModel = [self chatModelWithDict:dataDict];
    NSString * myUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (![chatModel.fromUid isEqualToString:myUid]) {
        if ([chatModel.groupId integerValue] >0 ) {
            [[JYChatDataBase sharedInstance] insertOneChatMsgIntoGroupChatLogWithModel:chatModel];
            NSMutableDictionary *temp = [[JYChatDataBase sharedInstance] getOneUser:chatModel.groupId type:2];
            if ([[temp objectForKey:@"hint"] intValue] == 1) {
                isHint = YES;
            }
        } else {
            [[JYChatDataBase sharedInstance] insertOneChatMsgIntoChatLogWithModel:chatModel];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocketReceiveChatMsgNotification object:nil userInfo:[NSDictionary dictionaryWithObject:chatModel forKey:@"model"]];
    
//    long long int iid = [[JYChatDataBase sharedInstance] insertOneChatLog:[msgDict objectForKey:@"data"]];
    
//    if (iid != 0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveNewChatMsgNotification object:nil userInfo:nil];
//    }
    
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *temp = [accountDefaults objectForKey:@"currentViewControllerIsChat"];
    if(![temp isEqualToString:@"1"] && !isHint){
//        NSString *alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        shareWindowStatusBar = [[JYShareWindowStatusBar alloc] init];
//        [shareWindowStatusBar showStatusWithMessage:alertStr];
        
        [[JYAppDelegate sharedAppDelegate] playSound];
        [[JYAppDelegate sharedAppDelegate] shakeDevice];
    }
    
    
}


- (void)dealConnectMsg:(NSDictionary *)msgDict
{
    
    NSDictionary *temp = [msgDict objectForKey:@"data"];
    
    if ([[temp objectForKey:@"uid"] intValue] == 0) {
        [self stopWork];
        return;
    }
    
    //登录成功后，更新动态文案，用于从答完题进入聊天时用,更新聊天用户列表
    [[JYMsgUpdate sharedInstance] getDynamicMsgContentWhenAnswerToChat];
    [[JYMsgUpdate sharedInstance] updateAllUserMessageList];
    //请求系统消息
    [[JYMsgUpdate sharedInstance] getSysMsgCount];
    
    [[JYMsgUpdate sharedInstance] updateNewUnreadMessageCount];
}



/*
- (void)_dealSystemtMsg:(NSDictionary *)msg{
    NSDictionary *temp = [msg objectForKey:@"data"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //修改sendtime的格式，系统的为:14-2-20 ,普通用户为:2013-12-09 12:34:45
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[temp objectForKey:@"t"] intValue]];
    NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
    
    int tempMessageCount = 0;
    tempMessageCount = [[ChatDataBase shareInstance] getOneUserUnreadNum:@"10001"]+1;
    
    //拼一个系统用户数据出来，存入数据库
    NSDictionary *tm = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"",@"avatar",
                        @"小编",@"nick",
                        [temp objectForKey:@"c"],@"content",
                        [NSString stringWithFormat:@"%d",tempMessageCount],@"newmsg",@"10001" ,@"oid",
                        @"1",@"type",
                        [DLHelpers getFormatTime:[[temp objectForKey:@"t"] intValue]],@"time",
                        confromTimespStr,@"sendtime",
                        [temp objectForKey:@"iid"],@"iid",
                        [temp objectForKey:@"sex"],@"sex",
                        [temp objectForKey:@"t"],@"timer", nil];
    
    MessageModel *tmModel = [[MessageModel alloc] initWithDataDic:tm];
    [[ChatDataBase shareInstance] insertChatFriend:tmModel];
    
    //系统聊天通知
    ChatModel *chat = [[ChatModel alloc] initWithDataDic:tm];
    [[ChatDataBase shareInstance] insertChatMsg:chat];
    
    //最后发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dealSystemChatMsgFromSocket" object:nil userInfo:tm];
    
    
}
*/

@end


