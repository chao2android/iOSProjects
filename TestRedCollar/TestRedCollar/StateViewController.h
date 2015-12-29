//
//  StateViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"

@interface StateViewController : BaseADViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) SEL onSaveClick;
@property (nonatomic, assign) NSString *theArea;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSString *state;

@end
