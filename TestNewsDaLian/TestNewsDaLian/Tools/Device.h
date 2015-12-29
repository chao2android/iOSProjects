//
//  Device.h
//  AirportMerchant
//
//  Created by dxy on 14-7-29.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#ifndef AirportMerchant_Device_h
#define AirportMerchant_Device_h
//手机屏幕的长度和高度
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
//获取手机的系统
#define kVersion [[[UIDevice currentDevice] systemVersion]floatValue]
//获取手机的设备号
//#define kUUID [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString]
#define kUUID @"d664b6f0e8348bd94b0bc9d5b3ce04dd"
//获取当前时间的时间戳格式
//#define kTimeSp [NSString stringWithFormat:@"%ld",(long)[[[NSDate date] dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]]] timeIntervalSince1970]]
#define kTimeSp @"1413106024"
//把设备号和时间戳两次MD5加密
#define kSource [[[[NSString stringWithFormat:@"ios%@",kUUID] MD5Hash] stringByAppendingString:kTimeSp] MD5Hash]
//接口地址
#define kUrlStr @"http://vnews.cdv.com/app/?app=newsapp&controller=iosapi&action="
//适配屏幕的高度  上面的20
#define DifferenceHeight ([[[UIDevice currentDevice] systemVersion] floatValue] < 7 ? 20 : 0)

#define defaultWebServiceUrl @"http://218.60.57.136:8989/WebService.asmx?wsdl"
#define defaultWebServiceNameSpace @"http://tempuri.org/"

#define kShareUrl @"http://218.60.57.136:8080/comment/vitem.jsp?id="



#endif
