

//
//  AppDelegate.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/19.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "BPush.h"

#import "VideoDetailViewController.h"
#define SUPPORT_IOS8 1

@implementation AppDelegate
//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    
    RootViewController * root = [[RootViewController alloc] init];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nvc;
    
    //字体大小
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"font"] integerValue]==0) {
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"16" forKey:@"font"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //消息推送
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"apns"] isEqualToString:@"2"]) {
    
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"apns"];//这个表示是打开的
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //wifi环境下播放视频
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"wifi"] isEqualToString:@"2"]) {
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"wifi"];//这个表示是打开的
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    //设置友盟的appkey
    [UMSocialData setAppKey:@"54a3b6b1fd98c5b896000c03"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx976f0ba15f6097c9" appSecret:@"500955c401d8655926cf57f352a3746e" url:[NSString stringWithFormat:@"%@%@",kShareUrl,[[NSUserDefaults standardUserDefaults]objectForKey:@"sourceId"]]];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1103598709" appKey:@"F20CyjyCIavPzvMQ" url:nil];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    
    
    //设置状态栏上面的运营商 时间和电量都是白色字体的  还有在info.plist里面加View controller-based status bar appearance  no
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //百度云推送
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    
    [application setApplicationIconBadgeNumber:0];
#if SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
#endif
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

    
    //处理推送消息
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo) {
        [self handleRemoteNotification:application userInfo:userInfo];
    }

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"apns"] isEqualToString:@"2"]) {
        
        
        
        
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];

    }else{
    
        
    }
    
    return YES;
}
- (void)handleRemoteNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo {

   // [DxyCustom showAlertViewTitle:@"tishi" message:@"handleRemoteNotification" delegate:nil];
    
    
    [BPush handleNotification:userInfo]; // 可选
    
    NSString * idString = [userInfo objectForKey:@"id"];
    
    [self pushViewControllerWithId:idString];

    
    
}

#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
#endif



#pragma mark - 分享的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


#pragma mark - 推送的   中调用API，注册device token：
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    [BPush registerDeviceToken:deviceToken]; // 必须
    
    [BPush bindChannel]; // 必须。可以在其它时机调用，只有在该方法返回（通过onMethod:response:回调）绑定成功时，app才能接收到Push消息。一个app绑定成功至少一次即可（如果access token变更请重新绑定）。
}

#pragma mark - 实现BPushDelegate协议，必须实现方法onMethod:response:：
- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
    }
}

#pragma mark - 调用API，处理接收到的Push消息：
- (void)application:(UIApplication *)application  didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //[DxyCustom showAlertViewTitle:@"tishi" message:@"didReceiveRemoteNotification" delegate:nil];

    [BPush handleNotification:userInfo]; // 可选
    
    NSString * idString = [userInfo objectForKey:@"id"];
    
    [self pushViewControllerWithId:idString];
    
}

- (void)pushViewControllerWithId:(NSString * )idString{
    
    VideoDetailViewController * detail = [[VideoDetailViewController alloc]init];
    detail.source_id = idString;
    detail.titleNameString = @"热点";
    detail.hidesBottomBarWhenPushed = YES;
    UINavigationController *NVC =  (UINavigationController *)self.window.rootViewController;
    [NVC pushViewController:detail animated:YES];
    detail.hidesBottomBarWhenPushed = NO;
    
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //[DxyCustom showAlertViewTitle:@"tishi" message:@"didReceiveLocalNotification" delegate:nil];
    


}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString * idString = [userInfo objectForKey:@"id"];
    
    [self pushViewControllerWithId:idString];
    NSLog(@"%@",userInfo);
}

- (void)handleRemoteNotificationWidhAlertView:(UIApplication *)application userInfo:(NSDictionary *)userInfo {
    if(userInfo){
        NSLog(@"%@",userInfo);
        //[DxyCustom showAlertViewTitle:@"tishi" message:@"handleRemoteNotificationWidhAlertView" delegate:nil];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    //[DxyCustom showAlertViewTitle:@"提示" message:@"applicationWillEnterForeground" delegate:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[DxyCustom showAlertViewTitle:@"tishi" message:@"从后台恢复" delegate:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
