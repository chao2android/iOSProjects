//
//  TJForumViewModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJForumViewModel : NSObject
/**
 *  海报监听数组
 */
@property (nonatomic, strong) NSArray  *posterInfoArr;
/**
 *  四个热点数组
 */
@property (nonatomic, strong) NSArray  *hotInfoArr;
/**
 *  热门数组
 */
@property (nonatomic, strong) NSArray  *hotListArr;
/**
 *  版块分类数组
 */
@property (nonatomic, strong) NSArray  *forumArr;

#pragma mark -- host Operation
/**
 *  帖子热点推荐四个
 *
 *  @param finishBlock <#finishBlock description#>
 *  @param failedBlock <#failedBlock description#>
 */
- (void)requestBBsHotCommendFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock;
/**
 *  帖子热点轮播图
 *
 *  @param finishBlock <#finishBlock description#>
 *  @param failedBlock <#failedBlock description#>
 */
- (void)requestBBsHotFocusFinish:(void (^)(NSArray * results))finishBlock andFailed:(void (^)(NSString *errer))failedBlock;
/**
 *  加载帖子热点列
 *  @param pageIndex   分页数
 *  @param finishBlock <#finishBlock description#>
 *  @param failedBlock <#failedBlock description#>
 */
- (void)requestBBsHotListPage:(int)pageIndex andFinish:(void (^)(NSArray * results))finishBlock andFailed:(void (^)(NSString *errer))failedBlock;
/**
 *  获得贴吧板块分类
 *
 *  @param finishBlock <#finishBlock description#>
 *  @param failedBlock <#failedBlock description#>
 */
- (void)requestBBsCatagoryFinish:(void (^)(NSArray * results))finishBlock andFailed:(void (^)(NSString *errer))failedBlock;


/**
 *  获得一个帖子的内容
 *
 *  @param bbsID       一个帖子的ID
 *  @param finishBlock <#finishBlock description#>
 *  @param failedBlock <#failedBlock description#>
 */
- (void)requestBBsContent:(id)bbsID andFinish:(void (^)(void))finishBlock andFailed:(void (^)(void))failedBlock;




@end
