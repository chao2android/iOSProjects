//
//  WTVHttpClient.m
//  WiseTV
//
//  Created by Ran on 14-10-8.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import "TJHttpClient.h"
#import "RACAFNetworking.h"
#import "SDReachability.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+WiseTV.h"

NSString * WTVStringFromNetworkReachabilityStatus(NetworkReachabilityStatus status) {
    switch (status) {
        case NetworkReachabilityStatusNotReachable:
            return @"无网络访问状态";
        case NetworkReachabilityStatusReachableViaWWAN:
            return @"2g,3g网络状态";
        case NetworkReachabilityStatusReachableViaWiFi:
            return @"Wifi 网络状态";
        default:
            return @"未知网络状态";
    }
}

NSString * WTVErroInfoWithCode(NSInteger code) {
    if (code == -1001) {
        return @"网络连接超时，请稍后再试";
    } else {
        return @"网络连接差，请稍后再试";
    }
}

@interface TJHttpClient ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) SDReachability *reachability;
@end

@implementation TJHttpClient

#pragma mark - Initialization
+ (instancetype)sharedClient
{
    static TJHttpClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TJHttpClient alloc] initSingleton];
    });
    return instance;
}

- (id)initSingleton
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPRequestOperationManager manager];
        NSMutableSet *contentTypes = [NSMutableSet setWithSet:self.manager.responseSerializer.acceptableContentTypes];
        [contentTypes addObjectsFromArray:@[@"application/x-javascript", @"text/html"]];
        self.manager.responseSerializer.acceptableContentTypes = contentTypes;
    
        [self.manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"user-agent"];
        
        self.reachability = [SDReachability reachabilityWithTarget:self action:@selector(reachabilityStatusChanged)];
        self.networkStatusSignal = [RACReplaySubject subject];
        self.manager.requestSerializer.timeoutInterval = 30;
        
        
        self.failBlock = ^(NSError *error) {
            TLog(@"error : %@", error);
            NSString *msg = WTVErroInfoWithCode(error.code);
            [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
        };
    }
    return self;
}

#pragma mark - Properties
- (NetworkReachabilityStatus)networkReachablilityStatus
{
    return (NetworkReachabilityStatus)self.reachability.reachabilityStatus;
}

- (BOOL)isNetworkReachable
{
    return self.reachability.reachable;
}

- (void)reachabilityStatusChanged
{
    [(RACSubject *)self.networkStatusSignal sendNext:@(self.reachability.reachabilityStatus)];

    
}

#pragma mark - Request Methods
- (RACSignal *)getRequestWithPath:(NSString *)path
{
    return [self getRequestWithPath:path para:nil];
}

- (RACSignal *)getRequestWithPath:(NSString *)path para:(NSDictionary *)para
{
    return [self getRequestWithPath:path para:para repeatCount:1];
}

- (RACSignal *)getRequestWithPath:(NSString *)path para:(NSDictionary *)para repeatCount:(int)repeatCount
{
    @weakify(self)
    RACSignal *resultSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self getRequestWithPath:path para:para repeatCount:repeatCount subscribeInfo:subscriber];
        return nil;
    }];
    
    return resultSignal;
}

-(void)getRequestWithPath:(NSString *)path para:(NSDictionary *)para repeatCount:(int)repeatCount subscribeInfo:(id)subscriber
{
    @weakify(self)
    [[self.manager rac_GET:path parameters:para] subscribeNext:^(id x) {
        [subscriber sendNext:x];
    } error:^(NSError *error) {
        @strongify(self)
        if (repeatCount>0) {
            [self getRequestWithPath:path para:para repeatCount:(repeatCount-1) subscribeInfo:subscriber];
        } else {
            [subscriber sendError:error];
        }
    } completed:^{
        [subscriber sendCompleted];
    }];
}

- (RACSignal *)postRequestWithPath:(NSString *)path para:(NSDictionary *)para
{
    return [self.manager rac_POST:path parameters:para];
}

#pragma mark - Custom actions
    

- (id)serializeJsonString:(NSString *)json
{
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id ret = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        TLog(@"WARNING : Serialize Json Failed!");
    }
    
    return ret;
}

- (NSString *)md5StringForString:(NSString *)string {
    const char *str = [string UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

-(NSDictionary *)convertSharedInfo:(NSString *)sharedString
{
    sharedString = [NSString urlDecode:sharedString];
    
    TLog(@"handleSharedInfo sharedInfo is %@",sharedString);
    
    NSArray *arr = [sharedString componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (NSString *string in arr) {
        NSRange ran = [string rangeOfString:@"="];
        if (ran.location != NSNotFound) {
            NSString *keyStr = [string substringToIndex:ran.location];
            NSString *valueStr = [string substringFromIndex:ran.location+ran.length];
            [dic setValue:valueStr forKey:keyStr];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dic];
}
@end
