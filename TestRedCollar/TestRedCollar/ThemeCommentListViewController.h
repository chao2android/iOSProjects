//
//  ThemeCommentListViewController.h
//  TestRedCollar
//
//  Created by MC on 14-8-25.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "RefreshTableView.h"
@interface ThemeCommentListViewController : BaseADViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) NSArray *mArray;
@end
