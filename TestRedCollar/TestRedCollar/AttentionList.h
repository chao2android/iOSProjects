//
//  List.h
//  TestRedCollar
//
//  Created by miracle on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionList : NSObject

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *is_fans;
@property (nonatomic, strong) NSString *user_name;

+ (AttentionList *)CreateWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dictionary;

@end
