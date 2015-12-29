//
//  ProjectList.h
//  TestRedCollar
//
//  Created by miracle on 14-7-27.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectList : NSObject
@property (nonatomic, strong) NSDictionary *mDict;

@property (nonatomic, strong) NSString *add_time;//添加时间
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *comment_num;//评论次数
@property (nonatomic, strong) NSString *like_num;//喜欢次数
@property (nonatomic, strong) NSString *url;//图片地址
@property (nonatomic, strong) NSString *view;//查看次数
@property (nonatomic, strong) NSString *ID;

+ (ProjectList *)CreateWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dictionary;
@end
