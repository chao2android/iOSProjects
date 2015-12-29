//
//  GuiDang.m
//  OTT
//
//  Created by iHope on 13-12-23.
//  Copyright (c) 2013年 dreamRen. All rights reserved.
//

#import "GuiDang.h"

@implementation GuiDang
+ (NSString *)LuJingMenth
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
    return path;
}
- (void)ShanChuMenth:(NSString *)aString
{
    
}
+ (NSDictionary *)DuquMenth1:(NSString *)aString
{
    NSString *filename=[[GuiDang LuJingMenth] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",aString]];   //获取路径
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename]; //读取数据
    return dic2;
}

+ (NSArray *)DuquMenth:(NSString *)aString
{
    NSString *filename=[[GuiDang LuJingMenth] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",aString]];   //获取路径
    NSArray* dic2 = [NSArray arrayWithContentsOfFile:filename]; //读取数据
    return dic2;
}
+ (void)ChuCunMenth:(NSArray *)aDictionary LJstring:(NSString *)aString
{
    NSString *filename=[[GuiDang LuJingMenth] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",aString]];   //获取路径
    [aDictionary writeToFile:filename atomically:YES];
}
@end
