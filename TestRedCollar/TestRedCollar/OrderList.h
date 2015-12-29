//
//  OrderList.h
//  TestRedCollar
//
//  Created by miracle on 14-7-28.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartItemList.h"

@interface OrderList : NSObject

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSNumber *orderStatus;
@property (nonatomic, strong) NSString *orderCode;
@property (nonatomic, strong) NSString *orderMoney;
@property (nonatomic, strong) NSString *orderTime;
@property (nonatomic, strong) NSString *consigneeName;
@property (nonatomic, strong) NSString *consigneePhone;
@property (nonatomic, strong) NSString *consigneeAddress;
@property (nonatomic, strong) NSNumber *payWay;
@property (nonatomic, strong) NSString *delivery;
@property (nonatomic, strong) NSString *payUrl;
@property (nonatomic, strong) NSString *source_from;

@property (nonatomic, strong) NSMutableArray *cartItemArr;

+ (OrderList *)CreateWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dictionary;

@end
