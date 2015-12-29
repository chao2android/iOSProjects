//
//  JYGroupMemberManager.h
//  friendJY
//
//  Created by aaa on 15/6/16.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYGroupMemberManager : NSObject

@property (nonatomic, copy)NSMutableArray *memberArray;


+ (JYGroupMemberManager *)sharedManager:(NSArray *)memberList;
+ (JYGroupMemberManager *)sharedManager;

@end
