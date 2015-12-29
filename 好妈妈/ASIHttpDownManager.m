//
//  ASIHttpDownManager.m
//  ManziDigest
//
//  Created by Hepburn Alex on 12-9-19.
//  Copyright (c) 2012年 Hepburn Alex. All rights reserved.
//

#import "ASIHttpDownManager.h"
#import "ASIFormDataRequest.h"
#import "Md5Manager.h"

@implementation ASIHttpDownManager

@synthesize delegate, OnImageDown, OnImageFail, tag, userInfo, mWebStr;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)Cancel {
    if (mRequest) {
        NSLog(@"ASIHttpDownManager Cancel");
        mRequest.delegate = nil;
        [mRequest cancel];
        [mRequest release];
        mRequest = nil;
    }
}

- (void)dealloc {
    NSLog(@"ASIHttpDownManager dealloc");
    [self Cancel];
    self.delegate = nil;
    self.userInfo = nil;
    self.mWebStr = nil;
    NSLog(@"ASIHttpDownManager dealloc2");
    [super dealloc];
}

- (void)GetHttpRequest:(NSString *)cmd :(NSString *)action :(NSDictionary *)dict :(NSString *)filepath {
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    NSLog(@"%@",dict);
    for (NSString *key in dict) {
        NSString *newkey = [key lowercaseString];
        NSString *value = [dict objectForKey:key];
        if (value) {
            [newDict setObject:value forKey:newkey];
        }
    }
    
    [self PostHttpRequest:newDict :filepath :@"content"];
}

- (void)PostHttpRequest:(NSDictionary *)dict :(NSString *)filepath :(NSString *)filename {
    NSLog(@"PostHttpRequest:%@, %@", dict, filepath);
    NSURL *url = [NSURL URLWithString:[dict valueForKey:@"aUrl"]];
    mRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    [mRequest setTimeOutSeconds:120];
    for (NSString *key in dict.allKeys) {
        NSString *value = [dict objectForKey:key];
        [mRequest addPostValue:value forKey:key];
    }
    if (filepath && filename) {
        [mRequest addFile:filepath forKey:filename];
    }
    [mRequest setDelegate:self];
    [mRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)_request {
    NSData *data = [_request responseData];
    NSString *responseStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"responseContent is %@",responseStr);
    
    [self Cancel];
    if ([_request responseStatusCode] != 200) {
        return;
    }
    
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.mWebStr = responseStr;

    if (delegate && OnImageDown) {
        [delegate performSelector:OnImageDown withObject:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)_request {
    NSData *data = [_request responseData];
    NSString *responseStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"requestFailed %@", responseStr);
    
    [self Cancel];
    if (delegate && OnImageFail) {
        [delegate performSelector:OnImageFail withObject:self];
    }
}

@end
