//
//  JYProfileDownImagePraiseManager.m
//  friendJY
//
//  Created by aaa on 15/7/2.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYProfileDownImagePraiseManager.h"

@implementation JYProfileDownImagePraiseManager

+ (void)DownImagePraiseDate:(NSDictionary *)imageDict andSucceedBlock:(void(^)(NSMutableDictionary *imagePraiseDict)) SucceedBlock
{
    NSMutableDictionary *praiseDict = [[NSMutableDictionary alloc]init];
    NSString *myself_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t groupQueue = dispatch_group_create();
    for (NSString *key in imageDict) {
        dispatch_group_async(groupQueue, globalQueue, ^{
            NSString *urlStr = [NSString stringWithFormat:@"%@?mod=photo&func=getPhotoPraiseList", HTTP_PREFIX];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlStr]];
            [request setHTTPMethod:@"POST"];
            NSMutableData *postBody = [NSMutableData data];
            //int this->uid, int this->photo_id, int start, int nums
            [postBody appendData:[[NSString stringWithFormat:@"fuid=%@&photo_id=%@&start=0&nums=1",myself_uid,key] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:postBody];
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                                       returningResponse:nil error:nil];
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnData
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:nil];
            NSLog(@"responseObject--->%@",responseObject);
            if ([responseObject[@"retcode"] integerValue] == 1) {
                [praiseDict setObject:responseObject forKey:key];
            }
        });
    }
    dispatch_group_notify(groupQueue, dispatch_get_main_queue(), ^{
        
        SucceedBlock(praiseDict);
        NSLog(@"----finish-----");
    });
}
+ (void)DownImagePraiseDate:(NSDictionary *)imageDict andUid:(NSString *)fuid andSucceedBlock:(void(^)(NSMutableDictionary *imagePraiseDict)) SucceedBlock
{
    NSMutableDictionary *praiseDict = [[NSMutableDictionary alloc]init];
    //NSString *myself_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t groupQueue = dispatch_group_create();
    for (NSString *key in imageDict) {
        dispatch_group_async(groupQueue, globalQueue, ^{
            NSString *urlStr = [NSString stringWithFormat:@"%@?mod=photo&func=getPhotoPraiseList", HTTP_PREFIX];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlStr]];
            [request setHTTPMethod:@"POST"];
            NSMutableData *postBody = [NSMutableData data];
            //int this->uid, int this->photo_id, int start, int nums
            [postBody appendData:[[NSString stringWithFormat:@"fuid=%@&photo_id=%@&start=0&nums=1",fuid,key] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:postBody];
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                                       returningResponse:nil error:nil];
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnData
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:nil];
            NSLog(@"responseObject--->%@",responseObject);
            if ([responseObject[@"retcode"] integerValue] == 1) {
                [praiseDict setObject:responseObject forKey:key];
            }
        });
    }
    dispatch_group_notify(groupQueue, dispatch_get_main_queue(), ^{
        
        SucceedBlock(praiseDict);
        NSLog(@"----finish-----");
    });
}

+ (void)PraiseImage:(NSString *)uid andFuid:(NSString *)fuid andPid:(NSString *)pid andSucceedBlock:(void(^)())succeedBlock andFaildBlock:(void(^)(id error))faildBlock{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"photo" forKey:@"mod"];
    [parametersDict setObject:@"praisePhoto" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:uid forKey:@"uid"];
    [postDict setObject:fuid forKey:@"fuid"];
    [postDict setObject:pid forKey:@"photo_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            succeedBlock();
        } else {
            [[JYAppDelegate sharedAppDelegate]showTip:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"retmean"]]];
            faildBlock([responseObject objectForKey:@"retmean"]);
        }
        
    } failure:^(id error) {
        faildBlock(error);
    }];
}

+ (void)CanclePraiseImage:(NSString *)uid andFuid:(NSString *)fuid andPid:(NSString *)pid andSucceedBlock:(void(^)())succeedBlock andFaildBlock:(void(^)(id error))faildBlock{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"photo" forKey:@"mod"];
    [parametersDict setObject:@"praisePhotoCancle" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:uid forKey:@"uid"];
    [postDict setObject:fuid forKey:@"fuid"];
    [postDict setObject:pid forKey:@"photo_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            succeedBlock();
        } else {
            [[JYAppDelegate sharedAppDelegate]showTip:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"retmean"]]];
            faildBlock([responseObject objectForKey:@"retmean"]);
        }
        
    } failure:^(id error) {
        faildBlock(error);
    }];
}



@end
