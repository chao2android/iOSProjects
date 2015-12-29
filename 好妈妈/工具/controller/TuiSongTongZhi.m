//
//  TuiSongTongZhi.m
//  好妈妈
//
//  Created by 李 建伟 on 13-12-15.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "TuiSongTongZhi.h"

@implementation TuiSongTongZhi
+ (NSDate *)ChanJianTuiSongShiJianMenth1:(int)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date=[dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]] ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate * date2=[NSDate dateWithTimeInterval:(sender-1)*24*3600+6*3600 sinceDate:date];
    NSLog(@"dateFormatter %@",[dateFormatter stringFromDate:date2]);
    return date2;
}

+ (NSDate *)ChanJianTuiSongShiJianMenth:(int)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date=[dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]] ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate * date2=[NSDate dateWithTimeInterval:sender*24*3600+6*3600 sinceDate:date];
    NSLog(@"date2  %@",[dateFormatter stringFromDate:date2]);
    return date2;
}
+ (NSDate *)TuiSongShiJianMenth:(NSString *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate * date2=[dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 06:00:00",sender]];
    NSLog(@"%@",date2);
    return date2;
}
+ (BOOL)ShiFouJianTuiSongMenth:(NSDate *)sender
{
    if ([sender timeIntervalSinceDate:[NSDate date]]>0.000000) {
        return YES;
    }
    return NO;
}
//第二步：创建本地推送
+ (void)CteLocalNotification:(NSDate *)pushDate TuisongContent:(NSString *)aContent TuisongName:(NSString *)aName{
    // 创建一个本地推送
    
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    
    //设置10秒之后
//    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:tuosongshijian];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString * daStr = [dateFormatter stringFromDate:pushDate];
//    NSString * daStr1 = [dateFormatter stringFromDate:[NSDate date]];
//
    NSLog(@"daStr    %@   %@",daStr,aContent);
    if (notification != nil) {
        
        // 设置推送时间
        
        
        notification.fireDate = pushDate;
        
        
        // 设置时区
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        
        // 设置重复间隔
        
        
        notification.repeatInterval = kCFCalendarUnitDay;
        
        
        // 推送声音
        
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        
        // 推送内容
        
        
        notification.alertBody = aContent;
        
        
        //显示在icon上的红色圈中的数子
        
        
        notification.applicationIconBadgeNumber = 1;
        
        
        //设置userinfo 方便在之后需要撤销的时候使用
        
        
        NSDictionary *info = [NSDictionary dictionaryWithObject:aName forKey:@"key"];
        
        
        notification.userInfo = info;
        
        
        //添加推送到UIApplication       
        
        
        UIApplication *app = [UIApplication sharedApplication];
        
        
        [app scheduleLocalNotification:notification]; 
        
    }
}
//第三步：解除本地推送
+ (void)RemoveLocalNotication:(NSString *)aName {
    // 获得 UIApplication
    
    UIApplication *app = [UIApplication sharedApplication];
    
    //获取本地推送数组
    
    NSArray *localArray = [app scheduledLocalNotifications];
    
    //声明本地通知对象
    
    UILocalNotification *localNotification = nil;
    
    if (localArray) {
        
        
        for (UILocalNotification *noti in localArray) {
            
            
            NSDictionary *dict = noti.userInfo;
            
            
            if (dict) {
                
                
                NSString *inKey = [dict objectForKey:@"key"];
                NSLog(@"%@",inKey);
                
                if ([inKey isEqualToString:aName]) {
                    
                    
                    if (localNotification){
                        
                        
                        [localNotification release];
                        localNotification = nil;
                    }
                    
                    
                    localNotification = [noti retain];
                    
                    
                    break;
                    
                    
                }
                
                
            }
            
            
        }
        
        
        //判断是否找到已经存在的相同key的推送
        
        
        if (!localNotification) {
            
            
            //不存在初始化
            
            
            localNotification = [[UILocalNotification alloc] init];
            
            
        }
        
        
        
        
        if (localNotification) {
            
            
            //不推送 取消推送
            NSLog(@"12323123  %@",localNotification);
            [app cancelLocalNotification:localNotification];
            [localNotification release];
            localNotification=nil;
            
        }
        
    }
}
@end
