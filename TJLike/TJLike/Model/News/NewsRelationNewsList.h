//
//  NewsRelationNewsList.h
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsRelationNewsList : NSObject

@property (nonatomic, assign) int nid;
@property (nonatomic, strong) NSString *pubtime;
@property (nonatomic, strong) NSString *source;

+ (NewsRelationNewsList *)CreateWithDict:(NSDictionary *)dict;

@end
