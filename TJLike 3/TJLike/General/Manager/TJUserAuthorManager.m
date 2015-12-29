//
//  TJUserAuthorManager.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJUserAuthorManager.h"
#import "TJUserModel.h"
#import "TJBaseViewController.h"
#import "TJLoginRegisterViewController.h"

@interface TJUserAuthorManager()

@property (nonatomic, strong)TJBaseViewController *VC;

@end

@implementation TJUserAuthorManager

+(instancetype)registerPageManager
{
    static dispatch_once_t onceToken;
    static TJUserAuthorManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initRegisterManager];
        
    });
    
    return manager;
    
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initRegisterManager
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)applyFinishBlock
{
    if (self.finishBlock) {
        self.finishBlock();
        self.finishBlock = nil;
    }
}
- (void)applyFailedBlock
{
    if (self.failedBlock) {
        self.failedBlock();
        self.failedBlock = nil;
    }
}

- (void)authorizationLogin:(id)enterVC EnterPage:(EnterPresentMode)pageMode andSuccess:(RegistFinish)scccessBlock andFaile:(RegistFailed)faileBlock
{
    
    self.VC = (TJBaseViewController *)enterVC;
    self.finishBlock = scccessBlock;
    self.failedBlock = faileBlock;
    self.enterPage  = pageMode;
    [self gainCurrentStateForUserLoginAndBind];
    [self installNormalLevel];
}
//设置普通级别
- (void)installNormalLevel
{
    switch (self.loginStatus) {
        case CurrentUserState_Main:
        {
//            [self intoUserInfoEditVC];
            [self applyFinishBlock];
        }
            break;
        case CurrentUserState_ThirdParty:
        {
//            [self intoUserInfoEditVC];
            [self applyFinishBlock];
        }
            break;
        case CurrentUserState_None:
        {
            
            [self intoUserInfoLoginVC];
        }
            break;
        default:
            break;
    }
}

- (void)intoUserInfoLoginVC
{
    if (self.enterPage == EnterPresentMode_push) {
        TJLoginRegisterViewController *loginVC = [[TJLoginRegisterViewController alloc] init:EnterType_Push];
        loginVC.loginFinish = ^(id info){
              [self checkCurrentState];
        };
        [self.VC.naviController pushViewController:loginVC animated:YES];
        
    } else {
        [self presentUserInfoLoginVC];
    }
}
- (void)presentUserInfoLoginVC
{
    
    EnterType enterType = (EnterType)self.enterPage;
    TJLoginRegisterViewController *loginVC = [[TJLoginRegisterViewController alloc] init:enterType];
    
    loginVC.loginFinish = ^(id info){
        [self checkCurrentState];
    };

    [self.VC presentViewController:loginVC animated:YES completion:^{
        
    }];
}

-(void)checkCurrentState
{
    if ([self gainCurrentStateForUserLoginAndBind]!=CurrentUserState_None) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissCurrentVC];
        });
        [self applyFinishBlock];
    } else {
        [self applyFailedBlock];
    }
}
- (void)dismissCurrentVC
{
    if (self.enterPage == EnterPresentMode_push) {
        [self.VC.naviController popViewControllerAnimated:YES];
    } else if (self.enterPage == EnterType_PresentPor){
        [self.VC.naviController.viewControllers.lastObject dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        
    }
}


- (CurrentUserState)gainCurrentStateForUserLoginAndBind
{
    TJUserModel *userModel = UserManager.userInfor;
    if (userModel) {
        if(userModel.userName && !StringEqual(userModel.userName, @""))
        {
            self.loginStatus = CurrentUserState_Main;
        }
        else{
            self.loginStatus = CurrentUserState_ThirdParty;
        }
    }
    else{
        self.loginStatus = CurrentUserState_None;
    }
    return self.loginStatus;

}


@end
