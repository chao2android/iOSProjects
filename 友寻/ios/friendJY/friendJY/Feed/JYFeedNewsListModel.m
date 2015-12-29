//
//  JYFeedNewsListModel.m
//  friendJY
//
//  Created by ouyang on 4/20/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedNewsListModel.h"

@implementation JYFeedNewsListModel
- (NSDictionary*)attributeMapDictionary {

    NSDictionary *mapAtt = @{
                             @"avatars"     : @"avatars",
                             @"fcontent"        : @"fcontent",
                             @"fid"         : @"fid",
                             @"fpids"    : @"fpids",
                             @"ftype"         : @"ftype",
                             @"iid"        : @"iid",
                             @"nick"    : @"nick",
                             @"sendtime"    : @"sendtime",
                             @"title"       : @"title",
                             @"type"        : @"type",
                             @"uid"         : @"uid",
                             };
    
    return mapAtt;
}
@end
