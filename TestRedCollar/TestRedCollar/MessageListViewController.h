//
//  MessageListViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "RefreshTableView.h"

@interface MessageListViewController : BaseADViewController<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate>
{
    RefreshTableView *mTableView;
}
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, assign) int pageIndex;
@end
