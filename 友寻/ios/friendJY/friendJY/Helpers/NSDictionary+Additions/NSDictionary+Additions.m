//
//  NSDictionary+Additions.m
//  JiaYuan
//
//  Created by HsiuJane Sang on 7/6/12.
//  Copyright (c) 2012 JiaYuan. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    
    BOOL ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(boolValue)]) {
        ret = [[self objectForKey:key] boolValue];
    }
    return ret;
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    
    int ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(intValue)]) {
        ret = [[self objectForKey:key] intValue];
    }
    return ret;
}

- (NSInteger)getIntegerValueForKey:(NSString *)key
                      defaultValue:(NSInteger)defaultValue {
    
    NSInteger ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(integerValue)]) {
        ret = [[self objectForKey:key] integerValue];
    }
    return ret;
}

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
	NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%Y-%m-%d %H:%M:%S", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    
    long long ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(longLongValue)]) {
        ret = [[self objectForKey:key] longLongValue];
    }
    return ret;
}

- (float)getFloatValueValueForKey:(NSString *)key defaultValue:(float)defaultValue {
    
    float ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(floatValue)]) {
        ret = [[self objectForKey:key] floatValue];
    }
    return ret;
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:[NSString class]]) {
        return ret;
    }else if([ret respondsToSelector:@selector(stringValue)]){
        return [ret stringValue];
    }else {
        return defaultValue;
    }
}

- (NSDictionary *)getDictionaryValueForKey:(NSString *)key{
    id ret=[self objectForKey:key];
    if([ret isKindOfClass:[NSDictionary class]]){
        return ret;
    }
    return NULL;
}

- (NSDictionary *)getDictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue{
    id ret=[self objectForKey:key];
    if([ret isKindOfClass:[NSDictionary class]]){
        return ret;
    }
    return defaultValue;
}

- (NSArray *)getArrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue {
    
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:[NSArray class]]) {
        return [self objectForKey:key];
    }else {
        return defaultValue;
    }
}

@end
