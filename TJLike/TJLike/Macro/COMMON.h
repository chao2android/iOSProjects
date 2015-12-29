//
//  COMMON.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#ifndef TJLike_COMMON_h
#define TJLike_COMMON_h

#import "ReactiveCocoa/ReactiveCocoa.h"
#import "AFNetworking.h"
#import "TJAppContext.h"
#import "TJHttpClient.h"
#import "TJUserManager.h"
#import "TJUserAuthorManager.h"
#import "UIUtil.h"
#import "ComUtil.h"
#import "UIView+Toast.h"
#import "UIImage+WiseTV.h"

#pragma mark - Log

#ifdef DEBUG
#   define TLog(...) NSLog((@"%s [Line %d] %@"), __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#   define TLog(...)
#endif

#ifdef DEBUG
#   define TAssert(condition) NSAssert(condition, ([NSString stringWithFormat:@"file name = %s ---> function name = %s at line: %d", __FILE__, __FUNCTION__, __LINE__]));
#else
#   define TAssert(...)
#endif

#define SafePerformSelector(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define TJZOUNAI_ADDRESS_URL   @"http://www.zounai.com/index.php/api/"



#pragma mark - Size
//device physical pixels scale
#define SCREEN_PHISICAL_SCALE   (SCREEN_WIDTH/320)

//屏幕bounds
#define SCREEN_BOUNDS       (AppContext.deviceInfo.screenBounds)
//屏幕宽
#define SCREEN_WIDTH        (AppContext.deviceInfo.screenWidth)
//屏幕高
#define SCREEN_HEIGHT       (AppContext.deviceInfo.screenHeight)

//Tabbar高
#define TABBAR_HEIGHT           (49.0)
//nav高
#define NAVIBAR_HEIGHT          (44.0)
//状态条高
#define STATUSBAR_HEIGHT        (20.0)

#pragma mark - Color
//十六进制设置颜色 如：UIColorFromRGB(0xf4f3f2)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//三色和alpha设置yanse 如：COLOR(48, 48, 52, 1.0)
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//获取沙盒目录地址
#define DOCUMENTPATHS  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)


#pragma mark - Function
#define AppContext              [TJAppContext sharedContext]
#define HttpClient              [TJHttpClient sharedClient]
#define UserManager             [TJUserManager sharePageManager]
#define UserAuthorManager       [TJUserAuthorManager registerPageManager]

#define SHARE_DEFAULTS          [NSUserDefaults standardUserDefaults]
#define SHARE_APPLICATION       [UIApplication sharedApplication]
#define SHARE_WINDOW            SHARE_APPLICATION.keyWindow
#define NOTIFICATION_CENTER     [NSNotificationCenter defaultCenter]

#define ImageCache(para)        [UIImage imageNamed:(para)]
#define PointToValue(p)         [NSValue valueWithCGPoint:p]
#define ValueToPoint(v)         [v CGPointValue]
#define ClearObj(para)          (para = nil)
#define StringNotEmpty(str)     (str && (((NSString *)str).length > 0))
#define StringEqual(v, para)    [v isEqualToString:para]
#define StringForce(para)       ((para==nil)?@"":para)
#define IntegerString(num)      [NSString stringWithFormat:@"%zd", num]

#define StringToDate(str, format)   [ComUtil stod:str fs:format]
#define DateToString(date, format)  [ComUtil dtos:date fs:format]

#define WTV_STANDARD_TIMEZONE                @"Asia/Shanghai"
#define WTV_DATEFORMAT_TVOD                  @"yyyyMMddHHmmss"
#define WTV_DATEFORMAT_DAYUNIT               @"yyyyMMdd"

#pragma marl - string and key
#define NAVTITLE_COLOR_KEY  @"titleColor"
#define NAVTITLE_FONT_KEY   @"titleFont"

static NSString *UserLginInfo=@"UserLoginInfo";
static NSString *UserId=@"UserId";

#endif
