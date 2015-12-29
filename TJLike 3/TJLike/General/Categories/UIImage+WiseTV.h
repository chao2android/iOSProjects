//
//  UIImage+WiseTV.h
//  WiseTV
//
//  Created by Ran on 14/11/21.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WiseTV)

+ (UIImage *)wtv_imageAddSuffixByDeviceWithName:(NSString *)imgName;

+ (NSString *)wtv_imageNameAddSuffixByBusTransferSort:(int)sort;

- (UIImage *)wtv_imageTelescopicToSize:(CGSize)size;

- (NSData *)wtv_imageTransformData;

@end
