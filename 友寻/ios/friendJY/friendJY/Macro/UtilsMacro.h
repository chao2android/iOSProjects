//
//  UtilsMacro.h
//  imAZXiPhone
//
//  Created by GAO on 14-6-30.
//  Copyright (c) 2014年 GAO. All rights reserved.
//

//这个文件放一些方便使用的宏定义
#ifndef imAZXiPhone_UtilsMacro_h
#define imAZXiPhone_UtilsMacro_h


#if 1
#define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif


#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RgbHex2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define SYSTEM_IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_0)
//#define SYSTEM_IS_IOS8 ([[UIDevice currentDevice].systemVersion floatValue])
#define SYSTEM_IS_IOS8 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
#define SYSTEM_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

#define UUID ([[[UIDevice currentDevice] identifierForVendor] UUIDString])


// 获取物理屏幕的尺寸
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenVisualHeight (kScreenHeight - kNavigationBarHeight - kStatusBarHeight)
#define kTabBarViewHeight 49
#define kStatusBarHeight 20
#define kNavigationBarHeight 44
#define kPickerViewHeight 216
#define kToolBarHeight 44
#define kStatusViewHeight 216 // 发消息的时候弹出的下面视图的高度
#define kCustomizeAnswerViewHeight 330 // 自定义答案视图的高度
#define kEnglishKeyboardHeight 216 //英文键盘输入高度
#define kChineseKeyboardHeight 252 //中文键盘输入高度
#define kNewsAdViewHeight 54.0f //动态页广告位高度
#define kPlazaExpressionPlankHeight 265
#define kNavigationBarTitleFontSize 15.0f
#define kEmojiKeyboardHeight 200 //表情键盘高度
#define kSendImageBgHeight 110 //发送图片视图高度
#define kKeyboardAnimationDuration 0.25f

#define GuideToAddressBookIndexpath5 5
#define GuideToAddressBookIndexpath15 15
#define GuideToAddressBookIndexpath25 25

#define CArrayLength(arr)                       (sizeof(arr) / sizeof(*(arr)))
#define GetStringFromCArraySafely(arr, idx)     (((idx) >= 0) && (((idx) < CArrayLength(arr))) ? (arr)[idx] : @"")
#define GetNumberFromCArraySafely(arr, idx)     (((idx) >= 0) && (((idx) < CArrayLength(arr))) ? (arr)[idx] : 0)
#define NSNumWithInt(i)                         ([NSNumber numberWithInt:(i)])
#define NSNumWithFloat(f)                       ([NSNumber numberWithFloat:(f)])
#define NSNumWithBool(b)                        ([NSNumber numberWithBool:(b)])
#define IntFromNSNum(n)                         ([(n) intValue])
#define FloatFromNSNum(n)                       ([(n) floatValue])
#define BoolFromNSNum(n)                        ([(n) boolValue])
#define ToString(o)                             [NSString stringWithFormat:@"%@", (o)]
#define MyFilePath(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:(fileName)]
#define SharedDefault [NSUserDefaults standardUserDefaults]
#define kMyProfileInfoPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_profileInfo",[SharedDefault objectForKey:@"uid"]]]

#endif
