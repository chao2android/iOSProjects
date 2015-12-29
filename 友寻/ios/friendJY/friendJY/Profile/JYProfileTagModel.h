//
//  JYProfileTagModel.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/23.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYBaseModel.h"
/*
 *  JYProfileTagModel 仅仅起到一个类型转换的功能。。。
 *  为了不打乱，不重写太多之前写的逻辑的东西 tid bind oper 都为NSNumber类型
 *
 */
@interface JYProfileTagModel : JYBaseModel

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *bind;
@property (nonatomic, copy) NSString *oper;
@property (nonatomic, copy) NSString *ctime;

- (NSDictionary*)modelToDictionary;

@end
