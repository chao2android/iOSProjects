//
//  HttpDownManager.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-4-25.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "HttpDownManager.h"
#import "Md5Manager.h"

#define DEBUG_ERROR

@implementation HttpDownManager

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)GetHttpRequest:(NSString *)cmd :(NSString *)action :(NSDictionary *)dict {
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [newDict setObject:cmd forKey:@"c"];
    [newDict setObject:action forKey:@"a"];
    for (NSString *key in dict) {
        NSString *newkey = [key lowercaseString];
        NSString *value = [dict objectForKey:key];
        if (value) {
            [newDict setObject:value forKey:newkey];
        }
    }
    NSString *md5str = [Md5Manager GetMd5String:newDict :mbGb2312];
    if (md5str) {
        NSLog(@"%@", md5str);
        [newDict setObject:md5str forKey:@"__tokenmsg"];
    }
//    NSString *sessionID = [UserInfoManager Share].mSessionID;
//    if (sessionID) {
//        [newDict setObject:sessionID forKey:@"__sid"];
//    }
//    NSString *userID = [UserInfoManager Share].mLoginID;
//    if (userID) {
//        [newDict setObject:userID forKey:@"__login_sid"];
//    }
//    [self PostHttpRequest:SERVER_URL :newDict];
    
    
#ifdef DEBUG_ERROR
    NSString *urlstr = [NSString stringWithFormat:@"%@?", @"f"];
    for (NSString *key in newDict.allKeys) {
        NSString *value = [newDict objectForKey:key];
        urlstr = [urlstr stringByAppendingFormat:@"&%@=%@", key, value];
    }
    if (mbGb2312) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:enc];
    }
    NSLog(@"PostUrl:%@", urlstr);
#endif
}

- (void)GetHttpRequest2:(NSString *)cmd :(NSString *)action :(NSDictionary *)dict {
//    NSString *path = [NSString stringWithFormat:@"%@?c=%@&a=%@", SERVER_URL, cmd, action];
//    NSString *sessionID = [UserInfoManager Share].mSessionID;
//    if (sessionID) {
//        path = [path stringByAppendingFormat:@"&%@=%@", @"__sid", sessionID];
//    }
//    NSString *userID = [UserInfoManager Share].mLoginID;
//    if (userID) {
//        path = [path stringByAppendingFormat:@"&%@=%@", @"__login_sid", userID];
//    }
//    for (NSString *key in dict.allKeys) {
//        NSString *value = [dict objectForKey:key];
//        path = [path stringByAppendingFormat:@"&%@=%@", key, value];
//    }
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [newDict setObject:cmd forKey:@"c"];
    [newDict setObject:action forKey:@"a"];
    for (NSString *key in dict) {
        NSString *newkey = [key lowercaseString];
        NSString *value = [dict objectForKey:key];
        if (value) {
            [newDict setObject:value forKey:newkey];
        }
    }
//    NSString *md5str = [Md5Manager GetMd5String:newDict :mbGb2312];
//    if (md5str) {
//        path = [path stringByAppendingFormat:@"&__tokenmsg=%@", md5str];
//    }
//    [self GetImageByStr:path];
}

@end
