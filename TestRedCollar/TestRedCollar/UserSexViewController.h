//
//  UserSexViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"

@interface UserSexViewController : BaseADViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)SEL onSaveClick;

@property(nonatomic,copy)NSString *theSex;
@property (nonatomic, strong) ImageDownManager *mDownManager;

@end
