//
//  AudioRecordManager.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-1.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "AudioRecordManager.h"
#import <AudioToolbox/AudioServices.h>
#import "ProximityMonitor.h"

@implementation AudioRecordManager

@synthesize mLocalPath, delegate, OnRecordFinish, OnPlayFinish, miSecond;

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
    NSMutableDictionary *settings = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    [settings setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [settings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
    [settings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [settings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
    [settings setValue:[NSNumber numberWithInt:16] forKey:AVEncoderBitDepthHintKey];
    
    NSURL *url = [NSURL fileURLWithPath:self.mLocalPath];
    NSError *error = nil;
    mAVRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
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
        [mAVRecorder release];
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
    
    [[ProximityMonitor Share] StartMonitor];
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
    [[ProximityMonitor Share] StopMonitor];
    if (delegate && OnPlayFinish) {
        [delegate performSelector:OnPlayFinish withObject:self];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"audioRecorderEncodeErrorDidOccur:%@", error);
}

- (void)StopPlayAudio {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mAVPlayer stop];
}

- (void)CancelPlayAudio {
    [[ProximityMonitor Share] StopMonitor];
    if (mAVPlayer) {
        [mAVPlayer stop];
        [mAVPlayer release];
        mAVPlayer = nil;
    }
}

- (void)dealloc {
    [self StopPlayAudio];
    [self StopRecordAudio];
    [super dealloc];
}

@end
