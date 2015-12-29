//
//  RootViewController.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/19.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "BaseADViewController.h"
#import <AdSupport/AdSupport.h>
#import "ImageDownManager.h"
#import "ASIDownManager.h"
#import "MJRefresh.h"

@interface RootViewController : BaseADViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic, strong) ASIDownManager *mDownManager;

@property (nonatomic, strong) ImageDownManager *iDownManager;

@end
