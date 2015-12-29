//
//  WriteViewController.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/24.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "BaseADViewController.h"
#import "ReDianModel.h"
#import "ASIDownManager.h"
#import "ImageDownManager.h"
#import "CommintModel.h"
@interface WriteViewController : BaseADViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ImageDownManager *iDownManager;
@property (nonatomic, strong) ASIDownManager *mDownManager;
@property (nonatomic, retain)ReDianModel * model;
@end
