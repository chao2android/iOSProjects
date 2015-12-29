//
//  TJLoginViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJLoginViewModel.h"

@implementation TJLoginViewModel



- (void)postLoginUserInfo:(NSString *)userName andPassWord:(NSString *)password finish:(void (^)(void))finishBlock failed:(void (^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Login",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    userName,@"username",
                                                      password,@"password",
                                                        nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            NSDictionary *resultDict = resultDic[@"data"];
            
            [UserManager saveUserInfor:resultDict withPhone:userName];
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock([resultDic objectForKey:@"msg"]);
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 401){
            failedBlock(@"手机已用");
        }
        
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}

- (void)postThirdLoginUserInfo:(NSString *)jasonStr finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Weibo",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         jasonStr,@"param",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            NSDictionary *resultDict = resultDic[@"data"];
            
            TLog(@"%@",resultDict);
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"登陆失败");
        }
        
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}

@end
