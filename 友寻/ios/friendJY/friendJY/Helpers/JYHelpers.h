//
//  JYHelpers.h
//  friendJY
//
//  Created by 高斌 on 15/2/28.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYHelpers : NSObject

//设置颜色
+ (UIColor *)setFontColorWithString:(NSString *)color;

+ (BOOL)isPhoneNumber:(NSString *)phoneNumber;

+ (NSArray *)readAllPeoples;

+ (void)showAlertWithTitle:(NSString *)title;
+ (void)showAlertWithTitle:(NSString *)title
                       msg:(NSString *)msg
               buttonTitle:(NSString *)btnTitle;

+ (BOOL)isEmptyOfString:(NSString *)string;

+ (CGSize)GetTextSize:(NSString *)str UI:(UITextView *)textView uiWidth:(float) uiWidth;
+ (CGSize) getTextWidthAndHeight:(NSString *)str fontSize:(int) fontSize;
+ (CGSize) getTextWidthAndHeight:(NSString *)str fontSize:(int) fontSize uiWidth:(int) uiWidth;

+ (NSString *) computeStar:(NSInteger) month day :(NSInteger) day;
+ (NSString *) computeBirthpet:(NSInteger) year ;

#pragma mark - 字符串转时间戳
//字符串转时间戳
+ (long)stringDateToIntTimestamp:(NSString *)timeStr;

+ (NSString *)unixToDate:(NSInteger)myUnix;

+ (NSString *) unxiToDate2:(NSInteger)unix;

#pragma mark - 获取当前时间的时间戳
+ (NSString *)currentDateTimeInterval;

+ (NSString *)stringValueWithObject:(id)object;

+ (NSString *)compareCurrentTime:(NSDate *)compareDate;

+ (NSArray *)ratioWidthAndHeight:(float)sHeight
                          sWidth:(float)sWidth
                         dHeight:(float)dHeight
                          dWidth:(float)dWidth;

#pragma mark - 获取目录，目录不存时会被创建
+ (NSString *)getCurrentUserStoreageSubDirectory:(NSString*)dir;

#pragma mark - 从沙盒中读取文件
+ (NSData *)fromLocationPahtGetFileContent:(NSString *)path;
#pragma mark - 缓存操作
+(float)folderSizeAtCaches;

+(void)clearCache;

+(UIImage*)imageWithName:(NSString*)imageName;

+(NSString *) dictionaryToJSONString:(NSDictionary *)dic; //字典转json串

+(NSDictionary *) jsonStringToDictionary:(NSString *)jsonStr; //json串转字典
/**
 *  字符串或NSNumber转化为数字,空串返回0
 *
 *  @param aStr 字符串
 *
 *  @return integer
 */
+ (NSInteger)integerValueOfAString:(NSString *)aStr;
/**
 *  判断当前相机是否授权
 *
 *  @return 是否授权
 */
+ (BOOL)canUseCamera;
/**
 *  未授权相机弹窗
 */
+ (void)showCameraAuthDeniedAlertView;
/**
 *  判断当前相册是否授权
 *
 *  @return 相册是否授权
 */
+ (BOOL)canUsePhotoLibrary;
/**
 *  未授权相册弹窗
 */
+ (void)showPhotoLibraryDeniedAlertView;
/**
 *  将生日转化为XX后
 *
 *  @param birthday 生日 xxxx-xx-xx
 *
 *  @return XX后
 */
+ (NSString *)birthdayTransformToCentery:(NSString*)birthday;

//过滤字符中的emoji表情
+ (NSString *)filterEmojiString:(NSString *)text;
/**
 *  标签排序
 *
 *  @param tagArr 乱序标签数组
 *
 *  @return 排好序的标签数组
 */
+ (NSMutableArray*)sortTagArr:(NSArray*)tagArr;

@end




