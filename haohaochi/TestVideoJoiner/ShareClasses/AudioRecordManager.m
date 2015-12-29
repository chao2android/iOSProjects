//
//  AudioRecordManager.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-1.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "AudioRecordManager.h"
#import <AudioToolbox/AudioServices.h>
#ifdef ProximityMonitor
#import "ProximityMonitor.h"
#endif


#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp)
#define MB_DEALLOC()
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#define MB_DEALLOC() [super dealloc]
#endif


@implementation AudioRecordManager

@synthesize mLocalPath, delegate, OnRecordFinish, OnPlayFinish, miSecond, mAVPlayer;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)RecordOnly {
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
    NSError *error = nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    NSLog(@"%@", audioSession.category);
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    [audioSession setActive:YES error:&error];
}

- (void)PlayOnly {
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
    NSError *error = nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    NSLog(@"%@", audioSession.category);
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    [audioSession setActive:YES error:&error];
}

- (NSString *)mLocalPath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:@"audio.aac"];
}

- (void)StartRecordAudio {
    [self CancelRecordAudio];
    [self RecordOnly];
    NSMutableDictionary *settings = MB_AUTORELEASE([[NSMutableDictionary alloc] initWithCapacity:0]);
    [settings setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [settings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
    [settings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [settings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
    [settings setValue:[NSNumber numberWithInt:16] forKey:AVEncoderBitDepthHintKey];
    //        [settings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //        [settings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    
    NSURL *url = [NSURL fileURLWithPath:self.mLocalPath];
    NSError *error = nil;
    mAVRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    [mAVRecorder setDelegate:self];
    [mAVRecorder prepareToRecord];
    [mAVRecorder record];
}

- (void)StopRecordAudio {
    [mAVRecorder stop];
}

- (void)CancelRecordAudio {
    if (mAVRecorder) {
        [mAVRecorder stop];
        MB_RELEASE(mAVRecorder);
        mAVRecorder = nil;
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"audioRecorderDidFinishRecording");
    [self CancelRecordAudio];
    if (delegate && OnRecordFinish) {
        [delegate performSelector:OnRecordFinish withObject:self];
    }
}

- (void)StartPlayAudio:(NSURL *)url {
    [self StopPlayAudio];
    [self PlayOnly];
#ifdef ProximityMonitor
    [[ProximityMonitor Share] StartMonitor];
#endif
    NSError *error = nil;
	mAVPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    mAVPlayer.delegate = self;
	[mAVPlayer prepareToPlay];
	[mAVPlayer setVolume:1];
	[mAVPlayer play];
    NSLog(@"StartPlayAudio:%@, %@", error, mAVPlayer);
    miSecond = mAVPlayer.duration;
    if (!mAVPlayer) {
        [self audioPlayerDidFinishPlaying:mAVPlayer successfully:NO];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying");
#ifdef ProximityMonitor
    [[ProximityMonitor Share] StopMonitor];
#endif
    if (delegate && OnPlayFinish) {
        [delegate performSelector:OnPlayFinish withObject:self];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"audioRecorderEncodeErrorDidOccur:%@", error);
}

- (void)StopPlayAudio {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (mAVPlayer) {
        [mAVPlayer stop];
        self.mAVPlayer = nil;
    }
}

- (void)CancelPlayAudio {
#ifdef ProximityMonitor
    [[ProximityMonitor Share] StopMonitor];
#endif
    if (mAVPlayer) {
        [mAVPlayer stop];
        MB_RELEASE(mAVPlayer)
        mAVPlayer = nil;
    }
}

- (void)dealloc {
    [self StopPlayAudio];
    [self StopRecordAudio];
    MB_DEALLOC()
}

@end
