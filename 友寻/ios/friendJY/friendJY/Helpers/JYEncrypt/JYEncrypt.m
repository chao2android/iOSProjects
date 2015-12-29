//
//  JYEncrypt.m
//  friendJY
//
//  Created by 高斌 on 15/3/20.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYEncrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation JYEncrypt

+(NSString *)hashedISU {
    NSString *result = nil;
    // NSString *isu = [UIDevice currentDevice].uniqueIdentifier;
    //NSString *isu=[[ShareData sharedInstance]deviceID];
    //if(isu) {
    unsigned char digest[16];
    // NSData *data = [isu dataUsingEncoding:NSASCIIStringEncoding];
    //CC_MD5([data bytes], [data length], digest);
    
    result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
              digest[0], digest[1],
              digest[2], digest[3],
              digest[4], digest[5],
              digest[6], digest[7],
              digest[8], digest[9],
              digest[10], digest[11],
              digest[12], digest[13],
              digest[14], digest[15]];
    result = [result uppercaseString];
    //  }
    return result;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString
            stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
    
}


+ (NSString*)md5Hash:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], [data length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

+ (NSString*)sha1Hash:(NSData *)data {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([data bytes], [data length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19]
            ];
}

+ (NSData *)AES256EncryptWithKey:(NSData *)data key:(NSString *)key {
    
    NSData *returnData = nil;
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        returnData  = [[NSData alloc] initWithBytes:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    
    return returnData;
}

+ (NSData *)AES256DecryptWithKey:(NSData *)data key:(NSString *)key {
    
    NSData *returnData = nil;
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        returnData  = [[NSData alloc] initWithBytes:buffer length:numBytesDecrypted];
    }
    
    
    free(buffer);
    
    return returnData;
}

/*
 // 判断当前设备类型
 iPhone Simulator == i386
 iPhone == iPhone1,1
 3G iPhone == iPhone1,2
 3GS iPhone == iPhone2,1
 4 iPhone == iPhone3,1
 
 1st Gen iPod == iPod1,1
 2nd Gen iPod == iPod2,1
 3rd Gen iPod == iPod3,1
 4rd gen ipod == iPod4,1
 */
+ (NSString *)currentMachine {
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    // Allocate the space to store name
    char *name = malloc(size);
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    // Place name into a string
    NSString *machine = [NSString stringWithUTF8String:name];
    // Done with this
    free(name);
    return machine;
    
}

@end
