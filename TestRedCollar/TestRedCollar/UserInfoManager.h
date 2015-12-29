//
//  UserInfoManager.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject {
    
}

@property (nonatomic, assign) NSDictionary *mUserDict;
@property (nonatomic, assign) NSString *mNickName;
@property (nonatomic, assign) NSString *mPhoneNum;
@property (nonatomic, assign) NSString *mHeadImgUrl;
@property (nonatomic, assign) NSString *mAddress;
@property (nonatomic, assign) NSString *mUserID;
@property (nonatomic, assign) NSString *mToken;
@property (nonatomic, assign) int miSex;
@property (readonly) BOOL mbLogin;
@property (nonatomic, assign) BOOL mbShowLoading;
@property (nonatomic, assign) NSString *mServe_type;

#define kkToken         [UserInfoManager Share].mToken
#define kkUserDict      [UserInfoManager Share].mUserDict
#define kkUserID        [UserInfoManager Share].mUserID
#define kkSex           [UserInfoManager Share].miSex
#define kkAddress       [UserInfoManager Share].mAddress
#define kkAvatar        [UserInfoManager Share].mHeadImgUrl
#define kkPhone         [UserInfoManager Share].mPhoneNum
#define kkNickName      [UserInfoManager Share].mNickName
#define kkServe_type    [UserInfoManager Share].mServe_type

#define kkIsLogin         [UserInfoManager Share].mbLogin


#define kMsg_Logout     @"kMsg_Logout"

#define SafePerformSelector(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

+ (UserInfoManager *)Share;

+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateMobile:(NSString *)mobile;
+ (BOOL)isValidateQQ:(NSString *)QQ;
+ (BOOL)isValidateNumber:(NSString *)value length:(int)length;
+ (BOOL)isValidateNickName:(NSString *)value;

+ (NSArray *)DictionaryToArray:(NSDictionary *)dict;
+ (NSArray *)DictionaryToArray:(NSDictionary *)dict desc:(BOOL)desc;

+ (NSString *)GetSecretUserName:(NSString *)text;
+ (NSString *)GetSecretName:(NSString *)nickname username:(NSString *)username;
+ (NSString *)GetTextBetweenStr:(NSString *)content start:(NSString *)start end:(NSString *)end;

@end
