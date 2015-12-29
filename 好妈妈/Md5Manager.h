//
//  Md5Manager.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-21.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Md5Manager : NSObject

+ (NSString *)MD5String:(NSString *)str;
+ (NSString *)GetMd5String:(NSDictionary *)dict :(BOOL)bGB2312;
+ (NSString *)GetMd5UrlStr:(NSString *)urlstr;

@end
