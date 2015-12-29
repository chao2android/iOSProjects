//
//  ConsignessList.h
//  TestRedCollar
//
//  Created by miracle on 14-7-17.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsigneeList : NSObject

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSString *addr_id;
@property (nonatomic, strong) NSString *consignee;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *phone_mob;
@property (nonatomic, strong) NSString *phone_tel;
@property (nonatomic, strong) NSString *email;
@property (copy,nonatomic) NSString *region_name;
@property (copy,nonatomic) NSString *user_id;

@property (nonatomic, strong) NSString *region_id;

+ (ConsigneeList *)CreateWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dictionary;

@end
