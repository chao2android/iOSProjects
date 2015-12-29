//
//  TJSubjectViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJSubjectViewModel.h"

@implementation TJSubjectViewModel


- (void)postBBSCommentList:(NSString *)bid withPage:(NSString *)page withCommentid:(NSString *)commentid andFinishBlock:(void (^)(NSArray *))finishBlock andFaileBlock:(void (^)(NSString *))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsAddTieba",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bid,@"bid",
                         page,@"page",
                         commentid,@"commentid",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(id x) {
        TLog(@"%@",x);
        
        
    } error:^(NSError *error) {
        
    }];
}
//添加评论
- (void)postBBSAddComment:(NSString *)bid withUserID:(NSString *)uid withParent:(NSString *)Parent withReplyid:(NSString *)Replyid withContent:(NSString *)content withImage:(NSArray *)image andFinishBlock:(void (^)(NSArray *))finishBlock andFaileBlock:(void (^)(NSString *))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsAddTieba",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bid,@"bid",
                         uid,@"uid",
                         Parent,@"Parent",
                         Replyid,@"Replyid",
                         content,@"content",
                         image,@"$_FILES[0]",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(id x) {
        TLog(@"%@",x);
        
        
    } error:^(NSError *error) {
        
    }];
}
//举报论坛评论
- (void)postBBSCreport:(NSString *)bid withCid:(NSString *)cid andFinishBlock:(void (^)(NSArray *))finishBlock andFaileBlock:(void (^)(NSString *))failBloc
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsAddTieba",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bid,@"bid",
                         cid,@"cid",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(id x) {
        TLog(@"%@",x);
        
        
    } error:^(NSError *error) {
        
    }];
}
//帖子点赞
- (void)postBBSTiBaGood:(NSString *)bid andFinishBlock:(void (^)(NSArray *))finishBlock andFaileBlock:(void (^)(NSString *))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsAddTieba",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bid,@"cid",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(id x) {
        TLog(@"%@",x);
        
        
    } error:^(NSError *error) {
        
    }];
}

@end
