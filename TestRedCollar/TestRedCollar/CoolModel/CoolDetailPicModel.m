//
//  CoolDetailPicModel.m
//  TestRedCollar
//
//  Created by dreamRen on 14-7-22.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolDetailPicModel.h"

@implementation CoolDetailPicModel

- (void)dealloc
{
    self.add_time = nil;
    self.album_id = nil;
    self.avatar = nil;
    self.base_info = nil;
    self.cate = nil;
    self.comment_num = nil;
    self._id = nil;
    self.like_num = nil;
    self.link = nil;
    self.real_name = nil;
    self.recommend = nil;
    self.title = nil;
    self.uid = nil;
    self.url =nil;
    self.user_name = nil;
    self.views = nil;
    self.photo_list = nil;
    self.nickname = nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"未成功赋值的key = %@",key);
}
@end
