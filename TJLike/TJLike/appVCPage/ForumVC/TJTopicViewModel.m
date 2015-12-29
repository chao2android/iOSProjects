//
//  TJTopicViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJTopicViewModel.h"
#import "TJBBSTopTieBaModel.h"
#import "TJTieBaContentModel.h"

@implementation TJTopicViewModel

- (void)postTopicBBSNotice:(NSString *)subId andFinishBlock:(void (^)(NSArray *results))finishBlock andFaileBlock:(void (^)(NSString *))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsNotice",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         subId,@"subId",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSArray *resultList=[[NSArray alloc]init];
            resultList = [response objectForKey:@"data"];
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"数据请求失败");
        }
        
        
    } error:^(NSError *error) {
        failBlock(error.localizedDescription);
    }];
}

- (void)postTopicBBSTopTieBa:(NSString *)subId andFinishBlock:(void(^)(NSArray *results))finishBlock andFaileBlock:(void(^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsTopTieBa",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         subId,@"nid",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJBBSTopTieBaModel *model = [[TJBBSTopTieBaModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
            }
            self.topLists = resultList;
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"请求失败");
        }
        
        
    } error:^(NSError *error) {
        failBlock(error.localizedDescription);
    }];

}

- (void)postTopicBBSTieBaContent:(NSString *)subId withPageIndex:(int)pageIndex andFinishBlock:(void(^)(NSArray *results))finishBlock andFaileBlock:(void(^)(NSString *error))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsTieBa",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         subId,@"cid",
                         [NSNumber numberWithInt:pageIndex],@"Page",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(NSDictionary *response) {
        TLog(@"%@",response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *resultList=[[NSMutableArray alloc]init];
            NSArray *dicArray=response[@"data"];
            for (NSDictionary *item in dicArray) {
                TJTieBaContentModel *model = [[TJTieBaContentModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [resultList addObject:model];
                TLog(@"%@",model.imgs);
            }
            self.contentLists = resultList;
            
            finishBlock(resultList);
        }
        else if ([[response objectForKey:@"code"] integerValue] == 500){
            failBlock(@"数据返回失败");
        }
    } error:^(NSError *error) {
        failBlock(error.localizedDescription);
    }];
}

- (void)postTopicBBSAddTieba:(NSString *)cateId andUserId:(NSString *)userId withTitle:(NSString *)title withFont:(NSString *)font withPalce:(NSString *)palce withimageFile:(NSArray *)array andFinishBlock:(void (^)(NSArray *))finishBlock andFaileBlock:(void (^)(NSString *))failBlock
{
    NSString *strUrl = [NSString stringWithFormat:@"%@BbsAddTieba",TJZOUNAI_ADDRESS_URL];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         cateId,@"cid",
                         userId,@"uid",
                         title,@"Title",
                         font,@"Font",
                         palce,@"Palce",
                         array,@"$_FILES[0]",
                         nil];
    [[HttpClient postRequestWithPath:strUrl para:dic] subscribeNext:^(id x) {
        TLog(@"%@",x);
        
        
    } error:^(NSError *error) {
        
    }];
}


@end
