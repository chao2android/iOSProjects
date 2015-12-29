//
//  CustomListViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import "CustomListCell.h"

@interface CustomListViewController : BaseADViewController<UITableViewDataSource, UITableViewDelegate, CustomListCellDelegate> {
    UITableView *mTableView;
}

@property (nonatomic, strong) NSMutableArray *mArray;

@end
