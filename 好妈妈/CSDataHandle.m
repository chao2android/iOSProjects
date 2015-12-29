//
//  CSDataHandle.m
//  CSweibo
//

//  ［网络请求］

//  Created by ihope999 on 13-8-12.
//  Copyright (c) 2013年 cszwdy. All rights reserved.
//

//完整链接如：http://202.85.214.88/baiqu/web/home/index/shoplists?type=0&limit=20&page=1&order=0&distance=10000&lng=116.402977&lat=39.912952

#import "CSDataHandle.h"
#define BASE_URL @"http://202.85.214.88/baiqu/web/home/index/"

@implementation CSDataHandle

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                 httpRequestMethod:(NSString *)httpMehtod
                     completeBlock:(RequestCompleteBlock)block
{
    
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];    //禁用网络指示器
    
    //如：http://202.85.214.88/baiqu/web/home/index/basicregist?
//    urlstring = [BASE_URL stringByAppendingFormat:@"%@?",urlstring];
    
    /*** 处理GET请求的参数 ***/
    NSComparisonResult comparRecGET = [httpMehtod caseInsensitiveCompare:@"GET"];
    if (httpMehtod != nil && comparRecGET == NSOrderedSame) {
        
        NSArray *allKeys = [params allKeys];
        NSString *paramsString = [NSMutableString string];
        
        for (int i = 0; i< params.count; i++) {
            NSString *key = allKeys[i];
            id value = [params objectForKey:key];
            
            //拼接
            paramsString = [paramsString stringByAppendingFormat:@"%@=%@&",key,value];
        }
        //如：code=&name=&password=&sex=&age=&constellation=&img=&lat=&lng=&mobile=mmm
       paramsString = [paramsString substringToIndex:[paramsString length] - 1];
        
        //完整GET的URL：
       urlstring = [urlstring stringByAppendingString:paramsString];
        
      NSLog(@"urlstring:%@",urlstring);
    }
    NSURL *url = [NSURL URLWithString:urlstring];
    NSLog(@"url = %@",url);
    
    
   __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];   //避免block的循环引用
    
    /*** 设置超时时间 ***/
    [request setTimeOutSeconds:60];
    [request setRequestMethod:httpMehtod];
    
    
    /*** 处理POST请求 ***/
    NSComparisonResult comparRecPOST = [httpMehtod caseInsensitiveCompare:@"POST"];
    if (httpMehtod != nil && comparRecPOST == NSOrderedSame) {
        
        NSArray *allKeys = [params allKeys];
        NSLog(@"%@",allKeys);
        for (int i = 0; i < params.count; i++) {
            NSString *key = allKeys[i];
            id value = [params objectForKey:key];
            
             //判断文件是否上传
//#warning  又局限性，待修改
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value forKey:key];
            }else if ([key isEqualToString:@"file"] || [key isEqualToString:@"image"]){       //上传本地文件，file
                NSLog(@"%s,走file上传",__FUNCTION__);
                [request addFile:value forKey:key];
            }
            else {
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    [request setCompletionBlock:^{
        NSData *data = request.responseData;
        id result = nil;
        
        result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block != nil) {
            block(result);
        }
        
    }];
    
    [request startAsynchronous];
    
    /*** block获得解析结果 ***/
    
    return request;
}

@end
