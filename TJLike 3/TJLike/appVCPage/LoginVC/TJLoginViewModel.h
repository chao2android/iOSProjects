//
//  TJLoginViewModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJLoginViewModel : NSObject


- (void)postThirdLoginUserInfo:(NSString *)jasonStr finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock;
/**
 *  登录
 *
 *  @param userName
 *  @param password
 *  @param finishBlock
 *  @param failedBlock
 */
- (void)postLoginUserInfo:(NSString *)userName andPassWord:(NSString *)password finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock;

@end
