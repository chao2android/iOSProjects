//
//  AZXBaseFooterTableView.h
//  imAZXiPhone
//
//  Created by coder_zhang on 14-8-20.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class JYBaseFooterTableView;
//@class DeleteMsgTableSuccess;
@protocol FooterTableViewDelegate <NSObject>

@optional
// 上拉事件
- (void)pullUp:(JYBaseFooterTableView *)tableView;

// 选中事件
- (void)didSelectRowAtIndexPath:(JYBaseFooterTableView *)tabelView indexPath:(NSIndexPath *)indexPath;

// 编辑单元格事件
- (void)didEditTableView:(JYBaseFooterTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)didScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)didScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

@interface JYBaseFooterTableView : UITableView <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    UIButton *_moreButton;
    BOOL _reloading;        //正在加载的提示
    EGORefreshTableHeaderView *_refreshHeaderView;
}

@property(nonatomic, strong) NSArray *data;   // 数据源
// 判断是否有更多的数据
@property(nonatomic, assign)BOOL isMore;
// 上拉代理
@property (nonatomic, assign) id<FooterTableViewDelegate> refreshFooterDelegate;

//显示文本层
@property (nonatomic, strong) UILabel * showTextView;

@property (nonatomic, assign) BOOL isrecommend;

//显示或隐藏文本提示层
-(void)showOrHiddenTextView:(NSString *) text showOrHidden:(BOOL) showOrHidden;

-(void)launchRefreshing;

- (void)doneLoadingTableViewData;

@end
