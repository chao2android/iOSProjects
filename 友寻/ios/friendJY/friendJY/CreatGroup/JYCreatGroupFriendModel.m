//
//  JYCreatGroupFriendModel.m
//  friendJY
//
//  Created by 高斌 on 15/4/15.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYCreatGroupFriendModel.h"

@implementation JYCreatGroupFriendModel

- (NSDictionary*)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"friendUid"   : @"uid",
                             @"age"         : @"age",
                             @"nick"        : @"nick",
                             @"marriage"    : @"marriage",
                             @"sex"         : @"sex",
                             @"mutualNums"  : @"mutualnums",
                             @"mark"        : @"mark",
                             @"is_friend" : @"is_friend",
                             @"uid" : @"uid",
                             @"relation"    :@"relation",
                             @"gid"         :@"gid",
                             @"mobile"      : @"mobile"
                            };
    
    return mapAtt;
}


 /*
 @property (nonatomic, assign) int mfriend_num;//共同好友数量
 @property (nonatomic, copy) NSString *friendUid;
 @property (nonatomic, copy) NSString *age;
 @property (nonatomic, copy) NSString *avatar;
 @property (nonatomic, copy) NSString *nick;
 @property (nonatomic, copy) NSString *uid;
 @property (nonatomic, copy) NSString *marriage; //1.单身
 @property (nonatomic, copy) NSString *sex;
 @property (nonatomic, copy) NSString *mutualNums;
 @property (nonatomic, copy) NSString *mark;
 @property (nonatomic, copy) NSString *is_friend;
 @property (nonatomic, assign) BOOL isSelected;
 @property (nonatomic, strong) UIImage * image;
 
 {
 avatars =                 {
 150 = "http://p.iyouxun.com/09/44/c4a89de765a1444d0cadd34ae9883974/2292860150a.jpg?wh=150x150";
 200 = "http://p.iyouxun.com/09/44/c4a89de765a1444d0cadd34ae9883974/2292860200a.jpg?wh=200x200";
 };
 jointime = 1434416793;
 marriage = 1;
 "mfriend_num" = 17;
 nick = "\U6f47\U6d12\U54e5\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U59d0\U59d0";
 pinyin = s;
 relation = 3;
 sex = 1;
 uid = 1094460;
 },
 */


+(NSDictionary *)ModelToDict:(JYCreatGroupFriendModel *)model{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSDictionary *avatarDict = [[NSDictionary alloc]initWithObjects:@[model.avatar] forKeys:@[@"150"]];
    NSDate *date = [NSDate date];
    NSTimeInterval dateInterval = [date timeIntervalSince1970];
    [dict setObject:avatarDict forKey:@"avatars"];
    [dict setObject:[NSString stringWithFormat:@"%f",dateInterval] forKey:@"jointime"];
    [dict setObject:model.marriage forKey:@"marriage"];
    //[dict setObject:[NSNumber numberWithInt:model.mfriend_num] forKey:@"mfriend_num"];
    [dict setObject:model.mutualNums forKey:@"mfriend_num"];
    [dict setObject:model.relation forKey:@"relation"];
    [dict setObject:model.nick forKey:@"nick"];
    [dict setObject:@"1" forKey:@"relation"];
    [dict setObject:model.sex forKey:@"sex"];
    [dict setObject:model.uid forKey:@"uid"];
    return dict;
}


@end








