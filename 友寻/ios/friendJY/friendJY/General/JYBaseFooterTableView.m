//
//  AZXBaseFooterTableView.m
//  imAZXiPhone
//  集成上拉刷新
//  Created by coder_zhang on 14-8-20.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import "JYBaseFooterTableView.h"
#import "JYHelpers.h"
#import "EGORefreshTableHeaderView.h"

@implementation JYBaseFooterTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initViews];
    }
    
    return self;
}

#pragma mark - init method
-(void)initViews
{
    self.data = [NSMutableArray array];
    self.isMore = YES;
    
    self.dataSource = self;
    self.delegate = self;
    
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
    activityView.tag = 2000;
    [_moreButton addSubview:activityView];
    
    self.tableFooterView = _moreButton;
    
    _showTextView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _showTextView.textColor = [JYHelpers setFontColorWithString:@"#999999"];
    _showTextView.font = [UIFont systemFontOfSize:15];
    _showTextView.textAlignment = NSTextAlignmentCenter;
    
    
}

- (void)setIsrecommend:(BOOL)isrecommend
{
    _isrecommend = isrecommend;
    if (_isrecommend) {
        _moreButton.backgroundColor = [UIColor clearColor];
        _moreButton.frame = CGRectMake(0, 0, kScreenWidth, 45);
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2000];
        activityView.frame = CGRectMake(100, 13, 20, 20);
        self.tableFooterView = _moreButton;
    } else {
        _moreButton.backgroundColor = [UIColor orangeColor];
        _moreButton.frame = CGRectMake(0, 0, kScreenWidth, 65);
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2000];
        activityView.frame = CGRectMake(100, 23, 20, 20);
        self.tableFooterView = _moreButton;

    }

}

//模拟一个下拉动作. 原理:让scrollview自动下拉超过属性的距离,state和剪头方向、文字变化有关
-(void)launchRefreshing
{
    if (_reloading) {
        _reloading = NO;
        
        [UIView animateWithDuration:0.4 animations:^{
            [self setContentOffset:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            if (finished) {
                //设置停止拖拽
                [_refreshHeaderView performSelector:@selector(egoRefreshScrollViewDidEndDragging:) withObject:self afterDelay:0.2];
            }
        }];
    }else{
        //下拉之前还原_refreshHeaderView的state
        [_refreshHeaderView setState:EGOOPullRefreshNormal];
        
        [UIView animateWithDuration:0.4 animations:^{
            [self setContentOffset:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            if (finished) {
                [_refreshHeaderView setState:EGOOPullRefreshPulling];
                
                //设置停止拖拽
                [_refreshHeaderView performSelector:@selector(egoRefreshScrollViewDidEndDragging:) withObject:self afterDelay:0.2];
            }
        }];
    }
}


// 上拉加载更多
-(void)loadMoreAction
{
    // 如果没有更多,就返回
    if (!self.isMore) {
        return;
    }
    
    // 刷新正在加载的状态
    [self startLoadMore];
    
    if ([self.refreshFooterDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.refreshFooterDelegate pullUp:self];
    }
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

-(void)startLoadMore
{
    [_moreButton setTitle:@"正在加载..." forState:UIControlStateNormal];
    _moreButton.enabled = NO;
    self.isMore = NO;
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2000];
    [activityView startAnimating];
}

// 重写父类方法
-(void)reloadData
{
    [super reloadData];
    
    // 停止加载更多
    [self stopLoadMore];
    
}

-(void)stopLoadMore
{
    if (self.data.count > 0) {
        _moreButton.hidden = NO;
        _moreButton.enabled = YES;
        [_moreButton setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2000];
        [activityView stopAnimating];
        
        // 加载完成,如果没有更多的数据
        if (!self.isMore) {
//            _moreButton.hidden = YES;
            _moreButton.hidden = NO;
            _moreButton.enabled = YES;
            [_moreButton setTitle:@"没有更多内容了" forState:UIControlStateNormal];
        }
    }else{
        _moreButton.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"kBaseRefreshFooterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.refreshFooterDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:indexPath:)]) {
        [self.refreshFooterDelegate didSelectRowAtIndexPath:self indexPath:indexPath];
    }
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([self.refreshFooterDelegate respondsToSelector:@selector(didEditTableView:commitEditingStyle:forRowAtIndexPath:)]) {
//        [self.refreshFooterDelegate didEditTableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
//    }
//    
//}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    // 上拉加载更多
    // 实现原理: scrollView.contentSize.height - scrollView.contentOffset.y = scrollView.height
    float sub = scrollView.contentSize.height - scrollView.contentOffset.y;
    
//    NSLog(@"ffff  %f", scrollView.height - sub);
    
    if ([self.refreshFooterDelegate respondsToSelector:@selector(didScrollViewDidEndDragging:willDecelerate:)]) {
        [self.refreshFooterDelegate didScrollViewDidEndDragging:self willDecelerate:decelerate];
    }
	
    if (scrollView.height - sub > 50) {
        [self loadMoreAction];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//    
//    if ([self.refreshFooterDelegate respondsToSelector:@selector(didScrollViewDidScroll:)]) {
//        [self.refreshFooterDelegate didScrollViewDidScroll:self];
//    }
//    
//}
//
//#pragma mark -
//#pragma mark Data Source Loading / Reloading Methods
//
//- (void)reloadTableViewDataSource{
//	_reloading = YES;
//	
//}
//
//- (void)doneLoadingTableViewData
//{
//	_reloading = NO;
//	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
//}
//
//#pragma mark EGORefreshTableHeaderDelegate Methods
////已经触发了下拉刷新的动作
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
//{
//    
//    [self reloadTableViewDataSource];
//    
//    NSLog(@"---------");
//    
//    //请求网络
////    if (_pullDownBlock) {
////        _pullDownBlock(self);
////    }
//    
//    //停止加载，模拟弹回下拉
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
//    
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
//{
//	return _reloading; // should return if data source model is reloading
//	
//}




@end
