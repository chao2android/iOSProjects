//
//  AmrFormat.h
//  JiaYuan
//
//  Created by  on 12-10-9.
//  Copyright (c) 2012年 JiaYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define __AUDIO_QUEUE_H__

#if !defined(__COREAUDIO_USE_FLAT_INCLUDES__)
#include <AudioToolbox/AudioQueue.h>
#include <AudioToolbox/AudioFile.h>
#include <AudioToolbox/AudioFormat.h>
#else
#include "AudioQueue.h"
#include "AudioFile.h"
#include "AudioFormat.h"
#endif
#include <AudioToolbox/AudioServices.h>
#include "pcm.h"
#include <sys/time.h>
#include <pthread.h>
#include "devfs.h"



#define AUDIO_QUEUE_DEBUG 1
#define AUDIO_FILE_ANA    0

#if AUDIO_QUEUE_DEBUG
#define AUDIO_QUEUE_RECORD 1
#define AUDIO_QUEUE_PLAY 1
#else
#define AUDIO_QUEUE_RECORD 0
#define AUDIO_QUEUE_PLAY 0
#endif

#define FRAME_SIZE (sizeof(short) * 160)
#define BUFFER_PLAY (FRAME_SIZE*5)
#define BUFFER_RECORD (FRAME_SIZE*2)

#define BUFFER_NUMER    3
#define MAXRECORDTIME  60000

typedef struct {
    volatile int   iCur;
    volatile int   n;
    volatile int   iTotal;
    short *buf;
}audioBuf;

typedef struct{
    enum Mode mode;
    
    KX_FILE_HANDLE fdstart;
    KX_FILE_HANDLE fdend;
    
    /* for audio queue */
    AudioQueueRef                   mQueue;
    AudioStreamBasicDescription     des;
    pthread_mutex_t                 mutex;
    pthread_t                       thread;
    
    /* for record */
    KX_FILE_HANDLE                  fdout;
    AudioQueueBufferRef             mOutBuffers[BUFFER_NUMER];
    unsigned int                    record_time_msec;
    unsigned int                    record_time_msec_cur;
    void *                          pEncode;
    unsigned int                    curRecordPower;
    audioBuf                        tAudioBuf;
    volatile int                    m_Done;
    int                             m_compressDone;
    
    /* for play */
    KX_FILE_HANDLE                  fdin;
    AudioQueueBufferRef             mInBuffers[BUFFER_NUMER];
    unsigned int                    play_time_msec;
    unsigned int                    play_time_msec_cur;
    void *                          pDecode;
}AmrInfo;

@class AmrFormat;

@protocol AmrFormatDelegate <NSObject>
@optional
//** Record **
-(void)amrFormatRecordBegan:(AmrFormat *)amrFormat identifier:(NSString *)identifier;
-(void)amrFormatRecordFinished:(AmrFormat *)amrFormat identifier:(NSString *)identifier amrLength:(unsigned int)amrLength;
-(void)amrFormatRecordError:(AmrFormat *)amrFormat identifier:(NSString *)identifier;
-(void)amrFormatRecord:(AmrFormat *)amrFormat identifier:(NSString *)identifier changeTime:(unsigned int)timems volum:(unsigned int)volum;
//** Play **
-(void)amrFormatPlayBegan:(AmrFormat *)amrFormat identifier:(NSString *)identifier;
-(void)amrFormatPlayFinished:(AmrFormat *)amrFormat identifier:(NSString *)identifier;
-(void)amrFormatPlayError:(AmrFormat *)amrFormat identifier:(NSString *)identifier;
-(void)amrFormatPlay:(AmrFormat *)amrFormat identifier:(NSString *)identifier changeTime:(unsigned int)curTimems totallyTime:(unsigned int)totalTimems;
@end

@interface AmrFormat : NSObject
{
    id<AmrFormatDelegate>     delegate;
    AmrInfo                  _recordInfo;
    AmrInfo                  _playInfo;
    UInt32                   _category;
    NSString               * _recordIdentifier;
    NSString               * _playIdentifier;
    AVAudioPlayer          * _audioPlayer;
    bool                     _playBegan;
}

@property (nonatomic, assign) id<AmrFormatDelegate>    delegate;
@property (nonatomic, retain) NSString               * recordIdentifier;
@property (nonatomic, retain) NSString               * playIdentifier;

unsigned int getAmrTimeMsLength(const char* path);
void releaseResource(AmrInfo *pInfo);
OSStatus playAmr(AmrInfo *pInfo, const char* path, const char *startamr, const char *endamr, CFRunLoopRef refLoop);
OSStatus recordAmr(AmrInfo *pInfo, const char* path, enum Mode mod, CFRunLoopRef refLoop);
void stopPlayAmr(AmrInfo *pInfo);
void stopRecordAmr(AmrInfo *pInfo);

-(void)recordBegin;
-(void)recordError;
-(void)setRecordTime;
-(void)recordFinish;
-(void)playBegin;
-(void)playError;
-(void)setPlayTime;
-(void)playFinish;

-(bool)isRecordingAmr;
-(bool)isPlayingAmr;
-(void)stopRecordAmr;
-(void)stopPlayAmr;
-(void)startRecordAmr:(NSString *)path identifier:(NSString *)identifier;
-(void)startPlayAmr:(NSString *)path identifier:(NSString *)identifier;

@end
