//
//  JYHttpServeice.m
//  friendJY
//
//  Created by 高斌 on 15/3/2.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYHttpServeice.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "JYAppDelegate.h"

@implementation JYHttpServeice

+ (BOOL)NetworkStatues{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    return manager.networkReachabilityStatus != 0;
}

+ (void)requestWithParameters:(NSDictionary *)parametersDict
                     postDict:(NSDictionary *)postDict
                   httpMethod:(NSString *)httpMethod
                      success:(SuccessRequestBlock)successBlock
                      failure:(FailureRequestBlock)failureBlock
{
    
    if (![JYHttpServeice NetworkStatues]) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        failureBlock(nil);
        return;
    }
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", HTTP_PREFIX];
    [urlStr appendString:@"?"];
    NSArray *allkeys = [parametersDict allKeys];
    for (int i=0; i<allkeys.count; i++) {
        NSString *key = [allkeys objectAtIndex:i];
        NSString *value = [parametersDict objectForKey:key];
        
        // url编码
        value = [value URLEncodedString];
        
        [urlStr appendFormat:@"%@=%@",key,value];
        
        if (i<allkeys.count-1) {
            [urlStr appendString:@"&"];
        }
    }
    //postDict加4个参数
    /*
     reg_meid  设备id
     reg_version  版本号
     reg_channel_id  传 100
     reg_mtype 传 ios
     */
//    NSLog(@"----->%@",UUID);
//    NSString *uuid = UUID;
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//    [postDict setObject:uuid forKey:@"reg_meid"];
//    [postDict setObject:version forKey:@"reg_version"];
//    [postDict setObject:@"100" forKey:@"reg_channel_id"];
//    [postDict setObject:@"ios" forKey:@"reg_mtype"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookies){
            
            [cookieStorage setCookie: cookie];
            
        }
        //NSLog(@"JSON: %@", responseObject);
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@---------%@************%@", error,operation.responseString,operation.request);
        failureBlock(error);
        
    }];
}

+ (void)requestWithParameters:(NSDictionary *)parametersDict
                     postDict:(NSDictionary *)postDict
                     formDict:(NSDictionary *)formDict
                      success:(SuccessRequestBlock)successBlock
                      failure:(FailureRequestBlock)failureBlock
{
    if (![JYHttpServeice NetworkStatues]) {
        failureBlock(nil);
        return;
    }
    
    if (formDict) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:formDict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
//        NSDictionary *postDict = [NSDictionary dictionaryWithObject:jsonString forKey:@"form"];
        [postDict setValue:jsonString forKey:@"form"];
    }
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", HTTP_PREFIX];
    [urlStr appendString:@"?"];
    NSArray *allkeys = [parametersDict allKeys];
    for (int i=0; i<allkeys.count; i++) {
        NSString *key = [allkeys objectAtIndex:i];
        NSString *value = [parametersDict objectForKey:key];
        
        // url编码
        value = [value URLEncodedString];
        
        [urlStr appendFormat:@"%@=%@",key,value];
        
        if (i<allkeys.count-1) {
            [urlStr appendString:@"&"];
        }
    }
    
//    NSLog(@"%@", formDict);
//    NSLog(@"%@", postDict);
//    NSLog(@"%@", urlStr);
//    [postDict setObject:UUID forKey:@"reg_meid"];
//    [postDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"reg_version"];
//    [postDict setObject:@"100" forKey:@"reg_channel_id"];
//    [postDict setObject:@"ios" forKey:@"reg_mtype"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        failureBlock(error);
        
    }];
    
}

+ (void)requestWithParameters:(NSDictionary *)parametersDict
                     postDict:(NSDictionary *)postDict
                     dataDict:(NSDictionary *)dataDict
                     formDict:(NSDictionary *)formDict
                      success:(SuccessRequestBlock)successBlock
                      failure:(FailureRequestBlock)failureBlock
{
    if (![JYHttpServeice NetworkStatues]) {
        failureBlock(nil);
        return;
    }
    if (formDict) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:formDict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //        NSDictionary *postDict = [NSDictionary dictionaryWithObject:jsonString forKey:@"form"];
        [postDict setValue:jsonString forKey:@"form"];
    }
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", HTTP_PREFIX];
    [urlStr appendString:@"?"];
    NSArray *allkeys = [parametersDict allKeys];
    for (int i=0; i<allkeys.count; i++) {
        NSString *key = [allkeys objectAtIndex:i];
        NSString *value = [parametersDict objectForKey:key];
        
        // url编码
        value = [value URLEncodedString];
        
        [urlStr appendFormat:@"%@=%@",key,value];
        
        if (i<allkeys.count-1) {
            [urlStr appendString:@"&"];
        }
    }
    
//    NSLog(@"%@", postDict);
//    NSLog(@"%@", urlStr);
//    
//    [postDict setObject:UUID forKey:@"reg_meid"];
//    [postDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"reg_version"];
//    [postDict setObject:@"100" forKey:@"reg_channel_id"];
//    [postDict setObject:@"ios" forKey:@"reg_mtype"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:postDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSString *key in dataDict) {
            NSData *data = [dataDict objectForKey:key];
//            [formData appendPartWithFormData:data name:key];
            [formData appendPartWithFileData:data name:key fileName:@"image.jpg" mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        failureBlock(error);
        
    }];

}

//上传通信录
+ (void)requestUpListWithParameters:(NSDictionary *)parametersDict
                           dataDict:(NSDictionary *)dataDict
                            success:(SuccessRequestBlock)successBlock
                            failure:(FailureRequestBlock)failureBlock
{
    if (![JYHttpServeice NetworkStatues]) {
        failureBlock(nil);
        return;
    }
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", HTTP_PREFIX];
    [urlStr appendString:@"?"];
    NSArray *allkeys = [parametersDict allKeys];
    for (int i=0; i<allkeys.count; i++) {
        NSString *key = [allkeys objectAtIndex:i];
        NSString *value = [parametersDict objectForKey:key];
        
        // url编码
        value = [value URLEncodedString];
        
        [urlStr appendFormat:@"%@=%@",key,value];
        
        if (i<allkeys.count-1) {
            [urlStr appendString:@"&"];
        }
    }
    
    NSLog(@"%@", dataDict);
    NSLog(@"%@", urlStr);
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithObject:@"4" forKey:@"type"];
//    [postDict setObject:UUID forKey:@"reg_meid"];
//    [postDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"reg_version"];
//    [postDict setObject:@"100" forKey:@"reg_channel_id"];
//    [postDict setObject:@"ios" forKey:@"reg_mtype"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:postDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSString *key in dataDict) {
            NSData *data = [dataDict objectForKey:key];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
            [formData appendPartWithFileData:data name:key fileName:@"contacts" mimeType:@""];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        failureBlock(error);
        
    }];
    
}

@end
