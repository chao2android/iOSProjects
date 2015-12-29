//
//  OptionViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"

@interface OptionViewController : BaseADViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ImageDownManager *mDownManager;

@end
