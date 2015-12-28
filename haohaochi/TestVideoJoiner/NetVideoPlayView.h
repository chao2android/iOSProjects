//
//  NetVideoPlayView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWMoviePlayerController.h"

@interface NetVideoPlayView : UIView {
    UIButton *mPlayBtn;
    UIImageView *mFlagView;
    UIActivityIndicatorView *mActView;
}

@property (nonatomic, strong) NSString *mVideoID;
@property (nonatomic, strong) DWMoviePlayerController *mPlayer;
@property (nonatomic, strong) NSDictionary *currentPlayUrl;
@property (nonatomic, strong) NSDictionary *playUrls;

- (void)PlayVideo:(NSString *)videoid;
- (void)StopVideo;
- (void)CleanVideo;


@end
