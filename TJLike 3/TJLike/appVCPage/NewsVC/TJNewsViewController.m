//
//  TJNewsViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJNewsViewController.h"
#import "BaseNewsListView.h"
#import "EditCategoryViewController.h"
#import "CategoryManager.h"

@interface TJNewsViewController ()
{
    TypeSelectView *selectView;
    UIScrollView *mScrollView;
    NSMutableArray *cateArray;
}
@end

/*
 微信： https://open.weixin.qq.com/  账户 6544226@qq.com    密码juewoo2014
 新浪微博：App Key： 4229658652 App Secret： f86396c7ad1868d241a3d54dfeb2596d
 sharesdk我给你创建一个ios的应用
 appid 6afd87eb76b6
 app secret e64699d90d9aeb909e97d92f8fa46113
 后边这俩是sharesdk的
 */

@implementation TJNewsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        cateArray = [[NSMutableArray alloc]initWithCapacity:10];
        
        self.view.backgroundColor = COLOR(240, 240, 240, 1);
        [self AddNaviView];
        mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        mScrollView.showsHorizontalScrollIndicator = NO;
        mScrollView.backgroundColor = [UIColor clearColor];
        mScrollView.delegate = self;
        mScrollView.pagingEnabled = YES;
        [self.view addSubview:mScrollView];
        [self requestRegionsInfo];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)requestRegionsInfo {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/NewMenu"];
    
    [[HttpClient getRequestWithPath:urlStr] subscribeNext:^(NSDictionary *info) {
        for (int i = 0; i<[info[@"data"] count]; i++) {
            NSDictionary *dict = info[@"data"][i];
            [cateArray addObject:dict];
        }
        
        
        [self ReloadCateView];
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
    }];
}
- (void)ReloadCateView{
    [selectView removeFromSuperview];
    
    selectView = [[TypeSelectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-44, 64)];
    selectView.mDelegate = self;
    [self.view addSubview:selectView];
    
    if ([CategoryManager Share].mcArray) {
        selectView.mArray = [CategoryManager Share].mcArray;
    }
    else{
        selectView.mArray = cateArray;
    }
    [selectView reloadData];
    mScrollView.contentSize = CGSizeMake(selectView.mArray.count*SCREEN_WIDTH, SCREEN_HEIGHT-64);
    int cid = [selectView.mArray[0][@"id"] intValue];
    [self AddListView];
    [self OnTabSelect:0 WithId:cid];
}
- (void)AddNaviView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-40, 34, 17.5, 17.5);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"news_top_2_35x35_@2x.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(EditCategory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}
- (void)EditCategory{
    EditCategoryViewController *eCtrl = [[EditCategoryViewController alloc]init];
    eCtrl.dataSource = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i = 0; i<cateArray.count; i++) {
        NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:selectView.mArray[i]];
        [eCtrl.dataSource addObject:dict];
    }
    eCtrl.mBlock = ^{
        [self ReloadCateView];
    };
    [self.naviController pushViewController:eCtrl animated:YES];
}

#pragma mark - TypeSelectViewDelegate
- (void)TypeSelectViewSelectType:(int)mIndex WithId:(int) cid{
    [self OnTabSelect:mIndex WithId:cid];
}

- (void)OnTabSelect:(int)index WithId:(int)cid;
{
    for (int i = 0; i < selectView.mArray.count; i++) {
        BaseNewsListView *view = (BaseNewsListView *)[mScrollView viewWithTag:i+2000];
        if (view) {
            [mScrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:NO];
        }
    }
}
- (void)AddListView{
    @autoreleasepool {
        for (UIView *view in mScrollView.subviews) {
            if (view && [view isKindOfClass:[BaseNewsListView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    for (int i = 0; i < selectView.mArray.count; i++) {
        CGRect rect = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        BaseNewsListView *listView = [[BaseNewsListView alloc] initWithFrame:rect];
        listView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        listView.mRootCtrl = self;
        listView.cid = [selectView.mArray[i][@"id"] intValue];
        listView.tag = i + 2000;
        [listView requestBannerInfo];
        [mScrollView addSubview:listView];
    }
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if((int)(scrollView.contentOffset.x/scrollView.frame.size.width)==scrollView.contentOffset.x/scrollView.frame.size.width){
        int index = round(scrollView.contentOffset.x/scrollView.frame.size.width);
        [selectView SelectType:index];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.naviController.navigationBarHidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
