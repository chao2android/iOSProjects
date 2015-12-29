//
//  TJVillageViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJVillageViewModel.h"

@implementation TJVillageViewModel

- (void)getCityFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@City",TJZOUNAI_ADDRESS_URL];
    [[HttpClient getRequestWithPath:strUrl] subscribeNext:^(NSDictionary *response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
//            NSArray *dicArray=response[@"data"];
//            for (NSDictionary *item in dicArray) {
//                TJBBSCommendModel *model = [[TJBBSCommendModel alloc] init];
//                [model setValuesForKeysWithDictionary:item];
//                [resultList addObject:model];
//            }
            self.cityArr = resultList;
            finishBlock(resultList);;
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock([response objectForKey:@"msg"]);
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}

- (void)postStreet:(NSString *)cityId andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Street",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         cityId ,@"id",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
    
           
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
//            NSArray *dicArray=resultDic[@"data"];
            
            
            self.streetArr = resultList;
            finishBlock(nil);
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"获取失败");
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];

}

- (void)postCommunity:(NSString *)streetID andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Street",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         streetID ,@"id",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            //            NSArray *dicArray=resultDic[@"data"];
            
            
            self.communityArr = resultList;
            finishBlock(nil);
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"获取失败");
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}
- (void)postAddCommunity:(NSString *)streetID communtyName:(NSString *)name andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Street",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         streetID ,@"id",
                         name,@"name",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            //            NSArray *dicArray=resultDic[@"data"];
            
            
            self.communityArr = resultList;
            finishBlock(nil);
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"获取失败");
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}
- (void)postUserAddCommunity:(NSString *)city andStreet:(NSString *)street andCommunity:(NSString *)community andUserid:(NSString *)uid andStatus:(NSString *)status andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@Street",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         city ,@"city",
                         street,@"street",
                         community,@"community",
                         uid,@"uid",
                         status,@"status",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *resultDic) {
        
        
        
        if ([[resultDic objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            //            NSArray *dicArray=resultDic[@"data"];
            
            
            self.communityArr = resultList;
            finishBlock(nil);
        }
        else if ([[resultDic objectForKey:@"code"] integerValue] == 500){
            failedBlock(@"获取失败");
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}


@end
