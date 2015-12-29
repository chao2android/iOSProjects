//
//  MessageList.h
//  TestRedCollar
//
//  Created by miracle on 14-8-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageList : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *last_update;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *msg_id;

@end
