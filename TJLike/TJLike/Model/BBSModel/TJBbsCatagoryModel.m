//
//  TJBbsCatagoryModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBbsCatagoryModel.h"

@implementation TJBbsCatagoryModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _subclassList = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
    if (StringEqual(key, @"id")) {
        self.CataId = value;
    }
    else if (StringEqual(key, @"subclass"))
    {
        
        if ([value isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in (NSArray *)value) {
                
                TJBBSCateSubModel *subClass = [[TJBBSCateSubModel alloc] init];
                [subClass setValuesForKeysWithDictionary:dic];
                [_subclassList addObject:subClass];
            }
        }
    }
}


@end
