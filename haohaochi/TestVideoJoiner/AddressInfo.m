//
//  AddressInfo.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AddressInfo.h"

@implementation AddressInfo

+ (AddressInfo *)CreateWithDict:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[AddressInfo alloc] initWithDict:dict];
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
        NSArray *array = [netDic objectForKey:@"regions"];
        if (array.count>0) {
            self.region = [array objectAtIndex:0];
        }
        for (NSString *key in netDic.allKeys) {
            NSString *newkey = key;
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
