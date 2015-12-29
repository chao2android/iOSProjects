//
//  JYProfileModel.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/20.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileModel.h"

@implementation JYProfileModel
- (NSDictionary *)attributeMapDictionary{

   
    NSDictionary *attributeDic = @{
                                   @"weight"                            :@"weight",
                                   @"update_time"                       :@"update_time",
                                   @"uid"                               :@"uid",
                                   @"star"                              :@"star",
                                   @"allow_second_friend_look_my_dync"  :@"allow_second_friend_look_my_dync",
                                   @"allow_my_profile_show"             :@"allow_my_profile_show",
                                   @"allow_add_with_chat"               :@"allow_add_with_chat",
                                   @"allow_accept_second_friend_invite" :@"allow_accept_second_friend_invite",
                                   @"show_second_friend_dync"           :@"show_second_friend_dync",
                                   @"sex"                               :@"sex",
                                   @"school"                            :@"school",
                                   @"photoes"                           :@"photoes",
                                   @"avatars"                           :@"avatars",
                                   @"photocount"                        :@"photocount",
                                   @"nick"                              :@"nick",
                                   @"marriage"                          :@"marriage",
                                   @"mark"                              :@"mark",
                                   @"lonely_confirm"                    :@"lonely_confirm",
                                   @"live_sublocation"                  :@"live_sublocation",
                                   @"live_location"                     :@"live_location",
                                   @"lastLoginTime"                     :@"lastLoginTime",
                                   @"is_lonely_confirm"                 :@"is_lonely_confirm",
                                   @"is_friend"                         :@"is_friend",
                                   @"intro"                             :@"intro",
                                   @"height"                            :@"height",
                                   @"distance"                          :@"distance",
                                   @"company_name"                      :@"company_name",
                                   @"career"                            :@"career",
                                   @"callno_upload"                     :@"callno_upload",
                                   @"birthday"                          :@"birthday",
                                   @"animal"                            :@"animal",
                                   @"age"                               :@"age",
                                   @"address"                           :@"address",
                                   @"friends_num"                       :@"friends_num",
                                   @"gid"                               :@"gid",
                                   @"hasavatar"                         :@"hasavatar"
                                   };
    
    return attributeDic;

}
- (id)initWithDataDic:(NSDictionary*)data
{
    if (self = [super init]) {
        [self setAttributes:data];
        _dataDict = [NSDictionary dictionaryWithDictionary:data];
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

- (NSDictionary *)modelToDictionary{
    return _dataDict;
}
@end
