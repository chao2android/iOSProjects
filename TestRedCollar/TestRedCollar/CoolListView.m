//
//  CoolListView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolListView.h"
#import "CoolSubView.h"
#import "CoolDetailViewController.h"
#import "CoolThemeViewController.h"
#import "JSON.h"
#import "CoolListModel.h"
#import "FansInfoViewController.h"
#import "CoolCommentView.h"
#import "CoolCommentListViewController.h"
#import "TypeSelectView.h"

@implementation CoolListView

@synthesize mArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentOffSet = CGPointMake(0, 0);
        
        self.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
        mArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        
        mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40)];
        mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        mScrollView.delegate =self;
        [self addSubview:mScrollView];
        
        
        //添加刷新类
        mheader = [MJRefreshHeaderView header];
        mheader.delegate = self;
        mheader.scrollView = mScrollView;
        
        mfooter = [MJRefreshFooterView footer];
        mfooter.delegate = self;
        mfooter.scrollView = mScrollView;
        
        TypeSelectView *topView = [[TypeSelectView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 41)];
        topView.delegate = self;
        topView.OnTypeSelect = @selector(OnTabSelect:);
        [self addSubview:topView];
        topView.mArray = @[@"人气街拍",@"最新街拍",@"人气设计",@"最新设计"];
        [topView reloadData];
    }
    return self;
}
#pragma mark 专题切换
- (void)OnTabSelect:(TypeSelectView *)sender {
    int index = sender.miIndex;
    index = -(index-3);
    self.type = index+1;
    self.pageIndex = 1;
    self.contentOffSet = CGPointMake(0, 0);
    [self.mArray removeAllObjects];//更换专题时,清空数组;
    [self loadData];

}
#pragma mark 清除scrollview上view并且添加新的view;
- (void)LoadCoolList {
    @autoreleasepool {
        for (UIView *view in mScrollView.subviews) {
            if ([view isKindOfClass:[CoolSubView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    int iHeight1 = 5;
    int iHeight2 = 5;
    
    for (int i = 0; i < mArray.count; i ++) {
        int iXPos = 0;
       CoolListModel *model  = [mArray objectAtIndex:i];
        //计算高度和存储下载图片
        NSDictionary *info = [CoolSubView HeightOfContent:model];
        
        if (info.count==1) {
            continue;
        }
        int iHeight = [info[@"height"] intValue] ;
        int iTop = 0;
        if (iHeight1 <= iHeight2) {
            iTop = iHeight1;
            iHeight1 += (iHeight+5);
            iXPos = 0;
        }
        else {
            iTop = iHeight2;
            iHeight2 += (iHeight+5);
            iXPos = 1;
        }
        CoolSubView *subView = [[CoolSubView alloc] initWithFrame:CGRectMake(iXPos*158+5, iTop, 153, iHeight)];
        subView.delegate = self;
        subView.MyClick = @selector(OnDetailClick:);
        subView.OnHeadViewClick = @selector(OnHeadViewClick:);
        subView.tag = i+1300;
        
        [mScrollView addSubview:subView];
        NSLog(@"dict = %@",model);
        [subView LoadContent:model and:(UIImage*)info[@"image"]];
    }
    //mScrollView.contentOffset = CGPointMake(0, 0);
    mScrollView.contentOffset = self.contentOffSet;
    mScrollView.contentSize = CGSizeMake(mScrollView.frame.size.width, MAX(iHeight1, iHeight2));
    if (self.pageIndex==1) {
         [self refreshAnimation];
    }
   
}
- (void)OnHeadViewClick:(CoolSubView *)sender{
    NSLog(@"%d",sender.tag);
    CoolListModel *model  = [mArray objectAtIndex:sender.tag-1300];
    FansInfoViewController *ctrl = [[FansInfoViewController alloc] init];
    ctrl.isAdded=YES;
    ctrl.userID = model.uid;
    [self.mRootCtrl.navigationController pushViewController:ctrl animated:YES];
}
#pragma mark  点击进入详情页
- (void)OnDetailClick:(CoolSubView *)sender {
    CoolDetailViewController *ctrl = [[CoolDetailViewController alloc] init];
    ctrl.model = [mArray objectAtIndex:(sender.tag - 1300)];
    ctrl.type = self.type;
    
    __block CoolListModel *model = [mArray objectAtIndex:(sender.tag - 1300)];
    ctrl.updateBlock = ^(int type,NSString *content){
        UIButton *button =nil;

        if (type == 3) {
            //修改在mArray评论个数
            button  = (UIButton*)[sender viewWithTag:3];
            model.comment_num = content;
        }else{
            //修改在mArray喜欢的个数
            button = (UIButton*)[sender viewWithTag:4];
            model.like_num = content;
        }
        [button setTitle:content forState:UIControlStateNormal];
    
    };
    //修改显示的个数
    [self.mRootCtrl.navigationController pushViewController:ctrl animated:YES];
}

- (void)refreshAnimation {
    for (int i = 0; i<mArray.count; i++) {
        CoolSubView *subView = (CoolSubView*)[mScrollView viewWithTag:1300+i];

        //根据i算时间
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2+i*0.1;         /* 间隔时间*/
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; /* 动画的开始与结束的快慢*/
        transition.type = @"moveIn"; /* 各种动画效果*/
        transition.subtype = kCATransitionFromTop;
        //        transition.delegate = self;
        /* 在想添加CA动画的VIEW的层上添加此代码*/
        [subView.layer addAnimation:transition forKey:nil];
    }
}

- (void)onThemeClick:(TouchView *)sender {
    CoolThemeViewController *ctrl = [[CoolThemeViewController alloc] init];
    [self.mRootCtrl.navigationController pushViewController:ctrl animated:YES];
}


#pragma  mark 数据下载

- (void)dealloc {
    [self Cancel];
    self.mArray = nil;
    [mheader free];
    [mfooter free];
}

#pragma mark - ImageDownManager

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)loadData {
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php", SERVER_URL];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"kukeIndex" forKey:@"act"];
    [dict setObject:@"8" forKey:@"pageSize"];
    [dict setObject:[NSString stringWithFormat:@"%d",self.pageIndex]  forKey:@"pageIndex"];
    [dict setObject:[NSString stringWithFormat:@"%d",self.type] forKey:@"type"];
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        self.hasNext = [[dict objectForKey:@"hasNext"] charValue];
        if (!self.isLoading) {
            [mArray removeAllObjects];
        }
        NSDictionary *array = [dict objectForKey:@"list"];
        if (array && [array isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in array) {
                CoolListModel *model = [CoolListModel CreateWithDict:array[key]];
                [mArray addObject:model];
            }
        }
        
        //停止加载或刷新
        if (!self.isLoading) {
            [mheader endRefreshing];
        }
        else{
            [mfooter endRefreshing];
        }
        //从上一页的末尾显示图片
        mScrollView.contentOffset = self.contentOffSet;
        [self LoadCoolList];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

#pragma mark  数据刷新

//开始刷新触发事件
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView==mheader) {
        //下拉
        //[self.dataArray addObject:@"下拉"];
        NSLog(@"下拉");
        self.pageIndex = 1;
        self.isLoading = NO;
        [self loadData];
        
    }else{
        //上拉
        // [self.dataArray addObject:@"上拉"];
        NSLog(@"上拉");
        if (self.hasNext==1) {
            self.pageIndex = self.pageIndex+1;
            self.isLoading = YES;
            [self loadData];
        }else{
            [refreshView endRefreshing];
            [self Click];
            
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.contentOffSet = scrollView.contentOffset;
    NSLog(@"self.conten = %@",NSStringFromCGPoint(self.contentOffSet));
}

#pragma mark  警告框
//创建一个没有点击按钮的警告框
-(void)Click{
    _alert=[[UIAlertView alloc]initWithTitle:@"告知" message:@"亲,没有数据了" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alert show];
    
    [self performSelector:@selector(alertClick) withObject:nil afterDelay:2];
}
-(void)alertClick{
    //没有按键，强行调用第0位取消按键
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
