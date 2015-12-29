//
//  AudioPlayButton.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-13.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "AudioPlayButton.h"
#import "NetImageView.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioPlayButton

@synthesize mbWhite, delegate, OnAudioStart, mLocalPath, mAudioPath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mbWhite = NO;
        mBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mBackBtn.frame = CGRectMake(0, 0, 60, self.frame.size.height);
        mBackBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [mBackBtn addTarget:self action:@selector(OnButtonClick) forControlEvents:UIControlEventTouchUpInside];
        mBackBtn.hidden = YES;
        [self addSubview:mBackBtn];
        
        mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 30)];
        mImageView.image = [UIImage imageNamed:@"voice-black00.png"];
        [mBackBtn addSubview:mImageView];
        [mImageView release];
        
        mlbLength = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 80, frame.size.height)];
        mlbLength.backgroundColor = [UIColor clearColor];
        mlbLength.font = [UIFont systemFontOfSize:10];
        [mBackBtn addSubview:mlbLength];
        [mlbLength release];
        
        mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        mActView.center = CGPointMake(15, 15);
        [self addSubview:mActView];
        [mActView release];
    }
    return self;
}

- (void)dealloc {
    [self Cancel];
    self.mLocalPath = nil;
    self.mAudioPath = nil;
    self.userInfo = nil;
    [super dealloc];
}

- (void)StartAnimate {
    [self StopAnimate];
    miIndex = 0;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(OnChangeAnimate) userInfo:nil repeats:YES];
}

- (void)OnChangeAnimate {
    NSString *imagename = [NSString stringWithFormat:@"voice-black%02d.png", miIndex+1];
    if (mbWhite) {
        imagename = [NSString stringWithFormat:@"voice-white%02d.png", miIndex+1];
    }
    mImageView.image = [UIImage imageNamed:imagename];
    miIndex ++;
    if (miIndex == 4) {
        miIndex = 0;
    }
}

- (void)StopAnimate {
    if (mTimer) {
        [mTimer invalidate];
        mTimer = nil;
    }
    NSLog(@"Audio StopAnimate");
    NSString *imagename = @"voice-black00.png";
    if (mbWhite) {
        imagename = @"voice-white00.png";
    }
    mImageView.image = [UIImage imageNamed:imagename];
}

- (void)setMbWhite:(BOOL)bWhite {
    mbWhite = bWhite;
    NSString *imagename = @"voice-black00.png";
    mlbLength.textColor = [UIColor blackColor];
    if (mbWhite) {
        imagename = @"voice-white00.png";
        mlbLength.textColor = [UIColor whiteColor];
    }
    mImageView.image = [UIImage imageNamed:imagename];
}

- (void)OnButtonClick {
    [self StartAnimate];
    if (delegate && OnAudioStart) {
        [delegate performSelector:OnAudioStart withObject:self.mLocalPath];
    }
}

- (void)GetAudioStr:(NSString *)path {
    if (!path || (self.mAudioPath && ![self.mAudioPath isEqualToString:path])) {
        mBackBtn.hidden = YES;
        [self Cancel];
        [self StopAnimate];
    }
    self.mAudioPath = path;
    if (!path) {
        return;
    }
    NSLog(@"OnPlayAudio:%@", path);
    NSString *localpath = [AudioPlayButton GetLocalPathOfUrl:path];
    if (!localpath) {
        return;
    }
    self.mLocalPath = localpath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:localpath]) {
        [self ShowAudioLength];
    }
    else {
        [mActView startAnimating];
        mDownManager = [[ImageDownManager alloc] init];
        mDownManager.delegate = self;
        mDownManager.OnImageDown = @selector(OnAudioDown:);
        mDownManager.OnImageFail = @selector(OnAudioFail:);
        mDownManager.userInfo = localpath;
        [mDownManager GetImageByStr:path];
    }
}

- (void)OnAudioDown:(ImageDownManager *)sender {
    NSString *localpath = sender.userInfo;
    if (sender.mWebData.length>0 && localpath && localpath.length>0) {
        NSLog(@"OnPlayAudio:%@", localpath);
        [sender.mWebData writeToFile:localpath atomically:YES];
        [self ShowAudioLength];
    }
    [self Cancel];
}

- (void)ShowAudioLength {
    mBackBtn.hidden = NO;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.mLocalPath] error:nil];
    int iAudioLength = player.duration;
    NSLog(@"ShowAudioLength:%@, %d", self.mLocalPath, iAudioLength);
    mlbLength.text = [NSString stringWithFormat:@"%d\"", iAudioLength];
    [player release];
}

- (void)OnAudioFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)Cancel {
    [mActView stopAnimating];
    if (mDownManager) {
        mDownManager.delegate = nil;
        [mDownManager Cancel];
        [mDownManager release];
        mDownManager = nil;
    }
}

+ (NSString *)GetLocalPathOfUrl:(NSString *)path {
    NSRange headrange = [path rangeOfString:@"http:" options:NSCaseInsensitiveSearch];
    if (headrange.length == 0) {
        return path;
    }
    NSString *extname = @"m4a";
    NSString *name = [NetImageView MD5String:path];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *localpath = [docDir stringByAppendingPathComponent:name];
    localpath = [localpath stringByAppendingFormat:@".%@", extname];
    return localpath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
