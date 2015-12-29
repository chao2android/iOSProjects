//
//  TJRegistViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJRegistViewModel.h"

@implementation TJRegistViewModel


- (void)postPhoneRegisterUserInfo:(NSString *)userName andPassWord:(NSString *)password andCode:(NSString *)code finish:(void (^)(void))finishBlock failed:(void (^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Register",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         userName,@"username",
                         password,@"password",
                         code,@"code",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            //            NSDictionary *resultDict = resultDic[@"data"];
            
            //            [UserManager saveUserInfor:resultDict];
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"注册失败");
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 401){
            failedBlock(@"手机已用");
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}

- (void)postForgetPassWord:(NSString *)userName andPassWord:(NSString *)password andRepassword:(NSString *)repassword andCode:(NSString *)code finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@ResetPass",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         userName,@"username",
                         password,@"password",
                         repassword,@"repassword",
                         code,@"code",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            //            NSDictionary *resultDict = resultDic[@"data"];
            
            //            [UserManager saveUserInfor:resultDict];
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"注册失败");
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 501){
            failedBlock(@"两次密码不一致");
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 501){
            failedBlock(@"验证码错误");
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}

- (void)postSendNumbert:(NSString *)telphone finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@SendNumbert",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         telphone,@"telphone",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            //            NSDictionary *resultDict = resultDic[@"data"];
            
            //            [UserManager saveUserInfor:resultDict];
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"验证失败");
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}


@end
