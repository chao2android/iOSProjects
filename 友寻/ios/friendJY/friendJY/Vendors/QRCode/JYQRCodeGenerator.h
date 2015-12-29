//
//  JYQRCodeGenerator.h
//  friendJY
//
//  Created by chenxiangjing on 15/6/9.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYQRCodeGenerator : NSObject

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;
+ (UIImage *) twoDimensionCodeImage:(UIImage *)twoDimensionCode withAvatarImage:(UIImage *)avatarImage;


@end