//
//  SingleListModel.h
//  TestRedCollar
//
//  Created by MC on 14-7-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleListModel : NSObject

@property int id;
@property int cst_id;
@property int cst_cate;
@property (copy,nonatomic)NSString *image;
@property (copy,nonatomic)NSString *name;
@property (copy,nonatomic)NSString *oldprice;
@property (copy,nonatomic)NSString *price;
@property (copy,nonatomic)NSString *des;
@property (copy,nonatomic)NSArray *biaoZhunMa;
@end
