//
//  JYManageFriendData.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/21.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYManageFriendData.h"
#import "JYCreatGroupFriendModel.h"
#import "JYFriendGroupModel.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"


#define kFriendDataPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_friendData",[SharedDefault objectForKey:@"uid"]]]

#define kFriendDataSecondPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_secondFriendData",[SharedDefault objectForKey:@"uid"]]]

static JYManageFriendData *sharedData = nil;

@implementation JYManageFriendData
@synthesize friendList = _friendList;
@synthesize secondFriendList = _secondFriendList;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[super allocWithZone:NULL] init];
    });
    return sharedData;
}

- (JYCreatGroupFriendModel*)aFriendWithFriendID:(NSString *)frdID{
    for (NSArray *arr in _friendList) {
        for (JYCreatGroupFriendModel *model in arr) {
            if ([model.friendUid isEqualToString:frdID]) {
                return model;
            }
        }
    }
    return nil;
}
- (JYFriendGroupModel *)aGroupArrWithGroupID:(NSString *)groupID{
    for (JYFriendGroupModel *model in _groupListArr) {
        if ([model.group_id isEqualToString:groupID]) {
            return model;
        }
    }
    return nil;
}
- (void)addAGroupIntoGroupList:(JYFriendGroupModel *)groupModel{
    if (![_groupListArr containsObject:groupModel]) {
        [_groupListArr addObject:groupModel];
    }
}
//删除一个组
- (void)removeAGroupWithGroupID:(NSString*)group_id{
    JYFriendGroupModel *model = [self aGroupArrWithGroupID:group_id];
//    [self removeAGroupInSever:group_id];
    [_groupListArr removeObject:model];
    
}
//修改组名
- (void)modifyGroupNameWithGroupID:(NSString*)group_id andGroupName:(NSString*)groupName{
    JYFriendGroupModel *model = [self aGroupArrWithGroupID:group_id];
    [model setGroup_name:groupName];
}
//减少组成员
- (void)deleteMemberInGroupWithGroupID:(NSString*)group_id{
    JYFriendGroupModel *model = [self aGroupArrWithGroupID:group_id];
    NSInteger menberCount = [model.member_nums integerValue] - 1;
    if (menberCount == 0) {
//        [self removeAGroupWithGroupID:group_id];
        [self removeAGroupInSever:group_id];
    }else{
        [model setMember_nums:[NSString stringWithFormat:@"%ld",(long)menberCount]];
    }
}
//增加组员
- (void)addMemberInGroupWithGroupID:(NSString*)group_id withMemberCount:(NSInteger)nums{
    JYFriendGroupModel *model = [self aGroupArrWithGroupID:group_id];
    NSInteger menberCount = [model.member_nums integerValue] + nums;
    [model setMember_nums:[NSString stringWithFormat:@"%ld",(long)menberCount]];
}

- (void)setFriendList:(NSMutableArray *)friendList{
    _friendList = [NSMutableArray arrayWithArray:friendList];
    _friendNums = _friendList.count;
}
- (void)setSecondFriendList:(NSMutableArray *)secondFriendList{
    _secondFriendList = [NSMutableArray arrayWithArray:secondFriendList];
    _fsFriendNums = _secondFriendList.count;
}
- (void)setMobileFriendList:(NSMutableArray *)mobileFriendList{
    if (_mobileFriendList == nil) {
        _mobileFriendList = [NSMutableArray arrayWithArray:mobileFriendList];
    }else{
        [_mobileFriendList removeAllObjects];
        _mobileFriendList = [NSMutableArray arrayWithArray:mobileFriendList];
    }
}
- (void)cleanData{
    if (_groupListArr.count > 0) {
        [_groupListArr removeAllObjects];
    }
    if (_friendList.count > 0) {
        [_friendList removeAllObjects];
    }
    if (_mobileFriendList.count > 0) {
        [_mobileFriendList removeAllObjects];
    }
    if (_secondFriendList.count > 0) {
        [_mobileFriendList removeAllObjects];
    }
    _groupListArr = nil;
    _friendList = nil;
    _mobileFriendList = nil;
    _secondFriendList = nil;
    
    _friendNums = 0;
    _fsFriendNums = 0;
}
//删除
- (void)removeAGroupInSever:(NSString*)group_id{
    //服务器删除成功 本地也需要删除
    [self removeAGroupWithGroupID:group_id];
    NSDictionary *paraDic = @{
                              @"mod":@"friends",
                              @"func":@"friends_del_group"
                              };
    NSDictionary *postDic = @{
                              @"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"group_id":group_id
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"保存成功"];
        }
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"删除失败"];
    }];

}
- (void)loadMyFriendsAllWithNums:(NSInteger)nums SuccessBlock:(void (^)(NSArray *))successBlcok failureBlock:(void (^)(NSError *))failureBlock{
    
    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_myfriends_all"
                              };
    
    NSDictionary *postDic = @{@"uid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"start":@"0",
                              @"nums":[NSString stringWithFormat:@"%ld",(long)nums]
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            NSLog(@"成功获取一度好友信息")
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                [self setFriendListAndMobileListWithDataDic:dataDic];
                //更新本地
                [self savaFriendDataToLocalFileWithDic:dataDic];

            }else if([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]){
                if (((NSArray*)[responseObject objectForKey:@"data"]).count > 0) {
                    [self setMobileFriendList:[responseObject objectForKey:@"data"]];
                }
            }
            if (_friendList.count + _mobileFriendList.count == 0) {
                if (failureBlock) {
                    failureBlock(nil);
                }
            }else if (successBlcok) {
                successBlcok(nil);
            }
        }else{
            if (failureBlock) {
                failureBlock(nil);
            }
        }
//        if (successBlock) {
//            successBlock([self formADict]);
//        }
        
    } failure:^(id error) {
        if (failureBlock) {
            failureBlock(error);
        }
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
}

- (void)setFriendListAndMobileListWithDataDic:(NSDictionary*)dataDic{
    NSMutableArray *mobileFriendArr = [NSMutableArray array];
    NSMutableArray *friendList = [NSMutableArray array];
    
    
    for (NSString *key in dataDic.allKeys) {
        if([dataDic[key] count] > 3){
            JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dataDic[key]];
            [model setAvatar:dataDic[key][@"avatars"][@"100"]];
            [model setIs_friend:@"1"];
            if (![JYHelpers isEmptyOfString:model.friendUid]) {
                [friendList addObject:model];
            }
            
        }else{
            [mobileFriendArr addObject:dataDic[key]];
        }
    }
    [self setFriendList:friendList];
    [self setMobileFriendList:mobileFriendArr];
    
}

- (NSMutableArray *)friendList{
    if (_friendList ==nil) {

        _friendList = [NSMutableArray array];

        if ([[NSFileManager defaultManager] fileExistsAtPath:kFriendDataPath]) {
            NSData *jsonData = [NSData dataWithContentsOfFile:kFriendDataPath];
            NSError *error = nil;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"读取错误");
            }
            if ([arr isKindOfClass:[NSArray class]]) {
                [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:obj];
                    [model setAvatar:obj[@"avatars"][@"100"]];
                    [model setIs_friend:@"1"];
                    if (![JYHelpers isEmptyOfString:model.friendUid]) {
                        [_friendList addObject:model];
                    }
                }];
            }
        }
        
    }
    return _friendList;
}

- (void)savaFriendDataToLocalFileWithDic:(NSDictionary*)dataDic{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic.allValues options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"转化data失败");
    }else{
    
        [jsonData writeToFile:kFriendDataPath atomically:YES];
    
    }
}

/**
 *  二度好友
 */
- (void)loadSecondFriendsWithNums:(NSInteger)nums statusDic:(NSDictionary *)statusDic SuccessBlock:(void (^)(NSMutableArray *))successBlcok failureBlock:(void (^)(NSError *))failureBlock{
    
    NSDictionary *paraDic = @{@"mod":@"friends",
                              @"func":@"friends_get_fsfriends"
                              };
    
    NSDictionary *dic = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],
                          @"is_reg":@"1",
                          @"start":@"0",
                          @"nums":@"300"
                          };
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (statusDic.count > 0) {
        [postDic addEntriesFromDictionary:statusDic];
    }
    
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            NSMutableArray *dataArr = [NSMutableArray array];
            if (dataDic.count != 0) {
                
                [dataDic.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
                    if (key.length > 7) {
                        //key 13800138012
                    }else{
                        JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:dataDic[key]];
                        [model setAvatar:dataDic[key][@"avatars"][@"100"]];
                        [model setIs_friend:@"2"];
                        [dataArr addObject:model];
                    }
                }];

//                [self setSecondFriendList:dataArr];
                if ([[statusDic objectForKey:@"condition"] isEqualToString:@""] || statusDic == nil) {
                    
                    [self setSecondFriendList:dataArr];
                    //后台存入本地
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [self saveSecondFriendDataToLocalWithDataDic:dataDic];
                    });
                
                }
//                [self handleFriendsList];
            }else{
                [_friendList removeAllObjects];
            }
            if (successBlcok) {
                successBlcok(dataArr);
            }
        }else{
            if (failureBlock) {
                failureBlock(nil);
            }
        }
    } failure:^(id error) {
        if (failureBlock) {
            failureBlock(error);
        }
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}
- (NSMutableArray *)secondFriendList{
    if (_secondFriendList ==nil) {
        
        _secondFriendList = [NSMutableArray array];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:kFriendDataSecondPath]) {
            NSData *jsonData = [NSData dataWithContentsOfFile:kFriendDataSecondPath];
            NSError *error = nil;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"读取错误");
            }
            if ([arr isKindOfClass:[NSArray class]]) {
                [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    JYCreatGroupFriendModel *model = [[JYCreatGroupFriendModel alloc] initWithDataDic:obj];
                    [model setAvatar:obj[@"avatars"][@"100"]];
                    [model setIs_friend:@"2"];
                    if (![JYHelpers isEmptyOfString:model.friendUid]) {
                        [_secondFriendList addObject:model];
                    }
                }];
            }
        }
        
    }
    return _secondFriendList;
}

- (void)saveSecondFriendDataToLocalWithDataDic:(NSDictionary*)dataDic{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic.allValues options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"转化data失败");
    }else{
        
        [jsonData writeToFile:kFriendDataSecondPath atomically:YES];
        
    }


}

@end


