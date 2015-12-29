//
//  NSString+WiseTV.h
//  WiseTV
//
//  Created by littlezl on 14/11/18.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WiseTV)

+(NSString *)urlEncode:(NSString *)string;
+(NSString *)urlDecode:(NSString *)string;

@end
