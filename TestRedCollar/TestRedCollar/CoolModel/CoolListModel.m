//
//  CoolListModel.m
//  TestRedCollar
//
//  Created by dreamRen on 14-7-18.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolListModel.h"

@implementation CoolListModel

+ (CoolListModel *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[CoolListModel alloc] initWithDict:dict];
}

- (NSDictionary *)GetFormatDict:(NSDictionary *)dictionary {
    NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    for (NSString *key in netDic.allKeys) {
        id target = [netDic objectForKey:key];
        if ([target isKindOfClass:[NSNull class]]) {
            [netDic removeObjectForKey:key];
        }
    }
    return netDic;
}

- (id)initWithDict:(NSDictionary *)dictionary
{
    self = [super init];
    if (self){
        NSDictionary *netDic = [self GetFormatDict:dictionary];
        self.mDict = netDic;
        [self setValuesForKeysWithDictionary:netDic];
        self._id = [netDic objectForKey:@"id"];
        if (self.avatar && self.avatar.length > 0) {
            NSRange range = [self.avatar rangeOfString:@"http://"];
            if (range.length == 0) {
                self.avatar = [NSString stringWithFormat:@"%@%@",URL_HEADER, self.avatar];
            }
        }
    }
    return self;
}

- (void)dealloc{
    self.mDict = nil;
    self.add_time =nil;
    self.like_num = nil;
    self.title = nil;
    self.url = nil;
    self.des = nil;
    self.views = nil;
    self.comment_num = nil;
    self.uid = nil;
    self._id = nil;
    self.user_name = nil;
    self.avatar = nil;
    self.nickname = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
