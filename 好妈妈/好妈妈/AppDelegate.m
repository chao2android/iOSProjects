//
//  AppDelegate.m
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WBApi.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "TuiSongTongZhi.h"
#import "BangzhuViewController.h"
#import "VersionManager.h"
#import "ADLoadManager.h"
#import "MobClick.h"
#import "UserLocationManager.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}


# pragma mark -
# pragma mark - remotion Notification
#pragma mark -
#pragma mark -注册消息推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog (@"errorerrorerrorerror---》%@",error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    //在此时设置解析notification，并展示提示视图
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒"
                          
                                                    message:notification.alertBody
                          
                                                   delegate:nil
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
    
    application.applicationIconBadgeNumber = 0;
    [TuiSongTongZhi RemoveLocalNotication:[notification.userInfo valueForKey:@"key"]];
}

#pragma mark - 获取DeviceToken(手机令牌)
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //获取deviceToken；
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSLog(@"deviceToken---->%@",deviceToken);
    
    NSMutableString* tokenString = [NSMutableString stringWithString:[[deviceToken description]uppercaseString]];
    [tokenString replaceOccurrencesOfString:@"<" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tokenString.length)];
    [tokenString replaceOccurrencesOfString:@">" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tokenString.length)];
    [tokenString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tokenString.length)];
    
    NSLog(@"Token: %@",tokenString);
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TokenString"];
    [[NSUserDefaults standardUserDefaults] setValue:tokenString forKey:@"TokenString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"We successfully registered forpush notifications");
}

#pragma mark -
#pragma mark - 处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *dict = [userInfo objectForKey:@"aps"];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        self.mMsgID = [dict objectForKey:@"tid"];
    }
    NSLog(@"didReceiveRemoteNotification:%@", userInfo);
    //设为0；
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

//从后台回到应用的时候 推送消息设置为0；
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (self.mMsgID) {
        [UserInfoManager Share].mMsgID = self.mMsgID;
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"Tuisongtishi" object:nil];
        exit(0);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)initializePlat
{
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    [MobClick updateOnlineConfig];
    
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    //    [ShareSDK connectSinaWeiboWithAppKey:@"4118436256"
    //                               appSecret:@"11fbe693e5bb08b8146ff27a091a29fc"
    //                             redirectUri:@"http://app.manymike.com/index.php?c=users&a=callback"];
    [ShareSDK connectSinaWeiboWithAppKey:@"4238369003"
                               appSecret:@"7e708278e6ac0e34fdc88400bf37c910"
                             redirectUri:@"http://appgo.cn"];
    
    //    [ShareSDK connectSinaWeiboWithAppKey:@"4238369003"
    //                               appSecret:@"7e708278e6ac0e34fdc88400bf37c910"
    //                             redirectUri:@"http://app.manymike.com/index.php?c=users&amp;a=callback"];
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801489282"
                                  appSecret:@"6f184fad1558fd2a50c062d8644ee1a5"
                                redirectUri:@"http://haomama.mum360.com"
                                   wbApiCls:[WBApi class]];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100570832"
                           appSecret:@"0f5f77bad08d11b60538c37d71ec45d2"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectWeChatWithAppId:@"wx17609a0a78f30206" wechatCls:[WXApi class]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [ShareSDK registerApp:@"ab4558f213b"];
    
    [[VersionManager Share] GetAppDetail:@"738956677"];
    
    
    //分享
    [self initializePlat];
    
    // Override point for customization after application launch.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"qidong"]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString* date = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tixingshoufei"];
        [[NSUserDefaults standardUserDefaults] setValue:date forKey:@"tixingshoufei"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"qidong"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    qidongImageView=[[UIImageView alloc]initWithFrame:[ADLoadManager Share].mADFrame];
    qidongImageView.image=[ADLoadManager Share].mADImage;
    qidongImageView.backgroundColor=[UIColor whiteColor];
    
    BOOL bDefaultAD = [ADLoadManager Share].mbDefaultAD;
    
    UIImageView * backImageView=[[UIImageView alloc] initWithFrame:CGRectMake((Screen_Width-200)/2, Screen_Height-28, 200, 1)];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tiao1@2x副本" ofType:@"png"]];
    backImageView.hidden = !bDefaultAD;
    [qidongImageView addSubview:backImageView];
    
    donghuaImageView=[[UIImageView alloc]initWithFrame:CGRectMake(backImageView.frame.origin.x, backImageView.frame.origin.y, 0, 1)];
    donghuaImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tiao2@2x" ofType:@"png"]];
    donghuaImageView.backgroundColor=[UIColor clearColor];
    donghuaImageView.hidden = !bDefaultAD;
    [qidongImageView addSubview:donghuaImageView];
    [donghuaImageView release];
    
    butImageView=[[UIImageView alloc] initWithFrame:CGRectMake(backImageView.frame.origin.x, backImageView.frame.origin.y-8.5, 18, 18)];
    butImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faguang@2x" ofType:@"png"]];
    butImageView.hidden = !bDefaultAD;
    [qidongImageView addSubview:butImageView];
    //    donghuaImageView.transform = CGAffineTransformScale([self transformForOrientation], 0.5, 0.5);
    
    [[UserLocationManager Share] StartLocation];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"shifoulogin"])
    {
        qidongImageView.frame=CGRectMake(0, 0, Screen_Width,KUIOS_7(Screen_Height-20));
        
        
        LoginViewController * loginview=[[LoginViewController alloc]init];
        UINavigationController *loginNavigation=[[UINavigationController alloc]initWithRootViewController:loginview];
        self.window.rootViewController=loginNavigation;
        [loginview release];
        [loginNavigation release];
        [loginview.view addSubview:qidongImageView];
        [qidongImageView release];
    }
    else
    {
        NSDictionary *apsDict = [[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"];
        NSString * string=@"0";
        if (apsDict != nil)
        {
            string=@"3";
        }
        
        RootViewController * rootviewCotroller=[[RootViewController alloc]initWithNibName:string bundle:[NSBundle mainBundle]];
        
        if (apsDict != nil)
        {
            rootviewCotroller.selectedIndex=3;
            
        }
        else
        {
            
            rootviewCotroller.selectedIndex=0;
        }
        self.window.rootViewController=rootviewCotroller;
        [rootviewCotroller release];
        [rootviewCotroller.view addSubview:qidongImageView];
        [qidongImageView release];
    }
    [UIView animateWithDuration:2 animations:^{
        butImageView.frame=CGRectMake((Screen_Width-200)/2+5+195, butImageView.frame.origin.y, butImageView.frame.size.width, butImageView.frame.size.height);
        donghuaImageView.frame=CGRectMake(donghuaImageView.frame.origin.x, donghuaImageView.frame.origin.y, 200, donghuaImageView.frame.size.height);
        //        donghuaImageView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-200)/2, Screen_Height-28, 0, 1)];
        
        //        donghuaImageView.alpha=0.0;
        //        donghuaImageView.transform = CGAffineTransformScale([self transformForOrientation], 2, 1.5);
    }];
    [self performSelector:@selector(RemoveView) withObject:self afterDelay:3.0];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"tuisong"]) {
        
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"diyici"]){
        BangzhuViewController* bangzhu=[[BangzhuViewController alloc] init];
        bangzhu.shouming=YES;
        bangzhu.view.frame=CGRectMake(0, 20, Screen_Width, Screen_Height);
        [self.window addSubview:bangzhu.view];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"diyici"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        [bangzhu release];
    }
    
    return YES;
}
- (CGAffineTransform)transformForOrientation {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationLandscapeLeft == orientation) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (UIInterfaceOrientationLandscapeRight == orientation) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}
-(void)RemoveView
{
    if (qidongImageView) {
        [qidongImageView removeFromSuperview];
        qidongImageView=nil;
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
