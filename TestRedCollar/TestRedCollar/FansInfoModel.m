//
//  FansInfoModel.m
//  TestRedCollar
//
//  Created by dreamRen on 14-7-25.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FansInfoModel.h"

@implementation FansInfoModel
- (void)dealloc {
    self.city = nil;
    self.coin = nil;
    self.def_addr = nil;
    self.fans = nil;
    self.follows = nil;
    self.gender = nil;
    self.nickname = nil;
    self.point = nil;
    self.portrait = nil;
    self.province = nil;
    self.signature = nil;
    self.user_id = nil;
    self.user_name = nil;
    self.isfollow = nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"未成功赋值的key = %@",key);
}
@end
