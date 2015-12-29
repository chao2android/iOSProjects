//
//  ShopCarViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"

@interface ShopCarViewController : BaseADViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTableView;
}
@property (nonatomic, copy) NSString *theTitleText;
@property (nonatomic, assign) SEL onSaveClick;

@end
