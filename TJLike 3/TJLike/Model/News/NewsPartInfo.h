//
//  NewsPartInfo.h
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsPartInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int cid;

+ (NewsPartInfo *)CreateWithDict:(NSDictionary *)dict;


@end
