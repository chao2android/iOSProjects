//
//  JYFeedDetailModel.m
//  friendJY
//
//  Created by ouyang on 4/7/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedDetailModel.h"

@implementation JYFeedDetailModel
- (NSDictionary*)attributeMapDictionary {
    NSDictionary *mapAtt = @{
                             @"feedid"    :@"feedid",
                             @"feedUid"   :@"feedUid",
                             @"avatar"    : @"avatar",
                             @"content"    : @"content",
                             @"id"         : @"id",
                             @"nick"       : @"nick",
                             @"reply"      : @"reply",
                             @"sex"        : @"sex",
                             @"time"       : @"time",
                             @"uid"        : @"uid"
                             };
    
    return mapAtt;
}

@end
