//
//  Md5Manager.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-21.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "Md5Manager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Md5Manager

+ (NSString *)MD5String:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)MD5Data:(NSData *)data {
    unsigned char result[16];
    CC_MD5(data.bytes, data.length, result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)GetMd5String:(NSDictionary *)dict :(BOOL)bGB2312 {
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    for (NSString *key in dict.allKeys) {
        NSString *value = [dict objectForKey:key];
        NSDictionary *tmpdict = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",value,@"value", nil];
        [array addObject:tmpdict];
    }
    
    NSArray *sorteArray = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        NSDictionary *dict1 = (NSDictionary *)obj1;
        NSDictionary *dict2 = (NSDictionary *)obj2;
        NSString *key1 = [dict1 objectForKey:@"key"];
        NSString *key2 = [dict2 objectForKey:@"key"];
        return [key1 compare:key2];
    }];
    NSString *srcstr = @"";
    for (int i = 0; i < sorteArray.count; i ++) {
        NSDictionary *tmpDict = [sorteArray objectAtIndex:i];
        if (i == 0) {
            srcstr = [NSString stringWithFormat:@"%@=%@", [tmpDict objectForKey:@"key"], [tmpDict objectForKey:@"value"]];
        }
        else {
            srcstr = [srcstr stringByAppendingFormat:@",%@=%@", [tmpDict objectForKey:@"key"], [tmpDict objectForKey:@"value"]];
        }
    }
    srcstr = [srcstr stringByAppendingString:@"+pinbang"];
    if (bGB2312) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSData *data = [srcstr dataUsingEncoding:enc];
        return [Md5Manager MD5Data:data];
    }
    NSLog(@"[%@]", srcstr);
    return [Md5Manager MD5String:srcstr];
}

+ (NSString *)GetMd5UrlStr:(NSString *)urlstr {
    if (!urlstr || urlstr.length == 0) {
        return nil;
    }
    NSRange range = [urlstr rangeOfString:@"?"];
    if (range.length>0) {
        urlstr = [urlstr substringFromIndex:range.location+range.length];
        NSArray *array = [urlstr componentsSeparatedByString:@"&"];
        NSLog(@"%@", array);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *substr in array) {
            NSRange range2 = [substr rangeOfString:@"="];
            if (range2.length>0) {
                NSString *key = [substr substringToIndex:range2.location];
                NSString *value = [substr substringFromIndex:range2.location+range2.length];
                if (key && value) {
                    [dict setObject:value forKey:key];
                }
            }
        }
        NSLog(@"%@", dict);
        return [Md5Manager GetMd5String:dict :NO];
    }
    return nil;
}

@end
