//
//  AppDelegate.m
//  friendJY
//
//  Created by 高斌 on 15/2/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYAppDelegate.h"
#import "JYGuideController.h"
#import <ShareSDK/ShareSDK.h>

#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import "Toast+UIView.h"
#import "JYLocationManage.h"
#import "JYHttpServeice.h"
#import "JYShareData.h"
#import "JYChatService.h"
#import "JYMsgUpdate.h"
#import "MobClick.h"
#import <AddressBook/AddressBook.h>

@interface JYAppDelegate ()

@end

@implementation JYAppDelegate


+ (JYAppDelegate *)sharedAppDelegate
{
    return (JYAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)dealloc
{
    [[JYChatService sharedInstance] stopWork];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //获取通讯录权限
    
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool greanted, CFErrorRef error) {
        
//        dispatch_semaphore_signal(sema);
        
    });
    
    NSLog(@"%@",NSHomeDirectory());
    [MobClick startWithAppkey:@"556ffccd67e58e3d4b00254f" reportPolicy:BATCH   channelId:@"5000"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    
    [self observeNotification];
    
    [self initPlatform];
    [self getDataWithFiles];

    if (![SharedDefault boolForKey:@"hadRunApp"]) {
        
        [SharedDefault setBool:YES forKey:@"hadRunApp"];
        [SharedDefault synchronize];
        
        JYGuideController *guideController = [[JYGuideController alloc] init];
        JYNavigationController *guideNavController = [[JYNavigationController alloc] initWithRootViewController:guideController];
        [self.window setRootViewController:guideNavController];

    }else{

        BOOL isAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"];
        if (isAutoLogin) {
            //自动登录
            [self requestAutoLogin];
            
        } else {
            JYLoginController *loginController = [[JYLoginController alloc] init];
            JYNavigationController *loginNav = [[JYNavigationController alloc] initWithRootViewController:loginController];
            [self.window setRootViewController:loginNav];
        }
    }
    //角标清0
    [UIApplication sharedApplication].applicationIconBadgeNumber= 0;
    
    //注册百度的push通知
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
#warning 上线 AppStore 时需要修改 pushMode
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    //API Key： ay1Ni09iB3vePWq3G9SCXBr0
    [BPush registerChannel:launchOptions apiKey:@"oVk3XAO8C03Ve9MAfC7uaA4A" pushMode:BPushModeProduction isDebug:NO];
    //[BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }

    hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"] ;//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    //开始定位
//    [self startLocation];
//    [NSThread detachNewThreadSelector:@selector(startLocation) toTarget:self withObject:nil];

    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"currentViewControllerIsChat"];
    
    [self.window makeKeyAndVisible];
    return YES;
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"this deviceToken:%@",deviceToken);
    //    NSString * tm =  [NSString stringWithFormat:@"%@",deviceToken];
    //    [AZXHelpers showAlertWithTitle:tm];
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"pushDeviceToken"];
    
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"receivePushMsg:%@",userInfo);
    //    NSData *jsonData = [userInfo dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *err;
    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
    //                                                        options:NSJSONReadingMutableContainers
    //                                                          error:&err];
    
    //是否在当前应用里面
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
//        
//        NSString *temp = [accountDefaults objectForKey:@"currentViewControllerIsChat"];
//        if(![temp isEqualToString:@"1"]){
//            NSString *alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//            shareWindowStatusBar = [[JYShareWindowStatusBar alloc] init];
//            [shareWindowStatusBar showStatusWithMessage:alertStr];
//            
//            [self playSound];
//            [self shakeDevice];
//        }
        
        //[UIApplication sharedApplication].applicationIconBadgeNumber= 4;
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber= [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
        
    }
    
    
    [BPush handleNotification:userInfo];
//    NSString *cmd  = [userInfo objectForKey:@"cmd"];
    
//    if([cmd intValue]== 120){//120手机在其它地方登录，退出
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAutoLogin"];
//        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"uid"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotification object:nil userInfo:nil];
//    } else if ([cmd intValue] == 130) { // 推荐用户，进入到用户详情页面
//        [[NSUserDefaults standardUserDefaults] setObject:cmd forKey:@"cmd"];
//        [[NSUserDefaults standardUserDefaults] setObject:ToString(userInfo[@"uid"]) forKey:@"recommendUid"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    } else if ([cmd intValue] == 133) { // 话题详情
//        [[NSUserDefaults standardUserDefaults] setObject:cmd forKey:@"cmd"];
//        [[NSUserDefaults standardUserDefaults] setObject:ToString(userInfo[@"uid"]) forKey:@"topicUid"];
//        [[NSUserDefaults standardUserDefaults] setObject:ToString(userInfo[@"nick_name"]) forKey:@"nick_name"];
//        [[NSUserDefaults standardUserDefaults] setObject:ToString(userInfo[@"subjectid"]) forKey:@"subjectid"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    } else if ([cmd intValue] == 134) { // 话题广场
//        
//        [[NSUserDefaults standardUserDefaults] setObject:cmd forKey:@"cmd"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//    } else {
//        [[NSUserDefaults standardUserDefaults] setObject:cmd forKey:@"cmd"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    
    //同步更新用户信再发notification
//    [[AZXMessageDataUpdata shareInstance] updateChatUserList:0 pageSize:@"1" cycle:NO synchronous:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kApnsPushMessageNotification object:nil userInfo:userInfo];
//    //每次收到通知都刷新一下，未读记录数
//    [[AZXMessageDataUpdata shareInstance] updateNewUnreadMessageCount];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}


#pragma mark Push Delegate
- (void)onMethod:(NSString*)method response:(NSDictionary*)data
{
    NSLog(@"%@",data);
    if ([BPushRequestMethodBind isEqualToString:method])
    {
        //NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        //存储百度推送返回来的信息
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"bindBaiduPushInfomation"];
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"程序进入后台");
//    [[JYChatService sharedInstance] stopWork];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"程序激活");
    BOOL isAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"];
    if (isAutoLogin) {
        [self requestHoldOn];
        [[JYChatService sharedInstance] startWork];
    }
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
     NSLog(@"%@---%@",[url absoluteString],sourceApplication);
//    [JYHelpers showAlertWithTitle:[NSString stringWithFormat:@"%@---%@",[url absoluteString],sourceApplication]];
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

//注册通知
- (void)observeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kLoginSuccessNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerAndUpMobileListSuccess:) name:kRegisterAndUpMobileListSuccessNotification object:nil];
}

- (void)getDataWithFiles
{
    NSString *profile_plist_path = [[NSBundle mainBundle] pathForResource:@"profile" ofType:@"plist"];
    NSDictionary *profile_plist_dict = [[NSDictionary alloc] initWithContentsOfFile:profile_plist_path];
    [[JYShareData sharedInstance] setProfile_dict:profile_plist_dict];
    
    
    NSString *city_plist_path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSArray *city_plist_array = [[NSArray alloc] initWithContentsOfFile:city_plist_path];
    [[JYShareData sharedInstance] setCity_array:city_plist_array];
    
    NSString *province_plist_path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    NSArray *province_plist_array = [[NSArray alloc] initWithContentsOfFile:province_plist_path];
    [[JYShareData sharedInstance] setProvince_array:province_plist_array];
    
    NSString *province_city_code_plist_path = [[NSBundle mainBundle] pathForResource:@"province_city_code" ofType:@"plist"];
    NSDictionary *province_city_code_plist_dict = [[NSDictionary alloc] initWithContentsOfFile:province_city_code_plist_path];
    [[JYShareData sharedInstance] setCity_code_dict:[province_city_code_plist_dict objectForKey:@"101"]];
    [[JYShareData sharedInstance] setProvince_code_dict:[province_city_code_plist_dict objectForKey:@"100"]];
    
    NSString *emoji_plist_path = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
    NSArray *emojiList = [[NSArray alloc] initWithContentsOfFile:emoji_plist_path];
    [[JYShareData sharedInstance] setEmoji_array:emojiList];
}

//初始化第三方平台
- (void)initPlatform
{
    [ShareSDK registerApp:SHARE_SDK_APP_KEY];
    
//    [ShareSDK connectWeChatWithAppId:WX_APP_ID
//                           wechatCls:[WXApi class]];
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:WX_APP_ID
                           appSecret:WX_APP_SECRET
                           wechatCls:[WXApi class]];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    //微信好友
//    [ShareSDK connectWeChatSessionWithAppId:WX_APP_ID appSecret:WX_APP_SECRET wechatCls:[WXApi class]];
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:SINA_APP_KEY
                               appSecret:SINA_APP_SECRET
                             redirectUri:@"http://www.iyouxun.com"];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:QQ_APP_ID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:TENCENTWB_APP_KEY
                                  appSecret:TENCENTWB_APP_SECRET
                                redirectUri:@"http://www.iyouxun.com"
                                   wbApiCls:[WeiboApi class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQ_APP_ID
                           appSecret:QQ_APP_KEY
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    //连接邮件
    [ShareSDK connectMail];
}

//开始定位
- (void)startLocation
{
    if (SIMULATOR) {
        [[NSUserDefaults standardUserDefaults] setObject:@"116.398135" forKey:@"Longitude"];
        [[NSUserDefaults standardUserDefaults] setObject:@"39.972313" forKey:@"Latitude"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Locationed"];
    } else {
        [[JYLocationManage shareInstance] startLocationManager];
    }
}

- (void)showTip:(NSString *)strMsg
{
    [self.window makeToast: strMsg duration:1.5 position:@"center"];
}

- (void)showTipTop:(NSString *)strMsg
{
    [self.window makeToast: strMsg duration:1.0 position:@"top"];
}
- (void)showPromptTip:(NSString*)strMsg withTipCenter:(CGPoint)center{
    NSValue *pointValue = [NSValue valueWithCGPoint:center];
    [self.window makeToast:strMsg duration:1.0 position:pointValue];
}
- (void)loadMainController
{
    JYTabBarController *mainTabBarContr = [[JYTabBarController alloc] init];
    [self setMainTabBarController:mainTabBarContr];
    [self.window setRootViewController:self.mainTabBarController];
}

#pragma mark - notification
- (void)loginSuccess
{
    [[JYChatService sharedInstance] startWork];
////    [NSThread detachNewThreadSelector:@selector(startLocation) toTarget:self withObject:nil];
    [self startLocation];
//    [self.window setRootViewController:_mainTabBarController];
    [self loadMainController];
    
    //绑定百度push
    [[JYMsgUpdate sharedInstance] bindServiceWhenReceviceBaiduBindid];
    
    //刷新未读信息数
    [[JYMsgUpdate sharedInstance] updateNewUnreadMessageCount];
}

//- (void)registerAndUpMobileListSuccess:(NSNotification *)notification
//{
//    [self.window setRootViewController:_mainTabBarController];
//}

#pragma mark - request
- (void)requestAutoLogin
{
    //下面两行，是清除保存的cookies的信息，只有当登录操作时才有
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"sessionCookies"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"login" forKey:@"mod"];
    [parametersDict setObject:@"auto_login" forKey:@"func"];
    [parametersDict setObject:token forKey:@"token"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            //自动登录成功
            NSString *uid = [responseObject objectForKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
            [defaults setObject: cookiesData forKey: @"sessionCookies"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self loginSuccess];
            
        } else {
        
            //自动登录失败
            JYLoginController *loginController = [[JYLoginController alloc] init];
            JYNavigationController *loginNav = [[JYNavigationController alloc] initWithRootViewController:loginController];
            [self.window setRootViewController:loginNav];
            
        }
        
    } failure:^(id error) {
        
        //自动登录失败
        JYLoginController *loginController = [[JYLoginController alloc] init];
        JYNavigationController *loginNav = [[JYNavigationController alloc] initWithRootViewController:loginController];
        [self.window setRootViewController:loginNav];
        
    }];
}
//防止掉线，每次程序激活都会重新登录一下，更新cookies
- (void)requestHoldOn
{
    //下面两行，是清除保存的cookies的信息，只有当登录操作时才有
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"sessionCookies"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"login" forKey:@"mod"];
    [parametersDict setObject:@"auto_login" forKey:@"func"];
    [parametersDict setObject:token forKey:@"token"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            
            //自动登录成功
            NSString *uid = [responseObject objectForKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject: cookiesData forKey: @"sessionCookies"];
            
        }
        
    } failure:^(id error) {

    }];
}

#warning 调节系统振动与声音时调用
// 振动
-(void)shakeDevice
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:kUDPushShakeOption])
        return;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

// 声音
- (void)playSound
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:kUDPushSoundOption])
        return;
    
    AudioServicesPlaySystemSound(1000);
    return;
    
    if (!_soundID)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"notify" ofType:@"caf"];
        if (!path)
            return;
        
        NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
        if (aFileURL != nil)
        {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)aFileURL,
                                                              &aSoundID);
            if (error != kAudioServicesNoError)
                return;
            
            _soundID = aSoundID;
        }
    }
    
    AudioServicesPlaySystemSound(_soundID);
}

//监听到网络状态改变
- (void) reachabilityChanged: (NSNotification* )note

{
    
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
    
}


//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach

{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == kNotReachable)
    {
        [JYShareData sharedInstance].networkStates = YES;
        NSLog(@"\n有网络\n");
    }
    else
    {
        [JYShareData sharedInstance].networkStates = NO;
        NSLog(@"\n无网络\n");
        //[self showTip:@"网络连接错误"];
    }
    
}
@end
