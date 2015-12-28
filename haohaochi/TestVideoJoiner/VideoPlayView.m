//
//  VideoPlayView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoPlayView.h"
#import "MediaSelectManager.h"

//@interface MPMoviePlayerController (LandScapeMPMoviePlayer)
//
//- (BOOL)shouldAutorotate;
//
//@end
//
//@implementation MPMoviePlayerController (LandScapeMPMoviePlayer)
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
//}
//
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}
//
//@end


@implementation VideoPlayView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        
        self.mbRepeatPlay = NO;
        self.mVideoArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        mPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mPlayBtn.frame = CGRectMake((frame.size.width-60)/2, (frame.size.height-60)/2, 60, 60);
        mPlayBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
        [mPlayBtn setImage:[UIImage imageNamed:@"playimage.png"] forState:UIControlStateNormal];
        [mPlayBtn addTarget:self action:@selector(PlayVideo) forControlEvents:UIControlEventTouchUpInside];
        mPlayBtn.hidden = YES;
        [self addSubview:mPlayBtn];
    }
    return self;
}

- (void)dealloc {
    self.mVideoArray = nil;
    [self StopVideo];
}

- (void)PlayVideo:(NSString *)path {
    [_mVideoArray addObject:path];
    [self PlayVideo];
}

- (void)PlayVideoList:(NSArray *)array {
    for (NSString *path in array) {
        [_mVideoArray addObject:path];
    }
    [self PlayVideo];
}

- (void)PlayVideo {
    [self StopVideo];
    if (_mVideoArray.count == 0) {
        NSLog(@"PlayVideo Error: NO Video");
        return;
    }
    NSString *path = [_mVideoArray objectAtIndex:0];
    //self.image = [MediaSelectManager GetSnapshotOfVideo:path];
    
    //[UIApplication sharedApplication].statusBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnPlayFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnGetViewSize:) name:MPMovieNaturalSizeAvailableNotification object:nil];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    self.mPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    _mPlayer.view.frame = self.bounds;
    _mPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _mPlayer.controlStyle = MPMovieControlStyleNone;
    _mPlayer.repeatMode = MPMovieRepeatModeNone;
    [_mPlayer prepareToPlay];
    [self addSubview:_mPlayer.view];
    
    [_mVideoArray removeObject:path];
    [_mVideoArray addObject:path];
    [_mPlayer play];
    
    NSLog(@"%f, %f", _mPlayer.naturalSize.width, _mPlayer.naturalSize.height);
    
    mPlayBtn.hidden = YES;
    [self bringSubviewToFront:mPlayBtn];
}

- (void)OnGetViewSize:(NSNotification *)noti {
    float fWidth = _mPlayer.naturalSize.width;
    float fHeight = _mPlayer.naturalSize.height;
    NSLog(@"OnGetViewSize:%@", noti.userInfo);
    if (fWidth>fHeight) {
        int iWidth = self.frame.size.height*fWidth/fHeight;
        _mPlayer.view.frame = CGRectMake(0, 0, iWidth, self.frame.size.height);
    }
    else {
        _mPlayer.view.frame = self.bounds;
    }
}

- (void)ReplayVideo {
    [self StopVideo];
    [self PlayVideo];
}

- (void)OnPlayFinish {
    if (self.mbRepeatPlay) {
        if (_mVideoArray.count == 0) {
            NSLog(@"PlayVideo Error: NO Video");
            return;
        }
        NSString *path = [_mVideoArray objectAtIndex:0];
        NSURL *url = [NSURL fileURLWithPath:path];
        [_mPlayer setContentURL:url];
        [_mPlayer play];
        [_mVideoArray removeObject:path];
        [_mVideoArray addObject:path];
    }
    else {
        [self StopVideo];
    }
}

- (void)CleanVideo {
    [_mVideoArray removeAllObjects];
    [self StopVideo];
}

- (void)StopVideo {
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        if (self.mPlayer) {
            [_mPlayer stop];
            [_mPlayer.view removeFromSuperview];
            self.mPlayer = nil;
        }
        //[UIApplication sharedApplication].statusBarHidden = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
        
        //mPlayBtn.hidden = NO;
    }
}

@end
