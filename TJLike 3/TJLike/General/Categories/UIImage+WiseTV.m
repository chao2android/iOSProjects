//
//  UIImage+WiseTV.m
//  WiseTV
//
//  Created by Ran on 14/11/21.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import "UIImage+WiseTV.h"

@implementation UIImage (WiseTV)

+ (UIImage *)wtv_imageAddSuffixByDeviceWithName:(NSString *)imgName {
    NSMutableString *str = [NSMutableString stringWithString:imgName];
    switch (AppContext.deviceInfo.deviceVersion) {
        case iPhone4:
        case iPhone4S:
            [str appendString:@"_ip4"];
            break;
        case iPhone5:
        case iPhone5S:
            [str appendString:@"_ip5"];
            break;
        case iPhone6:
            [str appendString:@"_ip6"];
            break;
        case iPhone6Plus:
            [str appendString:@"_ip6plus"];
            break;
        default:
            [str appendString:@"_ip5"];
            break;
    }
    return [UIImage imageNamed:str];
}


+ (NSString *)wtv_imageNameAddSuffixByBusTransferSort:(int)sort {
    NSString *str = @"";
    
    switch (sort) {
        case 0:
            str = @"line_green";
            break;
        case 1:
            str = @"line_orange";
            break;
        case 2:
            str = @"line_red";
            break;
        case 3:
            str = @"line_blue";
            break;
        case 4:
            str = @"line_purple";
            break;
        default:
            break;
    }
    
    return str;
}

- (UIImage *)wtv_imageTelescopicToSize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (NSData *)wtv_imageTransformData
{
    NSData *data;
    if (UIImagePNGRepresentation(self) == nil) {
        data = UIImageJPEGRepresentation(self, 1);
    }
    else{
        data = UIImagePNGRepresentation(self);
    }
    
    return data;
}

@end
