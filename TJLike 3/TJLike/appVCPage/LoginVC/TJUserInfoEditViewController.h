//
//  TJUserInfoEditViewController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/5.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"

typedef NS_ENUM(NSInteger, AlertViewTag) {
    AlertViewTag_Icon = 0,
    AlertViewTag_NickName,
    AlertViewTag_Gender,
    AlertViewTag_Signature,
    AlertViewTag_Password,
    AlertViewTag_LogOut
};

@interface TJUserInfoEditViewController : TJBaseViewController

@end
