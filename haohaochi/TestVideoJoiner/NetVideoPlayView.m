//
//  NetVideoPlayView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "NetVideoPlayView.h"

@implementation NetVideoPlayView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        
        mPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mPlayBtn.frame = self.bounds;
        mPlayBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [mPlayBtn addTarget:self action:@selector(PauseVideo) forControlEvents:UIControlEventTouchUpInside];
        mPlayBtn.hidden = YES;
        [self addSubview:mPlayBtn];
        
        mFlagView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-60)/2, (frame.size.height-60)/2, 60, 60)];
        mFlagView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
        mFlagView.image = [UIImage imageNamed:@"playimage.png"];
        mFlagView.hidden = YES;
        [mPlayBtn addSubview:mFlagView];
        
        mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        mActView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        mActView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:mActView];
    }
    return self;
}

- (void)dealloc {
    [self StopVideo];
}

- (void)PlayVideo:(NSString *)videoid {
    self.mVideoID = videoid;
    [self StopVideo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnPlayFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnPlayStatusChange:) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    
    __weak NetVideoPlayView *blockSelf = self;
    
    self.mPlayer = [[DWMoviePlayerController alloc] initWithUserId:DWACCOUNT_USERID andVideoId:videoid key:DWACCOUNT_APIKEY];
    _mPlayer.view.frame = self.bounds;
    _mPlayer.view.backgroundColor = [UIColor blackColor];
    _mPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _mPlayer.timeoutSeconds = 60;
    _mPlayer.controlStyle = MPMovieControlStyleNone;
    _mPlayer.repeatMode = MPMovieRepeatModeOne;
    _mPlayer.scalingMode = MPMovieScalingModeAspectFill;
    _mPlayer.failBlock = ^(NSError *error){
        NSLog(@"DWMoviePlayerController Error:%@", error);
    };
    _mPlayer.getPlayUrlsBlock = ^(NSDictionary *playUrls){
        NSLog(@"DWMoviePlayerController getPlayUrlsBlock:%@", playUrls);
        NSNumber *status = [playUrls objectForKey:@"status"];
        if (status == nil || [status integerValue] != 0) {
            NSString *message = [NSString stringWithFormat:@"%@:%@",
                                 [playUrls objectForKey:@"status"],
                                 [playUrls objectForKey:@"statusinfo"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        blockSelf.playUrls = playUrls;
        
        [blockSelf resetViewContent];
    };
    
    [self addSubview:_mPlayer.view];
    [_mPlayer startRequestPlayInfo];
    
    [self bringSubviewToFront:mActView];
    [mActView startAnimating];
}

- (void)resetViewContent
{
    // 获取默认清晰度播放url
    NSNumber *defaultquality = [self.playUrls objectForKey:@"defaultquality"];
    
    for (NSDictionary *playurl in [self.playUrls objectForKey:@"qualities"]) {
        if (defaultquality == [playurl objectForKey:@"quality"]) {
            self.currentPlayUrl = playurl;
            break;
        }
    }
    
    if (!self.currentPlayUrl) {
        self.currentPlayUrl = [[self.playUrls objectForKey:@"qualities"] objectAtIndex:0];
    }
    NSLog(@"currentPlayUrl: %@", self.currentPlayUrl);

    [self.mPlayer prepareToPlay];
    
    [self.mPlayer play];
    
    NSLog(@"play url: %@", self.mPlayer.originalContentURL);
    
    mPlayBtn.hidden = NO;
    [self bringSubviewToFront:mPlayBtn];
}

- (void)OnPlayFinish {
    [self StopVideo];
}

- (void)OnPlayStatusChange:(NSNotification *)noti {
    NSLog(@"OnPlayStatusChange:%@", noti.userInfo);
    [mActView stopAnimating];
}

- (void)CleanVideo {
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
    }
}

- (void)PlayVideo {
    [self PlayVideo:self.mVideoID];
}

- (void)PauseVideo {
    if (_mPlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [_mPlayer pause];
        mFlagView.hidden = NO;
    }
    else {
        [_mPlayer play];
        mFlagView.hidden = YES;
    }
}

@end
