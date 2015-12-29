//
//  PersonViewController.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PersonViewController.h"
#import "VideoListModel.h"
#import "BeCareViewController.h"
#import "CareViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "NetImageView.h"
#import "SettingViewController.h"

@interface PersonViewController () {
    UILabel *_beCareLabel;
    UILabel *_careLabel;
    NetImageView *_headView;
    ImageDownManager *_mDownManager;
}

@end

@implementation PersonViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _headView.hidden = NO;
    [_headView GetImageByStr:kkUserDict[@"avater"]];
    [self StartDownload];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _headView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadList:) name:kMsg_VideoListRefresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadList:) name:kMsg_ReloginRefresh object:nil];
    // Do any additional setup after loading the view.
    NSLog(@"kkuser--->%@",kkUserDict);
    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    self.mTitleColor = [UIColor whiteColor];
    [self RefreshNavColor];
    
    self.title = kkUserDict[@"nickname"];
    [self AddLeftImageBtn:[UIImage imageNamed:@"1(8).png"] target:self action:@selector(SettingClick)];
    
    
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    topView.image = [UIImage imageNamed:@"Image-3"];
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    
    UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mBtn.backgroundColor = [UIColor clearColor];
    mBtn.frame = CGRectMake(0, 0, 62, 45);
    [mBtn addTarget:self action:@selector(BeCareClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:mBtn];
    
    mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mBtn.backgroundColor = [UIColor clearColor];
    mBtn.frame = CGRectMake(62, 0, 62, 45);
    [mBtn addTarget:self action:@selector(CareClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:mBtn];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(64, 15, 1, 20)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    [topView addSubview:lineView];
    
    _beCareLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 7, 62, 20)];
    _beCareLabel.textColor = [UIColor blackColor];
    _beCareLabel.font = [UIFont systemFontOfSize:20];
    _beCareLabel.backgroundColor = [UIColor clearColor];
    
    [topView addSubview:_beCareLabel];
    
    _careLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 7, 82, 20)];
    _careLabel.textColor = [UIColor blackColor];
    _careLabel.font = [UIFont systemFontOfSize:20];
    _careLabel.backgroundColor = [UIColor clearColor];
    
    [topView addSubview:_careLabel];
    
    UILabel *beCare = [[UILabel alloc]initWithFrame:CGRectMake(16, 27, 62, 18)];
    beCare.textColor = [UIColor grayColor];
    beCare.font = [UIFont systemFontOfSize:14];
    beCare.backgroundColor = [UIColor clearColor];
    beCare.text = @"被关注";
    [topView addSubview:beCare];
    
    UILabel *Care = [[UILabel alloc]initWithFrame:CGRectMake(73, 27, 62, 18)];
    Care.textColor = [UIColor grayColor];
    Care.font = [UIFont systemFontOfSize:14];
    Care.backgroundColor = [UIColor clearColor];
    Care.text = @"关注";
    //Care.adjustsFontSizeToFitWidth = YES;
    [topView addSubview:Care];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    _headView = [[NetImageView alloc]initWithFrame:CGRectMake(KscreenWidth-70, 35, 55, 55)];
    _headView.layer.masksToBounds = YES;
    _headView.layer.cornerRadius = _headView.frame.size.width/2;
    _headView.mImageType = TImageType_CutFill;
    _headView.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
    [_headView GetImageByStr:kkUserDict[@"avater"]];
    [window addSubview:_headView];
    
    _mTableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 48,KscreenWidth,  KscreenHeigh-164)];
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.delegate = self;
    [self.view addSubview:_mTableView];
    
    [self StartDownload];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !_mDownManager;
}

- (void)ReloadList:(RefreshTableView *)sender {
    [self StartDownload];
}


#pragma mark - ImageDownManager
- (void)dealloc {
    [self Cancel];
    [_headView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
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
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/video/user_video_list", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkUserID forKey:@"u_id"];
    [_mDownManager GetHttpRequest:urlstr :dict];
}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        [self HideMsgLabel];
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            [self.dataArray removeAllObjects];
            NSArray *array = [dict objectForKey:@"lst"];
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dDict = array[i];
                VideoListModel *model = [VideoListModel CreateWithDict:dDict];
                [self.dataArray addObject:model];
            }
        }
        
        else {
            mlbMsg.text = @"没有数据";
            [self ShowMsgLabel];
        }
        NSLog(@"_dataArray---%@",self.dataArray);
        _beCareLabel.text = dict[@"bieguanzhu_num"];
        _careLabel.text = dict[@"guanzhu_num"];
        [_mTableView reloadData];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_dataArray--%@",self.dataArray);
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

- (void)SettingClick{
    NSLog(@"set");
    SettingViewController *ctrl = [[SettingViewController alloc] init];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)CareClick{
    NSLog(@"关注");
    
    CareViewController *cvc = [[CareViewController alloc]init];
    cvc.uId = kkUserID;
    [cvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)BeCareClick{
    NSLog(@"被关注");
    BeCareViewController *cvc = [[BeCareViewController alloc]init];
    cvc.uId = kkUserID;
    [cvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
