//
//  JYProfileModel.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/20.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYProfileModel : JYBaseModel
{
@private
    NSDictionary *_dataDict;
}
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *animal;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *callno_upload;
@property (nonatomic, copy) NSString *career;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *is_friend;
@property (nonatomic, copy) NSString *is_lonely_confirm;
@property (nonatomic, copy) NSString *lastLoginTime;
@property (nonatomic, copy) NSString *live_location;
@property (nonatomic, copy) NSString *live_sublocation;
@property (nonatomic, copy) NSString *lonely_confirm;
@property (nonatomic, copy) NSString *mark;
@property (nonatomic, copy) NSString *marriage;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *photocount;
@property (nonatomic, strong) NSDictionary *avatars;
@property (nonatomic, strong) NSDictionary *photoes;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *show_second_friend_dync;
@property (nonatomic, copy) NSString *allow_accept_second_friend_invite;
@property (nonatomic, copy) NSString *allow_add_with_chat;
@property (nonatomic, copy) NSString *allow_my_profile_show;
@property (nonatomic, copy) NSString *allow_second_friend_look_my_dync;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *weight;

@property (nonatomic, copy) NSString *friends_num;
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *hasavatar;

- (NSDictionary*)modelToDictionary;

@end
