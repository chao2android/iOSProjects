//
//  TJUserInfoEditViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJUserInfoEditViewModel.h"

@implementation TJUserInfoEditViewModel

- (void)postPerfectUserInfo:(NSString *)nickname anduid:(NSString *)uid andsignature:(NSString *)signature andbirthday:(NSString *)birthday andsex:(NSString *)sex finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@UpdateUserInfo",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         nickname,@"nickname",
                         uid,@"uid",
                         signature,@"signature",
                         birthday,@"birthday",
                         sex,@"sex",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"修改个人信息失败");
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}
- (void)postBindThirdWeibo:(NSString *)weibo anduid:(NSString *)uid andweiboicon:(NSString *)weiboicon andtoken:(NSString *)token finish:(void(^)(void))finishBlock failed:(void(^)(NSString *error))failedBlock{
    NSString *strUrl = [NSString stringWithFormat:@"%@BindingWeibo",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         uid,@"uid",
                         weibo,@"weibo",
                         weiboicon,@"weiboicon",
                         token,@"token",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            
            
            finishBlock();
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"绑定失败失败");
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];

    
    
    
}

@end
