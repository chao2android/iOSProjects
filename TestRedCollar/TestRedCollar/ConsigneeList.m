//
//  ConsignessList.m
//  TestRedCollar
//
//  Created by miracle on 14-7-17.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ConsigneeList.h"

@implementation ConsigneeList

+ (ConsigneeList *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[ConsigneeList alloc] initWithDict:dict];
}

- (NSDictionary *)GetFormatDict:(NSDictionary *)dictionary {
    NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    for (NSString *key in netDic.allKeys) {
        id target = [netDic objectForKey:key];
        if ([target isKindOfClass:[NSNull class]]) {
            [netDic removeObjectForKey:key];
        }
    }
    return netDic;
}

- (id)initWithDict:(NSDictionary *)dictionary
{
    self = [super init];
    if (self){
        NSDictionary *netDic = [self GetFormatDict:dictionary];
        self.mDict = netDic;
        self.addr_id = [netDic objectForKey:@"addr_id"];
        self.consignee = [netDic objectForKey:@"consignee"];
        self.area = [netDic objectForKey:@"al_name"];
        self.city = [netDic objectForKey:@"region_name"];
        self.address = [netDic objectForKey:@"address"];
        self.zipCode = [netDic objectForKey:@"zipcode"];
        self.phone_mob = [netDic objectForKey:@"phone_mob"];
        self.phone_tel = [netDic objectForKey:@"phone_tel"];
        self.email = [netDic objectForKey:@"email"];
        self.region_name = [netDic objectForKey:@"region_name"];
        self.user_id = [netDic objectForKey:@"user_id"];
        self.region_id = [netDic objectForKey:@"region_id"];
    }
    return self;
}

- (void)dealloc
{
    self.mDict = nil;
    self.addr_id = nil;
    self.consignee = nil;
    self.area = nil;
    self.city = nil;
    self.address = nil;
    self.zipCode = nil;
    self.phone_mob = nil;
    self.phone_tel = nil;
    self.email = nil;
    self.region_name = nil;
    self.user_id = nil;
    self.region_id = nil;
}

@end
