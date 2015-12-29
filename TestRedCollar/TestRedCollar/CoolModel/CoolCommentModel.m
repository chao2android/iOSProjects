//
//  CoolCommentModel.m
//  TestRedCollar
//
//  Created by dreamRen on 14-7-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolCommentModel.h"

@implementation CoolCommentModel

+ (CoolCommentModel *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[CoolCommentModel alloc] initWithDict:dict];
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

- (void)dealloc {
    self.mDict = nil;
    self.add_time = nil;
    self._id = nil;
    self.cate = nil;
    self.comment_id = nil;
    self.content = nil;
    self.goods_id = nil;
    self.status =nil;
    self.to_uid = nil;
    self.uid = nil;
    self.avatar =nil;
    self.user_name =nil;
    self.nickname =nil;

}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"未赋值成功的key = %@", key);
}
@end
