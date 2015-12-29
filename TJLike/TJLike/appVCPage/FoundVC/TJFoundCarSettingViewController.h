//
//  TJFoundCarSettingViewController.h
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
typedef void (^AddFinish)();
@interface TJFoundCarSettingViewController : TJBaseViewController

@property (nonatomic, assign)int indexPath;
@property (nonatomic, copy)AddFinish mBlock;

@end
