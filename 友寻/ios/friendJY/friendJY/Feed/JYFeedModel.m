//
//  JYFeedModel.m
//  friendJY
//
//  Created by ouyang on 3/26/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedModel.h"

@implementation JYFeedModel

- (NSDictionary*)attributeMapDictionary {
    
    NSDictionary *mapAtt = @{
                             @"avatars"             : @"avatars",
                             @"comment_list"        : @"comment_list",
                             @"comment_num"         : @"comment_num",
                             @"contentIsExpand"     : @"contentIsExpand",
                             @"data"                : @"data",
                             @"feedid"              : @"feedid",
                             @"friend"              : @"friend",
                             @"is_comment"          : @"is_comment",
                             @"is_praise"           : @"is_praise",
                             @"is_rebroadcast"      : @"is_rebroadcast",
                             @"nick"                : @"nick",
                             @"praiseIsExpand"      : @"praiseIsExpand",
                             @"praise_list"         : @"praise_list",
                             @"praise_num"          : @"praise_num",
                             @"rebroadcastIsExpand" : @"rebroadcastIsExpand",
                             @"rebroadcast_list"    : @"rebroadcast_list",
                             @"rebroadcast_num"     : @"rebroadcast_num",
                             @"sex"                 : @"sex",
                             @"showtime"            : @"showtime",
                             @"time"                : @"time",
                             @"marriage"            : @"marriage",
                             @"type"                : @"type", //100-文字,101-图片,500-转播文字,501-转播图片 
                             @"uid"                 : @"uid"
                             
                             };
    
    return mapAtt;
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

- (void)setComment_list:(NSMutableArray *)comment_list{
    if ([comment_list isKindOfClass:[NSArray class]]) {
        NSMutableArray *indexArray = [[NSMutableArray alloc]initWithCapacity:10];
        for (int i = 0; i<comment_list.count; i++) {
            NSDictionary *comDict = comment_list[i];
            if ([JYHelpers isEmptyOfString:comDict[@"uid"]] || [JYHelpers isEmptyOfString:comDict[@"nick"]] || [JYHelpers isEmptyOfString:comDict[@"id"]]) {
                [indexArray addObject:[NSNumber numberWithInt:i]];
            }
        }
        NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:10];
        for (int  i=0;i<comment_list.count; i++) {
            if (![indexArray containsObject:[NSNumber numberWithInt:i]]) {
                [newArray addObject:comment_list[i]];
            }
        }
        _comment_list = newArray;
    }
}

- (SEL)getSetterSelWithAttibuteName:(NSString*)attributeName
{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

@end
