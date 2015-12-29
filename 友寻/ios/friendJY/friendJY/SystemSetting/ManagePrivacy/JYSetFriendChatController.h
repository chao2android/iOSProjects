//
//  JYSetFriendChatController.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/3.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileSetRootController.h"

#define kShowSecondFriendDync @"show_second_friend_dync"
#define kAllowSecondLook @"allow_second_friend_look_my_dync"
#define kAllowAcceptSecondInvite @"allow_accept_second_friend_invite"
#define kAllowProfileShow @"allow_my_profile_show"
#define kAllowAddWithChat @"allow_add_with_chat"


@interface JYSetFriendChatController : JYProfileSetRootController

@property (nonatomic, assign) JYPrivacyDetailStyle style;

@property (nonatomic, assign) BOOL allow_second_friend_look_my_dync;

@property (nonatomic, copy) void(^ChangeBlock)(NSString *text,NSInteger index);

@property (nonatomic, assign) NSInteger currentIndex;

@end
