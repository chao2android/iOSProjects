//
//  ComUtil.m
//  WiseTV
//
//  Created by Ran on 14-10-16.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import "ComUtil.h"

@implementation ComUtil

+ (NSString *)dtos:(NSDate *)date fs:(NSString *)formatstring;
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatstring];
    
    return [dateformatter stringFromDate:date];
}

+ (NSDate *)stod:(NSString *)datestring fs:(NSString *)formatstring
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatstring];
    
    return [dateformatter dateFromString:datestring];
}

+ (NSDate *) standTimeZoneDate
{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:WTV_STANDARD_TIMEZONE];
    [formatter setTimeZone:timeZone];
    
    return [formatter dateFromString:[formatter stringFromDate:date]];
}

+ (NSDate *)standTimeZoneDate:(NSDate *)date
{
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    
    return [formatter dateFromString:[formatter stringFromDate:localeDate]];
}


+ (NSString *) dateFormatterForRadio:(NSDate *) date;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:WTV_STANDARD_TIMEZONE];
    [dateFormatter setDateFormat:WTV_DATEFORMAT_TVOD];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dtdos:(NSDate *)date fs:(NSString *)formatstring
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatstring];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSString *strDate = [dateformatter stringFromDate:date];
    
    NSDate  *resultDate = [dateformatter dateFromString:strDate];
    NSDate *localeDate = [resultDate  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

+ (NSString *) timerIntervalComplete:(int) timer andSeparate:(NSString*) sep
{
    return (timer<10)?[NSString stringWithFormat:@"0%i%@", timer, sep]:[NSString stringWithFormat:@"%i%@", timer,sep];
}

+ (NSString *) NSTimeIntervalToFormalTimeString:(NSTimeInterval) interval
{
    NSString *result = nil;
    int timer = (int)interval;
    int hour = 0;
    int minute = 0;
    int second = 0;
    
    if (timer/3600>0) {
        hour = 0;
        minute = timer/60;
        second = (timer-minute*60)%60;
    } else if (timer/3600==0 && timer/60>0) {
        hour = 0;
        minute = timer/60;
        second = (timer-minute*60)%60;;
    } else {
        second = timer%60;
    }
    
    if (hour !=0) {
        result = [[self timerIntervalComplete:minute andSeparate:@":"] stringByAppendingString:[self timerIntervalComplete:second andSeparate:@""]];
    } else if (hour == 0 && minute !=0) {
        result = [[self timerIntervalComplete:minute andSeparate:@":"] stringByAppendingString:[self timerIntervalComplete:second andSeparate:@""]];
    } else if (hour==0 && minute==0) {
        result = [@"00:" stringByAppendingString:[self timerIntervalComplete:second andSeparate:@""]];
    }
    
    return result;
}

+(NSDateComponents *)getTimeDif:(NSDate *)date
{
    NSDate *nowTime   = [ComUtil standTimeZoneDate];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *dateComponents = [cal components:unitFlags fromDate:date toDate:nowTime options:0];
    return dateComponents;
}

@end
