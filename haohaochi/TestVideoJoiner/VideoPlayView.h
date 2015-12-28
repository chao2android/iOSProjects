//
//  VideoPlayView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayView : UIImageView {
    UIButton *mPlayBtn;
}

@property (nonatomic, assign) BOOL mbRepeatPlay;
@property (nonatomic, strong) NSMutableArray *mVideoArray;
@property (nonatomic, strong) MPMoviePlayerController *mPlayer;

- (void)PlayVideoList:(NSArray *)array;
- (void)PlayVideo:(NSString *)path;
- (void)StopVideo;
- (void)CleanVideo;
- (void)ReplayVideo;

@end
