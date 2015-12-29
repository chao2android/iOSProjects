//
//  MediaSelectManager.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MediaSelectManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreText/CoreText.h>
#import "VideoUrlInfo.h"

#define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#if __has_feature(objc_arc)
#define SAFE_RELEASE(x)
#define SAFE_SUPER_DEALLOC()
#define SAFE_AUTORELEASE(x) x
#else
#define SAFE_RELEASE(x) ([(x) release])
#define SAFE_SUPER_DEALLOC() ([super dealloc])
#define SAFE_AUTORELEASE(x) ([(x) autorelease])
#endif

@interface UIImagePickerController (LandScapeImagePicker)

@end

@implementation UIImagePickerController (LandScapeImagePicker)

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if ([self isKindOfClass:[UIImagePickerController class]]) {
        return UIInterfaceOrientationPortrait;
    }
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
@end

@implementation MediaSelectManager

@synthesize mRootCtrl, delegate;

- (id)init {
    self = [super init];
    if (self) {
        self.mbLightOff = NO;
    }
    return self;
}

- (void)dealloc {
    self.mWatermark = nil;
}

#pragma mark - Take Video

- (BOOL)IsMediaValidate:(BOOL)bCamera {
    if (!bCamera && [UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"找不到相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        SAFE_RELEASE(alertView);
        return NO;
    }
    if (bCamera && [UIImagePickerController isSourceTypeAvailable:
                    UIImagePickerControllerSourceTypeCamera] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"找不到摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        SAFE_RELEASE(alertView);
        return NO;
    }
    return YES;
}


- (BOOL)TakeVideo:(BOOL)bCamera controlView:(UIView *)controlView {
    return [self TakeVideo:bCamera controlView:controlView animated:YES];
}

- (BOOL)TakeVideo:(BOOL)bCamera controlView:(UIView *)controlView animated:(BOOL)animate {
    if (!mRootCtrl) {
        return NO;
    }
    if (![self IsMediaValidate:bCamera]) {
        return NO;
    }
    self.mPicker = [[UIImagePickerController alloc] init];
    if (bCamera) {
		self.mPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        self.mPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    self.mPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
    self.mPicker.allowsEditing = YES;
    self.mPicker.delegate = self;
    self.mPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    if (controlView) {
        self.mPicker.showsCameraControls = NO;
        self.mPicker.cameraOverlayView = controlView;
    }
    if (self.mbLightOff) {
        self.mPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
    [mRootCtrl presentViewController:self.mPicker animated:animate completion:nil];
    
    return YES;
}

- (void)setMbLightOff:(BOOL)value {
    _mbLightOff = value;
    if (self.mPicker) {
        self.mPicker.cameraFlashMode = _mbLightOff?UIImagePickerControllerCameraFlashModeOff:UIImagePickerControllerCameraFlashModeOn;
    }
}

- (void)CancelVideo {
    [self.mPicker dismissViewControllerAnimated:YES completion:nil];
    self.mPicker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"didFinishPickingMediaWithInfo：%@", url);
        if (delegate && [delegate respondsToSelector:@selector(MediaSelectManager:DidSelectVideo:)]) {
            [delegate MediaSelectManager:self DidSelectVideo:url];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self CancelVideo];
}

- (void)ChangeCameraDevice:(BOOL)bFront {
    if (bFront) {
        self.mPicker.cameraDevice =  UIImagePickerControllerCameraDeviceFront;
    }
    else {
        self.mPicker.cameraDevice =  UIImagePickerControllerCameraDeviceRear;
    }
}

- (void)ExchangeCamera {
    NSLog(@"ExchangeCamera");
    if (self.mPicker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        self.mPicker.cameraDevice =  UIImagePickerControllerCameraDeviceRear;
    }
    else {
        self.mPicker.cameraDevice =  UIImagePickerControllerCameraDeviceFront;
    }
}

#pragma mark - Take Audio

- (BOOL)TakeAudio {
    if (!mRootCtrl) {
        return NO;
    }
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
    mediaPicker.delegate = self;
    mediaPicker.prompt = @"选择音频";
    [mRootCtrl presentViewController:mediaPicker animated:YES completion:nil];
    return YES;
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    NSArray *selectedSong = [mediaItemCollection items];
    if ([selectedSong count] > 0) {
        MPMediaItem *songItem = [selectedSong objectAtIndex:0];
        NSURL *songURL = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
        if (delegate && [delegate respondsToSelector:@selector(MediaSelectManager:DidSelectAudio:)]) {
            [delegate MediaSelectManager:self DidSelectAudio:songURL];
        }
    }
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Join Media

- (CMTime)AddVideoToVideoComposition:(AVMutableCompositionTrack *)videoTrack videoinfo:(VideoUrlInfo *)info time:(CMTime)startTime instructions:(NSMutableArray *)instructions {
    AVAsset *videoAsset = [AVAsset assetWithURL:info.mUrl];
    if (videoAsset) {
        CMTime duration = info.mDuration;
        if (CMTimeCompare(duration, kCMTimeZero) == 0) {
            duration = videoAsset.duration;
        }
        if (CMTimeCompare(duration, videoAsset.duration) > 0) {
            duration = videoAsset.duration;
        }
        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        if (tracks.count == 0) {
            return duration;
        }
        AVAssetTrack *sourceTrack = [tracks objectAtIndex:0];
        [videoTrack insertTimeRange:CMTimeRangeMake(info.mStartTime, duration)
                            ofTrack:sourceTrack atTime:startTime error:nil];
        [videoTrack setPreferredTransform:sourceTrack.preferredTransform];
        
        NSLog(@"videoTrack.naturalSize:(%f, %f)", sourceTrack.naturalSize.width, sourceTrack.naturalSize.height);
        
        float fMinHeight = MIN(sourceTrack.naturalSize.width, sourceTrack.naturalSize.height);
        float fScale = 720.0/fMinHeight;
        
        AVMutableVideoCompositionInstruction *passInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        passInstruction.timeRange = CMTimeRangeMake(startTime, duration);
        
        AVMutableVideoCompositionLayerInstruction *passLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:sourceTrack];
        
        CGAffineTransform newtransform = CGAffineTransformConcat(sourceTrack.preferredTransform, CGAffineTransformMakeScale(fScale, fScale));
        [passLayer setTransform:newtransform atTime:startTime];
        
        passInstruction.layerInstructions = @[passLayer];
        [instructions addObject:passInstruction];
        return duration;
    }
    return kCMTimeZero;
}

- (void)JoinMedia:(NSArray *)urlarray :(NSURL *)audioURL {
    if (!urlarray || urlarray.count == 0) {
        return;
    }
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
    
    CGSize videoSize = CGSizeZero;
    //Join Video
    CMTime startTime = kCMTimeZero;
    
    NSMutableArray *videoarray = [NSMutableArray arrayWithCapacity:10];
    for (VideoUrlInfo *info in urlarray) {
        CMTime duration = [self AddVideoToVideoComposition:videoTrack videoinfo:info time:startTime instructions:videoarray];
        startTime = CMTimeAdd(startTime, duration);
        if (CGSizeEqualToSize(videoSize, CGSizeZero)) {
            videoSize = videoTrack.naturalSize;
            
            float fHeight = 720;
            float fWidth = fHeight*4/3;
            fWidth = MIN(fWidth, videoSize.width);
            
            videoComposition.renderSize = CGSizeMake(fWidth, fHeight);
        }
    }
    
    //Join Audio
    if (audioURL) {
        AVAsset *audioAsset = [AVAsset assetWithURL:audioURL];
        if (audioAsset) {
            AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, startTime) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        }
    }
    
    videoComposition.instructions = videoarray;
    
    self.mVideoSize = CGSizeMake(960, 720);
    
    [self GetVideoWatermark:videoComposition];
    
    NSString *exportname = [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000];
    NSString *exportPath = [DocumentDir stringByAppendingPathComponent:exportname];
    NSURL *url = [NSURL fileURLWithPath:exportPath];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_JoinMediaFinish object:nil userInfo:[NSDictionary dictionaryWithObject:exporter.outputURL forKey:@"url"]];
            }
            else {
                NSLog(@"exporter.status =%@",exporter.error);
            }
        });
    }];
}

- (CALayer*)copyWatermarkLayer:(CALayer*)inputLayer
{
	CALayer *exportWatermarkLayer = [CALayer layer];
	CATextLayer *titleLayer = [CATextLayer layer];
	CATextLayer *inputTextLayer = [inputLayer sublayers][0];
	titleLayer.string = inputTextLayer.string;
	titleLayer.foregroundColor = inputTextLayer.foregroundColor;
	titleLayer.font = inputTextLayer.font;
	titleLayer.shadowOpacity = inputTextLayer.shadowOpacity;
	titleLayer.alignmentMode = inputTextLayer.alignmentMode;
	titleLayer.bounds = inputTextLayer.bounds;
	
	[exportWatermarkLayer addSublayer:titleLayer];
	return exportWatermarkLayer;
}

- (void)GetVideoWatermark:(AVMutableVideoComposition *)videoComposition {
    if (self.mWatermark && self.mWatermark.length>0) {
        CALayer *watermarkLayer = [self watermarkLayerForSize:videoComposition.renderSize text:self.mWatermark font:self.mWatermarkFont];
        if (watermarkLayer) {
            CALayer *parentLayer = [CALayer layer];
            CALayer *videoLayer = [CALayer layer];
            parentLayer.frame = CGRectMake(0, 0, videoComposition.renderSize.width, videoComposition.renderSize.height);
            videoLayer.frame = CGRectMake(0, 0, videoComposition.renderSize.width, videoComposition.renderSize.height);
            [parentLayer addSublayer:videoLayer];
            
            UIImage *waterMarkImage = [UIImage imageNamed:@"f_alphacover.png"];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.contents = (id)waterMarkImage.CGImage;
            imageLayer.frame = videoLayer.frame;
            //waterMarkLayer.opacity = 0.6f;
            [parentLayer addSublayer:imageLayer];
            
            int iHeight = 30*videoComposition.renderSize.height/240;
            watermarkLayer.position = CGPointMake(parentLayer.frame.size.width/2, parentLayer.frame.size.height/2+watermarkLayer.frame.size.height/2);
            [parentLayer addSublayer:watermarkLayer];
            
            NSString *address = [NSString stringWithFormat:@"%@，%@", kUserInfoManager.mAddInfo.city, kUserInfoManager.mAddInfo.region];
            
            CALayer *addressLayer = [self watermarkLayerForSize:videoComposition.renderSize text:address font:[UIFont fontWithName:@"HelveticaNeue" size:16]];
            addressLayer.position = CGPointMake(videoComposition.renderSize.width/2, videoComposition.renderSize.height/2-iHeight/3);
            [parentLayer addSublayer:addressLayer];
            
            videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        }
    }
}

- (CALayer*)watermarkLayerForSize:(CGSize)videoSize text:(NSString *)text font:(UIFont *)font
{
    // Create a layer for the title
    CALayer *_watermarkLayer = [CALayer layer];
    
    NSMutableArray *textarray = [NSMutableArray arrayWithCapacity:10];
    NSInteger iSize = text.length;
    if (text.length<7) {
        [textarray addObject:text];
    }
    else {
        iSize = text.length/2;
        if (text.length%2 == 1) {
            iSize ++;
        }
        NSString *text1 = [text substringToIndex:iSize];
        NSString *text2 = [text substringFromIndex:iSize];
        [textarray addObject:text2];
        [textarray addObject:text1];
    }
    
    int iFontSize = 0;
    if (font) {
        NSLog(@"watermarkLayerForSize:%@, %f", font.fontName, font.pointSize);
        iFontSize = font.pointSize*videoSize.height/240;
        font = [UIFont fontWithName:font.fontName size:iFontSize];
    }
    
    _watermarkLayer.frame = CGRectMake(10, 10, videoSize.width-20, textarray.count*iFontSize*1.2);
    _watermarkLayer.anchorPoint = CGPointMake(0.5, 0.5);
    
    
    NSDictionary* attributes = @{ NSFontAttributeName : font,
                                  (NSString *)kCTForegroundColorAttributeName: (id)[UIColor whiteColor].CGColor,
                                  (NSString *)kCTStrokeWidthAttributeName: @(-1.0),
                                  (NSString *)kCTStrokeColorAttributeName: (id)[UIColor clearColor].CGColor, };
    int index = 0;
    for (NSString *text1 in textarray) {
        // Create a layer for the text of the title.
        CATextLayer *titleLayer = [CATextLayer layer];
        titleLayer.string = [[NSAttributedString alloc] initWithString:text1 attributes:attributes];
        titleLayer.foregroundColor = [[UIColor whiteColor] CGColor];
        titleLayer.shadowOpacity = 0.5;
        titleLayer.alignmentMode = kCAAlignmentCenter;
        titleLayer.frame = CGRectMake(0, (iFontSize*1.2)*index, _watermarkLayer.frame.size.width, iFontSize*1.1);
        titleLayer.anchorPoint = CGPointMake(0.5, 0.5);
        
        // Add it to the overall layer.
        [_watermarkLayer addSublayer:titleLayer];
        index ++;
    }
    return _watermarkLayer;
}

#pragma mark - Mix Sound

- (void)MixSound:(NSArray *)urlarray :(NSURL *)audioURL {
    if (!urlarray || urlarray.count == 0) {
        return;
    }
    NSMutableArray *audioMixParams = [NSMutableArray arrayWithCapacity:10];
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //Mix Video Sound
    CMTime startTime = kCMTimeZero;
    NSMutableArray *timearray = [NSMutableArray arrayWithCapacity:10];
    for (VideoUrlInfo *info in urlarray) {
        CMTime duration = [self AddAudioToAudioComposition:audioTrack videoinfo:info time:startTime mixParams:audioMixParams];
        NSDictionary *timedict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCMTime:startTime], @"time", [NSNumber numberWithBool:info.mbSoundLow], @"soundlow", nil];
        [timearray addObject:timedict];
        startTime = CMTimeAdd(startTime, duration);
    }
    //Mix Audio Sound
    if (audioURL) {
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [self AddAudioToAudioComposition2:audioTrack url:audioURL times:timearray mixParams:audioMixParams];
    }
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];
    
    NSString *exportname = [NSString stringWithFormat:@"mergeAudio-%d.m4a",arc4random() % 1000];
    NSString *exportPath = [DocumentDir stringByAppendingPathComponent:exportname];
    NSURL *url = [NSURL fileURLWithPath:exportPath];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    exporter.audioMix = audioMix;
    exporter.outputURL = url;
    exporter.outputFileType = AVFileTypeAppleM4A;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_MixSoundFinish object:nil userInfo:[NSDictionary dictionaryWithObject:exporter.outputURL forKey:@"url"]];
            }
            else {
                NSLog(@"exporter.status =%@",exporter.error);
            }
        });
    }];
}

- (CMTime)AddAudioToAudioComposition:(AVMutableCompositionTrack *)audioTrack videoinfo:(VideoUrlInfo *)info time:(CMTime)startTime mixParams:(NSMutableArray *)audioMixParams {
    AVAsset *audioAsset = [AVAsset assetWithURL:info.mUrl];
    if (audioAsset) {
        CMTime duration = info.mDuration;
        if (CMTimeCompare(duration, kCMTimeZero) == 0) {
            duration = audioAsset.duration;
        }
        NSArray *tracks = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
        if (tracks.count == 0) {
            return duration;
        }
        AVAssetTrack *sourceTrack = [tracks objectAtIndex:0];
        [audioTrack insertTimeRange:CMTimeRangeMake(info.mStartTime, duration)
                            ofTrack:sourceTrack atTime:startTime error:nil];
        if (audioMixParams) {
            //Set Volume
            AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
            [trackMix setVolume:1.0f atTime:startTime];
            [audioMixParams addObject:trackMix];
        }
        
        return duration;
    }
    return kCMTimeZero;
}

- (CMTime)AddAudioToAudioComposition2:(AVMutableCompositionTrack *)audioTrack url:(NSURL *)url times:(NSArray *)times mixParams:(NSMutableArray *)audioMixParams {
    AVAsset *audioAsset = [AVAsset assetWithURL:url];
    if (audioAsset) {
        CMTime duration = audioAsset.duration;
        NSArray *tracks = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
        if (tracks.count == 0) {
            return duration;
        }
        AVAssetTrack *sourceTrack = [tracks objectAtIndex:0];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
                            ofTrack:sourceTrack atTime:kCMTimeZero error:nil];
        if (audioMixParams) {
            //Set Volume
            AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
            for (NSDictionary *info in times) {
                BOOL bSoundLow = [[info objectForKey:@"soundlow"] boolValue];
                NSValue *value = [info objectForKey:@"time"];
                CMTime startTime = [value CMTimeValue];
                NSLog(@"info.mbSoundLow:%d, %lld", bSoundLow, startTime.value/startTime.timescale);
                [trackMix setVolume:bSoundLow?0.2f:1.0f atTime:startTime];
            }
            [audioMixParams addObject:trackMix];
        }
        
        return duration;
    }
    return kCMTimeZero;
}

#pragma mark - ImageToMovie

- (void)ImageToMovie:(UIImage *)image path:(NSString *)path duration:(float)duration size:(CGSize)size
{
    if (!image) {
        return;
    }
    image = [self ScaleImageToSize:image :size];
    
    NSError *error = nil;
    
    NSURL *outputURL = [NSURL fileURLWithPath:path];
    //—-initialize compression engine
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:outputURL fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(videoWriter);
    if(error) {
        NSLog(@"error = %@", [error localizedDescription]);
    }
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey, nil];
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if (![videoWriter canAddInput:writerInput]) {
        NSLog(@"can not AddInput");
    }
    
    [videoWriter addInput:writerInput];
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    int iTotalCount = 10*duration;
    //合成多张图片为一个视频文件
    dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue", NULL);
    int __block frame = 0;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while ([writerInput isReadyForMoreMediaData]) {
            if(++frame >= iTotalCount) {
                [writerInput markAsFinished];
                [videoWriter finishWriting];
                NSLog(@"appendPixelBuffer Finish");
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ImgToMovFinish object:nil userInfo:[NSDictionary dictionaryWithObject:outputURL forKey:@"url"]];
                break;
            }
            
            CVPixelBufferRef buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:image.CGImage size:size];
            if (buffer) {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, 10)]) {
                    NSLog(@"appendPixelBuffer Error");
                }
                else {
                    CFRelease(buffer);
                }
            }
            
        }
    }];
}

#pragma mark - Public Method

- (void)SaveToAlbum:(NSURL *)outputURL block:(void (^)(void))block {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                block();
            });
        }];
    }
}

+ (NSString *)GetLocalPath {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"%d.png", (int)interval];
    return [kDocumentPath stringByAppendingPathComponent:name];
}

+ (UIImage *)GetSnapshotOfVideo:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    player.shouldAutoplay = YES;
    player.controlStyle = MPMovieControlStyleNone;
    UIImage *image = [player thumbnailImageAtTime:0.5 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [player stop];
    
    NSString *localpath = [self GetLocalPath];
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    [data writeToFile:localpath atomically:YES];
    
    image = [UIImage imageWithContentsOfFile:localpath];
    
    return image;
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    NSLog(@"CVPixelBufferCreate:%d", status);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, (int)kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (UIImage *)ScaleImageToSize:(UIImage *)image :(CGSize)size {
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (CMTime)GetVideoDuration:(NSURL *)url {
    AVAsset *videoAsset = [AVAsset assetWithURL:url];
    if (videoAsset) {
        return videoAsset.duration;
    }
    return kCMTimeZero;
}

#pragma mark - Setup

- (void)GetAlbumThumb:(UIImageView *)imageView {
    ALAssetsLibrary *assetsLibrary = [self.class defaultAssetsLibrary];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            if (group.numberOfAssets > 0) {
                NSLog(@"group:%@", group);
                imageView.image = [UIImage imageWithCGImage:group.posterImage];
            }
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSLog(@"fail");
        
    };
    // Enumerate Camera roll first
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}

#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
