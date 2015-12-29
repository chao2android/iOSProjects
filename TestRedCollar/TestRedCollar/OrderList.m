//
//  OrderList.m
//  TestRedCollar
//
//  Created by miracle on 14-7-28.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "OrderList.h"

@implementation OrderList

+ (OrderList *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[OrderList alloc] initWithDict:dict];
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
        self.cartItemArr = [[NSMutableArray alloc] init];
        
        NSDictionary *netDic = [self GetFormatDict:dictionary];
        self.mDict = netDic;
        self.consigneeName = [[netDic objectForKey:@"Consignee"] objectForKey:@"name"];
        self.consigneeAddress = [[netDic objectForKey:@"Consignee"] objectForKey:@"address"];
        self.consigneePhone = [[netDic objectForKey:@"Consignee"] objectForKey:@"phone"];
        self.orderStatus = [netDic objectForKey:@"orderStatus"];
        self.orderCode = [netDic objectForKey:@"orderCode"];
        self.orderMoney = [netDic objectForKey:@"orderMoney"];
        self.payWay = [netDic objectForKey:@"payWay"];
        self.delivery = [netDic objectForKey:@"delivery"];
        self.orderTime = [netDic objectForKey:@"orderTime"];
        self.payUrl = [netDic objectForKey:@"payUrl"];
        self.source_from = [netDic objectForKey:@"source_from"];
        
        NSArray *array = [netDic objectForKey:@"cartItemList"];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            CartItemList *list = [[CartItemList alloc] init];
            list.goodsImage = [dict objectForKey:@"goods_image"];
            list.goodsName = [dict objectForKey:@"goods_name"];
            list.goodsPrice = [dict objectForKey:@"price"];
            list.goodsQuantity = [dict objectForKey:@"quantity"];
            list.type_name = [dict objectForKey:@"type_name"];
            
            if (list.goodsImage && list.goodsImage.length > 0){
                NSRange range = [list.goodsImage rangeOfString:@"http://"];
                if (range.length == 0){
                    list.goodsImage = [NSString stringWithFormat:@"%@%@",URL_HEADER,list.goodsImage];
                }
            }
            [self.cartItemArr addObject:list];
        }
    }
    return self;
}

- (void)dealloc
{
    self.mDict = nil;
    self.consigneeName = nil;
    self.consigneeAddress = nil;
    self.consigneePhone = nil;
    self.orderStatus = nil;
    self.orderCode = nil;
    self.orderMoney = nil;
    self.payWay = nil;
    self.delivery = nil;
    self.orderTime = nil;
}

@end
