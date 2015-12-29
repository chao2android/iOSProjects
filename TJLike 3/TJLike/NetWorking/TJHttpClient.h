//
//  WTVHttpClient.h
//  WiseTV
//
//  Created by Ran on 14-10-8.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetworkReachabilityStatus) {
    NetworkReachabilityStatusNotReachable = 0,
    NetworkReachabilityStatusReachableViaWiFi = 1,
    NetworkReachabilityStatusReachableViaWWAN = 2
};

typedef void (^HttpRequestFailedBlock)(NSError *error);

extern NSString * WTVStringFromNetworkReachabilityStatus(NetworkReachabilityStatus status);
extern NSString * WTVErroInfoWithCode(NSInteger code);

@interface TJHttpClient : NSObject

+ (instancetype)sharedClient;

@property (nonatomic, assign, readonly, getter = isNetworkReachable) BOOL networkReachable;
@property (nonatomic, assign, readonly) NetworkReachabilityStatus networkReachablilityStatus;
@property (nonatomic, strong) RACSignal * networkStatusSignal;

@property (nonatomic, copy) HttpRequestFailedBlock failBlock;

- (RACSignal *)getRequestWithPath:(NSString *)path;
- (RACSignal *)getRequestWithPath:(NSString *)path para:(NSDictionary *)para;
- (RACSignal *)getRequestWithPath:(NSString *)path para:(NSDictionary *)para repeatCount:(int)repeatCount;
- (RACSignal *)postRequestWithPath:(NSString *)path para:(NSDictionary *)para;

- (id)serializeJsonString:(NSString *)json;
- (NSString *)md5StringForString:(NSString *)string;

-(NSDictionary *)convertSharedInfo:(NSString *)sharedString;

@end
