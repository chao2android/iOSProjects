//
//  CityListViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "AreaList.h"
typedef void (^saveCity)(NSString *name,NSString *uid);
@interface CityListViewController : BaseADViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) AreaList *areaList;
@property (nonatomic, assign) SEL onSaveClick;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) int index;
@property (nonatomic, copy) saveCity block;

@end
