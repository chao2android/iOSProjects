//
//  NewsPartInfo.m
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsPartInfo.h"

@implementation NewsPartInfo

+ (NewsPartInfo *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[NewsPartInfo alloc] initWithDict:dict];
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
            if ([key isEqualToString:@"id"]) {
                self.cid = [netDic[key] intValue];
            }
            else {
                [self setValue:netDic[key] forKey:key];
            }
        }
    }
    return self;
}

- (void)dealloc {
    self.name = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"the undeFinedKey is -->%@",key);
}

@end
