//
//  AZXBaseTableView.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-6.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
//#import "EGORefreshTableFooterView.h"

@class JYBaseTableView;

@protocol JYBaseRefreshTableDelegate <NSObject>

@optional
// 下拉事件
- (void)pullDown:(JYBaseTableView *)tableView;
// 上拉事件
- (void)pullUp:(JYBaseTableView *)tableView;
// 选中单元格事件
- (void)didSelectRowAtIndexPath:(JYBaseTableView *)tabelView indexPath:(NSIndexPath *)indexPath;
- (void)didScrollViewDidScroll:(JYBaseTableView *)scrollView;
- (void)didScrollViewDidEndDragging:(JYBaseTableView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)didScrollViewDidEndDecelerating:(JYBaseTableView *)scrollView;

@end


typedef void(^PullDonwFinish)(void);


@interface JYBaseTableView : UITableView<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
	
	BOOL _reloading;
    
    UIButton *_moreButton;
    UIImageView *_footerImgView;
}

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;

@property (nonatomic, strong) NSMutableArray *data;
//是否显示下拉控件
@property (nonatomic, assign) BOOL refreshHeader;
//是否有更多(下一页)
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, copy) PullDonwFinish finishBlock;
//显示文本层
@property (nonatomic, strong) UILabel * showTextView;
//上拉代理对象
@property (nonatomic, assign) id<JYBaseRefreshTableDelegate> refreshDelegate;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)setNoFriend;
- (void)setNoMoreData;
- (void)setNoMoreDynamic;
- (void)setHeaderHidden:(BOOL) hiddenOrShow;

@end

