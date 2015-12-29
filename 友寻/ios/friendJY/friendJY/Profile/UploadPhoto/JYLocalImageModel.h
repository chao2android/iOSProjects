//
//  AZXLocalImageModel.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-14.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYLocalImageModel : NSObject

@property (nonatomic, copy) NSString *imageUrl; //url
@property (nonatomic, strong) UIImage *thumbnailImage; //缩略图
@property (nonatomic, strong) UIImage *fullScreenImage; //全屏图
@property (nonatomic, assign) BOOL selected;

@end
