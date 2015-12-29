//
//  Encryption.m
//  DownloadFile
//
//  Created by  on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Encryption.h"
#import <CommonCrypto/CommonCryptor.h>


static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static NSString *_key = @"5D508B9C8B7E4DBA9B27F0605F99FA35";

//static char iv[] = {1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8};
static Byte iv[]   = {0xA,1,0xB,8,0,0xF,7, 9, 0x17, 2, 4, 1, 5, 0xC,0xD, 92};

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
	-2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
	-2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};
@implementation NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          iv,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES256DecryptWithKey:(NSString *)key   //解密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          iv
                                          ,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}


- (NSString *)newStringInBase64FromData            //追加64编码
{
    NSMutableString *dest = [[NSMutableString alloc] initWithString:@""];
    unsigned char * working = (unsigned char *)[self bytes];
    int srcLen = [self length];
    for (int i=0; i<srcLen; i += 3) {
        for (int nib=0; nib<4; nib++) {
            int byt = (nib == 0)?0:nib-1;
            int ix = (nib+1)*2;
            if (i+byt >= srcLen) break;
            unsigned char curr = ((working[i+byt] << (8-ix)) & 0x3F);
            if (i+nib < srcLen) curr |= ((working[i+nib] >> ix) & 0x3F);
            [dest appendFormat:@"%c", base64[curr]];
        }
    }
    return dest;
}

+ (NSString*)base64encode:(NSString*)str
{
    if ([str length] == 0)
        return @"";
    const char *source = [str UTF8String];
    int strlength  = strlen(source);
    char *characters = malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    NSUInteger i = 0;
    while (i < strlength) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
            buffer[bufferLength++] = source[i++];
        characters[length++] = base64[(buffer[0] & 0xFC) >> 2];
        characters[length++] = base64[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = base64[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = base64[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    NSString *g = [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
    return g;
}   
+ (NSString *) encodeBase64WithData:(NSData *)objData {
    const unsigned char * objRawData = [objData bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    int intLength = [objData length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3; 
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Return the results as an NSString object
    return [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
    const char * objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
    int intLength = strlen(objPointer);
    int intCurrent;
    int i = 0, j = 0, k;
    
    unsigned char * objResult;
    objResult = calloc(intLength, sizeof(char));
    
    // Run through the whole string, converting as we go
    while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
        if (intCurrent == '=') {
            if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
                // the padding character is invalid at this point -- so this entire string is invalid
                free(objResult);
                return nil;
            }
            continue;
        }
        
        intCurrent = _base64DecodingTable[intCurrent];
        if (intCurrent == -1) {
            // we're at a whitespace -- simply skip over
            continue;
        } else if (intCurrent == -2) {
            // we're at an invalid character
            free(objResult);
            return nil;
        }
        
        switch (i % 4) {
            case 0:
                objResult[j] = intCurrent << 2;
                break;
                
            case 1:
                objResult[j++] |= intCurrent >> 4;
                objResult[j] = (intCurrent & 0x0f) << 4;
                break;
                
            case 2:
                objResult[j++] |= intCurrent >>2;
                objResult[j] = (intCurrent & 0x03) << 6;
                break;
                
            case 3:
                objResult[j++] |= intCurrent;
                break;
        }
        i++;
    }
    
    // mop things up if we ended on a boundary
    k = j;
    if (intCurrent == '=') {
        switch (i % 4) {
            case 1:
                // Invalid state
                free(objResult);
                return nil;
                
            case 2:
                k++;
                // flow through
            case 3:
                objResult[k] = 0;
        }
    }
    
    // Cleanup and setup the return NSData
    NSData * objData = [[[NSData alloc] initWithBytes:objResult length:j] autorelease];
    free(objResult);
    return objData;
}

+ (NSString *)encodeBase64WithString:(NSString *)strData {
	return [self encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
- (NSString *)base64Encoding;
{
    if (self.length == 0)
        return @"";
    
    char *characters = malloc(self.length*3/2);
    
    if (characters == NULL)
        return @"";
    
    int end = self.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[self bytes])[index]) & 0x0ff) << 16) 
        | (((int)(((char *)[self bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[self bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == self.length - 2)
    {
        int d = (((int)(((char *)[self bytes])[index]) & 0x0ff) << 16) 
        | (((int)(((char *)[self bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == self.length - 1)
    {
        int d = ((int)(((char *)[self bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES] autorelease];
    return rtnStr;
}


@end
