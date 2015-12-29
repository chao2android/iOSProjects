//
//  TJUserManager.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/8.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJUserManager.h"

@implementation TJUserManager

+ (instancetype)sharePageManager
{
    static dispatch_once_t onceToken;
    static TJUserManager *manager;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] initUserManager];
        
    });
    return manager;
}
- (instancetype)init {
    NSAssert(NO, @"Singleton class, use shared method");
    return nil;
}

- (instancetype)initUserManager {
    self = [super init];
    if (!self) return nil;
    
    if ([SHARE_DEFAULTS objectForKey:UserLginInfo]) {
        NSDictionary *userInforDic=[SHARE_DEFAULTS objectForKey:UserLginInfo];
        TJUserModel *userModel=[[TJUserModel alloc]init];
        userModel.userId = [userInforDic objectForKey:@"uid"];
        userModel.userName = [userInforDic objectForKey:@"username"];
        userModel.nickName = [userInforDic objectForKey:@"nickname"];
        userModel.icon = [userInforDic objectForKey:@"icon"];
        userModel.signature = [userInforDic objectForKey:@"signature"];
        userModel.birthday = [userInforDic objectForKey:@"birthday"];
        userModel.identity = [userInforDic objectForKey:@"identity"];
        userModel.city = [userInforDic objectForKey:@"city"];
        userModel.street = [userInforDic objectForKey:@"street"];
        userModel.community = [userInforDic objectForKey:@"community"];
        userModel.weibo = [userInforDic objectForKey:@"weiboicon"];
        userModel.token = [userInforDic objectForKey:@"token"];
        self.userInfor=userModel;
    }
    return self;
}

- (void)saveUserInfor:(NSDictionary *)userInfor withPhone:(NSString *)telephone
{
    if (!self.userInfor) {
        _userInfor = [[TJUserModel alloc] init];
    }
    TJUserModel *userModel=self.userInfor;
    userModel.userId = [userInfor objectForKey:@"uid"];
    userModel.userName = [userInfor objectForKey:@"username"];
    userModel.nickName = [userInfor objectForKey:@"nickname"];
    userModel.icon = [userInfor objectForKey:@"icon"];
    userModel.signature = [userInfor objectForKey:@"signature"];
    userModel.birthday = [userInfor objectForKey:@"birthday"];
    userModel.identity = [userInfor objectForKey:@"identity"];
    userModel.city = [userInfor objectForKey:@"city"];
    userModel.street = [userInfor objectForKey:@"street"];
    userModel.community = [userInfor objectForKey:@"community"];
    userModel.weibo = [userInfor objectForKey:@"weiboicon"];
    userModel.token = [userInfor objectForKey:@"token"];

    self.userInfor=userModel;
}

- (void)setUserInfor:(TJUserModel *)userInfor
{
    _userInfor = userInfor;
    if (!userInfor) {
        [SHARE_DEFAULTS setObject:nil forKey:UserLginInfo];

    }
    else{
        NSMutableDictionary *userInforDic=[[NSMutableDictionary alloc]init];
        [userInforDic setValue:userInfor.userName forKey:@"username"];
        [userInforDic setValue:userInfor.nickName forKey:@"nickname"];
        [userInforDic setValue:userInfor.icon forKey:@"icon"];
        [userInforDic setValue:userInfor.signature forKey:@"signature"];
        [userInforDic setValue:userInfor.birthday forKey:@"birthday"];
        [userInforDic setValue:userInfor.identity forKey:@"identity"];
        [userInforDic setValue:userInfor.city forKey:@"city"];
        [userInforDic setValue:userInfor.street forKey:@"street"];
        [userInforDic setValue:userInfor.community forKey:@"community"];
        [userInforDic setValue:userInfor.weibo forKey:@"weibo"];
        [userInforDic setValue:userInfor.token forKey:@"token"];
        [userInforDic setValue:userInfor.userId forKey:@"uid"];
        [SHARE_DEFAULTS setObject:userInforDic forKey:UserLginInfo];
        [SHARE_DEFAULTS setObject:userInfor.userId forKey:UserId];
        [SHARE_DEFAULTS synchronize];
    }
}
- (void)quitUserSuccess:(QuitFinish) quitBlock;{
    self.quitBlock = quitBlock;
    [SHARE_DEFAULTS setObject:nil forKey:UserLginInfo];
    [SHARE_DEFAULTS setObject:nil forKey:UserId];
    [SHARE_DEFAULTS synchronize];
    self.userInfor = nil;
    if (self.quitBlock) {
        self.quitBlock();
        self.quitBlock = nil;
    }
    
}

@end
