//
//  JYChatDataBase.m
//  friendJY
//
//  Created by 高斌 on 15/3/23.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYChatDataBase.h"
#import "FMDatabaseAdditions.h"
#import "JYMessageModel.h"

//#define SQL_JY_CHAT_LOG "create table chat_log(" \
//"id integer PRIMARY KEY AUTOINCREMENT," \
//"content text," \
//"content_type varchar(100)," \
//"deletime timestamp," \
//"myfrom varchar(100)," \
//"iid varchar(100)," \
//"mid varchar(100),"\
//"oid varchar(100)," \
//"readtime timestamp," \
//"sendtime timestamp," \
//"status integer default 0," \
//"timer integer default 0," \
//"type integer)"

/*
 id             integer             自增id
 iid            varchar(100)        消息id
 msgType        varchar(100)        消息类型 0:文本消息 2:语音消息 3:图片消息
 avatar         text                头像
 chatMsg        text                消息内容
 fromUid        varchar(100)        消息发自于哪个用户
 nick           text                发消息用户昵称
 msgFrom        varchar(100)        消息来自于哪种设备
 sex            varchar(100)        性别 0女 1男
 time           integer default 0   时间
 sendStatus     integer default 0   发送状态 0发送失败 1发送中 2发送成功
 readStatus     integer default 0   阅读状态 0未读 1已读
 fileUrl        text                图片 或者语音链接
 voiceLength    integer default 0   语音消息长度
 imgWidth       integer default 0   图片宽
 imgHeight      integer default 0   图片长
 */
#define SQL_JY_CHAT_LOG "create table chat_log(" \
"id integer PRIMARY KEY AUTOINCREMENT," \
"iid varchar(100)," \
"msgType varchar(100)," \
"avatar text," \
"chatMsg text," \
"fromUid varchar(100)," \
"nick text," \
"msgFrom varchar(100)," \
"sex varchar(100)," \
"time integer default 0," \
"sendStatus integer default 0," \
"readStatus integer default 0," \
"fileUrl text," \
"voiceLength integer default 0," \
"imgWidth integer default 0," \
"sendType integer default 0," \
"imgHeight integer default 0,"\
"ext text," \
"is_sys_tip varchar(200) default '')"

#define SQL_JY_GROUP_CHAT_LOG "create table group_chat_log(" \
"id integer PRIMARY KEY AUTOINCREMENT," \
"groupId varchar(100)," \
"iid varchar(100)," \
"msgType varchar(100)," \
"avatar text," \
"chatMsg text," \
"fromUid varchar(100)," \
"nick text," \
"msgFrom varchar(100)," \
"sex varchar(100)," \
"time integer default 0," \
"sendStatus integer default 0," \
"readStatus integer default 0," \
"fileUrl text," \
"voiceLength integer default 0," \
"imgWidth integer default 0," \
"sendType integer default 0," \
"imgHeight integer default 0,"\
"ext text," \
"is_sys_tip varchar(200) default '')"

/*
 id             integer             自增id
 oid            varchar(100)        好友uid
 avatar         text                头像
 content        text                消息内容
 hint
 logo           varchar(200)        群图标
 iid            varchar(20)        消息id
 group_id       varchar(20)         群组id
 msgtype        varchar(10)         (类型int,为聊天消息里的子消息类型 0 单聊普通聊天 1 群聊普通聊天 2 单聊上传声音 3 单聊上传图片 4 群聊上传声音 5 群聊上传图片
 newcount       varchar(10)         未读消息数量
 nick           varchar(100)        昵称
 oid            varchar(20)         消息来自于哪个人
 sex            varchar(1)          0:女 1:男
 status         varchar(1)          阅读状态 0未读 1已读
 type           varchar(1)          0全部 1收件 2发件
 sendtime       interger default 0  发送时间
 title          varchar(200)        群组标题
 */

#define  SQL_JY_CHAT_FRIEND " create table chat_friend(" \
"id integer PRIMARY KEY AUTOINCREMENT," \
"oid varchar(20)," \
"avatar text," \
"content text default ''," \
"hint varchar(100)," \
"logo varchar(200)," \
"iid varchar(20)," \
"group_id varchar(20)," \
"msgtype varchar(10)," \
"newcount varchar(10)," \
"nick varchar(100)," \
"sendtime integer default 0," \
"sex varchar(1)," \
"status varchar(1)," \
"title varchar(200))"

@implementation JYChatDataBase

static JYChatDataBase *_instance;
+ (JYChatDataBase *)sharedInstance
{
    @synchronized(self) {
        
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
            // Allocate/initialize any member variables of the singleton class here
            // example
            //_instance.member = @"";
            
        }
        
        if (![_instance isOpened]) {
            if (![_instance openDB]) {
                [_instance closeDB];
            }
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

- (void)dealloc{
    
    [self closeDB];
}


#pragma mark - DB OPEARTION

- (void)createEditableCopyOfDatabaseIfNeeded:(NSString*)filePath
{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSError *error;
    
    // No exists any database file. Create new one.
    //
    success = [fileManager fileExistsAtPath:filePath];
    if (success) return;
    
    // [self createNewDateBase:filePath];
    
}

- (BOOL)openDB
{
    _g_chat_tables_sql = [NSArray arrayWithObjects:@SQL_JY_CHAT_LOG, @SQL_JY_GROUP_CHAT_LOG, @SQL_JY_CHAT_FRIEND, nil];
    _g_chat_tables = [NSArray arrayWithObjects:@"chat_log", @"group_chat_log", @"chat_friend",nil ];
    
    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if([JYHelpers isEmptyOfString:ToString(uid)]){
        return NO;
    }
    NSString *fielName = [NSString stringWithFormat:@"%@.sqlite",uid];//数据库文件名
    NSString *sqlDBPath = MyFilePath(fielName);
    NSLog(@"mysqlDbpath:%@",sqlDBPath);
    
    [self createEditableCopyOfDatabaseIfNeeded:sqlDBPath];
    
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    _db = [FMDatabase databaseWithPath:sqlDBPath] ;
    if (![_db open]) {
        NSAssert(0, @"Could not open db.");
        return NO;
    }
    
    //检查表是否存在
    for(int i=0; i<3; i++)
    {
        if (![_db tableExists:_g_chat_tables[i]])
        {
            //先删除表再创建表
            [self deleteTable:_g_chat_tables[i]];
            [_db executeUpdate:_g_chat_tables_sql[i]];
        }
    }
    
    return YES;
}

- (void)closeDB{
    
    if (!_db) {
        return ;
    }
    [_db close];
    _db = nil;
}

- (BOOL)isOpened{
    if (_db) {
        return YES;
    }
    return NO;
}

//每一个uid都会是数据库，
- (void)deleteDB:(NSString *)uid{
    
    BOOL success;
    NSError *error;
    NSString *fielName = [NSString stringWithFormat:@"%@.sqlite",uid];//数据库文件名
    NSString *sqlDBPath = MyFilePath(fielName);
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // delete the old db.
    if ([fileManager fileExistsAtPath:sqlDBPath])
    {
        [_db close];
        success = [fileManager removeItemAtPath:sqlDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        }
    }
}

// 删除表
- (BOOL)deleteTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        NSLog(@"Delete table error!");
        return NO;
    }
    
    return YES;
}

#pragma mark - 对聊天用户的操作

#pragma mark - 对一个用户数据进行插入
- (BOOL)insertOneUser:(JYMessageModel *)dic{

    
    NSString *oid       = dic.oid;
    NSString *avatar    = dic.avatar;
    NSString *content   = dic.content;
    NSString *hint      = dic.hint;
    NSString *logo      = dic.logo;
    NSString *iid       = dic.iid;
    NSString *group_id  = dic.group_id;
    NSString *msgtype   = dic.msgtype;
    NSString *newcount  = dic.newcount;
    NSString *nick      = dic.nick;
    NSNumber *sendtime  = [NSNumber numberWithInteger:[dic.sendtime integerValue]];
    NSString *sex       = dic.sex;
    NSString *status    = dic.status;
    NSString *title     = dic.title;
    
    BOOL success;
    
    NSMutableDictionary * selectResult;
    if ([JYHelpers isEmptyOfString:ToString(group_id)]) {
        selectResult = [self getOneUser:oid type:1];
    }else{
        selectResult = [self getOneUser:group_id type:2];
    }
    
    //结果集大于0，进行更新操作
    if ([selectResult count] > 0) {
        
        success = [self updateOneUser:dic];
    } else {
        success = [_db executeUpdate:@"INSERT INTO chat_friend (oid,avatar,content,hint,logo,iid,group_id,msgtype,newcount,nick,sendtime,sex,status,title) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",oid,avatar,content,hint,logo,iid,group_id,msgtype,newcount,nick,sendtime,sex,status,title];
    }
    
    return success;
}

#pragma mark - 对一个用户进行更新操作
- (BOOL)updateOneUser:(JYMessageModel *)dic{
    
    NSString *oid       = dic.oid;
    NSString *avatar    = dic.avatar;
    NSString *content   = dic.content;
    NSString *hint      = dic.hint;
    NSString *logo      = dic.logo;
    NSString *iid       = dic.iid;
    NSString *group_id  = dic.group_id;
    NSString *msgtype   = dic.msgtype;
    NSString *newcount  = dic.newcount;
    NSString *nick      = dic.nick;
    NSNumber *sendtime  = [NSNumber numberWithInteger:[dic.sendtime integerValue]];
    NSString *sex       = dic.sex;
    NSString *status    = dic.status;
    NSString *title     = dic.title;
    
    BOOL success ;
    if ([JYHelpers isEmptyOfString:group_id]) {
        NSLog(@"UPDATE chat_friend set avatar = '%@',content ='%@',hint = '%@',logo = '%@',iid = '%@',group_id = '%@',msgtype = '%@',newcount = '%@',nick = '%@',sendtime = '%@',sex = '%@',status = '%@',title = '%@' WHERE oid = '%@' and (group_id = '0' or group_id is null  or group_id = '')" ,avatar,content,hint,logo,iid,group_id,msgtype,newcount,nick,sendtime,sex,status,title,oid);
        success = [_db executeUpdate:@"UPDATE chat_friend set avatar = %@,content =?,hint = ?,logo = ?,iid = ?,group_id = ?,msgtype = ?,newcount = ?,nick = ?,sendtime = ?,sex = ?,status = ?,title = ? WHERE oid = ? and (group_id = '0' or group_id is null  or group_id = '')" ,avatar,content,hint,logo,iid,group_id,msgtype,newcount,nick,sendtime,sex,status,title,oid];
    }else{
        success = [_db executeUpdate:@"UPDATE chat_friend set avatar = ?,content =?,hint = ?,logo = ?,iid = ?,group_id = ?,msgtype = ?,newcount = ?,nick = ?,sendtime = ?,sex = ?,status = ?,title = ? WHERE group_id = ?",avatar,content,hint,logo,iid,group_id,msgtype,newcount,nick,sendtime,sex,status,title,group_id];
    }
    
    
    return success;
}

#pragma mark - 获取一个用户
- (NSMutableDictionary *)getOneUser:(NSString *)oid type:(int) type{ //type =1，普通用户, type=2群组用户
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSString *sql;
    if (type ==1 ) {
        sql= [NSString stringWithFormat:@"SELECT * FROM chat_friend WHERE oid = '%@' and (group_id = '0' or group_id is null  or group_id = '')", oid];
    }else{
        sql= [NSString stringWithFormat:@"SELECT * FROM chat_friend WHERE group_id = '%@'", oid ];
    }

    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        [result setValue:[rs stringForColumn:@"oid"] forKey:@"oid"];
        [result setValue:[rs stringForColumn:@"avatar"] forKey:@"avatar"];
        [result setValue:[rs stringForColumn:@"content"] forKey:@"content"];
        [result setValue:[rs stringForColumn:@"hint"] forKey:@"hint"];
        [result setValue:[rs stringForColumn:@"logo"] forKey:@"logo"];
        [result setValue:[rs stringForColumn:@"iid"] forKey:@"iid"];
        [result setValue:[rs stringForColumn:@"group_id"] forKey:@"group_id"];
        [result setValue:[rs stringForColumn:@"msgtype"] forKey:@"msgtype"];
        [result setValue:[rs stringForColumn:@"newcount"] forKey:@"newcount"];
        [result setValue:[rs stringForColumn:@"nick"] forKey:@"nick"];
        [result setValue:[rs stringForColumn:@"sendtime"] forKey:@"sendtime"];
        [result setValue:[rs stringForColumn:@"sex"] forKey:@"sex"];
        [result setValue:[rs stringForColumn:@"status"] forKey:@"status"];
        [result setValue:[rs stringForColumn:@"title"] forKey:@"title"];
    }
    [rs close];
    return result;
}

#pragma mark - 获取一组用户,默认是10,timer是最后一个用户的时间撮之后取10个,按时间排序
- (NSMutableArray *)getListUser:(NSInteger)page{
    
    NSMutableArray * resultArray = [NSMutableArray array];
    
    NSString *sql;
    sql = [NSString stringWithFormat:@"SELECT * FROM chat_friend  order by sendtime DESC limit %ld",page*10];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while([rs next]){
        //NSLog(@"newmsg:%@",[rs stringForColumn:@"newmsg"]);
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setValue:[rs stringForColumn:@"oid"] forKey:@"oid"];
        [result setValue:[rs stringForColumn:@"avatar"] forKey:@"avatar"];
        [result setValue:[rs stringForColumn:@"content"] forKey:@"content"];
        [result setValue:[rs stringForColumn:@"hint"] forKey:@"hint"];
        [result setValue:[rs stringForColumn:@"logo"] forKey:@"logo"];
        [result setValue:[rs stringForColumn:@"iid"] forKey:@"iid"];
        [result setValue:[rs stringForColumn:@"group_id"] forKey:@"group_id"];
        [result setValue:[rs stringForColumn:@"msgtype"] forKey:@"msgtype"];
        [result setValue:[rs stringForColumn:@"newcount"] forKey:@"newcount"];
        [result setValue:[rs stringForColumn:@"nick"] forKey:@"nick"];
        [result setValue:[rs stringForColumn:@"sendtime"] forKey:@"sendtime"];
        [result setValue:[rs stringForColumn:@"sex"] forKey:@"sex"];
        [result setValue:[rs stringForColumn:@"status"] forKey:@"status"];
        [result setValue:[rs stringForColumn:@"title"] forKey:@"title"];

        [resultArray addObject:result];
    }
    //  result = [rs intForColumnIndex:0];
    [rs close];
    
    
    return resultArray;
}

- (BOOL) updateIsShowNum:(NSString * )group_id is_show_num:(NSString *)is_show_num{
    BOOL success = [_db executeUpdate:@"UPDATE chat_friend set hint = ? WHERE group_id = ?",is_show_num,group_id];
    return success;
}

- (BOOL) updateGroupName:(NSString *)group_id title:(NSString *)title{
    BOOL success = [_db executeUpdate:@"UPDATE chat_friend set title = ? WHERE group_id = ?",title,group_id];
    return success;
}

- (NSInteger) getUserUnreadCount:(NSInteger) num{
    NSString *total ;
    NSString * sql = [NSString stringWithFormat:@"select SUM(newcount) as c from chat_friend order by sendtime desc limit %ld",(long)num];

    FMResultSet *rs = [_db executeQuery:sql];
    while([rs next]){
        total = [rs stringForColumn:@"c"];
    }
    [rs close];

    return [total integerValue];
}

//清除群组用户，未读数字
- (BOOL) clearGroupUserUnreadCount:(NSString *)group_id{
    BOOL success = [_db executeUpdate:@"UPDATE chat_friend set newcount = '0' WHERE group_id = ?",group_id];
    return success;
}

//清除普通用户，未读数字
- (BOOL) clearNormalUserUnreadCount:(NSString *)oid{
    BOOL success = [_db executeUpdate:@"UPDATE chat_friend set newcount = '0' WHERE oid = ?",oid];
    return success;
}

//群组设置，消息提醒
- (BOOL) updateGroupUserListHint:(NSString *)group_id hint:(NSString *)hint{
    NSLog(@"UPDATE chat_friend set hint = %@ WHERE group_id = %@",hint , group_id);
    BOOL success = [_db executeUpdate:@"UPDATE chat_friend set hint = ? WHERE group_id = ?",hint , group_id];
    return success;
}

#pragma mark - 获取一个普通用户
- (BOOL)deleteOneUser:(NSString *)oid{
    
    BOOL success = [_db executeUpdate:@"delete FROM chat_friend WHERE oid = ?", oid];
    [_db executeUpdate:@"delete FROM chat_log WHERE fromUid = ?", oid];
    
    return success;
}

#pragma mark - 获取一个群组用户
- (BOOL)deleteOneGroupUser:(NSString *)group_id{
    
    BOOL success = [_db executeUpdate:@"delete FROM chat_friend WHERE group_id = ?", group_id];
    [_db executeUpdate:@"delete FROM group_chat_log WHERE groupId = ?", group_id];
    
    return success;
}

#pragma mark - 更新最后一条记录的内容及时间
- (BOOL)updateChatFriendLastTimer:(NSString *)timer oid:(NSString *)oid content:(NSString *)content msgType:(NSString *)msgType{
    
    BOOL success = [_db executeUpdate:@"update chat_friend set sendtime = ? , content = ? , msgtype = ? WHERE oid = ?",[NSNumber numberWithInteger:[timer integerValue]],content, msgType, oid];
    
    return success;
}

#pragma mark - 群组聊天更新最后一条记录的内容及时间
- (BOOL)updateGroupChatFriendLastTimer:(NSString *)timer group_id:(NSString *)group_id content:(NSString *)content msgType:(NSString *)msgType{
    
    BOOL success = [_db executeUpdate:@"update chat_friend set sendtime = ? , content = ? , msgtype = ? WHERE group_id = ?",[NSNumber numberWithInteger:[timer integerValue]],content, msgType, group_id];
    
    return success;
}

//- (BOOL)updateChatFriendUnreadNum:(NSInteger)num oid:(NSString *)oid{
//    
//    NSNumber *numObj = [NSNumber numberWithInteger: num];
//    BOOL success = YES;//[_db executeUpdate:@"update chat_friend set newmsg = ? WHERE oid = ?",numObj, oid];
//    
//    return success;
//}

//- (NSString *)setChatFriendUnreadNumToZero:(NSString *)oid{
//    
//    NSString *sql = [NSString stringWithFormat:@"SELECT count(id) as c FROM chat_log WHERE oid = '%@' and content_type = 'voice' and status = 0 and type = 1",oid];
//    NSLog(@"%@",sql);
//    NSString *voiceNum;
//    FMResultSet *rs = [_db executeQuery:sql];
//    while([rs next]){
//        voiceNum = [rs stringForColumn:@"c"];
//    }
//    [rs close];
//    NSNumber *numObj = [NSNumber numberWithInt: [voiceNum intValue]];
//    [_db executeUpdate:@"update chat_friend set newmsg = ? WHERE oid = ?",numObj, oid];
//    
//    return voiceNum;
//}

//#pragma mark - 获取用户未读聊天记录整数
//- (NSInteger)getChatFriendNureadMessageCount{
//    
//    NSString *total ;
//    NSString * sql = @"select SUM(newmsg) as c from chat_friend";
//    
//    FMResultSet *rs = [_db executeQuery:sql];
//    while([rs next]){
//        total = [rs stringForColumn:@"c"];
//    }
//    
//    return [total integerValue];
//}

#pragma mark - 聊天记录的操作

/*
- (long long int)insertOneChatLog:(NSDictionary *)dic{
    
    NSString *avatar    = [dic objectForKey:@"avatar"];
    NSString *chatMsg   = [dic objectForKey:@"chatmsg"];
//    NSString *ext       = [dic objectForKey:@"ext"];
    NSString *fromUid   = [dic objectForKey:@"from"];
    NSString *nick      = [dic objectForKey:@"fromnick"];
    NSString *iid       = [dic objectForKey:@"iid"];
    NSString *msgFrom   = [dic objectForKey:@"msgfrom"];
    NSString *msgType   = [dic objectForKey:@"msgtype"];
    NSString *sex       = [dic objectForKey:@"sex"];
    NSNumber *sendTime  = [dic objectForKey:@"time"];
    NSNumber *toUid     = [dic objectForKey:@"to"];

    BOOL success ;
    long long int insertIID = 0;
    //iid等于0，表示新插入数据，先获取本地的最后一条记录id，把本地id当iid插入数据库
    if ([iid longLongValue] == 0) {
        FMResultSet *rs2 = [_db executeQuery:@"SELECT * FROM chat_log ORDER BY id DESC LIMIT 1"];
        while([rs2 next]){
            iid = [NSString stringWithFormat:@"%lld",[[rs2 stringForColumn:@"id"] longLongValue]+1];
        }
        [rs2 close];
    }
    BOOL isEmpty = YES;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM chat_log WHERE iid = %@", iid];
    FMResultSet *rs = [_db executeQuery:sql];
    while([rs next]){
        isEmpty = NO;
    }
    [rs close];
    
    //查询返回的结果集为空，则插入
    if (isEmpty) {
        
        success = [_db executeUpdate:@"INSERT INTO chat_log (avatar, chatMsg, fromUid, nick, iid, msgFrom, msgType, sex, sendTime, toUid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", avatar, chatMsg, fromUid, nick, iid, msgFrom, msgType, sex, sendTime, toUid];
        
    } else {
        
        success = [self updateOneChatLog:dic];
    }
    
    if (success) {
        insertIID = [iid longLongValue];
    }
    
    return insertIID;
}
*/

//- (NSMutableArray *)getListChatLog:(NSString *)oid
//                               iid:(NSString *)iid
//                          pageSize:(NSInteger)pageSize{
- (NSMutableArray *)getListChatLogWithFromUid:(NSString *)fromUid
                                          iid:(NSString *)iid
                                     pageSize:(NSInteger)pageSize{

    NSMutableArray * resultArray = [NSMutableArray array];
    NSString *sql;
    if([iid longLongValue] > 0) {
        //先取一条记录，得到他的时间，再跟根据时间取下面的10条记录
        NSDictionary *userInfo = [self getOneChatLog:iid];
        
//        sql = [NSString stringWithFormat:@"SELECT a.*,b.avatar,b.nick,b.distance FROM chat_log as a left join chat_friend as b on a.oid = b.oid WHERE a.oid = '%@' and a.timer < %@  order by a.timer DESC limit %d",oid, [UserInfo objectForKey:@"timer"], pageSize];
        
//#define SQL_JY_CHAT_LOG "create table chat_log(" \
//"id integer PRIMARY KEY AUTOINCREMENT," \
//"avatar text," \
//"chatMsg text," \
//"fromUid varchar(100)," \
//"nick text," \
//"iid varchar(100)," \
//"msgFrom varchar(100)," \
//"msgType varchar(100)," \
//"sex varchar(100)," \
//"sendTime varchar(100)," \
//"toUid varchar(100))"
        
        sql = [NSString stringWithFormat:@"SELECT avatar, chatMsg, fromUid, nick, iid, msgFrom, msgType, sex, sendTime, toUid FROM chat_log WHERE fromUid = '%@' and sendTime < %@ order by sendTime DESC limit %ld", fromUid, [userInfo objectForKey:@"sendTime"], pageSize];
        
    } else {
//        sql = [NSString stringWithFormat:@"SELECT a.*,b.avatar,b.nick,b.distance FROM chat_log as a left join chat_friend as b on a.oid = b.oid WHERE a.oid = '%@' order by a.timer DESC limit %d",oid, pageSize];
        
        sql = [NSString stringWithFormat:@"SELECT avatar, chatMsg, fromUid, nick, iid, msgFrom, msgType, sex, sendTime, toUid FROM chat_log WHERE fromUid = '%@' order by sendTime DESC limit %ld", fromUid, pageSize];
//        sql = [NSString stringWithFormat:@"SELECT * FROM chat_log WHERE fromUid = '%@' order by sendTime DESC limit %d", fromUid, pageSize];

    }
    
    FMResultSet *rs = [_db executeQuery:sql];
    while([rs next]){
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setValue:[rs stringForColumn:@"avatar"] forKey:@"avatar"];
        [result setValue:[rs stringForColumn:@"chatMsg"] forKey:@"chatMsg"];
        [result setValue:[rs stringForColumn:@"fromUid"] forKey:@"fromUid"];
        [result setValue:[rs stringForColumn:@"nick"] forKey:@"nick"];
        [result setValue:[rs stringForColumn:@"iid"] forKey:@"iid"];
        [result setValue:[rs stringForColumn:@"msgFrom"] forKey:@"msgFrom"];
        [result setValue:[rs stringForColumn:@"msgType"] forKey:@"msgType"];
        [result setValue:[rs stringForColumn:@"sex"] forKey:@"sex"];
        [result setValue:[rs stringForColumn:@"sendTime"] forKey:@"sendTime"];
        [result setValue:[rs stringForColumn:@"toUid"] forKey:@"toUid"];
        [resultArray addObject:result];
    }
    //  result = [rs intForColumnIndex:0];
    [rs close];
    
    return resultArray;
}

- (BOOL)updateOneChatLog:(NSDictionary *)dic{
    
//    NSString *content           = [dic objectForKey:@"content"];
//    NSString *content_type      = [dic objectForKey:@"content-type"];
//    NSString *deletime          = [dic objectForKey:@"deletime"];
//    NSString *myfrom            = [dic objectForKey:@"from"];
//    NSString *iid               = [dic objectForKey:@"iid"];
//    NSString *mid               = [dic objectForKey:@"mid"];
//    NSString *oid               = [dic objectForKey:@"oid"];
//    NSString *readtime          = [dic objectForKey:@"readtime"];
//    NSString *sendtime          = [dic objectForKey:@"sendtime"];
//    NSNumber *status            = [dic objectForKey:@"status"];
//    NSNumber *timer             = [dic objectForKey:@"timer"];
//    NSNumber *type              = [dic objectForKey:@"type"];
    
    NSString *avatar    = [dic objectForKey:@"avatar"];
    NSString *chatMsg   = [dic objectForKey:@"chatmsg"];
    NSString *ext       = [dic objectForKey:@"ext"];
    NSString *fromUid   = [dic objectForKey:@"from"];
    NSString *nick      = [dic objectForKey:@"fromnick"];
    NSString *iid       = [dic objectForKey:@"iid"];
    NSString *msgFrom   = [dic objectForKey:@"msgfrom"];
    NSString *msgType   = [dic objectForKey:@"msgtype"];
    NSString *sex       = [dic objectForKey:@"sex"];
    NSNumber *sendTime  = [dic objectForKey:@"time"];
    NSNumber *toUid     = [dic objectForKey:@"to"];
    
    BOOL success = [_db executeUpdate:@"UPDATE chat_log set avatar=?, chatMsg=?, ext=?, fromUid=?, nick=?, msgFrom=?, msgType=?, sex=?, sendTime=?, toUid=? WHERE iid=?", avatar, chatMsg, ext, fromUid, nick, msgFrom, msgType, sex, sendTime, toUid, iid];
    return success;
}

//#pragma mark - 发送成功后发送聊天信息,只能新发送的msg更新，因为新插入的id都不是正常服务器返回的iid
//- (BOOL)updateChatMsgId:(NSString *)insertId
//                 msg_id:(NSString *)msg_id
//               sendTime:(NSString *)sendTime{
//    
//    BOOL success = [_db executeUpdate:@"update  chat_log set iid = ?, sendtime = ?, timer = ?, status = 0 where  iid =?", msg_id, [JYHelpers unixToDate:[sendTime intValue]], sendTime, insertId];
//    return success;
//    
//}

#pragma mark - 发送失败，更新聊天状态
//- (BOOL)updateChatStatusFailed:(NSString *)insertId{
//    
//    BOOL success = [_db executeUpdate:@"update  chat_log set status = 2 where  iid =?",insertId];
//    return success;
//}

//- (BOOL)updateChatStatusToReaded:(NSString *)iid{
//    
//    BOOL success        = [_db executeUpdate:@"update  chat_log set status = 1 where  iid =?",iid];
//    return success;
//}

//- (BOOL)updateOneChatLogContent:(NSString *)msgId content:(NSString *)content content_type:(NSString *)content_type{
//    
//    BOOL success        = [_db executeUpdate:@"update  chat_log set content = ?,content_type = ? where  iid =?",content,content_type, msgId];
//    return success;
//}

//- (BOOL) deleteOneChatLog:(NSString *)iid{
//    BOOL success        = [_db executeUpdate:@"delete from  chat_log where iid =?", iid];
//    return success;
//}

- (NSDictionary *)getOneChatLog:(NSString *)msgId{
    
    NSMutableArray * resultArray = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM chat_log WHERE iid = '%@'", msgId];
    FMResultSet *rs = [_db executeQuery:sql];
    while([rs next]){
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setValue:[rs stringForColumn:@"avatar"] forKey:@"avatar"];
        [result setValue:[rs stringForColumn:@"chatMsg"] forKey:@"chatMsg"];
        [result setValue:[rs stringForColumn:@"fromUid"] forKey:@"fromUid"];
        [result setValue:[rs stringForColumn:@"nick"] forKey:@"nick"];
        [result setValue:[rs stringForColumn:@"iid"] forKey:@"iid"];
        [result setValue:[rs stringForColumn:@"msgFrom"] forKey:@"msgFrom"];
        [result setValue:[rs stringForColumn:@"msgType"] forKey:@"msgType"];
        [result setValue:[rs stringForColumn:@"sex"] forKey:@"sex"];
        [result setValue:[rs stringForColumn:@"sendTime"] forKey:@"sendTime"];
        [result setValue:[rs stringForColumn:@"toUid"] forKey:@"toUid"];
        [result setValue:[rs stringForColumn:@"is_sys_tip"] forKey:@"is_sys_tip"];
        [resultArray addObject:result];
    }
    //  result = [rs intForColumnIndex:0];
    [rs close];
    return resultArray[0];
}

//- (NSString *)getChatLogCount:(NSString *)oid{
//    NSString *returnContent = nil;
//    NSString *sql = [NSString stringWithFormat:@"SELECT count(*) as c FROM chat_log WHERE oid = '%@' ", oid];
//    FMResultSet *rs = [_db executeQuery:sql];
//    while([rs next]){
//        returnContent = [rs stringForColumn:@"c"];
//    }
//    //  result = [rs intForColumnIndex:0];
//    [rs close];
//    return returnContent;
//}

//#pragma mark - 当前用户正在发送的数据，状态完部转为发送失败
//- (BOOL)userSendingLogToSendFailure:(NSString *)oid{
//    
//    BOOL success = [_db executeUpdate:@"update  chat_log set status = 2 where  oid =? and status = 3",oid];
//    return success;
//    
//}

#pragma mark - gao

#pragma mark - 获取新消息
- (NSArray *)getNewMsgWithFromUid:(NSString *)fromUid
                         sendTime:(NSString *)sendTime
{
    NSMutableArray * resultArray = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT avatar, chatMsg, fromUid, nick, iid, msgFrom, msgType, sex, sendTime, toUid FROM chat_log WHERE fromUid = '%@' and sendTime > %@ order by sendTime ASC", fromUid, sendTime];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setValue:[rs stringForColumn:@"avatar"] forKey:@"avatar"];
        [result setValue:[rs stringForColumn:@"chatMsg"] forKey:@"chatMsg"];
        [result setValue:[rs stringForColumn:@"fromUid"] forKey:@"fromUid"];
        [result setValue:[rs stringForColumn:@"nick"] forKey:@"nick"];
        [result setValue:[rs stringForColumn:@"iid"] forKey:@"iid"];
        [result setValue:[rs stringForColumn:@"msgFrom"] forKey:@"msgFrom"];
        [result setValue:[rs stringForColumn:@"msgType"] forKey:@"msgType"];
        [result setValue:[rs stringForColumn:@"sex"] forKey:@"sex"];
        [result setValue:[rs stringForColumn:@"sendTime"] forKey:@"sendTime"];
        [result setValue:[rs stringForColumn:@"toUid"] forKey:@"toUid"];
        [result setValue:[rs stringForColumn:@"is_sys_tip"] forKey:@"is_sys_tip"];
        [resultArray addObject:result];
    }
    [rs close];
    
    return resultArray;
}

#pragma mark - 获取历史消息
- (NSArray *)getHistoryMsgWithFromUid:(NSString *)fromUid
                             sendTime:(NSString *)sendTime
{
    /*
     id             integer             自增id
     iid            varchar(100)        消息id
     msgType        varchar(100)        消息类型 0:文本消息 2:语音消息 3:图片消息
     avatar         text                头像
     chatMsg        text                消息内容
     fromUid        varchar(100)        消息发自于哪个用户
     nick           text                发消息用户昵称
     msgFrom        varchar(100)        消息来自于哪种设备
     sex            varchar(100)        性别 0女 1男
     time           integer default 0   时间
     sendStatus     integer default 0   发送状态 0发送失败 1发送中 2发送成功
     readStatus     integer default 0   阅读状态 0未读 1已读
     fileUrl        text                图片 或者语音链接
     voiceLength    integer default 0   语音消息长度
     imgWidth       integer default 0   图片宽
     imgHeight      integer default 0   图片长
     */
    NSMutableArray * resultArray = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM chat_log WHERE fromUid = '%@' and time < %@ order by time DESC limit %d", fromUid, sendTime, 10];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setValue:[rs stringForColumn:@"iid"] forKey:@"iid"];
        [result setValue:[rs stringForColumn:@"msgType"] forKey:@"msgType"];
        [result setValue:[rs stringForColumn:@"avatar"] forKey:@"avatar"];
        [result setValue:[rs stringForColumn:@"chatMsg"] forKey:@"chatMsg"];
        [result setValue:[rs stringForColumn:@"fromUid"] forKey:@"fromUid"];
        [result setValue:[rs stringForColumn:@"nick"] forKey:@"nick"];
        [result setValue:[rs stringForColumn:@"msgFrom"] forKey:@"msgFrom"];
        [result setValue:[rs stringForColumn:@"sex"] forKey:@"sex"];
        [result setValue:[rs stringForColumn:@"time"] forKey:@"time"];
        [result setValue:[rs stringForColumn:@"sendStatus"] forKey:@"sendStatus"];
        [result setValue:[rs stringForColumn:@"readStatus"] forKey:@"readStatus"];
        [result setValue:[rs stringForColumn:@"fileUrl"] forKey:@"fileUrl"];
        [result setValue:[rs stringForColumn:@"voiceLength"] forKey:@"voiceLength"];
        [result setValue:[rs stringForColumn:@"imgWidth"] forKey:@"imgWidth"];
        [result setValue:[rs stringForColumn:@"imgHeight"] forKey:@"imgHeight"];
        [result setValue:[rs stringForColumn:@"is_sys_tip"] forKey:@"is_sys_tip"];
        [resultArray addObject:result];
    }
    [rs close];
    
    return resultArray;
}

#pragma mark - 插入一条聊天记录

- (NSString *)insertOneChatLog:(NSDictionary *)msgDict
{
    NSString *iid = [msgDict objectForKey:@"iid"];
    NSString *msgType = [msgDict objectForKey:@"msgType"];
    NSString *avatar = [msgDict objectForKey:@"avatar"];
    NSString *chatMsg = [msgDict objectForKey:@"chatMsg"];
    NSString *fromUid = [msgDict objectForKey:@"fromUid"];
    NSString *nick = [msgDict objectForKey:@"nick"];
    NSString *msgFrom = [msgDict objectForKey:@"msgFrom"];
    NSString *sex = [msgDict objectForKey:@"sex"];
    NSString *time = [msgDict objectForKey:@"time"];
    NSString *sendStatus = [msgDict objectForKey:@"sendStatus"];
    NSString *readStatus = [msgDict objectForKey:@"readStatus"];
    NSString *fileUrl = [msgDict objectForKey:@"fileUrl"];
    NSString *voiceLength = [msgDict objectForKey:@"voiceLength"];
    NSString *imgWidth = [msgDict objectForKey:@"imgWidth"];
    NSString *imgHeight = [msgDict objectForKey:@"imgHeight"];
    
    NSString *idStr = [NSString stringWithFormat:@"0"];
    
    BOOL success = [_db executeUpdate:@"insert into chat_log (iid, msgType, avatar, chatMsg, fromUid, nick, msgFrom, sex, time, sendStatus ,readStatus, fileUrl, voiceLength, imgWidth, imgHeight) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", iid, msgType, avatar, chatMsg ,fromUid, nick, msgFrom, sex, time, sendStatus, readStatus, fileUrl, voiceLength, imgWidth, imgHeight];

    if (success) {
        FMResultSet *resultSet1 = [_db executeQuery:@"SELECT * FROM chat_log ORDER BY id DESC LIMIT 1"];
        while ([resultSet1 next]) {
            
            idStr = [NSString stringWithFormat:@"%lld",[[resultSet1 stringForColumn:@"id"] longLongValue]];
        }
        [resultSet1 close];
    }
    
    return idStr;
    
    
    /*
    NSString *itemId;
    //iid等于0，表示新插入数据，先获取本地的最大id，"最大id+1"当iid插入数据库
    if ([iid longLongValue] == 0) {
        FMResultSet *resultSet1 = [_db executeQuery:@"SELECT * FROM chat_log ORDER BY id DESC LIMIT 1"];
        while ([resultSet1 next]) {
            
            itemId = [NSString stringWithFormat:@"%lld",[[resultSet1 stringForColumn:@"id"] longLongValue]+1];
        }
        [resultSet1 close];
    }
    
    //如果数据库已经有这条iid消息 更新
    BOOL isExist = NO;
    FMResultSet *resultSet2 = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM chat_log WHERE iid = %@", iid]];
    while ([resultSet2 next]) {
        isExist = YES;
    }
    
    BOOL success = NO;
    if (isExist == NO) {
        
        //不存在 插入
        success = [_db executeUpdate:@"INSERT INTO chat_log (iid, msgType, avatar, chatMsg, fromUid, nick, msgFrom, sex, time, sendStatus ,readStatus, fileUrl, voiceLength, imgWidth, imgHeight) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", iid,msgType, avatar, chatMsg ,fromUid, nick, msgFrom, sex, time, sendStatus, readStatus, fileUrl, voiceLength, imgWidth, imgHeight];
    } else {
        success = [self updateOneChatLogWithMsgDict:msgDict];
    }
    
    long long int insert_iid = 0;
    if (success) {
        insert_iid = [itemId longLongValue];
    }
    
    return insert_iid;
    */
}

#pragma mark - 更新一条聊天记录

//- (BOOL)updateOneChatLogWithMsgDict:(NSDictionary *)msgDict
//{
//    NSString *idStr = [msgDict objectForKey:@"id"];
//    NSString *iid = [msgDict objectForKey:@"iid"];
//    NSString *msgType = [msgDict objectForKey:@"msgType"];
//    NSString *avatar = [msgDict objectForKey:@"avatar"];
////    NSString *chatMsg = [msgDict objectForKey:@"chatMsg"];
//    NSString *fromUid = [msgDict objectForKey:@"fromUid"];
//    NSString *nick = [msgDict objectForKey:@"nick"];
//    NSString *msgFrom = [msgDict objectForKey:@"msgFrom"];
//    NSString *sex = [msgDict objectForKey:@"sex"];
//    NSString *time = [msgDict objectForKey:@"time"];
//    NSString *sendStatus = [msgDict objectForKey:@"sendStatus"];
//    NSString *readStatus = [msgDict objectForKey:@"readStatus"];
//    NSString *fileUrl = [msgDict objectForKey:@"fileUrl"];
//    NSString *voiceLength = [msgDict objectForKey:@"voiceLength"];
//    NSString *imgWidth = [msgDict objectForKey:@"imgWidth"];
//    NSString *imgHeight = [msgDict objectForKey:@"imgHeight"];
//    
//    NSString *sql = [NSString stringWithFormat:@"update chat_log set iid='%@', msgType=%@, avatar='%@', fromUid=%@, nick='%@', msgFrom=%@, sex=%@, time=%@, sendStatus=%@, readStatus=%@, fileUrl='%@', voiceLength=%@, imgWidth=%@, imgHeight=%@ WHERE id=%@", iid, msgType, avatar, fromUid, nick, msgFrom, sex, time, sendStatus, readStatus, fileUrl, voiceLength, imgWidth, imgHeight, idStr];
//    NSLog(@"%@", sql);
//    
//    BOOL success = [_db executeUpdate:sql];
////    BOOL success = [_db executeUpdate:@"update chat_log set iid='?', msgType=?, avatar='?', fromUid=?, nick='?', msgFrom=?, sex=?, time=?, sendStatus=?, readStatus=?, fileUrl='?', voiceLength=?, imgWidth=?, imgHeight=? WHERE id=?", iid, msgType, avatar, fromUid, nick, msgFrom, sex, time, sendStatus, readStatus, fileUrl, voiceLength, imgWidth, imgHeight, idStr];
//    
//    if (success) {
//        FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM chat_log WHERE id=?", idStr];
//        while ([resultSet next]) {
//            
//            NSLog(@"%@", [resultSet stringForColumn:@"iid"]);
//            NSLog(@"%@", [resultSet stringForColumn:@"sendStatus"]);
//        }
//    }
//    
//    return success;
//
//}


#pragma mark - 插入一组聊天关系

//- (void)insertChatFriendWithList:(NSArray *)modelList
//{
//    for (JYMessageModel *messageModel in modelList) {
//        
//    }
//}

#pragma mark - #####

//向chat_log表中插入一条记录
- (void)insertOneChatMsgIntoChatLogWithModel:(JYChatModel *)chatModel
{
    if ([JYHelpers isEmptyOfString:chatModel.iid]) {
        return ;
    }
    
    //ext如果是字典先转为json
    NSString * extString = @"";
    if ([chatModel.ext isKindOfClass:[NSDictionary class]]) {
        extString = [JYHelpers dictionaryToJSONString:chatModel.ext];
    }
    //查看数据库中是否已经有这条信息
    FMResultSet *resultSet = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM chat_log WHERE iid = %@", chatModel.iid]];
    BOOL isExist = NO;
    while ([resultSet next]) {
        isExist = YES;
    }
    
    if (isExist) {
        //存在 更新
        [self updateChatLogOneChatMsgWithModel:chatModel];
    } else {
        //不存在 插入
        BOOL success = [_db executeUpdate:@"insert into chat_log (iid, msgType, avatar, chatMsg, fromUid, nick, msgFrom, sex, time, sendStatus ,readStatus, fileUrl, voiceLength, imgWidth, imgHeight, sendType,ext,is_sys_tip) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?,?)", chatModel.iid, chatModel.msgType, chatModel.avatar, chatModel.chatMsg, chatModel.fromUid, chatModel.nick, chatModel.msgFrom, chatModel.sex, chatModel.time, chatModel.sendStatus, chatModel.readStatus, chatModel.fileUrl, chatModel.voiceLength, chatModel.imgWidth, chatModel.imgHeight, chatModel.sendType,extString, chatModel.is_sys_tip];
        if (success) {
            NSLog(@"插入成功");
        } else {
            NSLog(@"插入失败");
        }
    }
}

- (void)updateChatLogOneChatMsgWithModel:(JYChatModel *)chatModel
{
    //ext如果是字典先转为json
    NSString * extString = @"";
    if ([chatModel.ext isKindOfClass:[NSDictionary class]]) {
        extString = [JYHelpers dictionaryToJSONString:chatModel.ext];
    }
    
    NSString *sql = [NSString stringWithFormat:@"update chat_log set msgType='%@', avatar='%@', chatMsg='%@', fromUid='%@', nick='%@', msgFrom='%@', sex='%@', time='%@', sendStatus='%@', fileUrl='%@', voiceLength='%@', imgWidth='%@', imgHeight='%@', sendType='%@', ext = '%@', is_sys_tip = '%@' WHERE iid='%@' ", chatModel.msgType, chatModel.avatar, chatModel.chatMsg, chatModel.fromUid, chatModel.nick, chatModel.msgFrom, chatModel.sex, chatModel.time, chatModel.sendStatus, chatModel.fileUrl, chatModel.voiceLength, chatModel.imgWidth, chatModel.imgHeight, chatModel.sendType,extString, chatModel.is_sys_tip, chatModel.iid];
    NSLog(@"%@", sql);
    
    BOOL success = [_db executeUpdate:sql];
    if (success) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
    }
}

- (void)updateChatLogOneChatMsgWithModel:(JYChatModel *)chatModel
                                     iid:(NSString *)iid
{
    //ext如果是字典先转为json
    NSString * extString = @"";
    if ([chatModel.ext isKindOfClass:[NSDictionary class]]) {
        extString = [JYHelpers dictionaryToJSONString:chatModel.ext];
    }
    NSString *sql = [NSString stringWithFormat:@"update chat_log set iid='%@', msgType='%@', avatar='%@', chatMsg='%@', fromUid='%@', nick='%@', msgFrom='%@', sex='%@', time='%@', sendStatus='%@', fileUrl='%@', voiceLength='%@', imgWidth='%@', imgHeight='%@', sendType='%@', ext = '%@', is_sys_tip = '%@' WHERE iid='%@'", chatModel.iid, chatModel.msgType, chatModel.avatar, chatModel.chatMsg, chatModel.fromUid, chatModel.nick, chatModel.msgFrom, chatModel.sex, chatModel.time, chatModel.sendStatus, chatModel.fileUrl, chatModel.voiceLength, chatModel.imgWidth, chatModel.imgHeight, chatModel.sendType,extString, chatModel.is_sys_tip, iid];
    NSLog(@"%@", sql);
    
    BOOL success = [_db executeUpdate:sql];
    if (success) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
    }
}



- (NSMutableArray *)getChatMsgListFromChatLogWithModel:(JYChatModel *)chatModel
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from chat_log where fromUid = '%@' and time < %@ order by time DESC limit %d", chatModel.fromUid, chatModel.time, 10];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        JYChatModel *chatModel = [[JYChatModel alloc] init];
        chatModel.isGroup = NO;
        chatModel.iid = [rs stringForColumn:@"iid"];
        chatModel.msgType = [rs stringForColumn:@"msgType"];
        chatModel.avatar = [rs stringForColumn:@"avatar"];
        chatModel.chatMsg = [rs stringForColumn:@"chatMsg"];
        chatModel.fromUid = [rs stringForColumn:@"fromUid"];
        chatModel.nick = [rs stringForColumn:@"nick"];
        chatModel.msgFrom = [rs stringForColumn:@"msgFrom"];
        chatModel.sex = [rs stringForColumn:@"sex"];
        chatModel.time = [rs stringForColumn:@"time"];
        chatModel.sendStatus = [rs stringForColumn:@"sendStatus"];
        chatModel.readStatus = [rs stringForColumn:@"readStatus"];
        chatModel.fileUrl = [rs stringForColumn:@"fileUrl"];
        chatModel.voiceLength = [rs stringForColumn:@"voiceLength"];
        chatModel.imgWidth = [rs stringForColumn:@"imgWidth"];
        chatModel.imgHeight = [rs stringForColumn:@"imgHeight"];
        chatModel.sendType = [rs stringForColumn:@"sendType"];
        chatModel.ext = [JYHelpers jsonStringToDictionary:[rs stringForColumn:@"ext"]];
        chatModel.is_sys_tip = [rs stringForColumn:@"is_sys_tip"];

        [resultList addObject:chatModel];
        
    }
    [rs close];
    
    return resultList;
}

- (void)updateVoiceChatMsgReadStatus:(NSString *)iid readStatus:(NSString *)readStatus
{
   
    NSString *sql = [NSString stringWithFormat:@"update chat_log set  readStatus = '%@' WHERE iid='%@'", readStatus, iid];
    NSLog(@"%@", sql);
    
    BOOL success = [_db executeUpdate:sql];
    if (success) {
        NSLog(@"更新语音聊天状态成功");
    } else {
        NSLog(@"更新语音聊天状态失败");
    }
}

- (void)updateGourpVoiceChatMsgReadStatus:(NSString *)iid readStatus:(NSString *)readStatus
{
    
    NSString *sql = [NSString stringWithFormat:@"update group_chat_log set  readStatus = '%@' WHERE iid='%@'", readStatus, iid];
    NSLog(@"%@", sql);
    
    BOOL success = [_db executeUpdate:sql];
    if (success) {
        NSLog(@"更新语音聊天状态成功");
    } else {
        NSLog(@"更新语音聊天状态失败");
    }
}

- (NSString *)getChatLogId
{
    FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM chat_log ORDER BY id DESC LIMIT 1"];
    NSString *itemId = @"0";
    while ([resultSet next]) {
        
        NSInteger intId = [[resultSet stringForColumn:@"id"] integerValue];
        itemId = [NSString stringWithFormat:@"%ld", intId+1];
    }
    [resultSet close];

    return itemId;
}

//#pragma mark - 获取一个群组用户
//- (BOOL)deleteOneUserAllChatLog:(NSString *)oid{
//        
//    BOOL success = [_db executeUpdate:@"delete FROM chat_log WHERE oid = ?", group_id];
//    [_db executeUpdate:@"delete FROM group_chat_log WHERE groupId = ?", group_id];
//    
//    return success;
// 
//}


#pragma mark - ******

- (void)insertOneChatMsgIntoGroupChatLogWithModel:(JYChatModel *)chatModel
{
    //查看数据库中是否已经有这条信息
    FMResultSet *resultSet = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM group_chat_log WHERE iid = %@", chatModel.iid]];
    BOOL isExist = NO;
    while ([resultSet next]) {
        isExist = YES;
    }
    //ext如果是字典先转为json
    NSString * extString = @"";
    if ([chatModel.ext isKindOfClass:[NSDictionary class]]) {
        extString = [JYHelpers dictionaryToJSONString:chatModel.ext];
    }
    if (isExist) {
        //存在 更新
        [self updateGroupChatLogOneChatMsgWithModel:chatModel];
    } else {
        //不存在 插入
        BOOL success = [_db executeUpdate:@"insert into group_chat_log (groupId, iid, msgType, avatar, chatMsg, fromUid, nick, msgFrom, sex, time, sendStatus ,readStatus, fileUrl, voiceLength, imgWidth, imgHeight, sendType,ext,is_sys_tip) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?,?)", chatModel.groupId, chatModel.iid, chatModel.msgType, chatModel.avatar, chatModel.chatMsg, chatModel.fromUid, chatModel.nick, chatModel.msgFrom, chatModel.sex, chatModel.time, chatModel.sendStatus, chatModel.readStatus, chatModel.fileUrl, chatModel.voiceLength, chatModel.imgWidth, chatModel.imgHeight, chatModel.sendType,extString,chatModel.is_sys_tip];
        if (success) {
            NSLog(@"插入成功");
        } else {
            NSLog(@"插入失败");
        }
    }
}

- (void)updateGroupChatLogOneChatMsgWithModel:(JYChatModel *)chatModel
{
    //ext如果是字典先转为json
    NSString * extString = @"";
    if ([chatModel.ext isKindOfClass:[NSDictionary class]]) {
        extString = [JYHelpers dictionaryToJSONString:chatModel.ext];
    }
    NSString *sql = [NSString stringWithFormat:@"update group_chat_log set groupId='%@', msgType='%@', avatar='%@', chatMsg='%@', fromUid='%@', nick='%@', msgFrom='%@', sex='%@', time='%@', sendStatus='%@', fileUrl='%@', voiceLength='%@', imgWidth='%@', imgHeight='%@', sendType='%@',ext = '%@',is_sys_tip = '%@' WHERE iid='%@'", chatModel.groupId, chatModel.msgType, chatModel.avatar, chatModel.chatMsg, chatModel.fromUid, chatModel.nick, chatModel.msgFrom, chatModel.sex, chatModel.time, chatModel.sendStatus, chatModel.fileUrl, chatModel.voiceLength, chatModel.imgWidth, chatModel.imgHeight, chatModel.sendType,extString,chatModel.is_sys_tip, chatModel.iid];
    NSLog(@"%@", sql);
    
    BOOL success = [_db executeUpdate:@"update group_chat_log set groupId=?, msgType=?, avatar=?, chatMsg=?, fromUid=?, nick=?, msgFrom=?, sex=?, time=?, sendStatus=?, fileUrl=?, voiceLength=?, imgWidth=?, imgHeight=?, sendType=?,ext = ?,is_sys_tip = ? WHERE iid=?", chatModel.groupId, chatModel.msgType, chatModel.avatar, chatModel.chatMsg, chatModel.fromUid, chatModel.nick, chatModel.msgFrom, chatModel.sex, chatModel.time, chatModel.sendStatus, chatModel.fileUrl, chatModel.voiceLength, chatModel.imgWidth, chatModel.imgHeight, chatModel.sendType,extString,chatModel.is_sys_tip, chatModel.iid];
    if (success) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
    }
}

- (void)updateGroupChatLogOneChatMsgWithModel:(JYChatModel *)chatModel
                                          iid:(NSString *)iid
{
    //ext如果是字典先转为json
    NSString * extString = @"";
    if ([chatModel.ext isKindOfClass:[NSDictionary class]]) {
        extString = [JYHelpers dictionaryToJSONString:chatModel.ext];
    }
    NSString *sql = [NSString stringWithFormat:@"update group_chat_log set iid='%@', msgType='%@', avatar='%@', chatMsg='%@', fromUid='%@', nick='%@', msgFrom='%@', sex='%@', time='%@', sendStatus='%@', fileUrl='%@', voiceLength='%@', imgWidth='%@', imgHeight='%@', sendType='%@',ext = '%@',is_sys_tip = '%@' WHERE iid='%@'", chatModel.iid, chatModel.msgType, chatModel.avatar, chatModel.chatMsg, chatModel.fromUid, chatModel.nick, chatModel.msgFrom, chatModel.sex, chatModel.time, chatModel.sendStatus, chatModel.fileUrl, chatModel.voiceLength, chatModel.imgWidth, chatModel.imgHeight, chatModel.sendType, extString,chatModel.is_sys_tip, iid];
    NSLog(@"%@", sql);
    
    BOOL success = [_db executeUpdate:@"update group_chat_log set iid=?, msgType=?, avatar=?, chatMsg=?, fromUid=?, nick=?, msgFrom=?, sex=?, time=?, sendStatus=?, fileUrl=?, voiceLength=?, imgWidth=?, imgHeight=?, sendType=?,ext = ?,is_sys_tip = ? WHERE iid=?", chatModel.iid, chatModel.msgType, chatModel.avatar, chatModel.chatMsg, chatModel.fromUid, chatModel.nick, chatModel.msgFrom, chatModel.sex, chatModel.time, chatModel.sendStatus, chatModel.fileUrl, chatModel.voiceLength, chatModel.imgWidth, chatModel.imgHeight, chatModel.sendType, extString,chatModel.is_sys_tip, iid];
    if (success) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
    }
}

- (NSMutableArray *)getChatMsgListFromGroupChatLogWithModel:(JYChatModel *)chatModel
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from group_chat_log where groupId = '%@' and time < %@ order by time DESC limit %d", chatModel.groupId, chatModel.time, 10];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        JYChatModel *chatModel = [[JYChatModel alloc] init];
        chatModel.isGroup = YES;
        chatModel.groupId = [rs stringForColumn:@"groupId"];
        chatModel.iid = [rs stringForColumn:@"iid"];
        chatModel.msgType = [rs stringForColumn:@"msgType"];
        chatModel.avatar = [rs stringForColumn:@"avatar"];
        chatModel.chatMsg = [rs stringForColumn:@"chatMsg"];
        chatModel.fromUid = [rs stringForColumn:@"fromUid"];
        chatModel.nick = [rs stringForColumn:@"nick"];
        chatModel.msgFrom = [rs stringForColumn:@"msgFrom"];
        chatModel.sex = [rs stringForColumn:@"sex"];
        chatModel.time = [rs stringForColumn:@"time"];
        chatModel.sendStatus = [rs stringForColumn:@"sendStatus"];
        chatModel.readStatus = [rs stringForColumn:@"readStatus"];
        chatModel.fileUrl = [rs stringForColumn:@"fileUrl"];
        chatModel.voiceLength = [rs stringForColumn:@"voiceLength"];
        chatModel.imgWidth = [rs stringForColumn:@"imgWidth"];
        chatModel.imgHeight = [rs stringForColumn:@"imgHeight"];
        chatModel.sendType = [rs stringForColumn:@"sendType"];
        chatModel.ext = [JYHelpers jsonStringToDictionary:[rs stringForColumn:@"ext"]];
        chatModel.is_sys_tip = [rs stringForColumn:@"is_sys_tip"];
        [resultList addObject:chatModel];
        
    }
    [rs close];
    
    return resultList;
}

//获取最后一条id
- (NSString *)getGroupChatLogId
{
    FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM group_chat_log ORDER BY id DESC LIMIT 1"];
    NSString *itemId = @"0";
    while ([resultSet next]) {
        
        NSInteger intId = [[resultSet stringForColumn:@"id"] integerValue];
        itemId = [NSString stringWithFormat:@"%d", intId+1];
    }
    [resultSet close];
    
    return itemId;
}


//获取最后一条消息的iid
- (NSString *)getGroupChatLogLastIid:(NSString *)group_id
{
    NSLog(@"sql:SELECT * FROM group_chat_log WHERE groupId='%@' ORDER BY iid DESC LIMIT 1",group_id);
    FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM group_chat_log WHERE groupId=? ORDER BY iid DESC LIMIT 1",group_id];
    NSString *itemId = @"0";
    while ([resultSet next]) {
        
        itemId = [resultSet stringForColumn:@"iid"] ;
    }
    [resultSet close];
    
    return itemId;
}

- (void)updateGroupVoiceChatMsgReadStatus:(NSString *)group_id readStatus:(NSString *)readStatus
{
    
    NSString *sql = [NSString stringWithFormat:@"update group_chat_log set  readStatus = '%@' WHERE groupId='%@'", readStatus, group_id];
    NSLog(@"%@", sql);
    
    BOOL success = [_db executeUpdate:sql];
    if (success) {
        NSLog(@"更新群组语音聊天状态成功");
    } else {
        NSLog(@"更新群组语音聊天状态失败");
    }
}
@end
