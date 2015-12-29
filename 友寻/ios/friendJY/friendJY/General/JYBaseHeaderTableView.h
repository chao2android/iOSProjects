//
//  AZXBaseHeaderTableView.h
//  imAZXiPhone
//
//  Created by coder_zhang on 14-8-26.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class JYBaseHeaderTableView;
@protocol HeaderTableViewDelegate <NSObject>

@optional
// 下拉事件
- (void)pullDown:(JYBaseHeaderTableView *)tableView;

// 选中事件
- (void)didSelectRowAtIndexPath:(JYBaseHeaderTableView *)tabelView indexPath:(NSIndexPath *)indexPath;

- (void)didScrollViewDidScroll:(JYBaseHeaderTableView *)scrollView;

@end

@interface JYBaseHeaderTableView : UITableView <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;        //正在加载的提示
}

@property(nonatomic, retain)NSMutableArray *data;   //数据源

@property (nonatomic, assign) id<HeaderTableViewDelegate> refreshHeaderDelegate;

// 加载完成收起下拉
- (void)doneLoadingTableViewData;

@end
