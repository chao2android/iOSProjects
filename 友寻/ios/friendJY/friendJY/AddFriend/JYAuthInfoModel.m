//
//  JYAuthInfoModel.m
//  friendJY
//
//  Created by chenxiangjing on 15/6/16.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYAuthInfoModel.h"

@implementation JYAuthInfoModel


+ (JYAuthInfoModel *)authInfoModelWithDic:(NSDictionary *)dic{
    JYAuthInfoModel *model = [[JYAuthInfoModel alloc] initWithDic:dic];
    return model;
}

- (instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

#pragma mark - 

- (void)setValue:(id)value forKey:(NSString *)key{
    if (![value isKindOfClass:[NSString class]]) {
        value = ToString(value);
    }
    [super setValue:value forKey:key];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
- (NSString *)description{
    NSString *str = [NSString stringWithFormat:@"type ->%@, openid -> %@, token -> %@, uid -> %@",_type,_openid,_token,_uid];
    return str;
}
@end
