//
//  JYEncrypt.h
//  friendJY
//
//  Created by 高斌 on 15/3/20.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYEncrypt : NSObject

+ (NSString *)hashedISU;
+ (NSString *)md5:(NSString *)str;
+ (NSString*)sha1Hash:(NSData *)data;
+ (NSString*)md5Hash:(NSData *)data;

+ (NSData *)AES256EncryptWithKey:(NSData *)data key:(NSString *)key;
+ (NSData *)AES256DecryptWithKey:(NSData *)data key:(NSString *)key;

+ (NSString *)currentMachine;

@end
