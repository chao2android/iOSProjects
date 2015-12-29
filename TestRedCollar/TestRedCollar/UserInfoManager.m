//
//  UserInfoManager.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserInfoManager.h"

static UserInfoManager *gUserManager = nil;

@implementation UserInfoManager

@synthesize mbShowLoading;

+ (UserInfoManager *)Share {
    if (!gUserManager) {
        gUserManager = [[UserInfoManager alloc] init];
    }
    return gUserManager;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)mbShowLoading {
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"showloading"];
    if (number) {
        return [number boolValue];
    }
    return YES;
}

- (void)setMbShowLoading:(BOOL)value {
    NSNumber *number = [NSNumber numberWithBool:value];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"showloading"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)mToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

- (void)setMToken:(NSString *)value {
    if (value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"token"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)mbLogin {
    return (self.mUserDict != nil);
}

- (NSDictionary *)GetFormatDict:(NSDictionary *)dict1 {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    for (NSString *key in dict.allKeys) {
        id target = [dict objectForKey:key];
        if ([target isKindOfClass:[NSNull class]]) {
            [dict removeObjectForKey:key];
        }
    }
    return dict;
}

- (NSDictionary *)mUserDict {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
}

- (void)setMUserDict:(NSDictionary *)dict {
    if (dict) {
        dict = [self GetFormatDict:dict];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInfo"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)SetUserValue:(NSString *)value forKey:(NSString *)key {
    if (!value || !key) {
        return;
    }
    NSMutableDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];

    if (userinfo && [userinfo isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *userinfo2 = [NSMutableDictionary dictionaryWithDictionary:userinfo];
        [userinfo2 setObject:value forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:userinfo2 forKey:@"UserInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        NSLog(@"SetUserValue Error:userinfo");
    }
}

- (NSString *)GetUserValueforKey:(NSString *)key {
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    if (userinfo && [userinfo isKindOfClass:[NSDictionary class]]) {
        return [userinfo objectForKey:key];
    }
    return nil;
}

#pragma mark - User Params

- (NSString *)mUserID {
    return [self GetUserValueforKey:@"id"];
}

- (void)setMUserID:(NSString *)value {
    [self SetUserValue:value forKey:@"id"];
}

- (NSString *)mAddress {
    return [self GetUserValueforKey:@"address"];
}

- (void)setMAddress:(NSString *)value {
    [self SetUserValue:value forKey:@"address"];
}

- (int)miSex {
    return [[self GetUserValueforKey:@"gender"] intValue];
}

- (void)setMiSex:(int)value {
    [self SetUserValue:[NSString stringWithFormat:@"%d", value] forKey:@"gender"];
}

- (NSString *)mHeadImgUrl {
    return [self GetUserValueforKey:@"headImgUrl"];
}

- (void)setMHeadImgUrl:(NSString *)value {
    [self SetUserValue:value forKey:@"headImgUrl"];
}

- (NSString *)mNickName {
    return [self GetUserValueforKey:@"nickName"];
}

- (void)setMNickName:(NSString *)value {
    [self SetUserValue:value forKey:@"nickName"];
}

- (NSString *)mPhoneNum {
    return [self GetUserValueforKey:@"phoneNum"];
}

- (void)setMPhoneNum:(NSString *)value{
    
    [self SetUserValue:value forKey:@"phoneNum"];
}

- (NSString *)mServe_type {
    return [self GetUserValueforKey:@"serve_type"];
}

- (void)setMServe_type:(NSString *)value{
    
    [self SetUserValue:value forKey:@"serve_type"];
}

+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateMobile:(NSString *)mobile {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isValidateQQ:(NSString *)QQ {
    NSString *patternQQ = @"^[1-9](\\d){4,9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",patternQQ];
    return [phoneTest evaluateWithObject:QQ];
}

+ (BOOL)isValidateNumber:(NSString *)value length:(int)length {
    NSString *pattern = [NSString stringWithFormat:@"^[\\d]{%d}$", length];
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [phoneTest evaluateWithObject:value];
}

+ (BOOL)isValidateNickName:(NSString *)value {
    NSString *pattern = [NSString stringWithFormat:@"\\s+"];
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return ![phoneTest evaluateWithObject:value];
}

+ (NSArray *)DictionaryToArray:(NSDictionary *)dict desc:(BOOL)desc {
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        NSArray *keys = dict.allKeys;
        keys = [keys sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *key in keys) {
            NSDictionary *tmpdict = [dict objectForKey:key];
            if (desc) {
                [array insertObject:tmpdict atIndex:0];
            }
            else {
                [array addObject:tmpdict];
            }
        }
        return array;
    }
    return nil;
}

+ (NSArray *)DictionaryToArray:(NSDictionary *)dict {
    return [UserInfoManager DictionaryToArray:dict desc:NO];
}

+ (NSString *)GetSecretUserName:(NSString *)text {
    if (text && text.length > 0) {
        NSLog(@"text:[%@] %d", text, text.length);
        NSRange range = [text rangeOfString:@"@"];
        if (range.length>0) {
            int iStart = range.location-4;
            if (iStart < 0) {
                iStart = 0;
            }
            range = NSMakeRange(iStart, range.location-iStart);
            text = [text stringByReplacingCharactersInRange:range withString:@"****"];
        }
        else if ([UserInfoManager isValidateNumber:text length:11]) {
            range = NSMakeRange(3, 4);
            text = [text stringByReplacingCharactersInRange:range withString:@"****"];
        }
    }
    return text;
}

+ (NSString *)GetSecretName:(NSString *)nickname username:(NSString *)username {
    if (nickname && nickname.length>0) {
        return nickname;
    }
    else {
        username = [UserInfoManager GetSecretUserName:username];
        if (username) {
            return username;
        }
    }
    return @"匿名";
}

+ (NSRange)RangeOfRegularExpression:(NSString *)content fmt:(NSString *)fmtstr range:(NSRange)range {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:fmtstr options:NSRegularExpressionCaseInsensitive error:nil];
    if (regex != nil) {
        NSTextCheckingResult *check = [regex firstMatchInString:content options:0 range:range];
        return check.range;
    }
    return NSMakeRange(0, 0);
}

+ (NSRange)RangeOfRegularExpression:(NSString *)content start:(NSString *)start end:(NSString *)end range:(NSRange)range {
    NSString *fmtstr = [NSString stringWithFormat:@"(?<=(%@))[^\a]*?(?=(%@))", start, end];
    return [UserInfoManager RangeOfRegularExpression:content fmt:fmtstr range:range];
}

+ (NSString *)GetTextBetweenStr:(NSString *)content start:(NSString *)start end:(NSString *)end {
    NSString *fmtstr = [NSString stringWithFormat:@"(?<=(%@))[^\a]*?(?=(%@))", start, end];
    NSLog(@"%@", fmtstr);
    NSRange linkrange = [UserInfoManager RangeOfRegularExpression:content fmt:fmtstr range:NSMakeRange(0, content.length)];
    if (linkrange.length>0) {
        return [content substringWithRange:linkrange];
    }
    return nil;
}

@end
