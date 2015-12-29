//
//  NewsCommentInfo.h
//  TJLike
//
//  Created by MC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCommentInfo : UIView

@property (nonatomic, assign) int cid;
@property (nonatomic, assign) int nid;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int uid;
@property (nonatomic, assign) int username;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *weibo;
+ (NewsCommentInfo *)CreateWithDict:(NSDictionary *)dict;
@end
