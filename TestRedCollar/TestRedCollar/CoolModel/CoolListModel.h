//
//  CoolListModel.h
//  TestRedCollar
//
//  Created by dreamRen on 14-7-18.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoolListModel : NSObject

@property(nonatomic, strong) NSDictionary *mDict;
@property(nonatomic, strong) NSString *add_time;
@property(nonatomic, strong) NSString *like_num;
@property(nonatomic, strong) NSString *title;//
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *views;//
@property(nonatomic, strong) NSString *comment_num;
@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *_id;
@property(nonatomic, strong) NSString *user_name;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *des;
@property(nonatomic, strong) NSString *nickname;

- (id)initWithDict:(NSDictionary *)dictionary;
+ (CoolListModel *)CreateWithDict:(NSDictionary *)dict;

@end
