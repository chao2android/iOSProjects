//
//  JYProfileData.h
//  friendJY
//
//  Created by 欧阳 on 15/3/5.
//  Copyright (c) 2015年 欧阳. All rights reserved.
//
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import <Foundation/Foundation.h>

@interface JYProfileData : NSObject{
    NSString * p_uid;
    FMDatabase *db;
    NSDictionary * _photosList;
    NSMutableDictionary *_profile_dict;
}

@property (nonatomic, strong) NSMutableDictionary *profile_dict;

+ (JYProfileData *)sharedInstance;

- (NSDictionary *) getProfileData:(NSString *)target_uid;

- (NSDictionary *) getPhotoList:(NSString*)pid num:(NSString *)num;

- (NSMutableDictionary *) getProfileTagList:(NSString *)target_uid;

- (BOOL) insertOneUser:(NSString *) uid jsonString:(NSString *)jsonString;

- (BOOL)updateMyProfileWithNewProfileDic:(NSDictionary*)newProfileDic;

- (BOOL)updateTagListWithNewTagList:(NSArray*)tagList uid:(NSString*)uid;

- (void)cleanData;

- (void)loadMyProfileDataWithSuccessBlcok:(SuccessRequestBlock)successBlock failureBlock:(FailureRequestBlock)failureBlock;

@end
