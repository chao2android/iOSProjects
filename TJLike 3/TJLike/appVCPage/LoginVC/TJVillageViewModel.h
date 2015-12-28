//
//  TJVillageViewModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/15.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJVillageViewModel : NSObject

@property (nonatomic, strong) NSArray        *cityArr;
@property (nonatomic, strong) NSArray        *streetArr;
@property (nonatomic, strong) NSArray        *communityArr;

- (void)getCityFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock;

- (void)postStreet:(NSString *)cityId andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock;

- (void)postCommunity:(NSString *)streetID andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock;
- (void)postAddCommunity:(NSString *)streetID communtyName:(NSString *)name andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock;
- (void)postUserAddCommunity:(NSString *)city andStreet:(NSString *)street andCommunity:(NSString *)community andUserid:(NSString *)uid andStatus:(NSString *)status andFinish:(void(^)(NSArray * results))finishBlock andFailed:(void(^)(NSString *errer))failedBlock;


@end
