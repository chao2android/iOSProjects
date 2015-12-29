//
//  JYFeedData.m
//  friendJY
//
//  Created by ouyang on 5/9/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedData.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYEncrypt.h"
#import "JYShareData.h"
#import "JYProfileData.h"
#import "JYProfileModel.h"


#define  SQL_JY_PROFILE "create table feedList(uid varchar(20) ,postUrl  varchar(1000) PRIMARY KEY,content text)"
#define  SQL_JY_PHOTOS "create table myFeed(uid varchar(20) PRIMARY KEY,feedid varchar(20),feedContent text)"

@implementation JYFeedData


static JYFeedData *_instance;
+ (JYFeedData *)sharedInstance;
{
    @synchronized(self) {
        
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
            
            _instance.feedListArr = [[NSMutableArray alloc]initWithCapacity:10];
            //加载上次缓存的数据
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];//cache目录
            path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"]]];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            if ([fileMgr fileExistsAtPath:path]) {
                //读取数据
                NSData *data = [NSData dataWithContentsOfFile:path];
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                for (NSDictionary *temp in array) {
                    JYFeedModel * feedModel = [[JYFeedModel alloc] initWithDataDic:temp];
                    [_instance.feedListArr addObject:feedModel];
                }
            }
            
            _instance.myDynamicArr = [NSMutableArray array];
        }
    }
    return _instance;
}
- (void)CacheToFile:(NSData *) jsonData{
    //加载上次缓存的数据
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];//cache目录
    path = [path stringByAppendingPathComponent:ToString([[NSUserDefaults standardUserDefaults]objectForKey:@"uid"])];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:path]) {
        //删除
        BOOL res = [fileMgr removeItemAtPath:path error:nil];
    }
    //写入
    BOOL res = [jsonData writeToFile:path atomically:YES];
    NSLog(@"--->%d",res);
    
    
    
}

- (void)getFeedList:(NSString *)feedId isSingle:(NSString *)isSingle isUp:(int)isUp andFinishBlock:(void(^)(BOOL hasMore))finishBlock andFaileBlock:(void(^)())failBlock{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"snsfeed" forKey:@"mod"];
    [parametersDict setObject:@"get_recommend_dynamic_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:feedId forKey:@"dy_id"];
    [postDict setObject:@"10" forKey:@"num"];
    [postDict setObject:isSingle forKey:@"is_single"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            
            //2,更新 self.feedListArr
            NSArray *Arr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            
            if (isUp==0){//下拉刷新
                [self.feedListArr removeAllObjects];
                //1,缓存到本地 更新本地缓存数据  只存十条
                if (Arr.count>0) {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Arr options:(NSJSONWritingPrettyPrinted) error:nil];
                    [self CacheToFile:jsonData];
                }
            }
            else{//加载更多
            }
            
            BOOL hasMore = Arr.count!=0;
            
            for (NSDictionary *temp in Arr) {
                //不重复的add 重复的替换掉
                BOOL isRepetition = NO;
                JYFeedModel *feedModel = [[JYFeedModel alloc] initWithDataDic:temp];
                for (int i = 0; i<self.feedListArr.count; i++) {
                    if (![[self.feedListArr objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                        JYFeedModel *oldModel = [self.feedListArr objectAtIndex:i];
                        if ([oldModel isKindOfClass:[JYFeedModel class]]) {
                            if ([oldModel.feedid intValue] == [feedModel.feedid intValue]) {
                                [self.feedListArr replaceObjectAtIndex:i withObject:feedModel];
                                isRepetition = YES;
                                break;
                            }
                        }
                    }
                }
                if (!isRepetition) {
                    [self.feedListArr addObject:feedModel];
                }
            }
            
//            //在5 15 25处加一个导入通讯录的
            if (self.feedListArr.count>GuideToAddressBookIndexpath5 && ![self.feedListArr[GuideToAddressBookIndexpath5] isKindOfClass:[NSDictionary class]]) {
                if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_IsUpList", [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]] && [([JYShareData sharedInstance].myself_profile_model).callno_upload  isEqualToString:@"0"]) {
                    if (![self.feedListArr[GuideToAddressBookIndexpath5] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *addDict = [[NSDictionary alloc]initWithObjects:@[@"add"] forKeys:@[@"add"]];
                        [self.feedListArr insertObject:addDict atIndex:GuideToAddressBookIndexpath5];
                    }
                }
            }
            
            if (self.feedListArr.count>GuideToAddressBookIndexpath15 && ![self.feedListArr[GuideToAddressBookIndexpath15] isKindOfClass:[NSDictionary class]]) {
                if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_IsUpList", [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]] && [([JYShareData sharedInstance].myself_profile_model).callno_upload  isEqualToString:@"0"]) {
                    if (![self.feedListArr[GuideToAddressBookIndexpath15] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *addDict = [[NSDictionary alloc]initWithObjects:@[@"add"] forKeys:@[@"add"]];
                        [self.feedListArr insertObject:addDict atIndex:GuideToAddressBookIndexpath15];
                    }
                }
            }
            
            if (self.feedListArr.count>GuideToAddressBookIndexpath25 && ![self.feedListArr[GuideToAddressBookIndexpath25] isKindOfClass:[NSDictionary class]]) {
                if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_IsUpList", [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]] && [([JYShareData sharedInstance].myself_profile_model).callno_upload  isEqualToString:@"0"]) {
                    if (![self.feedListArr[GuideToAddressBookIndexpath25] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *addDict = [[NSDictionary alloc]initWithObjects:@[@"add"] forKeys:@[@"add"]];
                        [self.feedListArr insertObject:addDict atIndex:GuideToAddressBookIndexpath25];
                    }
                }
            }
            
            
            //回掉去刷新页面
            finishBlock(hasMore);
            
        } else {
            failBlock();
        }
        
    } failure:^(id error) {
        failBlock();
        NSLog(@"%@", error);
        
    }];
}


- (NSMutableArray *) getFeedList:(NSString *)feedId isSingle:(NSString *)isSingle isUp:(int)isUp{
    BOOL is_sync = FALSE;
    NSString *bodyStr = [NSString stringWithFormat:@"dy_id=%@&num=10&is_single=%@",feedId,isSingle];
    NSString *myFeedListStr = [self getDatabaseFeedList:[JYEncrypt md5:bodyStr]];
    if (myFeedListStr.length<1) {
        is_sync = TRUE;
    }else{
        NSData *jsonData = [myFeedListStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary * dic =  [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&err];
        [self handleReturnData:dic postUrl:bodyStr isUp:isUp isInsertDB:NO];
        
    }
    [self _fromHttpGetData:is_sync d_id:feedId isSingle:isSingle isUp:(int)isUp];
    
    
    return self.feedListArr;
}

- (void) _fromHttpGetData:(BOOL) is_sync d_id:(NSString *)d_id isSingle:(NSString *)isSingle isUp:(int)isUp{
    NSString *bodyStr = [NSString stringWithFormat:@"dy_id=%@&num=10&is_single=%@",d_id,isSingle];
    if (is_sync && d_id == 0) { //网络请求，是否需要同步还是异步 ,d_id=0，也就是当第一页时，要同步，同步时会卡，所以只可能第一次加载时使用
        NSString *urlStr = [NSString stringWithFormat:@"%@?mod=snsfeed&func=get_recommend_dynamic_list", HTTP_PREFIX];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
        urlrequest.HTTPMethod = @"POST";
        
        NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        urlrequest.HTTPBody = body;
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [requestOperation start];
        [requestOperation waitUntilFinished];
        //NSLog(@"%@",requestOperation.responseString);
        NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&err];
        if (!err) {
            if ([[responseObject objectForKey:@"retcode"] integerValue] == 1) {
                //[self insertOneFeedList:[JYEncrypt md5:bodyStr] jsonString:requestOperation.responseString];
                [self handleReturnData:responseObject postUrl:bodyStr isUp:isUp isInsertDB:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
            }
        }else{
            NSLog(@"返回数据解析错误，可能不是json字符串");
        }
        
        
    }else{
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"snsfeed" forKey:@"mod"];
        [parametersDict setObject:@"get_recommend_dynamic_list" forKey:@"func"];
        
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:d_id forKey:@"dy_id"];
        [postDict setObject:@"10" forKey:@"num"];
        [postDict setObject:isSingle forKey:@"is_single"];
        
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            
            if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                [self handleReturnData:responseObject postUrl:bodyStr isUp:isUp isInsertDB:YES];
                NSArray *Arr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
                NSLog(@"----->%lu",(unsigned long)Arr.count);
                [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
            } else {
                [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            }
            
        } failure:^(id error) {
            
            NSLog(@"%@", error);
            
        }];
    }
}



//处理返回的数据
- (void) handleReturnData:(NSDictionary *)responseObject postUrl:(NSString *)postUrl isUp:(int)isUp isInsertDB:(BOOL) isInsertDB{
    //异步从网络返回数据，正确数据，先存本地数据库
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&err];
    if (isInsertDB) { //需要插入本地数据库，才插入
        [self insertOneFeedList:[JYEncrypt md5:postUrl] jsonString:[[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding]];
    }
    
    NSMutableArray *resultData = [NSMutableArray array];
    NSArray *rArray = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
    for (NSDictionary * temp in rArray) {
        JYFeedModel * feedModel = [[JYFeedModel alloc] initWithDataDic:temp];
        
        BOOL isDuplicate = NO;
        for (int i = 0; i<self.feedListArr.count; i++) {
            JYFeedModel * tempScourceArr = [self.feedListArr objectAtIndex:i];
            if ( [tempScourceArr.feedid integerValue] == [feedModel.feedid integerValue]) {
                isDuplicate = YES;
                feedModel.contentIsExpand = tempScourceArr.contentIsExpand;
                feedModel.praiseIsExpand = tempScourceArr.praiseIsExpand;
                feedModel.rebroadcastIsExpand = tempScourceArr.rebroadcastIsExpand;
                //tempScourceArr = feedModel ; //如果是重复的替换
                //[self.feedListArr  setObject:feedModel atIndexedSubscript:i];
                [self.feedListArr replaceObjectAtIndex:i withObject:feedModel];//如果是重复的替换
                break;
            }
        }
        if (!isDuplicate) { //不是重复的内容将加到数组中
            feedModel.contentIsExpand = NO;
            feedModel.praiseIsExpand = NO;
            feedModel.rebroadcastIsExpand = NO;
            [resultData addObject:feedModel];
        }else{
            
        }
    }
    
    
    if (resultData.count > 0) { //只有结果数据大于0，才进行操作
        if(self.feedListArr.count == 0){
            self.feedListArr = resultData;
            
        }else{
            if(isUp == 0){
                self.feedListArr = resultData;
                JYFeedModel * tempScourceArr = [self.feedListArr objectAtIndex:0];
                NSLog(@"%@",tempScourceArr.uid);
            }else{
                [self.feedListArr addObjectsFromArray:resultData];
            }
        }
    }
}
//新返回的数据，需要去重
- (BOOL) eliminateDuplicate:(NSString *)feedid{
    BOOL isDuplicate = NO;
    for (int i = 0; i<self.feedListArr.count; i++) {
        JYFeedModel * temp = [self.feedListArr objectAtIndex:i];
        if ( [temp.feedid integerValue] == [feedid integerValue]) {
            isDuplicate = YES;
            break;
        }
    }
    return isDuplicate;
}

//发送评论数据
- (void) sendCommendDataToHttp:(NSString *) sendOid sendFeedId:(NSString *) sendFeedId content:(NSString *)content{
    
    if (sendFeedId == nil || sendOid == nil || content == nil) {
        return;
    }
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"comment" forKey:@"mod"];
    [parametersDict setObject:@"send_comment" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:sendOid forKey:@"oid"];
    [postDict setObject:sendFeedId forKey:@"dy_id"];
    [postDict setObject:content forKey:@"content"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        //[self.feedTableView doneLoadingTableViewData]; //数据返回，则收起加载
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //拼接数据，存入数据
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            
            NSDictionary * myProfile = [JYShareData sharedInstance].myself_profile_dict;
            NSDictionary * temp = [[NSDictionary alloc] initWithObjectsAndKeys:[myProfile objectForKey:@"avatars"],@"avatar", [myProfile objectForKey:@"nick"],@"nick",[myProfile objectForKey:@"sex"],@"sex",[myProfile objectForKey:@"uid"],@"uid",content,@"content",@"",@"reply",timeSp,@"time",[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]],@"id",nil];
            NSMutableArray *commentTemp = [NSMutableArray array];
            
            
            for (int i = 0; i<self.feedListArr.count; i++) {
                JYFeedModel *tempModel = [self.feedListArr objectAtIndex:i];
                if ([tempModel.feedid isEqualToString:sendFeedId]) {
                    [commentTemp addObjectsFromArray:tempModel.comment_list];
                    [commentTemp addObject:temp];
                    tempModel.comment_list = commentTemp;
                    tempModel.comment_num  = [NSString stringWithFormat:@"%ld",[tempModel.comment_num integerValue]+1];
                    break;
                }
            }
            commentTemp = [NSMutableArray array];
            //我的动态数据更新 和 别人的动态都用myDynamicArr 
            for (int i = 0; i<self.myDynamicArr.count; i++) {
                JYFeedModel *tempModel = [self.myDynamicArr objectAtIndex:i];
                if ([tempModel.feedid isEqualToString:sendFeedId]) {
                    NSLog(@"--->%lu",(unsigned long)tempModel.comment_list.count);
                    [commentTemp addObjectsFromArray:tempModel.comment_list];
                    [commentTemp addObject:temp];
                    tempModel.comment_list = commentTemp;
                    tempModel.comment_num  = [NSString stringWithFormat:@"%ld",[tempModel.comment_num integerValue]+1];
                    NSLog(@"--->%lu",(unsigned long)tempModel.comment_list.count);
                    break;
                }
            }
            
            //[self.feedTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }
        
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        NSLog(@"%@", error);
        
    }];
}

//发送回复评论数据
- (void) sendReplyCommendDataToHttp:(NSString *) dy_uid reply_nick:(NSString *)relpy_nick reply_uid:(NSString *) reply_uid dy_id:(NSString *) dy_id comment_id:(NSString *) comment_id comment_uid:(NSString *) comment_uid content:(NSString *)content{
    
    if (dy_uid == nil || reply_uid == nil || dy_id == nil || comment_id == nil || comment_uid == nil ||content == nil) {
        return;
    }
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"comment" forKey:@"mod"];
    [parametersDict setObject:@"reply_comment" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:dy_uid forKey:@"dy_uid"];
    [postDict setObject:reply_uid forKey:@"reply_uid"];
    [postDict setObject:dy_id forKey:@"dy_id"];
    [postDict setObject:comment_id forKey:@"comment_id"];
    [postDict setObject:comment_uid forKey:@"comment_uid"];
    [postDict setObject:content forKey:@"content"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        //[self.feedTableView doneLoadingTableViewData]; //数据返回，则收起加载
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //拼接数据，存入数据
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            
            //            reply =                         {
            //                avatar =                             {
            //                    100 = "http://p.friendly.dev/13/42/9e35e159280e84f65b7f4289a172087f/146350100a.jpg?wh=100x100";
            //                    150 = "http://p.friendly.dev/13/42/9e35e159280e84f65b7f4289a172087f/146350150a.jpg?wh=150x150";
            //                    200 = "http://p.friendly.dev/13/42/9e35e159280e84f65b7f4289a172087f/146350200a.jpg?wh=200x200";
            //                    50 = "http://p.friendly.dev/13/42/9e35e159280e84f65b7f4289a172087f/14635050a.jpg?wh=50x50";
            //                    600 = "http://p.friendly.dev/13/42/9e35e159280e84f65b7f4289a172087f/146350600a.jpg?wh=600x600";
            //                    pid = 146350;
            //                };
            //                id = 69550;
            //                nick = "\U51ef\U54e5\U554a";
            //                sex = 1;
            //                time = 1431411878;
            //                uid = 2134250;
            //            };
            
            for (int i = 0; i<self.feedListArr.count; i++) { //查找对应的动态id
                JYFeedModel *tempModel = [self.feedListArr objectAtIndex:i];
                if (tempModel && [tempModel isKindOfClass:[JYFeedModel class]]) {
                    if ([tempModel.feedid isEqualToString:dy_id]) {
                        //                        NSDictionary *tempComment = [tempModel.comment_list objectAtIndex:i];
                        NSDictionary * myProfile = [JYShareData sharedInstance].myself_profile_dict;
                        NSDictionary *replayData = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]],@"id",[myProfile objectForKey:@"avatars"],@"avatar",relpy_nick,@"nick",[myProfile objectForKey:@"sex"],@"sex",[myProfile objectForKey:@"uid"],@"uid",timeSp,@"time", nil];
                        NSDictionary * temp = [[NSDictionary alloc] initWithObjectsAndKeys:[myProfile objectForKey:@"avatars"],@"avatar", [myProfile objectForKey:@"nick"],@"nick",@"1",@"sex",comment_uid,@"uid",content,@"content",replayData,@"reply",timeSp,@"time",comment_id,@"id",nil];
                        NSMutableArray *commentTemp = [NSMutableArray array];
                        
                        [commentTemp addObjectsFromArray:tempModel.comment_list];
                        [commentTemp addObject:temp];
                        tempModel.comment_list = commentTemp;
                        tempModel.comment_num  = [NSString stringWithFormat:@"%ld",[tempModel.comment_num integerValue]+1];
                        break;
                    }
                }
            }
            
            //我的数据更新
            for (int i = 0; i<self.myDynamicArr.count; i++) { //查找对应的动态id
                JYFeedModel *tempModel = [self.myDynamicArr objectAtIndex:i];
                if (tempModel && [tempModel isKindOfClass:[JYFeedModel class]]) {
                    if ([tempModel.feedid isEqualToString:dy_id]) {
                        //                        NSDictionary *tempComment = [tempModel.comment_list objectAtIndex:i];
                        NSDictionary * myProfile = [JYShareData sharedInstance].myself_profile_dict;
                        NSDictionary *replayData = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]],@"id",[myProfile objectForKey:@"avatars"],@"avatar",relpy_nick,@"nick",[myProfile objectForKey:@"sex"],@"sex",[myProfile objectForKey:@"uid"],@"uid",timeSp,@"time", nil];
                        NSDictionary * temp = [[NSDictionary alloc] initWithObjectsAndKeys:[myProfile objectForKey:@"avatars"],@"avatar", [myProfile objectForKey:@"nick"],@"nick",@"1",@"sex",comment_uid,@"uid",content,@"content",replayData,@"reply",timeSp,@"time",comment_id,@"id",nil];
                        NSMutableArray *commentTemp = [NSMutableArray array];
                        
                        [commentTemp addObjectsFromArray:tempModel.comment_list];
                        [commentTemp addObject:temp];
                        tempModel.comment_list = commentTemp;
                        tempModel.comment_num  = [NSString stringWithFormat:@"%ld",[tempModel.comment_num integerValue]+1];
                        break;
                    }
                }
            }
            
            
           
            //[self.feedTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }
        
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        NSLog(@"%@", error);
        
    }];
}
//取消赞
-(BOOL) sendCancelPariseDataToHttp:(NSString *)uid feedid:(NSString *)feedid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?mod=snsfeed&func=del_praise", HTTP_PREFIX];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"oid=%@&dy_id=%@",uid,feedid];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSLog(@"%@",requestOperation.responseString);
    NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *responseObject = nil;
    if (jsonData && jsonData.length>0) {
        responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    }
    
    if (!err &&  responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
        if ([[responseObject objectForKey:@"retcode"] integerValue] == 1) {
            //拼接数据，存入数据
            NSDictionary * myProfile = [JYShareData sharedInstance].myself_profile_dict;
            NSMutableArray *pariseTemp = [NSMutableArray array];
            
            for (int i = 0; i<self.feedListArr.count; i++) {
                JYFeedModel *tempModel = [self.feedListArr objectAtIndex:i];
                if ([tempModel.feedid isEqualToString:feedid]) {
                    [pariseTemp addObjectsFromArray:tempModel.praise_list];
                    for (int j = 0; j<pariseTemp.count; j++) {
                        if ([pariseTemp[j][@"uid"] isEqualToString:[myProfile objectForKey:@"uid"]]) {
                            [pariseTemp removeObjectAtIndex:j];
                        }
                        break;
                    }
                    tempModel.praise_list = pariseTemp;
                    tempModel.is_praise = @"0";
                    tempModel.praise_num  = [NSString stringWithFormat:@"%ld",[tempModel.praise_num integerValue]-1];
                    break;
                }
            }
            pariseTemp = [NSMutableArray array];
            for (int i = 0; i<self.myDynamicArr.count; i++) {
                JYFeedModel *tempModel = [self.myDynamicArr objectAtIndex:i];
                if ([tempModel.feedid isEqualToString:feedid]) {
                    [pariseTemp addObjectsFromArray:tempModel.praise_list];
                    for (int j = 0; j<pariseTemp.count; j++) {
                        if ([pariseTemp[j][@"uid"] isEqualToString:[myProfile objectForKey:@"uid"]]) {
                            [pariseTemp removeObjectAtIndex:j];
                        }
                        break;
                    }
                    tempModel.praise_list = pariseTemp;
                    tempModel.is_praise = @"0";
                    tempModel.praise_num  = [NSString stringWithFormat:@"%ld",[tempModel.praise_num integerValue]-1];
                    break;
                }
            }
            
            return  YES;
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            return NO;
        }
    }else{
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        return NO;
        NSLog(@"返回数据解析错误，可能不是json字符串");
    }
    
}
//发送赞数据
-(BOOL) sendPariseDataToHttp:(NSString *)uid feedid:(NSString *)feedid{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?mod=snsfeed&func=send_praise", HTTP_PREFIX];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"oid=%@&dy_id=%@",uid,feedid];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSLog(@"%@",requestOperation.responseString);
    NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *responseObject = nil;
    if (jsonData && jsonData.length>0) {
        responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    }
    
    if (!err && responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
        if ([[responseObject objectForKey:@"retcode"] integerValue] == 1) {
            //拼接数据，存入数据
            NSDictionary * myProfile = [JYShareData sharedInstance].myself_profile_dict;
            NSDictionary * temp = [[NSDictionary alloc] initWithObjectsAndKeys:[myProfile objectForKey:@"avatars"],@"avatar", [myProfile objectForKey:@"nick"],@"nick",[myProfile objectForKey:@"sex"],@"sex",[myProfile objectForKey:@"uid"],@"uid",nil];
            NSMutableArray *pariseTemp = [NSMutableArray array];
            
            for (int i = 0; i<self.feedListArr.count; i++) {
                JYFeedModel *tempModel = [self.feedListArr objectAtIndex:i];
                if ([tempModel.feedid isEqualToString:feedid]) {
                    [pariseTemp addObjectsFromArray:tempModel.praise_list];
                    [pariseTemp insertObject:temp atIndex:0];
                    tempModel.praise_list = pariseTemp;
                    tempModel.is_praise = @"1";
                    tempModel.praise_num  = [NSString stringWithFormat:@"%ld",[tempModel.praise_num integerValue]+1];
                    break;
                }
            }
            
            pariseTemp = [NSMutableArray array];
            for (int i = 0; i<self.myDynamicArr.count; i++) {
                JYFeedModel *tempModel = [self.myDynamicArr objectAtIndex:i];
                if ([tempModel.feedid isEqualToString:feedid]) {
                    [pariseTemp addObjectsFromArray:tempModel.praise_list];
                    [pariseTemp insertObject:temp atIndex:0];
                    tempModel.praise_list = pariseTemp;
                    tempModel.is_praise = @"1";
                    tempModel.praise_num  = [NSString stringWithFormat:@"%ld",[tempModel.praise_num integerValue]+1];
                    break;
                }
            }
            
            return  YES;
        }
        else if ([[responseObject objectForKey:@"retcode"] integerValue] == -8){
            [[JYAppDelegate sharedAppDelegate] showTip:@"你在对方黑名单中！"];
            return NO;
        }
        else{
            NSLog(@"返回数据解析错误，可能不是json字符串");
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            return NO;
        }
    }else{
        NSLog(@"返回数据解析错误，可能不是json字符串");
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        return NO;
    }
}

//转播数据提交到服务器
-(BOOL) sendRebroadcastDataToHttp:(NSString *)uid feedid:(NSString *)feedid{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?mod=snsfeed&func=rebroadcast_dynamic", HTTP_PREFIX];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"oid=%@&dy_id=%@",uid,feedid];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSLog(@"%@",requestOperation.responseString);
    NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *responseObject = nil;
    if (jsonData && jsonData.length>0) {
        responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    }
    if (!err && responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
        if ([[responseObject objectForKey:@"retcode"] integerValue] == 1) {
            //拼接数据，存入数据
            NSDictionary * myProfile = [JYShareData sharedInstance].myself_profile_dict;
            NSDictionary * temp = [[NSDictionary alloc] initWithObjectsAndKeys:[myProfile objectForKey:@"avatars"],@"avatar", [myProfile objectForKey:@"nick"],@"nick",[myProfile objectForKey:@"sex"],@"sex",[myProfile objectForKey:@"uid"],@"uid",nil];
            NSMutableArray *rebroadcastTemp = [NSMutableArray array];
            
            
            //我的和他人的都要更新数据
            for (int i = 0; i<self.feedListArr.count; i++) {
                JYFeedModel *tempModel = [self.feedListArr objectAtIndex:i];
                //把转发人”我“加到原来 model里
                if (tempModel && [tempModel isKindOfClass:[JYFeedModel class]]) {
                    if ([tempModel.feedid isEqualToString:feedid]) {
                        [rebroadcastTemp addObjectsFromArray:tempModel.rebroadcast_list];
                        [rebroadcastTemp insertObject:temp atIndex:0];
                        tempModel.rebroadcast_list = rebroadcastTemp;
                        tempModel.is_rebroadcast = @"1";
                        tempModel.rebroadcast_num  = [NSString stringWithFormat:@"%ld",[tempModel.rebroadcast_num integerValue]+1];
                        break;
                    }
                }
            }
            //
            rebroadcastTemp = [NSMutableArray array];
            for (int i = 0; i<self.myDynamicArr.count; i++) {
                JYFeedModel *tempModel = [self.myDynamicArr objectAtIndex:i];
                if (tempModel && [tempModel isKindOfClass:[JYFeedModel class]]) {
                    if ([tempModel.feedid isEqualToString:feedid]) {
                        [rebroadcastTemp addObjectsFromArray:tempModel.rebroadcast_list];
                        [rebroadcastTemp insertObject:temp atIndex:0];
                        tempModel.rebroadcast_list = rebroadcastTemp;
                        tempModel.is_rebroadcast = @"1";
                        tempModel.rebroadcast_num  = [NSString stringWithFormat:@"%ld",[tempModel.rebroadcast_num integerValue]+1];
                        break;
                    }
                }
            }
            
            return  YES;
        }
        else if ([[responseObject objectForKey:@"retcode"] integerValue] == -8){
            [[JYAppDelegate sharedAppDelegate] showTip:@"你在对方黑名单中！"];
            return NO;
        }
        else{
            NSLog(@"---->%@",[responseObject objectForKey:@"retmean"]);
            return NO;
        }
    }else{
        NSLog(@"返回数据解析错误，可能不是json字符串");
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        return NO;
    }
}

- (BOOL) deleteOneFeed:(NSString *)feedid{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?mod=snsfeed&func=del_dynamic", HTTP_PREFIX];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"dy_id=%@",feedid];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSLog(@"%@",requestOperation.responseString);
    if (!requestOperation.responseString) {
        return NO;
    }
    NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&err];
    
    if ([[responseObject objectForKey:@"retcode"] integerValue] == 1) {
        for (int i = 0; i<self.feedListArr.count; i++) {
            JYFeedModel *tempModel = [self.feedListArr objectAtIndex:i];
            if ([tempModel.feedid isEqualToString:feedid]) {
                [self.feedListArr removeObjectAtIndex:i];
                break;
            }
        }
        
        for (int i = 0; i<self.myDynamicArr.count; i++) {
            JYFeedModel *tempModel = [self.myDynamicArr objectAtIndex:i];
            if ([tempModel.feedid isEqualToString:feedid]) {
                [self.myDynamicArr removeObjectAtIndex:i];
                break;
            }
        }
        
        [self deleteDBFeedAllRecodes]; //清空本地数据列表
        return  YES;
    }else{
        return NO;
    }
    
   
    
}

//本地数据部份
- (BOOL)openDB
{
    
    //    if([JYHelpers isEmptyOfString:ToString(p_uid)]){
    //        return FALSE;
    //    }
    
    NSString *sqlDBPath = MyFilePath(@"jy_feedData.sqlite");
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    db = [FMDatabase databaseWithPath:sqlDBPath] ;
    NSLog(@"%@",sqlDBPath);
    if (![db open]) {
        NSAssert(0, @"Could not open db.");
        return FALSE;
    }
    
    //检查表是否存在
    if (![db tableExists:@"feedList"])
    {
        [self deleteTable:@"feedList"];
        
        [db executeUpdate:@SQL_JY_PROFILE];
        
    }
    
    return TRUE;
}



-(void)closeDB{
    if (!db) {
        return ;
    }
    
    [db close];
    db = nil;
}

- (BOOL)isOpened{
    if (db) {
        return YES;
    }
    return NO;
}

-(void)dealloc{
    
    [self closeDB];
}

// 删除表
- (BOOL)deleteTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![db executeUpdate:sqlstr])
    {
        NSLog(@"Delete table error!");
        return NO;
    }
    
    return YES;
}

- (NSString *) getDatabaseFeedList:(NSString *)url{
    NSString *result;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM feedList WHERE uid = '%@' and postUrl = '%@'", uid,url];
    //NSLog(@"%@",sql);
    FMResultSet *rs = [db executeQuery:sql];
    while([rs next]){
        result = [rs stringForColumnIndex:2];
    }
    [rs close];
    return result;
}

- (BOOL) insertOneFeedList:(NSString *) postUrl jsonString:(NSString *)jsonString{
    
    BOOL success;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString * userInfo = [self getDatabaseFeedList:postUrl];
    if(userInfo.length > 0){
        success = [db executeUpdate:@"UPDATE  feedList SET content = ? where postUrl = ? and uid = ? ",jsonString,postUrl,uid];
    }else{
        success = [db executeUpdate:@"INSERT INTO feedList (uid,postUrl,content) VALUES (?,?,?)",uid,postUrl,jsonString];
    }
   
    return success;
}

- (void) deleteDBFeedAllRecodes{
     [db executeUpdate:@"DELETE FROM feedList"];
 
}

//- (BOOL) insertUserTagList:(NSString *) uid jsonString:(NSString *)jsonString{
//    
//    BOOL success;
//    NSString * userInfo = [self getOneUser:uid];
//    if(userInfo.length > 0){
//        success = [db executeUpdate:@"UPDATE  profile SET taglist = ? where uid = ?",jsonString,uid];
//    }else{
//        success = [db executeUpdate:@"INSERT INTO profile(uid,taglist) VALUES (?,?)",uid,jsonString];
//    }
//    
//    
//    return success;
//}

@end
