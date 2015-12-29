//
//  TJUserModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/7.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJLikeBaseDataModel.h"

@interface TJUserModel : TJLikeBaseDataModel

@property (nonatomic, strong) NSString   *userId;
@property (nonatomic, strong) NSString   *userName;
@property (nonatomic, strong) NSString   *nickName;
@property (nonatomic, strong) NSString   *icon;
@property (nonatomic, strong) NSString   *signature;
@property (nonatomic, strong) NSString   *birthday;
@property (nonatomic, strong) NSString   *identity;
@property (nonatomic, strong) NSString   *city;
@property (nonatomic, strong) NSString   *street;
@property (nonatomic, strong) NSString   *community;
@property (nonatomic, strong) NSString   *weibo;
@property (nonatomic, strong) NSString   *weiboicon;
@property (nonatomic, strong) NSString   *token;

@property (nonatomic, strong) NSString    *userPhone;

@end
