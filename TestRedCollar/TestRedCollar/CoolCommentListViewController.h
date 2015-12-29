//
//  CoolCommentListViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-7-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "RefreshTableView.h"

@interface CoolCommentListViewController : BaseADViewController<RefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    RefreshTableView *mTableView;
    int _commentCount;
}

@property(nonatomic, strong) ImageDownManager *mDownManager;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSString *urlID;
@property(nonatomic, assign) int pageIndex;
@property(nonatomic, assign) int olderArrayNum;
//是主题里的
@property(nonatomic, assign) BOOL isTheme;
@end
