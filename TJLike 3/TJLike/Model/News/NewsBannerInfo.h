//
//  NewsBannerInfo.h
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsBannerInfo : NSObject
@property (nonatomic, strong) NSString *focusimg;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int nid;

+ (NewsBannerInfo *)CreateWithDict:(NSDictionary *)dict;
@end
