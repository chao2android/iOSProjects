//
//  UIUtil.m
//  WiseTV
//
//  Created by Ran on 14-9-29.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import "UIUtil.h"
#define Station_Suffix @"公交站"

@implementation UIUtil

+ (UIView *)customSnapshotFromView:(UIView *)inputView
{
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 4.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

+(BOOL)userTapNowDelay:(float)time
{
    static NSDate *userTapNow;
    NSDate *now = [NSDate date];
    if (!userTapNow || [now timeIntervalSinceDate:userTapNow] > time) {
        userTapNow = now;
        return YES;
    }
    return NO;
}

+ (void) breatheAllSubViewsFromSpecificView:(UIView *) view andDisplay:(BOOL) display
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1.f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        if (display) {
            if ([view isKindOfClass:NSClassFromString(@"WTVStationCardView")]) {
                view.alpha = 0.5f;
            }
            else{
                view.alpha=1.f;
            }
        } else {
            view.alpha=0.3f;
        }
    
    [UIView commitAnimations];
    
}

/**
 *  根据已定宽度，由字号，文本获取最终文本size
 *
 *  @param text     文本
 *  @param fontSize 字号
 *
 *  @return size
 */
+(CGSize)textToSize:(NSString *)text fontSize:(CGFloat)fontSize
{
    CGSize sizeTemp= CGSizeMake(SCREEN_WIDTH, 20000.0f);
    
    UIFont  *font = [UIFont boldSystemFontOfSize:fontSize];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    sizeTemp =[text boundingRectWithSize:sizeTemp options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    return sizeTemp;
}

/**
 *  根据宽度，字号，文本获取最终文本size
 *
 *  @param text     文本
 *  @param fontSize 字号
 *
 *  @return size
 */
+(CGSize)textToSize:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    CGSize sizeTemp= CGSizeMake(width, 20000.0f);
    
    UIFont  *font = [UIFont boldSystemFontOfSize:fontSize];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    sizeTemp =[text boundingRectWithSize:sizeTemp options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    return sizeTemp;
}

+(UIAlertView *)showLocationUnabled:(NSString *)title withMessage:(NSString *)message
{
    UIAlertView *alertView;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
    {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"设置", nil];
        [alertView.rac_buttonClickedSignal subscribeNext:^(id index) {
            if ([index integerValue]==1) {
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:self
                                     cancelButtonTitle:@"好的"
                                     otherButtonTitles:nil, nil];
    }
    return alertView;
}

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL) containsChinese:(NSString *)str {
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return TRUE;
    }
    return FALSE;
}


+ (NSString *)stringByReplacing:(NSString *)strReplace withStation:(BOOL)isBool
{
    
    NSString *strResult = [NSString stringWithFormat:@"%@",strReplace];
    if([strReplace hasSuffix:@"_"]){
        strResult = [strResult stringByReplacingOccurrencesOfString:@"_" withString:@""];
    }
    if (isBool) {
        if (strResult.length >= 9 && [strResult hasSuffix:Station_Suffix]) {
            strResult = [strResult stringByReplacingOccurrencesOfString:Station_Suffix withString:@" "];
        }
    }
    return strResult;
}




+ (void) shakeToShow:(UIView*)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.0;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

+ (void) shakeToNarrowShow:(UIView*)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5f;
    
    NSMutableArray *values = [NSMutableArray array];
   
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
     [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

+ (void) shakeToEnlargeShow:(UIView*)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5f;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

+ (void) animateToShow:(UIView *)aView
{
    aView.hidden = NO;

    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5f;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

+ (void) animateToHide:(UIView *)aView
{
    [UIView animateWithDuration:.1f animations:^{
        [aView.layer setTransform:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.4f animations:^{
            [aView.layer setTransform:CATransform3DMakeScale(0.1, 0.1, 1.0)];
        } completion:^(BOOL finished) {
            aView.hidden = YES;
            [aView.layer setTransform:CATransform3DMakeScale(1.0, 1.0, 1.0)];
        }];
    }];
}

+(BOOL)isValidatePhoneNumber:(NSString *)phoneNumber {
    
    NSString *phoneNumberRegex = @"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    
    NSPredicate *phoneNumberVali = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegex];
    
    return [phoneNumberVali evaluateWithObject:phoneNumber];
}
- (UIImage *)TelescopicImageToSize:(CGSize) size withImage:(UIImage *)originImg
{
    
    UIGraphicsBeginImageContext(size);
    
    [originImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
//过滤所有表情
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            const unichar hs = [substring characterAtIndex:0];
            // surrogate pair
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue = YES;
                    }
                }
            } else if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                       if (ls == 0x20e3) {
                            returnValue = YES;
                        }
                        } else {
                            // non surrogate
                            if (0x2100 <= hs && hs <= 0x27ff) {
                                returnValue = YES;
                            }
                            else if (0x2B05 <= hs && hs <= 0x2b07)
                            {
                                returnValue = YES;
                            }
                            else if (0x2934 <= hs && hs <= 0x2935) {
                                 returnValue = YES;
                            }
                            else if (0x3297 <= hs && hs <= 0x3299) {
                                  returnValue = YES;
                            }
                            else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                  returnValue = YES;
                            }
                        }
            }];
       return returnValue;
}

@end
