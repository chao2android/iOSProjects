//
//  SpeechController.h
//  JiaYuan
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 JiaYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AmrFormat.h"
#import "JYHelpers.h"


@class SpeechController;

@protocol SpeechControllerDelegate <NSObject>
//** Record **
@required
-(void)speechRecordBegan:(SpeechController *)speechController msgId:(NSString *)msgId;
-(void)speechRecordFinished:(SpeechController *)speechController msgId:(NSString *)msgId speechLength:(NSInteger)speechLength;
-(void)speechRecordError:(SpeechController *)speechController msgId:(NSString *)msgId;
@optional
-(void)speechRecord:(SpeechController *)speechController msgId:(NSString *)msgId changeTime:(unsigned int)timems volum:(unsigned int)volum;
//** Play **
@required
-(void)speechPlayBegan:(SpeechController *)speechController msgId:(NSString *)msgId;
-(void)speechPlayFinished:(SpeechController *)speechController msgId:(NSString *)msgId;
-(void)speechPlayError:(SpeechController *)speechController msgId:(NSString *)msgId;
@optional
-(void)speechPlay:(SpeechController *)speechController msgId:(NSString *)msgId changeTime:(unsigned int)curTimems totallyTime:(unsigned int)totalTimems;
@end

@interface SpeechController : NSObject<AmrFormatDelegate>
{
    id<SpeechControllerDelegate> delegate;
    
    AmrFormat                  * _amrFormat;
    
   // HttpAsyncActionQueue       * _actionQueue;
    
    NSString                   * _toUid;
    NSString                   * _mailContent;
    NSString                   * _preparePlayId;
    bool                         _upLoad;
    bool                         _autoPlay;
    
    __block bool                 _startRecordFinished;
    __block bool                 _needToStopRecord;
    
    bool                         _isRealRecording;
    
    NSDictionary               * _additionDict;
}

@property (nonatomic, strong) id<SpeechControllerDelegate> delegate;
@property (nonatomic, assign) bool                         upLoad;
@property (nonatomic, retain) NSString                   * toUid;
@property (nonatomic, retain) NSString                   * mailContent;
@property (nonatomic, retain) NSString                   * preparePlayId;
@property (nonatomic, retain) NSDictionary               * additionDict;
//for record and upLoad
-(void)startRecord;
-(bool)isRecording;
-(void)stopRecord;
-(void)upLoadSpeech:(NSString *)msgId speechLength:(NSUInteger)length toUid:(NSString *)toUid mailContent:(NSString *)mailContent self_pay:(NSUInteger)self_pay additionDict:(NSDictionary *)additionDict;
//for play and download
-(void)startPlay:(NSString *)msgId;
-(bool)isPlaying;
-(void)stopPlay;
-(void)downLoadSpeech:(NSString *)msgId toUid:(NSString *)toUid boxType:(NSString *)boxType autoPlay:(bool)autoPlay overWrite:(bool)overWrite;
//other
-(bool)speechFileDelete:(NSString *)msgId;
-(bool)speechFileExistsAtPath:(NSString *)msgId;

-(void)statTrackerEvent:(NSString*)event eventLabel:(NSString*)label;
@end