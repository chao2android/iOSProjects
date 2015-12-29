//
//  AFHTTPRequestOperationManager+RACSupport.h
//  ReactiveDemo
//
//  Created by Ran on 14-9-12.
//  Copyright (c) 2014年 ran. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AFHTTPRequestOperationManager (RACSupport)

#ifdef _SYSTEMCONFIGURATION_H

- (RACSignal *)networkReachabilityStatusSignal;

#endif

- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation;

- (RACSignal *)rac_GET:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_POST:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_PUT:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_DELETE:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_PATCH:(NSString *)path parameters:(NSDictionary *)parameters;

@end
