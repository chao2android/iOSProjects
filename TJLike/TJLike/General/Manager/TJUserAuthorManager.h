//
//  TJUserAuthorManager.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EnterPresentMode){
    EnterPresentMode_push = 0, //推页进入
    EnterPresentMode_present_por, //present进入
    EnterPresentMode_present_land //present进入
};

typedef NS_ENUM(NSInteger, CurrentUserState) {
    CurrentUserState_None     = 0,  //未登录
    CurrentUserState_Main,          //主用户登录，高级级别登录
    CurrentUserState_ThirdParty,    //第三方授权
};

typedef void(^RegistFinish)();
typedef void(^RegistFailed)();

@interface TJUserAuthorManager : NSObject

@property (nonatomic, assign) CurrentUserState  loginStatus;
@property (nonatomic, assign) EnterPresentMode     enterPage;
@property (nonatomic, copy)   RegistFinish  finishBlock;
@property (nonatomic, copy)   RegistFailed  failedBlock;

+ (instancetype)registerPageManager;
//获取当前用户登陆注册状态
- (CurrentUserState)gainCurrentStateForUserLoginAndBind;
//申请用户授权
- (void)authorizationLogin:(id)enterVC EnterPage:(EnterPresentMode)pageMode andSuccess:(RegistFinish)scccessBlock andFaile:(RegistFailed)faileBlock;


@end
