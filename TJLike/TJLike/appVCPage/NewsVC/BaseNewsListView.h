//
//  BaseNewsListView.h
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJBaseViewController.h"
#import "RefreshTableView.h"

@interface BaseNewsListView : UIView<RefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    RefreshTableView *mTableView;
}

@property (nonatomic, assign) TJBaseViewController *mRootCtrl;
@property (nonatomic, assign) int cid;

- (void)requestBannerInfo;

@end
