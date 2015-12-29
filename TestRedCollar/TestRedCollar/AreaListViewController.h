//
//  AreaListViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "CityListViewController.h"
typedef void (^saveArea)(NSString *areaStr,NSString *areaId);
@interface AreaListViewController : BaseADViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) SEL onSaveClick;
@property (nonatomic, assign) NSString *theArea;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSString *state;

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) int index;
@property (copy,nonatomic)saveArea block;
@property (retain,nonatomic) CityListViewController *CityListViewController;

@end
