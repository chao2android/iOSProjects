//
//  AZXBaseTableView.m
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-6.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYBaseTableView.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"

@implementation JYBaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    self.delegate = self;
    self.dataSource = self;
    self.refreshHeader = YES;
    self.isMore = YES;
    
    
    // 加载更多
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectMake(0, 0, kScreenWidth, 65);
    _moreButton.backgroundColor = [UIColor whiteColor];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_moreButton setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
    [_moreButton setTitleColor:[JYHelpers setFontColorWithString:@"#999999"] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(100, 23, 20, 20);
    [activityView stopAnimating];
    activityView.tag = 2013;
    [_moreButton addSubview:activityView];
    
    self.tableFooterView = _moreButton;
    
    _showTextView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _showTextView.textColor = [JYHelpers setFontColorWithString:@"#999999"];
    _showTextView.font = [UIFont systemFontOfSize:15];
    _showTextView.textAlignment = NSTextAlignmentCenter;

    
    
}

- (void)setRefreshHeader:(BOOL)refreshHeader {
    _refreshHeader = refreshHeader;
    
    if (self.refreshHeader) {
        if (_refreshHeaderView == nil) {
            //创建下拉控件
            _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
            _refreshHeaderView.delegate = self;
            _refreshHeaderView.backgroundColor = [UIColor clearColor];
            [_refreshHeaderView refreshLastUpdatedDate];
        }
        
        [self addSubview:_refreshHeaderView];
    } else {
        if (_refreshHeaderView.superview != nil) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}

//hiddenOrShow 当为yes时隐藏，当为no时显示
- (void)setHeaderHidden:(BOOL) hiddenOrShow{
    [_refreshHeaderView removeFromSuperview];
}



- (void)setData:(NSMutableArray *)data
{
    if (_data != data) {
        _data = data;
        
        if (_data.count > 0) {
            _moreButton.hidden = NO;
        } else {
            _moreButton.hidden = NO;
        }
    }
}

- (void)setIsMore:(BOOL)isMore
{
    _isMore = isMore;
    if (self.isMore) {
        [_moreButton setTitle:@"上拉加载更多" forState:UIControlStateNormal];
        _moreButton.enabled = YES;
    } else {
        [_moreButton setTitle:@"加载完成" forState:UIControlStateNormal];
        _moreButton.enabled = NO;
    }
    
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2013];
    [activityView stopAnimating];
}

-(void)showOrHiddenTextView:(NSString *) text showOrHidden:(BOOL) showOrHidden
{
    if (showOrHidden) {
        _showTextView.text = text;
        self.tableFooterView = _showTextView;
    }else{
        self.tableFooterView = _moreButton;
    }
}

// 上拉按钮的点击事件
- (void)loadMoreAction
{
    _footerImgView.hidden = NO;
    //    _moreButton.hidden = YES;
    [_moreButton setTitle:@"正在加载..." forState:UIControlStateNormal];
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2013];
    [activityView startAnimating];
    
    // 调用代理对象的协议方法
    if ([self.refreshDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.refreshDelegate pullUp:self];
    }
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.refreshDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:indexPath:)]) {
        [self.refreshDelegate didSelectRowAtIndexPath:self indexPath:indexPath];
    }
}

/*________________________下拉控件相关方法________________________________*/
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	_reloading = YES;
}

//收起下拉刷新
- (void)doneLoadingTableViewData
{
    _footerImgView.hidden = YES;
    [_moreButton setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2013];
    [activityView stopAnimating];
    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

- (void)setNoMoreDynamic{
    [_moreButton setTitle:@"暂无动态" forState:UIControlStateNormal];
}

- (void)setNoFriend{
    [_moreButton setTitle:@"你还没有好友" forState:UIControlStateNormal];
}

- (void)setNoMoreData
{
    //    _noMoreLabel.hidden = NO;
    //    _footerImgView.hidden = YES;
    [_moreButton setTitle:@"没有更多了" forState:UIControlStateNormal];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //didScrollViewDidScroll
    if ([self.refreshDelegate respondsToSelector:@selector(didScrollViewDidScroll:)]) {
        [self.refreshDelegate didScrollViewDidScroll:self];
    }
    //NSLog(@"%f",scrollView.height);
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // didScrollViewDidEndDragging
//    NSLog(@"![JYHttpServeice NetworkStatues]--->%d",[JYHttpServeice NetworkStatues])
//    if (![JYHttpServeice NetworkStatues]) {
//        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//        return;
//    }
    if ([self.refreshDelegate respondsToSelector:@selector(didScrollViewDidEndDragging:willDecelerate:)]) {
        [self.refreshDelegate didScrollViewDidEndDragging:self willDecelerate:decelerate];
    }
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    //偏移量.y + tableView.height = 内容的高度
    //h是上拉超出来的尺寸
    float h = scrollView.contentOffset.y + scrollView.height - scrollView.contentSize.height;
    if (h > 30 && self.isMore) {
        [self loadMoreAction];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // didScrollViewDidEndDecelerating
    if ([self.refreshDelegate respondsToSelector:@selector(didScrollViewDidEndDecelerating:)]) {
        [self.refreshDelegate didScrollViewDidEndDecelerating:self];
    }
    
}



#pragma mark - EGORefreshTableHeaderDelegate Methods
// 下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
	[self reloadTableViewDataSource];
    
    // 停止加载，弹回下拉
    //	[self performSelector:@selector(doneLoadingTableViewData)
    //               withObject:nil afterDelay:3.0];
    
    if (self.finishBlock != nil) {
        self.finishBlock();
    }
    
    if ([self.refreshDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.refreshDelegate pullDown:self];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed	
}

@end


