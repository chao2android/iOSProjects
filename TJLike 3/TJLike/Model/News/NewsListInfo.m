//
//  NewsListInfo.m
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsListInfo.h"

@implementation NewsListInfo
+ (NewsListInfo *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[NewsListInfo alloc] initWithDict:dict];
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
    if (self) {
        NSDictionary *netDic = [self GetFormatDict:dictionary];
        for (NSString *key in netDic.allKeys) {
            if ([key isEqualToString:@"nid"]) {
                self.nid = [netDic[key] intValue];
            }
            else if([key isEqualToString:@"comment"]) {
                self.comment = [netDic[key] intValue];
            }
            else if([key isEqualToString:@"ztid"]) {
                self.ztid = [netDic[key] intValue];
            }
            else if([key isEqualToString:@"nums"]) {
                self.nums = [netDic[key] intValue];
            }
            else if([key isEqualToString:@"description"]) {
                self.mDescription = netDic[key];
            }
            else {
                [self setValue:netDic[key] forKey:key];
            }
        }
    }
    return self;
}

- (void)dealloc {
    self.brief = nil;
    self.property = nil;
    self.title = nil;
    self.pic = nil;
    self.tuwen = nil;
    self.mDescription = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"the undeFinedKey is -->%@",key);
}
@end
