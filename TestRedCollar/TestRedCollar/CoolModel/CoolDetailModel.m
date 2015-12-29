//
//  CoolDetailModel.m
//  TestRedCollar
//
//  Created by dreamRen on 14-7-19.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolDetailModel.h"

@implementation CoolDetailModel
- (void)dealloc {
    self.comment = nil;
    self.desc = nil;
    self._id = nil;
    self.image = nil;
    self.islove = nil;
    self.likes = nil;
    self.list = nil;
    self.name = nil;
    self.price = nil;

}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"没有赋值成功的是%@",key);

}
@end
