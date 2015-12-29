//
//  CheckGoodsListViewController.h
//  TestRedCollar
//
//  Created by MC on 14-7-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"

@interface CheckGoodsListViewController : BaseADViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
}

@property (copy,nonatomic) NSArray *dataArray;

@end
