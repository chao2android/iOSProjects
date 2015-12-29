//
//  NewsListInfo.h
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsListInfo : NSObject
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, assign) int nid;
@property (nonatomic, assign) int comment;
@property (nonatomic, strong) NSArray *tuwen;
@property (nonatomic, assign) int ztid;
@property (nonatomic, assign) int nums;
@property (nonatomic, strong) NSString *mDescription;

+ (NewsListInfo *)CreateWithDict:(NSDictionary *)dict;

@end
