//
//  InstallViewController.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/22.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "BaseADViewController.h"
#import "BPush.h"
@interface InstallViewController : BaseADViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UISwitch * mainSwtich;

@property (nonatomic,strong) UISwitch * clearSwtich;

@end
