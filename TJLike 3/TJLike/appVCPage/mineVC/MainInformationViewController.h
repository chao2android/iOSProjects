//
//  MainInformationViewController.h
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"

typedef void(^SaveFinish)();

@interface MainInformationViewController : TJBaseViewController

@property (nonatomic, copy)SaveFinish mBlock;

@end
