//
//  CategoryManager.h
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryManager : NSObject

@property (nonatomic, assign) NSMutableArray *mcArray;

+ (CategoryManager *)Share;

@end
