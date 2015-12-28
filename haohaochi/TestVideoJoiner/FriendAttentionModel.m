//
//  FriendAttentionModel.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FriendAttentionModel.h"

@implementation FriendAttentionModel

+ (FriendAttentionModel *)CreateWithDict:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[FriendAttentionModel alloc] initWithDict:dict];
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

- (id)initWithDict:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSDictionary *netDic = [self GetFormatDict:dictionary];
        self.mDict = netDic;
        for (NSString *key in netDic.allKeys) {
            NSString *newkey = key;
            if ([key isEqualToString:@"id"]) {
                newkey = @"m_id";
            }
            [self setValue:netDic[key] forKey:newkey];
        }
    }
    return self;
}

- (void)dealloc {
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"UndefinedKey -- %@",key);
}

@end
