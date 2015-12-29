//
//  ChatNewManager.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-16.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "ChatNewManager.h"

@implementation ChatNewManager

@synthesize mLastID, mType, mBelongID, mbCanCheck, delegate, OnNewCheck, miNewNum;

- (id)init {
    self = [super init];
    if (self) {
        mType = TChatType_Group;
        mbCanCheck = NO;
        miNewNum = 0;
        mTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(OnTimeCheck) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc {
    [self StopCheck];
    self.mBelongID = nil;
    self.mLastID = nil;
    [super dealloc];
}

- (void)OnTimeCheck {
    if (mbCanCheck) {
        [self CheckNewChats];
    }
}

- (void)StopCheck {
    if (mTimer) {
        [mTimer invalidate];
        mTimer = nil;
    }
    [self Cancel];
}

- (void)Cancel {
    if (mDownManager) {
        mDownManager.delegate = nil;
        [mDownManager Cancel];
        [mDownManager release];
        mDownManager = nil;
    }
}

- (void)OnLoadSuccess:(HttpDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"%@", [dict valueForKey:@"message"]);
    if (dict) {
        miNewNum = [[dict objectForKey:@"num"] intValue];
    }
    if (delegate && OnNewCheck && miNewNum>0) {
        [delegate performSelector:OnNewCheck withObject:self];
    }
}

- (void)OnLoadFail:(HttpDownManager *)sender {
    [self Cancel];
}

- (void)CheckNewChats {
    if (!self.mLastID) {
        return;
    }
    if (mDownManager) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.mLastID forKey:@"id"];

    if (mType == TChatType_Group) {
//        [dict setObject:[UserInfoManager Share].mUserID forKey:@"uid"];
        [dict setObject:@"group" forKey:@"belong"];
        [dict setObject:mBelongID forKey:@"belong_id"];
    }
    else if (mType == TChatType_User) {
//        [dict setObject:[UserInfoManager Share].mUserID forKey:@"belong_id"];
        [dict setObject:@"user" forKey:@"belong"];
        [dict setObject:mBelongID forKey:@"uid"];
    }
    else if (mType == TChatType_Demand) {
//        [dict setObject:[UserInfoManager Share].mUserID forKey:@"uid"];
        [dict setObject:@"demand" forKey:@"belong"];
        [dict setObject:mBelongID forKey:@"belong_id"];
    }
    
    mDownManager = [[HttpDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadSuccess:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    [mDownManager GetHttpRequest2:@"chats" :@"Getcount" :dict];
}


/*
 String c	chats
 String a	Getcount
 Int uid	用户id
 Int id 	数据最大的id
 String belong 	拼吧的：group;用户的:user
 Int belong_id	拼吧的id
 */

@end
