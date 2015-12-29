//
//  CategoryManager.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "CategoryManager.h"


static CategoryManager *gUserManager = nil;

@implementation CategoryManager

+ (CategoryManager *)Share
{
    if (!gUserManager) {
        gUserManager = [[CategoryManager alloc] init];
        
    }
    return gUserManager;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)mcArray
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"mcArray"];
}

- (void)setMcArray:(NSMutableArray *)array
{
    if (array) {
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"mcArray"];
    }else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mcArray"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
