//
//  JYFeedData.h
//  friendJY
//
//  Created by ouyang on 5/9/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "JYFeedModel.h"
#import <Foundation/Foundation.h>



@interface JYFeedData : NSObject{
    FMDatabase *db;
}

@property (nonatomic,strong) NSMutableArray *feedListArr;
@property (nonatomic,strong) NSMutableArray *myDynamicArr;

- (void)getFeedList:(NSString *)feedId isSingle:(NSString *)isSingle isUp:(int)isUp andFinishBlock:(void(^)(BOOL hasMore))finishBlock andFaileBlock:(void(^)())failBlock;

+ (JYFeedData *)sharedInstance;

- (NSMutableArray *) getFeedList:(NSString *)feedId isSingle:(NSString *)isSingle isUp:(int)isUp;
- (BOOL) fromHttpGetDataDownRefresh:(NSString *)isSingle;
//发送评论
- (void) sendCommendDataToHttp:(NSString *) sendOid sendFeedId:(NSString *) sendFeedId content:(NSString *)content;
//回复评论
- (void) sendReplyCommendDataToHttp:(NSString *) dy_uid reply_nick:(NSString *)relpy_nick reply_uid:(NSString *) reply_uid  dy_id:(NSString *) dy_id comment_id:(NSString *) comment_id comment_uid:(NSString *) comment_uid content:(NSString *)content;
//取消赞
-(BOOL) sendCancelPariseDataToHttp:(NSString *)uid feedid:(NSString *)feedid;
//发送赞数据
-(BOOL) sendPariseDataToHttp:(NSString *)uid feedid:(NSString *)feedid;
-(BOOL) sendRebroadcastDataToHttp:(NSString *)uid feedid:(NSString *)feedid;


-(BOOL) deleteOneFeed:(NSString *)feedid;
@end
