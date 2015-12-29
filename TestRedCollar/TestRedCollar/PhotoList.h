//
//  PhotoList.h
//  TestRedCollar
//
//  Created by miracle on 14-7-19.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoList : NSObject

@property (nonatomic, strong) NSDictionary *mDict;

@property (nonatomic, strong) NSString *pic_num;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *top_url;
@property (nonatomic, strong) NSString *ID;

+ (PhotoList *)CreateWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dictionary;

@end
