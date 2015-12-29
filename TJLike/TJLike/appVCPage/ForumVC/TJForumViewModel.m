//
//  TJForumViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJForumViewModel.h"
#import "TJBBSPosterModel.h"
#import "TJBBSCommendModel.h"
#import "TJBBSHotListModel.h"
#import "TJBbsCatagoryModel.h"

@implementation TJForumViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _posterInfoArr = [[NSMutableArray alloc] init];
        _hotInfoArr    = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)requestBBsHotCommendFinish:(void (^)(NSArray *))finishBlock andFailed:(void (^)(NSString *))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsHotCommend",TJZOUNAI_ADDRESS_URL];
    [[HttpClient getRequestWithPath:strUrl] subscribeNext:^(NSDictionary *response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJBBSCommendModel *model = [[TJBBSCommendModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.hotInfoArr = resultList;
            finishBlock(resultList);;
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock([response objectForKey:@"msg"]);
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
}

- (void)requestBBsHotFocusFinish:(void (^)(NSArray *))finishBlock andFailed:(void (^)(NSString *))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsHotFocus",TJZOUNAI_ADDRESS_URL];
    [[HttpClient getRequestWithPath:strUrl] subscribeNext:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJBBSPosterModel *model = [[TJBBSPosterModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.posterInfoArr = resultList;
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock([response objectForKey:@"msg"]);
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
   
}

- (void)requestBBsHotListPage:(int)pageIndex andFinish:(void (^)(NSArray *))finishBlock andFailed:(void (^)(NSString *))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsHotList",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt:pageIndex],@"Page",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJBBSHotListModel *model = [[TJBBSHotListModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.hotListArr = resultList;
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock([response objectForKey:@"msg"]);
        }
        
        
    } error:^(NSError *error) {
         failedBlock(error.localizedDescription);
    }];
   
}


- (void)requestBBsCatagoryFinish:(void (^)(NSArray *))finishBlock andFailed:(void (^)(NSString *))failedBlock
{
     NSString *strUrl = [NSString stringWithFormat:@"%@BbsCatagory",TJZOUNAI_ADDRESS_URL];
    [[HttpClient getRequestWithPath:strUrl] subscribeNext:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJBbsCatagoryModel *model = [[TJBbsCatagoryModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.forumArr = resultList;
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failedBlock([response objectForKey:@"msg"]);
        }
    } error:^(NSError *error) {
        failedBlock(error.localizedDescription);
    }];
    
}

- (void)requestBBsContent:(id)bbsID andFinish:(void (^)(void))finishBlock andFailed:(void (^)(void))failedBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsContent",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         bbsID,@"Id",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(id x) {
        TLog(@"%@",x);
        
    } error:^(NSError *error) {
        
    }];
}

@end
