//
//  CommentModel.h
//  TestRedCollar
//
//  Created by MC on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(strong,nonatomic) NSDictionary *mDict;
@property(strong,nonatomic) NSString *add_time;
@property(strong,nonatomic) NSString *cate;
@property(strong,nonatomic) NSString *comment_id;
@property(strong,nonatomic) NSString *content;
@property(strong,nonatomic) NSString *goods_id;
@property(strong,nonatomic) NSString *_id;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *to_uid;
@property(strong,nonatomic) NSString *uid;
@property(strong,nonatomic) NSString *avatar;
@property(strong,nonatomic) NSString *user_name;
@property(strong,nonatomic) NSString *nickname;

+ (CommentModel *)CreateWithDict:(NSDictionary *)dict;

@end
