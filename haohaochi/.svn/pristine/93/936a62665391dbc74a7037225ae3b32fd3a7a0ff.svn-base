//
//  VideoCutViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoCutViewController.h"
#import "NetImageView.h"
#import "MediaSelectManager.h"
#import "VideoListManager.h"

@interface VideoCutViewController ()<UIGestureRecognizerDelegate> {
    NetImageView *mImageView;
    UIView *mBotView;
    UIView *mCutView;
    float mLastScale;
    CGSize mSize;
    CGPoint mPoint;
    
    float mfTotalTime;
    float mfRecordTime;
    float mfSepTime;
    NSTimer *mTimer;
    int miThumbIndex;
}

@property (nonatomic, strong) MPMoviePlayerController *mPlayer;

@end

@implementation VideoCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self HideStatusBar:YES];
    
    miThumbIndex = 0;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    topView.image = [UIImage imageNamed:@"f_topbar"];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:topView];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, topView.frame.size.width, 1)];
    shadowView.image = [UIImage imageNamed:@"f_shadow"];
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [topView addSubview:shadowView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 67, 30);
    [backBtn setImage:[UIImage imageNamed:@"p_deletebtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnDelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(self.view.frame.size.width-67, 0, 67, 30);
    commitBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [commitBtn setImage:[UIImage imageNamed:@"p_commitbtn"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(OnCommitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-100, 30)];
    lbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:lbTitle];
    
    mImageView = [[NetImageView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30)];
    mImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mImageView.mImageType = TImageType_CutFill;
    [self.view addSubview:mImageView];
    
    if (self.mDict) {
        NSURL *url = [self.mDict objectForKey:@"url"];
        UIImage *image = [MediaSelectManager GetSnapshotOfVideo:url.path];
        mImageView.mDefaultImage = image;
        [mImageView ShowLocalImage];
        
        CMTime duration = [MediaSelectManager GetVideoDuration:[self.mDict objectForKey:@"url"]];
        mfTotalTime = duration.value/duration.timescale;
        mfRecordTime = [[self.mDict objectForKey:@"time"] floatValue];
        if (mfTotalTime<mfRecordTime) {
            mfRecordTime = mfTotalTime;
        }
        mfSepTime = [[self.mDict objectForKey:@"septime"] floatValue];
    }
    self.mPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[self.mDict objectForKey:@"url"]];
    _mPlayer.view.frame = self.view.bounds;
    _mPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _mPlayer.controlStyle = MPMovieControlStyleNone;
    _mPlayer.repeatMode = MPMovieRepeatModeNone;
    [self.view addSubview:_mPlayer.view];
    [self.view sendSubviewToBack:_mPlayer.view];
    //[_mPlayer pause];
    
    mBotView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    mBotView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    mBotView.backgroundColor = [UIColor colorWithWhite:0.54 alpha:1.0];
    [self.view addSubview:mBotView];
    
    float fWidth = MAX(KscreenHeigh, KscreenWidth)/8;
    for (int i = 0; i < 8; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(fWidth*i, 0, fWidth, mBotView.frame.size.height)];
        imageView.tag = i+1000;
        [mBotView addSubview:imageView];
    }
    
    mCutView = [[UIView alloc] initWithFrame:CGRectMake((mBotView.frame.size.width-100)/2, -2, 100, mBotView.frame.size.height+2)];
    mCutView.hidden = YES;
    [mBotView addSubview:mCutView];
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, mCutView.frame.size.width-30, mCutView.frame.size.height)];
    centerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    centerView.image = [UIImage imageNamed:@"f_timecut"];
    [mCutView addSubview:centerView];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, mCutView.frame.size.height)];
    leftView.image = [UIImage imageNamed:@"f_timeflag"];
    [mCutView addSubview:leftView];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(mCutView.frame.size.width-17, 0, 17, mCutView.frame.size.height)];
    rightView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    rightView.image = [UIImage imageNamed:@"f_timeflag"];
    [mCutView addSubview:rightView];
    
    if ((int)mfSepTime == 0) {
        UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(scale:)];
        [pinchGR setDelegate:self];
        [mCutView addGestureRecognizer:pinchGR];
        
    }
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(panPiece:)];
    [panGR setMaximumNumberOfTouches:1];
    [panGR setDelegate:self];
    [mCutView addGestureRecognizer:panGR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnRequestThumbs:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    
    float fOffset = mfTotalTime/8;
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 8; i ++) {
        [times addObject:[NSNumber numberWithFloat:fOffset*i]];
    }
    [self.mPlayer requestThumbnailImagesAtTimes:times timeOption: MPMovieTimeOptionExact];
    NSLog(@"%@", self.mDict);
}

- (void)OnRequestThumbs:(NSNotification *)noti {
    NSLog(@"OnRequestThumbs:%@", noti.userInfo);
    UIImageView *imageView = (UIImageView *)[mBotView viewWithTag:miThumbIndex+1000];
    if (imageView) {
        imageView.image = [noti.userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
    }
    miThumbIndex ++;
}

- (void)dealloc {
    if (self.mPlayer) {
        [self.mPlayer stop];
        self.mPlayer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.mPlayer cancelAllThumbnailImageRequests];
}

- (void)OnDelClick {
    [[VideoListManager Share] DelVideoAtIndex:self.miIndex subindex:self.miSubIndex];
    
    NSDictionary *userinfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.miIndex] forKey:@"index"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RefreshTimeline object:nil userInfo:userinfo];
    [super GoBack];
}

- (void)OnCommitClick {
    float fStartTime = mCutView.frame.origin.x*mfTotalTime/self.view.frame.size.width;
    [self.mDict setObject:[NSNumber numberWithFloat:fStartTime] forKey:@"starttime"];
    [super GoBack];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    float fScreenWidth = MAX(KscreenWidth, KscreenHeigh);
    float fWidth = fScreenWidth*mfRecordTime/mfTotalTime;
    
    float fStartTime = [[self.mDict objectForKey:@"starttime"] floatValue];
    float fLeft = fStartTime*fScreenWidth/mfTotalTime;
    mCutView.frame = CGRectMake(fLeft, mCutView.frame.origin.y, fWidth, mCutView.frame.size.height);
    mCutView.hidden = NO;
}

- (void)scale:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self StartPlayTimer];
        return;
    }
    else if (sender.state == UIGestureRecognizerStateBegan) {
        mSize = mCutView.frame.size;
        mPoint = mCutView.center;
        [self StopPlayTimer];
    }
    float fMinWidth = self.view.frame.size.width*mfSepTime/mfTotalTime;
    float fWidth = mSize.width*sender.scale;
    if (fWidth<fMinWidth) {
        fWidth = fMinWidth;
    }
    float fLeft = mPoint.x-fWidth/2;
    if (fLeft < 0 || fLeft+fWidth>self.view.frame.size.width) {
        return;
    }
    mCutView.frame = CGRectMake(fLeft, mCutView.frame.origin.y, fWidth, mSize.height);

}

- (void)panPiece:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self StartPlayTimer];
        return;
    }
    else if (sender.state == UIGestureRecognizerStateBegan) {
        mSize = mCutView.frame.size;
        mPoint = mCutView.center;
        [self StopPlayTimer];
    }
    CGPoint translation = [sender translationInView:[sender.view superview]];
    float fLeft = mPoint.x-mSize.width/2+translation.x;
    if (fLeft < 0) {
        fLeft = 0;
    }
    else if (fLeft+mSize.width>self.view.frame.size.width) {
        fLeft = self.view.frame.size.width-mSize.width;
    }
    mCutView.frame = CGRectMake(fLeft, mCutView.frame.origin.y, mSize.width, mSize.height);
}

- (void)StartPlayTimer {
    if (!self.mPlayer.isPreparedToPlay) {
        [_mPlayer prepareToPlay];
    }
    [self.view sendSubviewToBack:mImageView];
    NSLog(@"StartPlayTimer");
    [self StopPlayTimer];
    float fStartTime = mCutView.frame.origin.x*mfTotalTime/self.view.frame.size.width;
    float fDuration = mCutView.frame.size.width*mfTotalTime/self.view.frame.size.width;
    self.mPlayer.currentPlaybackTime = fStartTime;
    [self.mPlayer play];
    mTimer = [NSTimer scheduledTimerWithTimeInterval:fDuration target:self selector:@selector(StopPlayTimer) userInfo:nil repeats:YES];
}

- (void)StopPlayTimer {
    if (mTimer) {
        [mTimer invalidate];
        mTimer = nil;
    }
    float fStartTime = mCutView.frame.origin.x*mfTotalTime/self.view.frame.size.width;
    self.mPlayer.currentPlaybackTime = fStartTime;
    [self.mPlayer pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate");
    return YES;
}

@end
