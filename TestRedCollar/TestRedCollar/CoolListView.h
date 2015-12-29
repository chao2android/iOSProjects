//
//  CoolListView.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListView.h"
#import "ImageDownManager.h"
#import "RefreshTableView.h"
#import "MJRefresh.h"

@interface CoolListView : BaseListView<MJRefreshBaseViewDelegate,UIScrollViewDelegate>{
    UIScrollView *mScrollView;
    RefreshTableView *mTableView;
    MJRefreshHeaderView *mheader;
    MJRefreshFooterView *mfooter;
    UIAlertView *_alert;
}

@property(nonatomic, strong)NSMutableArray *mArray;
@property(nonatomic,assign)int type;
@property(nonatomic, strong)ImageDownManager *mDownManager;
@property(nonatomic,assign)char hasNext;
@property(nonatomic,assign)int pageIndex;
@property(nonatomic,assign)BOOL isLoading;//是上拉加载还是下拉刷新的标志
@property(nonatomic,assign)CGPoint contentOffSet;//记录显示的最后位置,方便加载后从看到的位置续接;
- (void)LoadCoolList;
- (void)loadData ;

@end
