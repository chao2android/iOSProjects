//
//  VideoListViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-20.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoListTableViewCell.h"
#import "ImageDownManager.h"
#import "JSON.h"

@interface VideoListViewController () {
}

@property (nonatomic, strong) ImageDownManager *mDownManager;

@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshCity) name:kMsg_ShowCenter object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadList:) name:kMsg_VideoListRefresh object:nil];
    self.title = @"本地";
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_citybtn"] target:self action:@selector(OnLeftClick)];
    [self AddRightTextBtn:@"搜索" target:self action:@selector(OnSearchClick)];
    
    UIButton *rightBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    rightBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    _mTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.delegate = self;
    [self.view addSubview:_mTableView];
    
    [self StartDownload];
}

- (void)RefreshCity {
    self.title = kUserInfoManager.mCityName;
    [self ReloadList:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self Cancel];
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
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/video/city_video_list", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kUserInfoManager.mCityID forKey:@"c_id"];
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
        [self HideMsgLabel];
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (miPage == 0) {
            [self.dataArray removeAllObjects];
        }
        NSInteger iCount = 0;
        if (iStatus == 1001) {
            NSArray *array = [dict objectForKey:@"lst"];
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dDict = array[i];
                VideoListModel *model = [VideoListModel CreateWithDict:dDict];
                [self.dataArray addObject:model];
            }
            iCount = array.count;
            miPage ++;
        }
        if (self.dataArray.count == 0) {
            mlbMsg.text = @"没有数据";
            [self ShowMsgLabel];
        }
        _mTableView.mbMoreHidden = (iCount < 10);
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

- (void)OnLeftClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ShowLeft object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
