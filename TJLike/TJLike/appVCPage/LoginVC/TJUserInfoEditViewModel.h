//
//  TJUserInfoEditViewModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJUserInfoEditViewModel : NSObject


- (void)postPerfectUserInfo:(NSString *)nickname anduid:(NSString *)uid andsignature:(NSString *)signature andbirthday:(NSString *)birthday andsex:(NSString *)sex finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock;

- (void)postBindThirdWeibo:(NSString *)weibo anduid:(NSString *)uid andweiboicon:(NSString *)weiboicon andtoken:(NSString *)token finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock;


@end
