//
//  HttpDownManager.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-4-25.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownManager.h"
#import "NSString+SBJSON.h"

@interface HttpDownManager : ImageDownManager {
    
}

- (void)GetHttpRequest:(NSString *)cmd :(NSString *)action :(NSDictionary *)dict;
- (void)GetHttpRequest2:(NSString *)cmd :(NSString *)action :(NSDictionary *)dict;

@end
