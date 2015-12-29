//
//  AppDelegate.h
//  friendJY
//
//  Created by 高斌 on 15/2/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYTabBarController.h"
#import "JYNavigationController.h"
#import "BPush.h"
#import "JYShareWindowStatusBar.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Reachability.h"

@interface JYAppDelegate : UIResponder <UIApplicationDelegate,BPushDelegate>
{
    JYTabBarController *_mainTabBarController;
//    JYNavigationController *_guideNaviController;
    JYShareWindowStatusBar *shareWindowStatusBar ;//顶部黑色通知栏
    SystemSoundID _soundID;   // 系统声音
@private
    Reachability *hostReach; //监听网络变化
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) float autoSizeScaleX;
@property (assign, nonatomic) float autoSizeScaleY;
@property (nonatomic, strong) JYTabBarController *mainTabBarController;

+ (JYAppDelegate *)sharedAppDelegate;

- (void)showTip:(NSString *)strMsg;
- (void)showTipTop:(NSString *)strMsg;
- (void)showPromptTip:(NSString*)strMsg withTipCenter:(CGPoint)center;
//绑定用户第三方登录成功调用自动登录
- (void)requestAutoLogin;
// 振动
-(void)shakeDevice;

// 声音
- (void)playSound;
@end

