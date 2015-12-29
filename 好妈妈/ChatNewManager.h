//
//  ChatNewManager.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-16.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDownManager.h"

typedef enum {
    TChatType_Group,
    TChatType_User,
    TChatType_Demand
} TChatType;

@interface ChatNewManager : NSObject {
    HttpDownManager *mDownManager;
    TChatType mType;
    BOOL mbCanCheck;
    NSTimer *mTimer;
    int miNewNum;
}

@property (nonatomic, assign) int miNewNum;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnNewCheck;
@property (nonatomic, assign) BOOL mbCanCheck;
@property (nonatomic, assign) TChatType mType;
@property (nonatomic, retain) NSString *mLastID;
@property (nonatomic, retain) NSString *mBelongID;

- (void)StopCheck;

@end
