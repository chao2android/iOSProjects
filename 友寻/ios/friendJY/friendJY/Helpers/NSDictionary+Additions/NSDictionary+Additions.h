//
//  NSDictionary+Additions.h
//  JiaYuan
//
//  Created by HsiuJane Sang on 7/6/12.
//  Copyright (c) 2012 JiaYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (NSInteger)getIntegerValueForKey:(NSString *)key
                      defaultValue:(NSInteger)defaultValue;
- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (float)getFloatValueValueForKey:(NSString *)key defaultValue:(float)defaultValue;
- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSDictionary *)getDictionaryValueForKey:(NSString *)key;
- (NSDictionary *)getDictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;
- (NSArray *)getArrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;

@end
