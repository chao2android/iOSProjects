//
//  AFHTTPRequestOperationManager+RACSupport.m
//  ReactiveDemo
//
//  Created by Ran on 14-9-12.
//  Copyright (c) 2014年 ran. All rights reserved.
//

#import "AFHTTPRequestOperationManager+RACSupport.h"
#import "AFURLConnectionOperation+RACSupport.h"

#define DEFAULT_TIMEOUT_INTERVAL (8.0)

static NSString * const HTTP_METHOD_GET     = @"GET";
static NSString * const HTTP_METHOD_POST    = @"POST";
static NSString * const HTTP_METHOD_PUT     = @"PUT";
static NSString * const HTTP_METHOD_DELETE  = @"DELETE";
static NSString * const HTTP_METHOD_PATCH   = @"PATCH";

@implementation AFHTTPRequestOperationManager (RACSupport)

#ifdef _SYSTEMCONFIGURATION_H

- (RACSignal *)networkReachabilityStatusSignal
{
    return RACObserve(self.reachabilityManager, networkReachabilityStatus);
}

#endif

#pragma mark - Request Method (Private)

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(NSDictionary *)parameters method:(NSString *)method
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSMutableURLRequest *httpRequest = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
        httpRequest.timeoutInterval = DEFAULT_TIMEOUT_INTERVAL;
        httpRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:httpRequest success:nil failure:nil];
        RACSignal *signal = [requestOperation rac_httpRequestCompletionSignal];
        [self.operationQueue addOperation:requestOperation];
        [signal subscribe:subscriber];
        
        return [RACDisposable disposableWithBlock:^{
            [requestOperation cancel];
        }];
    }];
}

#pragma mark - Request Method (Public)

- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation
{
    RACSignal *signal = [requestOperation rac_httpRequestCompletionSignal];
    [self.operationQueue addOperation:requestOperation];
    return signal;
}

- (RACSignal *)rac_GET:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [[self rac_requestPath:path parameters:parameters method:HTTP_METHOD_GET]
            setNameWithFormat:@"<%@: %p> -rac_getPath: %@, parameters: %@", self.class, self, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [[self rac_requestPath:path parameters:parameters method:HTTP_METHOD_POST]
            setNameWithFormat:@"<%@: %p> -rac_postPath: %@, parameters: %@", self.class, self, path, parameters];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [[self rac_requestPath:path parameters:parameters method:HTTP_METHOD_PUT]
            setNameWithFormat:@"<%@: %p> -rac_putPath: %@, parameters: %@", self.class, self, path, parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [[self rac_requestPath:path parameters:parameters method:HTTP_METHOD_DELETE]
            setNameWithFormat:@"<%@: %p> -rac_deletePath: %@, parameters: %@", self.class, self, path, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [[self rac_requestPath:path parameters:parameters method:HTTP_METHOD_PATCH]
            setNameWithFormat:@"<%@: %p> -rac_patchPath: %@, parameters: %@", self.class, self, path, parameters];
}

@end
