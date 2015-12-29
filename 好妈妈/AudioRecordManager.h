//
//  AudioRecordManager.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-1.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AudioRecordManager : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
	AVAudioRecorder *mAVRecorder;
    AVAudioPlayer *mAVPlayer;
    int miSecond;
}

@property (readonly) int miSecond;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnRecordFinish;
@property (nonatomic, assign) SEL OnPlayFinish;

@property (readonly) NSString *mLocalPath;

- (void)StartRecordAudio;
- (void)StopRecordAudio;
- (void)CancelRecordAudio;
- (void)StartPlayAudio:(NSURL *)url;
- (void)StopPlayAudio;
- (void)CancelPlayAudio;

@end
