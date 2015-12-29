//
//  AudioPlayButton.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-13.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownManager.h"

@interface AudioPlayButton : UIView {
    UIImageView *mImageView;
    ImageDownManager *mDownManager;
    NSTimer *mTimer;
    int miIndex;
    BOOL mbWhite;
    UIButton *mBackBtn;
    UILabel *mlbLength;
    UIActivityIndicatorView *mActView;
}

@property (nonatomic, assign) BOOL mbWhite;
@property (nonatomic, retain) NSString *mAudioPath;
@property (nonatomic, retain) NSString *mLocalPath;
@property (nonatomic, retain) NSString *userInfo;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnAudioStart;

- (void)GetAudioStr:(NSString *)path;
- (void)StopAnimate;
- (void)Cancel;

@end
