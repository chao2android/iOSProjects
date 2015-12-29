//
//  JYChatService.h
//  friendJY
//
//  Created by 高斌 on 15/3/20.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYChatSocket.h"

@interface JYChatService : NSObject<JYChatSocketDelegate>

@property(nonatomic,strong) JYChatSocket *clientSocket;

+ (JYChatService *)sharedInstance;
- (void)startWork;
//- (void)resumeWork;
/*
 * 用户登出以后，调用此函数
 */
- (void)stopWork;
- (BOOL)isSocketConnected;

@end
