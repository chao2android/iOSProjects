//
//  JYAuthInfoModel.h
//  friendJY
//
//  Created by chenxiangjing on 15/6/16.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYAuthInfoModel : NSObject

@property (nonatomic, readwrite, copy) NSString *content;
@property (nonatomic, readwrite, copy) NSString *expires_in;
@property (nonatomic, readwrite, copy) NSString *login_count;
@property (nonatomic, readwrite, copy) NSString *login_time;
@property (nonatomic, readwrite, copy) NSString *openid;
@property (nonatomic, readwrite, copy) NSString *token;
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *refresh_token;
@property (nonatomic, readwrite, copy) NSString *uid;

+ (JYAuthInfoModel*)authInfoModelWithDic:(NSDictionary*)dic;

@end
