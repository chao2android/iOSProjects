//
//  JYProfileTagModel.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/23.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYProfileTagModel.h"

@implementation JYProfileTagModel

- (NSDictionary*)modelToDictionary{
    NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];

    [modelDict setObject:self.tid forKey:@"tid"];
    [modelDict setObject:self.title forKey:@"title"];
    [modelDict setObject:self.oper forKey:@"oper"];
    [modelDict setObject:self.bind forKey:@"bind"];
    if ([JYHelpers isEmptyOfString:self.ctime]) {
        self.ctime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    }
    [modelDict setObject:self.ctime forKey:@"ctime"];
    NSLog(@"\n---------\n%@\n----------",modelDict);
    return modelDict;

}
- (NSDictionary *)attributeMapDictionary{

    NSDictionary *attributeDict = @{
                                    @"tid"   :@"tid",
                                    @"oper"  :@"oper",
                                    @"title" :@"title",
                                    @"bind"  :@"bind",
                                    @"ctime" :@"ctime"
                                    };
    
    return attributeDict;
}
- (id)initWithDataDic:(NSDictionary*)data
{
    if (self = [super init]) {
        [self setAttributes:data];
    }
    return self;
}

- (void)setAttributes:(NSDictionary*)dataDic
{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[dataDic count]];
        for (NSString *key in dataDic) {
            [dic setValue:key forKey:key];
            attrMapDic = dic;
        }
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel]) {
            NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
            id attributeValue = [dataDic objectForKey:dataDicKey];
            
            id value;
            if ([attributeValue isKindOfClass:[NSNumber class]]) {
                value = [attributeValue stringValue];
            }else if([attributeValue isKindOfClass:[NSNull class]]){
                value = @"";
            }else {
                value = attributeValue;
            }
            
            [self performSelectorOnMainThread:sel
                                   withObject:value
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}
- (SEL)getSetterSelWithAttibuteName:(NSString*)attributeName
{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

@end
