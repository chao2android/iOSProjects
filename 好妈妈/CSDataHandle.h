//
//  CSDataHandle.h
//  CSweibo
//

//  ［网络请求］GET & POST

//  Created by ihope999 on 13-8-12.
//  Copyright (c) 2013年 cszwdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestCompleteBlock)(id result);

@interface CSDataHandle : NSObject

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                 httpRequestMethod:(NSString *)httpMehtod
                     completeBlock:(RequestCompleteBlock)block;
@end
