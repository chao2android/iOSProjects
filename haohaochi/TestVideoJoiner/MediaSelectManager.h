//
//  MediaSelectManager.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

@class MediaSelectManager;

@protocol MediaSelectManagerDelegate <NSObject>

@optional

- (void)MediaSelectManager:(MediaSelectManager *)manager DidSelectVideo:(NSURL *)url;
- (void)MediaSelectManager:(MediaSelectManager *)manager DidSelectAudio:(NSURL *)url;

@end

@interface MediaSelectManager : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPMediaPickerControllerDelegate> {
    
}

@property (nonatomic, assign) BOOL mbLightOff;
@property (nonatomic, strong) UIImagePickerController *mPicker;
@property (nonatomic, strong) NSString *mWatermark;
@property (nonatomic, strong) UIFont *mWatermarkFont;
@property (nonatomic, assign) UIViewController *mRootCtrl;
@property (nonatomic, assign) id<MediaSelectManagerDelegate> delegate;
@property (nonatomic, assign) CGSize mVideoSize;

- (BOOL)TakeVideo:(BOOL)bCamera controlView:(UIView *)controlView animated:(BOOL)animate;
- (BOOL)TakeVideo:(BOOL)bCamera controlView:(UIView *)controlView;
- (BOOL)TakeAudio;
- (void)JoinMedia:(NSArray *)urlarray :(NSURL *)audioURL;
- (void)MixSound:(NSArray *)urlarray :(NSURL *)audioURL;
- (void)CancelVideo;
- (void)ExchangeCamera;
- (void)ChangeCameraDevice:(BOOL)bFront;
- (void)SaveToAlbum:(NSURL *)outputURL block:(void (^)(void))block;
- (void)GetAlbumThumb:(UIImageView *)imageView;
+ (CMTime)GetVideoDuration:(NSURL *)url;

+ (UIImage *)GetSnapshotOfVideo:(NSString *)path;
- (void)ImageToMovie:(UIImage *)image path:(NSString *)path duration:(float)duration size:(CGSize)size;

#define kMsg_JoinMediaFinish  @"kMsg_JoinMediaFinish"
#define kMsg_MixSoundFinish  @"kMsg_MixSoundFinish"
#define kMsg_ImgToMovFinish  @"kMsg_ImgToMovFinish"


@end
