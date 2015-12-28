//
//  SearchViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SearchViewController.h"
#import "VideoListTableViewCell.h"
#import "VideoDetialViewController.h"
#import "FriendViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "VideoUploadManager.h"
#import "RefreshTableView.h"
#import "ShareMethod.h"
#import "ThirdLoginViewController.h"
#import "NetVideoPlayView.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate, UIActionSheetDelegate> {
    NetVideoPlayView *mPlayView;
    int miIndex;
    int miPage;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;


@end

@implementation SearchViewController

- (void)viewDidLoad {

    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    self.mTitleColor = [UIColor whiteColor];
    [super viewDidLoad];
    self.title = @"搜索";
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"p_backbtn3"] target:self action:@selector(GoBack) scale:1.0];
    
    _mTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.delegate = self;
    [self.view addSubview:_mTableView];
    
    [self StartDownload];
}

#pragma mark - RefreshTableView

- (void)ReloadList:(RefreshTableView *)sender {
    miPage = 0;
    [self StartDownload];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self StartDownload];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !_mDownManager;
}

#pragma mark - ImageDownManager

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownManager);
}

- (void)StartDownload{
    if(_mDownManager){
        return;
    }
    [self StartLoading];
    
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/video/name_city_search", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kUserInfoManager.mCityID forKey:@"c_id"];
    [dict setObject:self.mText forKey:@"title"];
    [dict setObject:[NSString stringWithFormat:@"%d", miPage+1] forKey:@"page"];
    [dict setObject:@"10" forKey:@"page_size"];
    if (kkIsLogin) {
        [dict setObject:kkUserID forKey:@"u_id"];
    }
    [_mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            if (miPage == 0) {
                [self.dataArray removeAllObjects];
            }
            NSArray *array = [dict objectForKey:@"lst"];
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dDict = array[i];
                VideoListModel *model = [VideoListModel CreateWithDict:dDict];
                [self.dataArray addObject:model];
            }
            miPage ++;
            _mTableView.mbMoreHidden = (array.count < 10);
        }
        else {
            NSLog(@"Error:%@", dict[@"error"]);
            [AutoAlertView ShowAlert:@"提示" message:@"没有匹配的视频"];
        }
        [_mTableView FinishLoading];
        [_mTableView reloadData];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KscreenWidth+15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellID";
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[VideoListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
        cell.headClick = @selector(OnHeadClick:);
        cell.videoClick = @selector(OnVideoClick:);
        cell.moreCLick = @selector(OnMoreClick:);
        cell.haveGoClick = @selector(OnHaveGoClick:);
        cell.xingClick = @selector(OnXingClick:);
        cell.locationClick = @selector(OnLocationClick:);
    }
    VideoListModel *model = self.dataArray[indexPath.row];
    cell.tag = indexPath.row;
    [cell loadView:model];
    [self CheckPlayer:cell];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    [self RefreshNavColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    @autoreleasepool {
        if (mPlayView) {
            [mPlayView StopVideo];
            [mPlayView removeFromSuperview];
            mPlayView = nil;
        }
    }
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
