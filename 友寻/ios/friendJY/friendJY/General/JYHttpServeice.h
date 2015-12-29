//
//  JYHttpServeice.h
//  friendJY
//
//  Created by 高斌 on 15/3/2.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessRequestBlock)(id responseObject);
typedef void(^FailureRequestBlock)(id error);

@interface JYHttpServeice : NSObject

+ (void)requestWithParameters:(NSDictionary *)parametersDict
                     postDict:(NSDictionary *)postDict
                   httpMethod:(NSString *)httpMethod
                      success:(SuccessRequestBlock)successBlock
                      failure:(FailureRequestBlock)failureBlock;

+ (void)requestWithParameters:(NSDictionary *)parametersDict
                     postDict:(NSDictionary *)postDict
                     formDict:(NSDictionary *)formDict
                      success:(SuccessRequestBlock)successBlock
                      failure:(FailureRequestBlock)failureBlock;

+ (void)requestWithParameters:(NSDictionary *)parametersDict
                     postDict:(NSDictionary *)postDict
                     dataDict:(NSDictionary *)dataDict
                     formDict:(NSDictionary *)formDict
                      success:(SuccessRequestBlock)successBlock
                      failure:(FailureRequestBlock)failureBlock;

//上传通信录
+ (void)requestUpListWithParameters:(NSDictionary *)parametersDict
                           dataDict:(NSDictionary *)dataDict
                            success:(SuccessRequestBlock)successBlock
                            failure:(FailureRequestBlock)failureBlock;
+ (BOOL)NetworkStatues;

@end
