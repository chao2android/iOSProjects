//
//  InputViewController.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-1.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecordManager.h"
#import "EmoKeyboardView.h"
#import "PhotoSelectManager.h"

@protocol InputViewControllerDelegate <NSObject>

- (void)OnInputTextFinish:(NSString *)text;
- (void)OnInputImageFinish:(NSString *)imagepath;
- (void)OnInputAudioFinish:(NSString *)audiopath;
- (void)OnInputLocationFinish:(NSDictionary *)dict;

@optional
- (void)OnBottomBarChange:(UIView *)botview;

@end

typedef enum {
    TRecordInputType_Text,
    TRecordInputType_Voice,
    TRecordInputType_Image,
    TRecordInputType_Emo,
} TRecordInputType;

@interface InputViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate> {
    UITextField *mTextField;
    TRecordInputType miType;
    AudioRecordManager *mAudioRecorder;
    PhotoSelectManager *mPhotoManager;
    UIView *mBotView;
    UIButton *mFaceBtn;
    UIButton *mVoiceBtn;
    UIButton *mPhotoBtn;
    UIButton *mTalkBtn;
    EmoKeyboardView *mFaceView;
    UIView *mCoverView;
    BOOL mbPhotoEdit;
    BOOL mbSaveAudio;
    BOOL mbGPSHidden;
    float mLatitude;
    float mLongitude;
}

- (void)HideBotBar;

@end
