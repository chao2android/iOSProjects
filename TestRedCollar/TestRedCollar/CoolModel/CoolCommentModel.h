//
//  CoolCommentModel.h
//  TestRedCollar
//
//  Created by dreamRen on 14-7-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoolCommentModel : NSObject

@property(nonatomic, strong) NSDictionary *mDict;
@property(copy,nonatomic)NSString *add_time;
@property(copy,nonatomic)NSString *cate;
@property(copy,nonatomic)NSString *comment_id;
@property(copy,nonatomic)NSString *content;
@property(copy,nonatomic)NSString *goods_id;
@property(copy,nonatomic)NSString *_id;
@property(copy,nonatomic)NSString *status;
@property(copy,nonatomic)NSString *to_uid;
@property(copy,nonatomic)NSString *uid;
@property(copy,nonatomic)NSString *avatar;
@property(copy,nonatomic)NSString *user_name;
@property(copy,nonatomic)NSString *nickname;

- (id)initWithDict:(NSDictionary *)dictionary;
+ (CoolCommentModel *)CreateWithDict:(NSDictionary *)dict;

@end
