//
//  TJUserManager.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/8.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJUserModel.h"

typedef void(^QuitFinish)();

@interface TJUserManager : NSObject

@property (nonatomic, strong) TJUserModel *userInfor;
@property (nonatomic, copy)   QuitFinish  quitBlock;

+ (instancetype)sharePageManager;

- (void)quitUserSuccess:(QuitFinish) quitBlock;

- (void)saveUserInfor:(NSDictionary *)userInfor withPhone:(NSString *)telephone;

@end
