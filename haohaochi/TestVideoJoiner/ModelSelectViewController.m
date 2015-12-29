//
//  ModelSelectViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-7.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ModelSelectViewController.h"
#import "VideoPlayView.h"
#import "TouchView.h"
#import "AudioRecordManager.h"
#import "ImageProgressView.h"
#import "ShareViewController.h"

@interface ModelSelectViewController () {
    UILabel *mlbWatermark;
    UILabel *mlbAddress;
    VideoPlayView *mPlayView;
    NSInteger miLastIndex;
}

@property (nonatomic, strong) NSArray *mFontArray;
@property (nonatomic, strong) AudioRecordManager *mAudioManager;
@property (nonatomic, strong) NSString *mSelectFont;
@property (nonatomic, strong) NSURL *mAudioUrl;
@end

@implementation ModelSelectViewController

- (void)viewDidLoad {
    self.mTopImage = [UIImage imageNamed:@"topbar7"];
    [super viewDidLoad];
    
    [self HideStatusBar:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    miLastIndex = -1;
    
    self.title = @"美化";
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"发布" target:self action:@selector(OnJoinClick)];
    
    int iTop = 0;
    float iWidth = MIN(KscreenWidth, KscreenHeigh)/2;
    float fHeight = MAX(KscreenWidth, KscreenHeigh);
    
    int iPlayHeight = (iWidth*6)/4;

    mPlayView = [[VideoPlayView alloc] initWithFrame:CGRectMake(0, iTop, self.view.frame.size.width, iPlayHeight)];
    mPlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    mPlayView.mbRepeatPlay = YES;
    [self.view addSubview:mPlayView];
    
    mStopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mStopBtn.frame = mPlayView.frame;
    mStopBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [mStopBtn addTarget:self action:@selector(OnStopClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mStopBtn];
    
    mlbWatermark = [[UILabel alloc] initWithFrame:CGRectMake(10, iTop+(mPlayView.frame.size.height-44)/2-20, mPlayView.frame.size.width-20, 44)];
    mlbWatermark.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    mlbWatermark.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    mlbWatermark.textAlignment = NSTextAlignmentCenter;
    mlbWatermark.textColor =[UIColor whiteColor];
    mlbWatermark.shadowOffset = CGSizeMake(1, 1);
    mlbWatermark.shadowColor = [UIColor darkGrayColor];
    [self.view addSubview:mlbWatermark];
    
    mlbAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, iTop+(mPlayView.frame.size.height-44)/2+20, mPlayView.frame.size.width-20, 44)];
    mlbAddress.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    mlbAddress.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    mlbAddress.textAlignment = NSTextAlignmentCenter;
    mlbAddress.textColor =[UIColor whiteColor];
    mlbAddress.shadowOffset = CGSizeMake(1, 1);
    mlbAddress.shadowColor = [UIColor darkGrayColor];
    [self.view addSubview:mlbAddress];
    
    NSMutableArray *newarray = [NSMutableArray arrayWithCapacity:10];
    for (NSURL *url in self.mVideoArray) {
        [newarray addObject:url.path];
    }
    
    [mPlayView PlayVideoList:newarray];

    iTop += mPlayView.frame.size.height;
    
    ImageProgressView *progressView = [[ImageProgressView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-220)/2, iTop, 220, 40)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:progressView];
    iTop += 40;

    self.mFontArray = @[@"HiraMinProN-W6", @"STLiti", @"DamascusMedium", @"Thonburi-Bold", @"SnellRoundhand-Bold", @"MarkerFelt-Wide"];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iTop, self.view.frame.size.width, fHeight-iTop-65)];
    mScrollView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mScrollView];
    
    NSLog(@"mScrollView:%f", fHeight);
    
    int iHeight = iWidth*17/32;
    int iTotalHeight = 0;
    for (int i = 0; i < _mFontArray.count; i ++) {
        int iXPos = i%2;
        int iYPos = i/2;
        
        NSString *imagename = [NSString stringWithFormat:@"m%d.png", i+1];
        
        TouchView *touchView = [[TouchView alloc] initWithFrame:CGRectMake(iXPos*iWidth+1, iYPos*iHeight+1, iWidth-1, iHeight-1)];
        touchView.delegate = self;
        touchView.OnViewClick = @selector(OnModelSelect:);
        touchView.image = [UIImage imageNamed:imagename];
        touchView.tag = i+1000;
        [mScrollView addSubview:touchView];
        
        NSString *imagename2 = [NSString stringWithFormat:@"n%d.png", i+1];
        UIImageView *coverView = [[UIImageView alloc] initWithFrame:touchView.bounds];
        coverView.image = [UIImage imageNamed:imagename2];
        coverView.tag = 3000;
        coverView.alpha = 0.0;
        [touchView addSubview:coverView];
        
        iTotalHeight = touchView.frame.origin.y+touchView.frame.size.height;
    }
    mScrollView.contentSize = CGSizeMake(KscreenWidth, iTotalHeight);
    
    self.mAudioManager = [[AudioRecordManager alloc] init];
    _mAudioManager.delegate = self;
    _mAudioManager.OnPlayFinish = @selector(OnPlayFinish);
}

- (void)GoBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)OnStopClick {
    if (mPlayView.mPlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [mPlayView.mPlayer pause];
        [_mAudioManager.mAVPlayer pause];
    }
    else {
        [mPlayView.mPlayer play];
        [_mAudioManager.mAVPlayer play];
    }
}

- (void)OnPlayFinish {
    
}

- (void)RefreshImage:(NSInteger)index {
    if (index == miLastIndex) {
        return;
    }
    TouchView *touchView = (TouchView *)[mScrollView viewWithTag:index+1000];
    UIImageView *imageView = (UIImageView *)[touchView viewWithTag:3000];
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1.0;
    }];
    
    TouchView *touchView2 = (TouchView *)[mScrollView viewWithTag:miLastIndex+1000];
    UIImageView *imageView2 = (UIImageView *)[touchView2 viewWithTag:3000];
    [UIView animateWithDuration:0.2 animations:^{
        imageView2.alpha = 0.0;
    }];
    
    miLastIndex = index;
}

- (void)OnModelSelect:(TouchView *)sender {
    NSInteger index = sender.tag-1000;
    [self RefreshImage:index];
    
    //test
    self.mSelectFont = @"AppleSDGothicNeo-Bold";//[self.mFontArray objectAtIndex:index];
    
    
    mlbWatermark.text = [UserInfoManager Share].mWatermark;
    mlbAddress.text = [NSString stringWithFormat:@"%@，%@", kUserInfoManager.mAddInfo.city, kUserInfoManager.mAddInfo.region];
    
    int iFontSize = 50;
    if (mlbWatermark.text.length>0) {
        int iCount = [UserInfoManager sinaCountWord:mlbWatermark.text];
        iFontSize = 300/iCount;
        if (iFontSize > 50) {
            iFontSize = 50;
        }
    }
    mlbWatermark.font = [UIFont fontWithName:self.mSelectFont size:iFontSize*4/5];
    
    NSString *audioname = [NSString stringWithFormat:@"%d", (int)index+1];
    NSString *audiopath = [[NSBundle mainBundle] pathForResource:audioname ofType:@"mp3"];
    
    self.mAudioUrl = [NSURL fileURLWithPath:audiopath];
    [self performSelector:@selector(DelayPlayAudio) withObject:nil afterDelay:0.1];
}

- (void)DelayPlayAudio {
    [_mAudioManager StartPlayAudio:self.mAudioUrl];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [mPlayView.mPlayer pause];
    [_mAudioManager.mAVPlayer pause];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)dealloc {
    self.mVideoArray = nil;
    self.mMediaManager = nil;
    [self.mAudioManager StopPlayAudio];
    self.mAudioManager = nil;
}

- (void)OnJoinClick {
    if (!self.mAudioUrl) {
        [AutoAlertView ShowAlert:@"提示" message:@"请选择模板"];
        return;
    }
    ShareViewController *ctrl = [[ShareViewController alloc] init];
    ctrl.mVideoArray = self.mVideoArray;
    ctrl.mMediaManager = self.mMediaManager;
    ctrl.mSelectFont = self.mSelectFont;
    ctrl.mAudioUrl = self.mAudioUrl;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate");
    return YES;
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
