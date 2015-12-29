//
//  HttpDownManager.h
//  ManziDigest
//
//  Created by Hepburn Alex on 12-9-19.
//  Copyright (c) 2012年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "NSString+SBJSON.h"

@interface ASIHttpDownManager : NSObject {
    ASIFormDataRequest *mRequest;
    int tag;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnImageDown;
@property (nonatomic, assign) SEL OnImageFail;
@property (nonatomic, assign) int tag;
@property (nonatomic, retain) id userInfo;
@property (nonatomic, retain) NSString *mWebStr;

- (void)GetHttpRequest:(NSString *)cmd :(NSString *)action :(NSDictionary *)dict :(NSString *)filepath;
- (void)PostHttpRequest:(NSDictionary *)dict :(NSString *)filepath :(NSString *)filename;

- (void)Cancel;

@end
