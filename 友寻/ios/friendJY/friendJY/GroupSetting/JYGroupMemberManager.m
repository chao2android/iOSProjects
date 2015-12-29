//
//  JYGroupMemberManager.m
//  friendJY
//
//  Created by aaa on 15/6/16.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYGroupMemberManager.h"

@implementation JYGroupMemberManager



+ (JYGroupMemberManager *)sharedManager:(NSArray *)memberList
{
    JYGroupMemberManager *manager = [JYGroupMemberManager sharedManager];
    NSMutableArray *mutable = [[NSMutableArray alloc]init];
    for (int i = 0; i<memberList.count; i++) {
        NSDictionary *dict = memberList[i];
        [mutable addObject:dict];
    }
    manager.memberArray = mutable;
    return manager;
}

- (void)SortUserList{
    //           排序 时间越大的在前边
    [self.memberArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int time1 = [obj1[@"jointime"] intValue];
        int time2 = [obj2[@"jointime"] intValue];
        
        if (time1>time2) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
}

+ (JYGroupMemberManager *)sharedManager{
    static JYGroupMemberManager *sharedGroupMemberManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGroupMemberManager = [[self alloc] init];
    });
    return sharedGroupMemberManager;
}



@end





