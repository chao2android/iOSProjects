//
//  OrderViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "OrderInfoViewController.h"
#import "ImageDownManager.h"

@interface OrderViewController : BaseADViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTableView;
}
@property (nonatomic, copy) NSString *theTitleText;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, assign) SEL onSaveClick;
@end
