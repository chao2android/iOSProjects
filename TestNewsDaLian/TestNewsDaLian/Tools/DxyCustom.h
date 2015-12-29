//
//  DxyCustom.h
//  AirportMerchant
//
//  Created by dxy on 14-7-29.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface DxyCustom : NSObject
//解析html格式的字符串
+(NSString *)filterHTML:(NSString *)html;

//获取状态
+(NSString *) getStateWithInt:(NSString *)state;

//创建textField
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                                   secure:(BOOL)isSecure
                                    place:(NSString *)string
                                      tag:(NSInteger)tag
                                 delegate:(id<UITextFieldDelegate>)delegate;


//创建一个警告框AlertView
+ (UIAlertView *)showAlertViewTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;

+ (UIAlertView *)showSureAlertViewTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;


//动态调节高度
+ (CGSize)boundingRectWithString:(NSString *)textStr width:(CGFloat)width height:(CGFloat)height font:(NSInteger)font;

//创建label
+ (UILabel *)creatLabelWithFrame:(CGRect)frame
                            text:(NSString *)text
                       alignment:(NSTextAlignment)textAlignment;
//创建label 可以改变字体大小的
+ (UILabel *)createDiffFontLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                        alignment:(NSTextAlignment)textAlignment;


//创建图片类型的button
+ (UIButton *)creatButtonFrame:(CGRect)frame
                     imageName:(NSString *)imageName
               selectImageNmae:(NSString *)selectImageName
                        target:(id)target
                        action:(SEL)sel
                           tag:(NSInteger)tag;


//创建一个ImageView
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame
                               imageName:(NSString *)imageName;

//手机号校验
+ (BOOL)validateMobile:(NSString *)mobileNum;
//身份证号校验
+(BOOL) chk18PaperId:(NSString *) sPaperId;

//判断该路径下文件是否存在
+ (BOOL)fileIsExistsWithPath:(NSString *)path;


+ (BOOL)networkclick;

//根据时间戳获取时间
+ (NSString *)getTimeWithTimeSp:(NSString *)timeSp;

//获取年份
+ (NSString *)getYearMonthDay:(NSString *)timeSp;

//根据时间戳获取时间 并且显示今天昨天
+ (NSString *)isYestedayOrTodayWithTimeSp:(NSString *)timeSp;

+ (BOOL)isWifi;
@end
