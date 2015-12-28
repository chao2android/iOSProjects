//
//  UIUtil.h
//  WiseTV
//
//  Created by Ran on 14-9-29.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UIUtil : NSObject

+ (UIView *)customSnapshotFromView:(UIView *)inputView;
+ (BOOL)userTapNowDelay:(float)time;
+ (void) breatheAllSubViewsFromSpecificView:(UIView *) view andDisplay:(BOOL) display;
+ (CGSize)textToSize:(NSString *)text fontSize:(CGFloat)fontSize;
+(CGSize)textToSize:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;
+(UIAlertView *)showLocationUnabled:(NSString *)title withMessage:(NSString *)message;
+ (BOOL)isPureInt:(NSString*)string;
+ (NSString *)stringByReplacing:(NSString *)strReplace withStation:(BOOL)isBool;
+ (BOOL)containsChinese:(NSString *)str;

+ (void) shakeToShow:(UIView*)aView;
+ (void) shakeToNarrowShow:(UIView*)aView;
+ (void) shakeToEnlargeShow:(UIView*)aView;

+ (void) animateToShow:(UIView *)aView;
+ (void) animateToHide:(UIView *)aView;

+(BOOL)isValidatePhoneNumber:(NSString *)phoneNumber;

+ (BOOL)stringContainsEmoji:(NSString *)string;
@end
