//
//  GrassLandViewController.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "GrassLandViewController.h"
#import "GrassHaveGoTableViewCell.h"
#import "GrassWantGoTableViewCell.h"
#import "HaveGownModel.h"
#import "WantToGoModel.h"
#import "VideoDetialViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "ThirdLoginViewController.h"
#import "VideoListModel.h"
#import "ShareMethod.h"
#import "SearchViewController.h"
#import "PopSearchView.h"

@interface GrassLandViewController ()<ShareMethodDelegate>
{
    UIView *mTopView;
    UITableView *_mTableView;
    NSMutableArray *_dataArray;
    ImageDownManager *_mDownManager;
}
@end

@implementation GrassLandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReDownloadList) name:kMsg_ReloginRefresh object:nil];
    // Do any additional setup after loading the view.
    self.title = @"草地";
    miIndex = 0;
    [self AddRightTextBtn:@"搜索" target:self action:@selector(OnSearchClick)];
    
    UIButton *rightBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    rightBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    _dataArray = [[NSMutableArray alloc]init];
    
    mTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 52)];
    mTopView.clipsToBounds = YES;
    [self.view addSubview:mTopView];
    
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(0+i*KscreenWidth*0.5, -10, KscreenWidth*0.5, 62);
        btn.tag = i+1000;
        [btn addTarget:self action:@selector(OnTabClick:) forControlEvents:UIControlEventTouchUpInside];
        [mTopView addSubview:btn];
    }
    [self RefreshTabView];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 52, KscreenWidth,  self.view.frame.size.height-52)];
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    [self.view addSubview:_mTableView];
    
    [self ReDownloadList];
    
}

- (void)RefreshTabView {
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = (UIButton *)[mTopView viewWithTag:1000+i];
        if (btn) {
            NSString *imagename = nil;
            if (i == 0){
                if (i == miIndex) {
                    imagename = @"去过已选";
                    btn.frame = CGRectMake(0+i*KscreenWidth*0.5, -10, KscreenWidth*0.5, 62);
                }
                else {
                    imagename = @"去过未选";
                    btn.frame = CGRectMake(0+i*KscreenWidth*0.5, -15, KscreenWidth*0.5, 62);
                }
            }
            else if (i == 1){
                if (i == miIndex) {
                    imagename = @"想去已选";
                    btn.frame = CGRectMake(0+i*KscreenWidth*0.5, -10, KscreenWidth*0.5, 62);
                }
                else {
                    imagename = @"想去未选";
                    btn.frame = CGRectMake(0+i*KscreenWidth*0.5, -15, KscreenWidth*0.5, 62);
                }
            }
            [btn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        }
    }
}
- (void)OnTabClick:(UIButton *)sender {
    NSLog(@"_data---%@",_dataArray);
    miIndex = (int)sender.tag-1000;
    [self RefreshTabView];
    [_dataArray removeAllObjects];
    [_mTableView reloadData];
    [self ReDownloadList];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_dataArray--%@",_dataArray);
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KscreenWidth*114/320;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d", miIndex];
    if (miIndex == 0) {
        
        GrassHaveGoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GrassHaveGoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.delegete = self;
            cell.OnDelete = @selector(OnDeleteClick:);
        }
        
        cell.tag = indexPath.row;
        VideoListModel *info = [_dataArray objectAtIndex:indexPath.row];
        [cell loadView:info];
        return cell;
    }
    else {
        
        GrassWantGoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[GrassWantGoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.delegate = self;
            cell.OnDelete = @selector(OnDeleteClick:);
            cell.OnAddHave = @selector(OnHaveGoClick:);
        }
        cell.tag = indexPath.row;
        VideoListModel *info = [_dataArray objectAtIndex:indexPath.row];
        [cell loadView:info];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoDetialViewController *ctrl = [[VideoDetialViewController alloc] init];
    ctrl.mVideoModel = _dataArray[indexPath.row];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - ImageDownManager
- (void)dealloc {
    [self Cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownManager);
}

- (void)ReDownloadList{
    if(_mDownManager){
        return;
    }
    [self StartLoading];
    
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *type;
    if (miIndex == 0) {
        type = @"/mobileapi/user/User_video_qu";
    }
    else if(miIndex == 1){
        type = @"/mobileapi/user/User_video_xiang";
    }
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@", SERVER_URL,type];
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
            NSArray *array = [dict objectForKey:@"lst"];
            for (int i = 0; i<array.count; i++) {
                VideoListModel *model = [VideoListModel CreateWithDict:array[i]];
                [_dataArray addObject:model];
            }
        }
        
        else {
            mlbMsg.text = @"没有数据";
            [self ShowMsgLabel];
        }
        NSLog(@"_dataArray---%@",_dataArray);
        [_mTableView reloadData];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

-(void)OnDeleteClick:(NSNumber *)sender{
    NSLog(@"%@",sender);
    
    if(_mDownManager){
        return;
    }
    [self StartLoading];
    VideoListModel *model = _dataArray[[sender intValue] ];
    
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnDeleteFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/user/User_video_qu_del", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkUserID forKey:@"u_id"];
    [dict setObject:model.m_id forKey:@"v_id"];
    [_mDownManager GetHttpRequest:urlstr :dict];
}

- (void)OnDeleteFinish:(ImageDownManager *)sender{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            [_dataArray removeAllObjects];
            [self ReDownloadList];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_VideoListRefresh object:nil];
        }
        else{
            NSString *msg = @"删除失败";
            [AutoAlertView ShowAlert:@"提示" message:msg];
        }
    }
}

#pragma mark - 加去过
- (void)OnHaveGoClick:(NSNumber *)sender {
    if (!kkIsLogin) {
        ThirdLoginViewController *ctrl = [[ThirdLoginViewController alloc] init];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else {
        VideoListModel *model = _dataArray[[sender intValue]];
        [[ShareMethod Share] HaveGo:model];
    }
}

#pragma mark - ShareMethodDelegate

- (void)OnWantGoStart:(ShareMethod *)sender {
    [self StartLoading];
}

- (void)OnHaveGoStart:(ShareMethod *)sender {
    [self StartLoading];
}

- (void)OnShareMethodFinish:(ShareMethod *)sender {
    [self StopLoading];
    [self ReDownloadList];
}

- (void)OnSearchClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    PopSearchView *searchView = [[PopSearchView alloc] initWithFrame:window.bounds];
    searchView.delegate = self;
    searchView.OnSearchText = @selector(OnSearchText:);
    [window addSubview:searchView];
}

- (void)OnSearchText:(NSString *)text {
    SearchViewController *ctrl = [[SearchViewController alloc] init];
    ctrl.mText = text;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"VideoList viewWillDisappear");
    [ShareMethod Share].delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"VideoList viewWillAppear");
    [ShareMethod Share].delegate = self;
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
