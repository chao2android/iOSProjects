//
//  AFURLConnectionOperation+RACSupport.h
//  ReactiveDemo
//
//  Created by Ran on 14-9-12.
//  Copyright (c) 2014年 ran. All rights reserved.
//

#import "AFURLConnectionOperation.h"

@interface AFURLConnectionOperation (RACSupport)

- (RACSignal *)rac_httpRequestCompletionSignal;

@end
