//
//  NewsCommentInfo.m
//  TJLike
//
//  Created by MC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsCommentInfo.h"

@implementation NewsCommentInfo

+ (NewsCommentInfo *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[NewsCommentInfo alloc] initWithDict:dict];
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
            if ([key isEqualToString:@"cid"]) {
                self.cid = [netDic[key] intValue];
            }
            else if ([key isEqualToString:@"nid"]) {
                self.nid = [netDic[key] intValue];
            }
            else if ([key isEqualToString:@"number"]) {
                self.number = [netDic[key] intValue];
            }
            else if ([key isEqualToString:@"uid"]) {
                self.uid = [netDic[key] intValue];
            }
            else if ([key isEqualToString:@"username"]) {
                self.username = [netDic[key] intValue];
            }
            else {
                [self setValue:netDic[key] forKey:key];
            }
        }
    }
    return self;
}

- (void)dealloc {
    self.content = nil;
    self.icon = nil;
    self.nickname = nil;
    self.time = nil;
    self.weibo = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"the undeFinedKey is -->%@",key);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
