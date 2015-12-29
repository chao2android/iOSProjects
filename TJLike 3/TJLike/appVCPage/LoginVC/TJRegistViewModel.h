//
//  TJRegistViewModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJRegistViewModel : NSObject

/**
 *  手机号注册
 *
 *  @param userName
 *  @param password
 *  @param code
 *  @param finishBlock
 *  @param failedBlock
 */
- (void)postPhoneRegisterUserInfo:(NSString *)userName andPassWord:(NSString *)password andCode:(NSString *)code finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock;

/**
 *  忘记密码
 *
 *  @param userName    <#userName description#>
 *  @param password    <#password description#>
 *  @param code        <#code description#>
 *  @param finishBlock <#finishBlock description#>
 *  @param failedBlock <#failedBlock description#>
 */
- (void)postForgetPassWord:(NSString *)userName andPassWord:(NSString *)password andRepassword:(NSString *)repassword andCode:(NSString *)code finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock;

/**
 *  短信验证
 *
 *  @param telphone    <#telphone description#>
 *  @param finishBlock <#finishBlock description#>
 *  @param failedBlock <#failedBlock description#>
 */
- (void)postSendNumbert:(NSString *)telphone finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock;

@end
