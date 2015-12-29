//
//  UserInfoManager.m
//  好妈妈
//
//  Created by Hepburn Alex on 14-6-25.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "UserInfoManager.h"

static UserInfoManager *gUserInfo = nil;

@implementation UserInfoManager

+ (UserInfoManager *)Share {
    if (!gUserInfo) {
        gUserInfo = [[UserInfoManager alloc] init];
    }
    return gUserInfo;
}

- (void)setMMsgID:(NSString *)value{
    if (value && value.length>0) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"msgid"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"msgid"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)mMsgID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"msgid"];
}

- (void)SetUserValue:(NSString *)value forKey:(NSString *)key {
    if (!value || !key) {
        return;
    }
    NSDictionary *dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"dataDic"];
    if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dataDic2 = [NSMutableDictionary dictionaryWithDictionary:dataDic];
        NSDictionary *userinfo = [dataDic2 objectForKey:@"userinfo"];
        if ([userinfo respondsToSelector:@selector(setObject:forKey:)]) {
            NSLog(@"NSMutableDictionary SetUserValue");
        }
        else {
            NSLog(@"NSDictionary SetUserValue");
        }
        
        if (userinfo && [userinfo isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *userinfo2 = [NSMutableDictionary dictionaryWithDictionary:userinfo];
            [userinfo2 setObject:value forKey:key];
            
            [dataDic2 setObject:userinfo2 forKey:@"userinfo"];
            [[NSUserDefaults standardUserDefaults] setObject:dataDic2 forKey:@"dataDic"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else {
            NSLog(@"SetUserValue Error:userinfo");
        }
    }
    else {
        NSLog(@"SetUserValue Error:dataDic");
    }
}

- (NSString *)GetUserValueforKey:(NSString *)key {
    NSDictionary *dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"dataDic"];
    
    if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
        NSDictionary *userinfo = [dataDic objectForKey:@"userinfo"];
        if (userinfo && [userinfo isKindOfClass:[NSDictionary class]]) {
            return [userinfo objectForKey:key];
        }
    }
    return nil;
}


@end
