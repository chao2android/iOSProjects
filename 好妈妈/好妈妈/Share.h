//
//  Share.h
//  好妈妈
//
//  Created by iHope on 13-10-28.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Share : NSObject

+ (void)SharecontentMenth:(NSString *)contentString shareImagePath:(NSString *)imageString biaoti:(NSString *)biaotiString fenxiangleixing:(int)fenxiangType;

+ (BOOL)IsIpad;

#define ISIPAD [Share IsIpad]
@end
