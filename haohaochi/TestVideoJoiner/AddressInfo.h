//
//  AddressInfo.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject

@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSDictionary *mDict;

+ (AddressInfo *)CreateWithDict:(NSDictionary *)dict;

@end
