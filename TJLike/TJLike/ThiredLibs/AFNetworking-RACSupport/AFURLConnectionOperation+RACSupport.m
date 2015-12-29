//
//  AFURLConnectionOperation+RACSupport.m
//  ReactiveDemo
//
//  Created by Ran on 14-9-12.
//  Copyright (c) 2014年 ran. All rights reserved.
//

#import "AFURLConnectionOperation+RACSupport.h"
#import "AFHTTPRequestOperation.h"

@implementation AFURLConnectionOperation (RACSupport)

- (RACSignal *)rac_httpRequestCompletionSignal
{
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    [subject setNameWithFormat:@"-rac_start: %@", self.request.URL];
    
    SEL completeSelector = NSSelectorFromString(@"setCompletionBlockWithSuccess:failure:");
    if ([self respondsToSelector:completeSelector]) {
        [(AFHTTPRequestOperation *)self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subject sendNext:responseObject];
            [subject sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subject sendError:error];
        }];
        
    }
    return subject;
}

@end
