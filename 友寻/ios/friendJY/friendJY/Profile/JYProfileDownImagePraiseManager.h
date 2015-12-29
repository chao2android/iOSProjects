//
//  JYProfileDownImagePraiseManager.h
//  friendJY
//
//  Created by aaa on 15/7/2.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYProfileDownImagePraiseManager : NSObject


//+(NSMutableDictionary *)DownImagePraiseDate:(NSDictionary *)imageDict;
//andFinishBlock:(void(^)(BOOL hasMore))finishBlock
+ (void)DownImagePraiseDate:(NSDictionary *)imageDict andSucceedBlock:(void(^)(NSMutableDictionary *imagePraiseDict)) SucceedBlock;
+ (void)DownImagePraiseDate:(NSDictionary *)imageDict andUid:(NSString *)fuid andSucceedBlock:(void(^)(NSMutableDictionary *imagePraiseDict)) SucceedBlock;

+ (void)PraiseImage:(NSString *)uid andFuid:(NSString *)fuid andPid:(NSString *)pid andSucceedBlock:(void(^)())succeedBlock andFaildBlock:(void(^)(id error))faildBlock;

+ (void)CanclePraiseImage:(NSString *)uid andFuid:(NSString *)fuid andPid:(NSString *)pid andSucceedBlock:(void(^)())succeedBlock andFaildBlock:(void(^)(id error))faildBlock;

@end
