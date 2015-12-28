//
//  ComUtil.h
//  WiseTV
//
//  Created by Ran on 14-10-16.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComUtil : NSObject

// date to string.
+ (NSString *)dtos:(NSDate *)date fs:(NSString *)formatstring;
// string to date.
+ (NSDate *)stod:(NSString *)datestring fs:(NSString *)formatstring;
+ (NSDate *)standTimeZoneDate;
+ (NSDate *)standTimeZoneDate:(NSDate *)date;

+ (NSString *) dateFormatterForRadio:(NSDate *)date;

+ (NSDate *)dtdos:(NSDate *)date fs:(NSString *)formatstring;

/* NSTimeInterval如何转化成HH:mm  */
+ (NSString *) timerIntervalComplete:(int) timer andSeparate:(NSString*)sep;
+ (NSString *) NSTimeIntervalToFormalTimeString:(NSTimeInterval) interval;

+(NSDateComponents *)getTimeDif:(NSDate *)date;

@end
