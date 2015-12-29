//
//  TuiSongTongZhi.h
//  好妈妈
//
//  Created by 李 建伟 on 13-12-15.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuiSongTongZhi : NSObject
+ (void)CteLocalNotification:(NSDate *)pushDate TuisongContent:(NSString *)aContent TuisongName:(NSString *)aName;
+ (void)RemoveLocalNotication:(NSString *)aName;
+ (NSDate *)TuiSongShiJianMenth:(NSString *)sender;
+ (BOOL)ShiFouJianTuiSongMenth:(NSDate *)sender;
+ (NSDate *)ChanJianTuiSongShiJianMenth:(int)sender;
+ (NSDate *)ChanJianTuiSongShiJianMenth1:(int)sender;
@end
