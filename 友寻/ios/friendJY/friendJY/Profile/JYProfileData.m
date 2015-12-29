//
//  JYShareData.m
//  friendJY
//
//  Created by 高斌 on 15/3/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileData.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYShareData.h"
#import "JYProfileTagModel.h"

#define  SQL_JY_PROFILE "create table profile(uid varchar(20) PRIMARY KEY,content text,taglist text, grouplist text)"
#define  SQL_JY_PHOTOS "create table photos(pid integer PRIMARY KEY,uid varchar(20),path text)"
@implementation JYProfileData



static JYProfileData *_instance;
+ (JYProfileData *)sharedInstance;
{
    @synchronized(self) {
        
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
            if (![_instance isOpened]) {
                [_instance openDB];
            }
        }
    }
    return _instance;
}



- (NSDictionary *) getProfileData:(NSString *)target_uid{
    _profile_dict = [NSMutableDictionary dictionary];
    BOOL is_sync = FALSE;
    if ([target_uid longLongValue] <= 0) {
        return nil;
    }
    p_uid = target_uid;
    NSString * my_profile_str = [self getOneUser:p_uid];
    if (my_profile_str.length<1) {
        is_sync = TRUE;
    }else{
        NSData *jsonData = [my_profile_str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary * dic =  [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&err];
        _profile_dict = [dic objectForKey:@"data"];
    }
    [self _fromHttpGetData:is_sync];
    
    //从网络请求照片列表
    //[self _fromHttpGetPhotoList:true pid:@"0"  num:@"4"];
    
    return _profile_dict;
}

- (void) _fromHttpGetData:(BOOL) is_sync{
    if (is_sync) { //网络请求，是否需要同步还是异步
        NSString *urlStr = [NSString stringWithFormat:@"%@?mod=profile&func=get_user_info", HTTP_PREFIX];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
        urlrequest.HTTPMethod = @"POST";
        NSString *bodyStr = [NSString stringWithFormat:@"uid=%@",p_uid];
        NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        urlrequest.HTTPBody = body;
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [requestOperation start];
        [requestOperation waitUntilFinished];
        NSLog(@"%@",requestOperation.responseString);
        
        if ([JYHelpers isEmptyOfString:requestOperation.responseString]) {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            return;
        }
        NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if (!err) {
            if ([[responseObject objectForKey:@"retcode"] integerValue] == 1) {
                [self insertOneUser:p_uid jsonString:requestOperation.responseString];
                _profile_dict = [responseObject objectForKey:@"data"];
                NSString *p_uidStr = [NSString stringWithFormat:@"%@",p_uid];
                if ([p_uidStr isEqualToString:ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])]) {
                   
                    [[JYShareData sharedInstance] setMyself_profile_dict:_profile_dict];
                }
            }
        }else{
            NSLog(@"返回数据解析错误，可能不是json字符串");
        }
        

    }else{
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"profile" forKey:@"mod"];
        [parametersDict setObject:@"get_user_info" forKey:@"func"];
        
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:p_uid forKey:@"uid"];
        //    [postDict setObject:_passwordTextField.text forKey:@"password"];
        
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            
            if (iRetcode == 1) {
               // NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&err];
                [self insertOneUser:p_uid jsonString:[[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding] ];
                _profile_dict = [responseObject objectForKey:@"data"];
                if ([p_uid isEqualToString:ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])]) {
                    
                    [[JYShareData sharedInstance] setMyself_profile_dict:_profile_dict];
                }
            } else {
                [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            }
            
        } failure:^(id error) {
            
            NSLog(@"%@", error);
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }];
    }
}

//从取照片列表
- (NSDictionary *) getPhotoList:(NSString*)pid num:(NSString *)num{
    _photosList = [NSDictionary dictionary];
    
    [self _fromHttpGetPhotoList:true pid:0 num:0];
    
    return _photosList;
}

//从本地取照片列表
- (void) _fromLocalDBGetPhotoList:(NSString*)pid num:(NSString *)num{
    
}

//从网络取照片列表
- (void) _fromHttpGetPhotoList:(BOOL) is_sync pid:(NSString*)pid num:(NSString *)num{
    if (is_sync) {
        NSString *urlStr = [NSString stringWithFormat:@"%@?mod=photo&func=get_photo_list", HTTP_PREFIX];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
        urlrequest.HTTPMethod = @"POST";
        NSString *bodyStr = [NSString stringWithFormat:@"uid=%@&pid=%@&num=%@",p_uid,pid,num];
        NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        urlrequest.HTTPBody = body;
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [requestOperation start];
        [requestOperation waitUntilFinished];
        NSLog(@"%@",requestOperation.responseString);
        
        if ([JYHelpers isEmptyOfString:requestOperation.responseString]) {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            return;
        }
        NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&err];
        if (!err) {
            if ([[responseObject objectForKey:@"retcode"] integerValue] == 1) {
                //[self insertOneUser:p_uid jsonString:requestOperation.responseString];
                //self.profile_dict = [responseObject objectForKey:@"data"];
                NSDictionary * result = [responseObject objectForKey:@"data"];
                //返回结整大于0，存在照片
                if (result.count > 0) {
                    _photosList = result;
                }
            }
        }else{
            NSLog(@"返回数据解析错误，可能不是json字符串");
        }
        
        
    }else{
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"photo" forKey:@"mod"];
        [parametersDict setObject:@"get_photo_list" forKey:@"func"];
        
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:p_uid forKey:@"uid"];
        [postDict setObject:pid forKey:@"pid"];
        [postDict setObject:num forKey:@"num"];
        //    [postDict setObject:_passwordTextField.text forKey:@"password"];
        
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            
            if (iRetcode == 1) {
                NSDictionary * result = [responseObject objectForKey:@"data"];
                if (result.count > 0) {
                    _photosList = result;
                }
            } else {
                [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            }
            
        } failure:^(id error) {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            NSLog(@"%@", error);
            
        }];
    }
}


- (NSMutableDictionary *) getProfileTagList:(NSString *)target_uid{
    p_uid = target_uid;
    NSMutableDictionary * myDic = [NSMutableDictionary dictionary];
    BOOL is_sync = FALSE;
    if ([target_uid longLongValue] <= 0) {
        return myDic;
    }

    NSString * my_tag_str = [self getOneUserTagList:target_uid];
    if (my_tag_str.length<1) {
        is_sync = TRUE;
    }else{
        NSData *jsonData = [my_tag_str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary * dic =  [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&err];
        NSArray * myArray = [dic objectForKey:@"data"];
        if ([myArray isKindOfClass:[NSArray class]]) {
            for(NSDictionary * temp in myArray){
                //改用model
                JYProfileTagModel *tagModel = [[JYProfileTagModel alloc] initWithDataDic:temp];
                [myDic setObject:tagModel.modelToDictionary forKey:tagModel.tid];
            }
        }else{
//            [[JYAppDelegate sharedAppDelegate] showTip:@"标签从本地数据库，取回数据不正确"];
            return myDic;
        }
    }
    
    if (is_sync) { //如果同步的话，等待结果反回，异步取数据，直接从本地数据库取
        NSArray * myArray = [self _fromHttpGetTagList:is_sync];
        if ([myArray isKindOfClass:[NSArray class]]) {
            for(NSDictionary * temp in myArray){
                [myDic setObject:temp forKey:[temp objectForKey:@"tid"]];
            }
        }else{
//            [[JYAppDelegate sharedAppDelegate] showTip:@"标签从网络，取回数据不正确"];
            return myDic;
        }
    }else{
        [self _fromHttpGetTagList:is_sync];
    }
    //从网络请求照片列表
    //[self _fromHttpGetPhotoList:true pid:@"0"  num:@"4"];
    return myDic;
}



- (NSArray *) _fromHttpGetTagList:(BOOL) is_sync{
    NSArray * resultDic = [NSArray array];
    if (is_sync) {
        NSString *urlStr = [NSString stringWithFormat:@"%@?mod=tags&func=tag_list", HTTP_PREFIX];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
        urlrequest.HTTPMethod = @"POST";
        NSString *bodyStr = [NSString stringWithFormat:@"uid=%@",p_uid];
        NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        urlrequest.HTTPBody = body;
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [requestOperation start];
        [requestOperation waitUntilFinished];
        NSLog(@"%@",requestOperation.responseString);
        
        if ([JYHelpers isEmptyOfString:requestOperation.responseString]) {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            return nil;
        }
        
        NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&err];
        if (!err) {
            if ([[responseObject objectForKey:@"retcode"] integerValue] == 1) {
                [self insertUserTagList:p_uid jsonString:requestOperation.responseString];
                resultDic = [responseObject objectForKey:@"data"];
            }
        }else{
            NSLog(@"返回数据解析错误，可能不是json字符串");
        }
        
        
    }else{
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"tags" forKey:@"mod"];
        [parametersDict setObject:@"tag_list" forKey:@"func"];
        
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:p_uid forKey:@"uid"];
        //    [postDict setObject:_passwordTextField.text forKey:@"password"];
        
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            
            if (iRetcode == 1) {
                // 更新本地数据库
                NSError *err;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&err];
                [self insertUserTagList:p_uid jsonString:[[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding] ];
                
            } else {
                [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            }
            
        } failure:^(id error) {
            
            NSLog(@"%@", error);
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }];
    }
    return  resultDic;
}



/***************Profile做本地数据缓存DB操作****************/
- (BOOL)openDB
{
    
//    if([JYHelpers isEmptyOfString:ToString(p_uid)]){
//        return FALSE;
//    }
    NSString *fileName = [NSString stringWithFormat:@"%@_jy_profile.sqlite",[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
                          
    NSString *sqlDBPath = MyFilePath(fileName);
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    db = [FMDatabase databaseWithPath:sqlDBPath] ;
    NSLog(@"%@",sqlDBPath);
    if (![db open]) {
        NSAssert(0, @"Could not open db.");
        return FALSE;
    }
    
    //检查表是否存在
    if (![db tableExists:@"profile"])
    {
//        //先删除表再创建表
//        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", @"jy_profile"];
//        if (![db executeUpdate:sqlstr])
//        {
//            NSLog(@"Delete table error!");
//            return FALSE;
//        }

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

- (BOOL)updateTagListWithNewTagList:(NSArray *)tagList uid:(NSString *)uid{
    BOOL success;
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [resultDic setObject:@"1" forKey:@"retcode"];
    [resultDic setObject:@"CMI_AJAX_RET_CODE_SUCC" forKey:@"retmean"];
    [resultDic setObject:tagList forKey:@"data"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!error) {
        
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        success = [self insertUserTagList:uid jsonString:jsonStr];
        
    }else{
        success = NO;
        NSLog(@"数据写入失败");
    }
    return success;

}
- (BOOL)updateMyProfileWithNewProfileDic:(NSDictionary *)newProfileDic{
    BOOL success;
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [resultDic setObject:@"1" forKey:@"retcode"];
    [resultDic setObject:@"CMI_AJAX_RET_CODE_SUCC" forKey:@"retmean"];
    [resultDic setObject:newProfileDic forKey:@"data"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!error) {
        
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
      success = [self insertOneUser:ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]) jsonString:jsonStr];
        
    }else{
        success = NO;
        NSLog(@"数据写入失败");
    }
    return success;
}

- (BOOL) insertOneUser:(NSString *) uid jsonString:(NSString *)jsonString{
    
    BOOL success;
    NSString * userInfo = [self getOneUser:uid];
    if(userInfo.length > 0){
        success = [db executeUpdate:@"UPDATE  profile SET content = ? where uid = ?",jsonString,uid];
    }else{
        success = [db executeUpdate:@"INSERT INTO profile(uid,content) VALUES (?,?)",uid,jsonString];
    }
    
    return success;
}

- (BOOL) insertUserTagList:(NSString *) uid jsonString:(NSString *)jsonString{
    
    BOOL success;
    NSString * userInfo = [self getOneUser:uid];
    if(userInfo.length > 0){
        success = [db executeUpdate:@"UPDATE  profile SET taglist = ? where uid = ?",jsonString,uid];
    }else{
        success = [db executeUpdate:@"INSERT INTO profile(uid,taglist) VALUES (?,?)",uid,jsonString];
    }
    
    
    return success;
}

//- (BOOL) insertNickMark:(NSString *) uid nickMark:(NSString *)nickMark{
//    
//    BOOL success;
//    NSString * userInfo = [self getOneUser:uid];
//    if(userInfo.length > 0){
//        success = [db executeUpdate:@"UPDATE  profile SET content = ? where uid = ?",jsonString,uid];
//    }else{
//        success = [db executeUpdate:@"INSERT INTO profile(uid,content) VALUES (?,?)",uid,jsonString];
//    }
//    
//    return success;
//}

//获取一个用户
- (NSString *) getOneUser:(NSString *) uid{
    
    NSString *result;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM profile WHERE uid = '%@'", uid];
    FMResultSet *rs = [db executeQuery:sql];
    while([rs next]){
        result = [rs stringForColumnIndex:1];
    }
    [rs close];
    return result;
}

//获取标签列表
- (NSString *) getOneUserTagList:(NSString *) uid{
    
    NSString *result;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM profile WHERE uid = '%@'", uid];
    FMResultSet *rs = [db executeQuery:sql];
    while([rs next]){
        result = [rs stringForColumnIndex:2];
    }
    [rs close];
    return result;
}

- (void)cleanData{
    [self closeDB];
    _instance = nil;
}

- (void)loadMyProfileDataWithSuccessBlcok:(SuccessRequestBlock)successBlock failureBlock:(FailureRequestBlock)failureBlock{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"profile" forKey:@"mod"];
    [parametersDict setObject:@"get_user_info" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:ToString([SharedDefault objectForKey:@"uid"]) forKey:@"uid"];
    //    [postDict setObject:_passwordTextField.text forKey:@"password"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            // NSData *jsonData = [requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&err];
            [self insertOneUser:p_uid jsonString:[[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding] ];
            _profile_dict = [responseObject objectForKey:@"data"];
            if ([p_uid isEqualToString:ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])]) {
                
                [[JYShareData sharedInstance] setMyself_profile_dict:_profile_dict];
                [self performSelectorInBackground:@selector(writeProfileInfoToLocal) withObject:nil];
            }
            if (successBlock) {
                successBlock(responseObject);
            }
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }
        
    } failure:^(id error) {
        if (failureBlock) {
            failureBlock(error);
        }
        NSLog(@"%@", error);
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}

- (void)writeProfileInfoToLocal{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_profile_dict options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"用户信息编码失败");
    }else{
        [jsonData writeToFile:kMyProfileInfoPath atomically:YES];
    }
}
@end
