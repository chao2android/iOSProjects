//
//  AZXLocalImageModel.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-14.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYBaseModel.h"

@interface JYAlbumModel : JYBaseModel

@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *pic100;
@property (nonatomic, strong) NSString *pic300;
@property (nonatomic, strong) NSString *pic800;
@property (nonatomic, strong) NSString *pic1600;


@end
