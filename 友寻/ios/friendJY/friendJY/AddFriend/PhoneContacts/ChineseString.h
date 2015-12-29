//
//  ChineseString.h
//  YZX_ChineseSorting
//
//  Created by Suilongkeji on 13-10-29.
//  Copyright (c) 2013年 Suilongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface ChineseString : NSObject

@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;

//-----  返回tableview右方indexArray
+ (NSMutableArray*)indexArray:(NSArray *)stringArr;

//-----  返回联系人
+ (NSMutableArray*)letterSortArray:(NSArray *)stringArr;

+ (NSMutableArray*)letterSortContactArray:(NSArray *)stringArr;
///----------------------
//返回一组字母排序数组(中英混排)
+ (NSMutableArray*)sortArray:(NSArray *)stringArr;

+(NSString*)RemoveSpecialCharacter: (NSString *)str;

+ (NSMutableArray*)returnSortChineseArrar:(NSArray*)stringArr;

@end