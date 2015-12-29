//
//  SpeechController.m
//  JiaYuan
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 JiaYuan. All rights reserved.
//

#import "SpeechController.h"
//#import "VoiceDownload.h"
//#import "JYMonitor.h"

@implementation SpeechController
@synthesize delegate;
@synthesize upLoad = _upLoad, toUid = _toUid, mailContent = _mailContent, preparePlayId = _preparePlayId, additionDict = _additionDict;

#define kUpLoadHttpTag 100
#define kDownLoadHttpTag 101

#pragma mark - life cycle

-(id)init
{
    self = [super init];
    if (self)
    {
        _amrFormat = [[AmrFormat alloc] init];
        _amrFormat.delegate = self;
        //_actionQueue = [[HttpAsyncActionQueue alloc] init];
    }
    return self;
}

-(void)dealloc
{
    _amrFormat.delegate = nil;
    delegate = nil;
    if ([_amrFormat isRecordingAmr])
    {
        [_amrFormat stopRecordAmr];
    }
    if ([_amrFormat isPlayingAmr])
    {
        [_amrFormat stopPlayAmr];
    }
     _amrFormat = nil;
    //[_actionQueue stopAllActions];
    //_actionQueue = nil;
    self.toUid = nil;
    self.mailContent = nil;
    self.preparePlayId = nil;
    self.additionDict = nil;
    
}
- (void)statTrackerEvent:(NSString*)event eventLabel:(NSString*)label
{

    //[JYMonitor event:event message:label];
}

#pragma mark - custom action

- (bool)speechFileExistsAtPath:(NSString *)msgId
{
    NSString *speechPath = [JYHelpers getCurrentUserStoreageSubDirectory:@"voice"];
    NSString * amrPath = [speechPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",msgId]];
    return [[NSFileManager defaultManager] fileExistsAtPath:amrPath];
}

-(NSString *)speechFilePath:(NSString *)msgId
{
   // NSString * speechPath = [JiaYuanLocalData getCurrentUserStoreageSubDirectory:@"Speech"];
    NSString *speechPath = [JYHelpers getCurrentUserStoreageSubDirectory:@"voice"];
    NSString * amrPath =[speechPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",msgId]];
    return amrPath;
}

-(void)startRecord
{
  //  [self statTrackerEvent:kTrackerVoiceRecord eventLabel:kTrackerVoiceRecord];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString * theMsgId = [NSString stringWithFormat:@"%f",timeInterval];
    theMsgId = [theMsgId stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString * identifier = theMsgId;
    if ([_amrFormat isPlayingAmr])
    {
        [_amrFormat stopPlayAmr];
    }
    
    if ([_amrFormat isRecordingAmr])
    {
        if ([delegate respondsToSelector:@selector(speechRecordError:msgId:)])
        {
            [delegate speechRecordError:self msgId:identifier];
        }
        return;
    }
    
    _isRealRecording = YES;
    
    _startRecordFinished = NO;
    _needToStopRecord = NO;
    
    [self performSelectorInBackground:@selector(recordThread:) withObject:identifier];
}

-(void)recordThread:(NSString *)identifier
{
    NSLog(@"recordThread");
    [_amrFormat startRecordAmr:[self speechFilePath:identifier] identifier:identifier];
    _startRecordFinished = YES;
    if (_needToStopRecord)
    {
        _needToStopRecord = NO;
        [_amrFormat stopRecordAmr];
    }
}

-(bool)isRecording
{
    return [_amrFormat isRecordingAmr];
}

-(void)stopRecord
{
    NSLog(@"stopRecord");
    if (_startRecordFinished)
    {
        _startRecordFinished = NO;
        [_amrFormat stopRecordAmr];
    }else 
    {
        _needToStopRecord = YES;
    }
}



-(void)startPlay:(NSString *)msgId
{
    if (_isRealRecording)
    {
        return;
    }
    if ([_amrFormat isRecordingAmr])
    {
        return;
    }
    self.preparePlayId = msgId;
    if ([_amrFormat isPlayingAmr])
    {
        [_amrFormat stopPlayAmr];
    }
    
    if ([self speechFileExistsAtPath:msgId]) {
        [_amrFormat startPlayAmr:[self speechFilePath:msgId] identifier:msgId];
    }else{
        NSLog(@"no file");
    }
    
}

-(bool)isPlaying
{
    return [_amrFormat isPlayingAmr];
}

-(void)stopPlay
{
    self.preparePlayId = nil;
    if ([_amrFormat isPlayingAmr]) [_amrFormat stopPlayAmr];
}

-(bool)speechFileDelete:(NSString *)msgId
{
    if ([self isPlaying] && [_amrFormat.playIdentifier isEqualToString:msgId])
    {
        [self stopPlay];
    }
    return [[NSFileManager defaultManager] removeItemAtPath:[self speechFilePath:msgId] error:nil];
}

-(bool)actionIsProgressing:(NSString *)msgId
{
    return NO;
}

#pragma mark - TFHttpAsyncActionDelegate

#pragma mark - RecordDelegate

-(void)amrFormatRecordBegan:(AmrFormat *)amrFormat identifier:(NSString *)identifier
{
    if ([delegate respondsToSelector:@selector(speechRecordBegan:msgId:)])
    {
        [delegate speechRecordBegan:self msgId:identifier];
    }
}
-(void)amrFormatRecordFinished:(AmrFormat *)amrFormat identifier:(NSString *)identifier amrLength:(unsigned int)amrLength
{
    _isRealRecording = NO;
    if ([delegate respondsToSelector:@selector(speechRecordFinished:msgId:speechLength:)])
    {
        [delegate speechRecordFinished:self msgId:identifier speechLength:amrLength];
    }
    if (_upLoad && amrLength >= 1000)
    {
       // [self upLoadSpeech:identifier speechLength:amrLength toUid:_toUid mailContent:_mailContent self_pay:0 additionDict:_additionDict];
    }
}
-(void)amrFormatRecordError:(AmrFormat *)amrFormat identifier:(NSString *)identifier
{
    _isRealRecording = NO;
    if ([delegate respondsToSelector:@selector(speechRecordError:msgId:)])
    {
        [delegate speechRecordError:self msgId:identifier];
    }
}
-(void)amrFormatRecord:(AmrFormat *)amrFormat identifier:(NSString *)identifier changeTime:(unsigned int)timems volum:(unsigned int)volum
{
    if ([delegate respondsToSelector:@selector(speechRecord:msgId:changeTime:volum:)])
    {
        [delegate speechRecord:self msgId:identifier changeTime:timems volum:volum];
    }
}
#pragma mark - PlayDelegate

-(void)amrFormatPlayBegan:(AmrFormat *)amrFormat identifier:(NSString *)identifier
{
    if ([delegate respondsToSelector:@selector(speechPlayBegan:msgId:)])
    {
        [delegate speechPlayBegan:self msgId:identifier];
    }
}
-(void)amrFormatPlayFinished:(AmrFormat *)amrFormat identifier:(NSString *)identifier
{
    if ([delegate respondsToSelector:@selector(speechPlayFinished:msgId:)])
    {
        [delegate speechPlayFinished:self msgId:identifier];
    }
}
-(void)amrFormatPlayError:(AmrFormat *)amrFormat identifier:(NSString *)identifier
{
    if ([delegate respondsToSelector:@selector(speechPlayError:msgId:)])
    {
        [delegate speechPlayError:self msgId:identifier];
    }
}
-(void)amrFormatPlay:(AmrFormat *)amrFormat identifier:(NSString *)identifier changeTime:(unsigned int)curTimems totallyTime:(unsigned int)totalTimems
{
    if ([delegate respondsToSelector:@selector(speechPlay:msgId:changeTime:totallyTime:)])
    {
        [delegate speechPlay:self msgId:identifier changeTime:curTimems totallyTime:totalTimems];
    }
}

@end