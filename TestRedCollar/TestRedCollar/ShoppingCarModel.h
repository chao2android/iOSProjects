//
//  ShoppingCarModel.h
//  TestRedCollar
//
//  Created by MC on 14-7-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCarModel : NSObject

@property (copy,nonatomic)NSString *goods_id;
@property (copy,nonatomic)NSString *goods_image;
@property (copy,nonatomic)NSString *goods_name;
@property (copy,nonatomic)NSString *goods_sn;
@property (copy,nonatomic)NSString *items;
@property (copy,nonatomic)NSString *price;
@property (copy,nonatomic)NSString *specification;

@property int quantity;
@property int rec_id;
@property int session_id;
@property int spec_id;
@property int store_id;
@property int subtotal;
@property int type;
@property int user_id;

@property (copy,nonatomic)NSString *cst_author;
@property (copy,nonatomic)NSString *cst_cate;
@property (copy,nonatomic)NSString *cst_source;
@property (copy,nonatomic)NSString *cst_source_id;
@property (copy,nonatomic)NSString *goods_weight;
@property (copy,nonatomic)NSString *height;
@property (copy,nonatomic)NSString *is_diy;
@property (copy,nonatomic)NSString *source_id;
@property (copy,nonatomic)NSString *source_title;
@property (copy,nonatomic)NSString *type_name;
@property (copy,nonatomic)NSString *weight;
@property (copy,nonatomic)NSString *emb_con;
@property (copy,nonatomic)NSString *fabric;
@end
