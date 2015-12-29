//
//  JYFeedModel.h
//  friendJY
//
//  Created by ouyang on 3/26/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYFeedModel : NSObject
- (id)initWithDataDic:(NSDictionary*)data;
- (NSString *)description;

@property (nonatomic,strong) NSDictionary * avatars;
@property (nonatomic,strong) NSMutableArray * comment_list;
@property (nonatomic,strong) NSString * comment_num;
@property (nonatomic,strong) NSDictionary * data;
@property (nonatomic,assign) BOOL  contentIsExpand;
@property (nonatomic,strong) NSString * feedid;
@property (nonatomic,strong) NSString * friend;
@property (nonatomic,strong) NSString * is_comment;
@property (nonatomic,strong) NSString * is_praise;
@property (nonatomic,assign) BOOL  praiseIsExpand;
@property (nonatomic,strong) NSString * is_rebroadcast;
@property (nonatomic,assign) BOOL  rebroadcastIsExpand;
@property (nonatomic,strong) NSString * nick;
@property (nonatomic,strong) NSArray * praise_list;
@property (nonatomic,strong) NSString * praise_num;
@property (nonatomic,strong) NSArray * rebroadcast_list;
@property (nonatomic,strong) NSString * rebroadcast_num;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * showtime;
@property (nonatomic,strong) NSString * time;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * uid;
@property (nonatomic,strong) NSString * marriage;

@end
