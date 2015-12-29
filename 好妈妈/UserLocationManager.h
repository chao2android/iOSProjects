//
//  UserLocationManager.h
//  好妈妈
//
//  Created by Hepburn Alex on 14-5-15.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobClick.h"
#import <CoreLocation/CoreLocation.h>

@interface UserLocationManager : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *mLocaManager;
    int miCount;
}

@property (nonatomic, assign) float mLat;
@property (nonatomic, assign) float mLng;

+ (UserLocationManager *)Share;

- (void)StartLocation;
- (void)StopLocation;

#define IsiPhone5 CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)
#define kLat [UserLocationManager Share].mLat
#define kLng [UserLocationManager Share].mLng

#define kMsg_Location  @"kMsg_Location"

#define MOBCLICK(x) [MobClick event:x label:@"count"]

#define kMob_MyGroup        @"groupmy"
 //我的圈子

#define kMob_GoodGroup      @"grouprec"
 //推荐圈子

#define kMob_Growing        @"growing"
 //成长足迹

#define kMob_HomePage       @"homepage"
 //我的主页

#define kMob_More           @"more"
 //更多

#define kMob_MoreLove       @"more2"
 //猜你喜欢

#define kMob_MoreFriend     @"more3"
 //邀好友

#define kMob_MoreAge        @"more4"
 //同龄

#define kMob_MoreCity       @"more5"
 //同城

#define kMob_MoreHot        @"more6"
 //热门

#define kMob_MoreRec        @"more7"
 //精品推荐

#define kMob_MoreInfo       @"more8"
 //个人资料

#define kMob_MoreSetting    @"more9"
 //设置

#define kMob_KnowNew        @"recommentknows"
 //知道-最新

#define kMob_KnowGood       @"recommentknows2"
 //知道-精华

#define kMob_Tools          @"tools"
 //工具

#define kMob_Tools1         @"tools1"
 //排卵期

#define kMob_Tools2         @"tools2"
 //预产期

#define kMob_Tools3         @"tools3"
 //产检提醒

 #define kMob_Tools4         @"tools4"
 //生男生女

 #define kMob_Tools5         @"tools5"
 //疫苗提醒

 #define kMob_Tools6         @"tools6"
 //微日记

@end
