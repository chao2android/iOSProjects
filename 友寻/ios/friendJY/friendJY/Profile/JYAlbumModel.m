//
//  AZXLocalImageModel.m
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-14.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYAlbumModel.h"

@implementation JYAlbumModel
- (NSDictionary*)attributeMapDictionary {
    NSDictionary *mapAtt = @{
                             @"pid"         : @"pid",
                             @"pic100"      : @"pic100",
                             @"pic300"      : @"pic300",
                             @"pic800"      : @"pic800",
                             @"pic1600"     : @"pic1600",
                             @"uid"         :@"uid",
                             @"nick"        :@"nick"
                             };
    return mapAtt;
}

@end
