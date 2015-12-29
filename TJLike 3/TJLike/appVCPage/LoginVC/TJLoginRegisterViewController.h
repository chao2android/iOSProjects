//
//  TJLoginRegisterViewController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/3.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"

typedef enum {
    EnterType_Push=0,
    EnterType_PresentPor,
}EnterType;

typedef void (^LogInBlock)(id info);

@interface TJLoginRegisterViewController : TJBaseViewController
@property (nonatomic, strong) LogInBlock loginFinish;

-(instancetype)init:(EnterType)enterType;

@end
