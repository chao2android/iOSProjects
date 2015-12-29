//
//  NSString+WiseTV.m
//  WiseTV
//
//  Created by littlezl on 14/11/18.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import "NSString+WiseTV.h"

@implementation NSString (WiseTV)

+(NSString *)urlEncode:(NSString *)string
{
    NSString *newString;
    
    newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                    (CFStringRef )string,
                                                                    (CFStringRef )@"!$&'()*+,-./:;=?@_~%#[]",
                                                                    NULL,
                                                                    kCFStringEncodingUTF8));
    
    return newString;
}

+(NSString *)urlDecode:(NSString *)string
{
    NSMutableString *newString = [NSMutableString stringWithString:string];
    [newString replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [newString length])];
    return [newString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
