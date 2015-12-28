//
//  BaseVideoViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseVideoViewController.h"
#import "FriendViewController.h"
#import "ThirdLoginViewController.h"
#import "NetVideoPlayView.h"
#import "VideoDetialViewController.h"
#import "SearchViewController.h"
#import "PopSearchView.h"

@interface BaseVideoViewController () {
    NetVideoPlayView *mPlayView;
    int miIndex;
}

@end

@implementation BaseVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewCellDelegate

- (void)OnHeadClick:(VideoListTableViewCell *)sender{
    NSLog(@"cell.tag==%ld,%@",(long)sender.tag,_dataArray[sender.tag]);
    VideoListModel *model = _dataArray[sender.tag];
    FriendViewController *fvc = [[FriendViewController alloc]init];
    fvc.headPic = model.avater;
    fvc.uid = model.uid;
    fvc.nikeName = model.nickname;
    fvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)OnVideoClick:(VideoListTableViewCell *)sender{
    NSLog(@"cell.tag==%ld",sender.tag);
    [self RemovePlayer];
    VideoListModel *model = _dataArray[sender.tag];
    mPlayView = [[NetVideoPlayView alloc] initWithFrame:sender.mVideoView.bounds];
    mPlayView.tag = sender.tag+1000;
    [sender.mVideoView addSubview:mPlayView];
    [mPlayView PlayVideo:model.src];
}

- (void)OnMoreClick:(VideoListTableViewCell *)sender {
    miIndex = (int)sender.tag;
    UIActionSheet *actView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"算了" destructiveButtonTitle:nil otherButtonTitles:@"黄赌毒！我要举报", nil];
    [actView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (!kkIsLogin) {
            ThirdLoginViewController *ctrl = [[ThirdLoginViewController alloc] init];
            [self presentViewController:ctrl animated:YES completion:nil];
        }
        else {
            VideoListModel *model = _dataArray[miIndex];
            [[ShareMethod Share] Report:model.m_id];
        }
    }
}

#pragma mark - 加去过
- (void)OnHaveGoClick:(VideoListTableViewCell *)sender {
    if (!kkIsLogin) {
        ThirdLoginViewController *ctrl = [[ThirdLoginViewController alloc] init];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else {
        VideoListModel *model = _dataArray[sender.tag];
        [[ShareMethod Share] HaveGo:model];
    }
}

#pragma mark - 加想去
- (void)OnXingClick:(VideoListTableViewCell *)sender {
    if (!kkIsLogin) {
        ThirdLoginViewController *ctrl = [[ThirdLoginViewController alloc] init];
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else {
        VideoListModel *model = _dataArray[sender.tag];
        [[ShareMethod Share] WantGo:model];
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
    [_mTableView reloadData];
}

- (void)OnLocationClick:(VideoListTableViewCell *)sender{
    NSLog(@"cell.tag==%ld",sender.tag);
    VideoDetialViewController *ctrl = [[VideoDetialViewController alloc] init];
    ctrl.mVideoModel = _dataArray[sender.tag];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"VideoList viewWillDisappear");
    [self RemovePlayer];
    [ShareMethod Share].delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"VideoList viewWillAppear");
    [ShareMethod Share].delegate = self;
}

- (void)RemovePlayer {
    @autoreleasepool {
        if (mPlayView) {
            [mPlayView StopVideo];
            [mPlayView removeFromSuperview];
            mPlayView = nil;
        }
    }
}

- (void)CheckPlayer:(VideoListTableViewCell *)sender{
    if (!mPlayView) {
        return;
    }
    if (mPlayView.superview == sender.mVideoView && sender.tag != mPlayView.tag-1000) {
        [self RemovePlayer];
    }
}

@end
