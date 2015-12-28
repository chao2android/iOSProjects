//
//  TJSubjectViewModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJSubjectViewModel : NSObject

- (void)postBBSCommentList:(NSString *)bid withPage:(NSString *)page withCommentid:(NSString *)commentid andFinishBlock:(void (^)(NSArray *))finishBlock andFaileBlock:(void (^)(NSString *))failBlock;
//添加评论
- (void)postBBSAddComment:(NSString *)bid withUserID:(NSString *)uid withParent:(NSString *)Parent withReplyid:(NSString *)Replyid withContent:(NSString *)content withImage:(NSArray *)image andFinishBlock:(void (^)(NSArray *))finishBlock andFaileBlock:(void (^)(NSString *))failBlock;
//举报论坛评论
- (void)postBBSCreport:(NSString *)bid withCid:(NSString *)cid andFinishBlock:(void (^)(NSArray *))finishBlock andFaileBlock:(void (^)(NSString *))failBlock;
//帖子点赞
- (void)postBBSTiBaGood:(NSString *)bid andFinishBlock:(void (^)(NSArray *))finishBlock andFaileBlock:(void (^)(NSString *))failBlock;

@end
