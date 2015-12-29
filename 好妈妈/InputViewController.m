//
//  InputViewController.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-1.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "InputViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AutoAlertView.h"
#import <QuartzCore/QuartzCore.h>

@interface InputViewController ()

@end

@implementation InputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mbGPSHidden = NO;
        mbPhotoEdit = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]]];

    mBotView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-259, self.view.frame.size.width, 259)];
    mBotView.backgroundColor = [UIColor colorWithWhite:0.16 alpha:1.0];
    [self.view addSubview:mBotView];
    [mBotView release];
    
    UIImageView *botBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mBotView.frame.size.width, 48)];
    botBar.image = [UIImage imageNamed:@"chatbarback.png"];
    botBar.userInteractionEnabled = YES;
    [mBotView addSubview:botBar];
    [botBar release];
    
    miType = TRecordInputType_Text;

    mFaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mFaceBtn.frame = CGRectMake(7, 7, 30, 30);
    [mFaceBtn setImage:[UIImage imageNamed:@"fabiao2.png"] forState:UIControlStateNormal];
    [mFaceBtn addTarget:self action:@selector(OnOtherClick) forControlEvents:UIControlEventTouchUpInside];
    [botBar addSubview:mFaceBtn];

    mTalkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mTalkBtn.frame = CGRectMake(40, 5, botBar.frame.size.width-120, 34);
    [mTalkBtn setBackgroundImage:[UIImage imageNamed:@"track-rectalk.png"] forState:UIControlStateNormal];
    [mTalkBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [mTalkBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    mTalkBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    mTalkBtn.hidden = YES;
    [mTalkBtn addTarget:self action:@selector(OnStartRecord:) forControlEvents:UIControlEventTouchDown];
    [mTalkBtn addTarget:self action:@selector(OnStopRecord:) forControlEvents:UIControlEventTouchUpInside];
    [mTalkBtn addTarget:self action:@selector(OnStopRecord2:) forControlEvents:UIControlEventTouchUpOutside];
    [botBar addSubview:mTalkBtn];
    
    mTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 5, botBar.frame.size.width-120, 34)];
    mTextField.delegate = self;
    mTextField.borderStyle = UITextBorderStyleRoundedRect;
    mTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mTextField.font = [UIFont systemFontOfSize:16];
    mTextField.returnKeyType = UIReturnKeyDone;
    [botBar addSubview:mTextField];
    [mTextField release];
    
    mPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mPhotoBtn.frame = CGRectMake(botBar.frame.size.width-77, 7, 30, 30);
    [mPhotoBtn setImage:[UIImage imageNamed:@"chatimageback.png"] forState:UIControlStateNormal];
    [mPhotoBtn addTarget:self action:@selector(OnPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [botBar addSubview:mPhotoBtn];

    mVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mVoiceBtn.frame = CGRectMake(botBar.frame.size.width-37, 7, 30, 30);
    [mVoiceBtn setImage:[UIImage imageNamed:@"chataudiobtn.png"] forState:UIControlStateNormal];
    [mVoiceBtn addTarget:self action:@selector(OnVoiceClick) forControlEvents:UIControlEventTouchUpInside];
    [botBar addSubview:mVoiceBtn];

    mFaceView = [[EmoKeyboardView alloc] initWithFrame:CGRectMake(0, 44, mBotView.frame.size.width, mBotView.frame.size.height-44)button:NO];
    mFaceView.backgroundColor = LIGHTBACK_COLOR;
    mFaceView.delegate = self;
    mFaceView.OnEmoSelect = @selector(OnEmoSelect:);
    mFaceView.OnSendClick = @selector(OnSendClick);
    mFaceView.hidden = YES;
    [mBotView addSubview:mFaceView];
    [mFaceView release];

    mCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    mCoverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    mCoverView.layer.cornerRadius = 10;
    mCoverView.layer.masksToBounds = YES;
    mCoverView.hidden = YES;
    mCoverView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:mCoverView];
    [mCoverView release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.image = [UIImage imageNamed:@"audiobtn.png"];
    imageView.center = CGPointMake(mCoverView.frame.size.width/2, mCoverView.frame.size.height/2-10);
    [mCoverView addSubview:imageView];
    [imageView release];
    
    UILabel *lbMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, mCoverView.frame.size.height-30, mCoverView.frame.size.width, 20)];
    lbMsg.backgroundColor = [UIColor clearColor];
    lbMsg.textAlignment = UITextAlignmentCenter;
    lbMsg.textColor = [UIColor whiteColor];
    lbMsg.font = [UIFont boldSystemFontOfSize:10];
    lbMsg.text = @"手指上滑，取消发送";
    [mCoverView addSubview:lbMsg];
    [lbMsg release];
    
    mAudioRecorder = [[AudioRecordManager alloc] init];
    mAudioRecorder.delegate = self;
    mAudioRecorder.OnRecordFinish = @selector(OnRecordFinish:);
    [self RefreshButton];
}

- (void)OnEmoSelect:(NSString *)text {
    if (!mTextField.text) {
        mTextField.text = @"";
    }
    mTextField.text = [mTextField.text stringByAppendingString:text];
}

- (void)OnRecordFinish:(AudioRecordManager *)sender {
    if (!mbSaveAudio) {
        return;
    }
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:sender.mLocalPath] error:nil];
    int iAudioLength = player.duration;
    [player release];
    if (iAudioLength < 1) {
        [AutoAlertView ShowAlert:@"提示" message:@"录音时长太短，多说两句"];
        return;
    }

    if ([self respondsToSelector:@selector(OnInputAudioFinish:)]) {
        [self performSelector:@selector(OnInputAudioFinish:) withObject:sender.mLocalPath];
    }
}

- (void)OnStartRecord:(UIButton *)sender {
    mbSaveAudio = NO;
    mCoverView.hidden = NO;
    [self.view bringSubviewToFront:mCoverView];
    [sender setTitle:@"松开停止" forState:UIControlStateNormal];
    [mAudioRecorder StartRecordAudio];
}

- (void)OnStopRecord:(UIButton *)sender {
    mbSaveAudio = YES;
    mCoverView.hidden = YES;
    [sender setTitle:@"按住说话" forState:UIControlStateNormal];
    [mAudioRecorder StopRecordAudio];
}

- (void)OnStopRecord2:(UIButton *)sender {
    mbSaveAudio = NO;
    mCoverView.hidden = YES;
    [sender setTitle:@"按住说话" forState:UIControlStateNormal];
    [mAudioRecorder StopRecordAudio];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self respondsToSelector:@selector(OnInputTextFinish:)]) {
        [self performSelector:@selector(OnInputTextFinish:) withObject:mTextField.text];
    }
    return YES;
}

- (void)OnSendClick {
    if ([self respondsToSelector:@selector(OnInputTextFinish:)]) {
        [self performSelector:@selector(OnInputTextFinish:) withObject:mTextField.text];
    }
}

- (void)OnPhotoClick {
    miType = TRecordInputType_Image;
    [self TakePhoto:NO];
}

- (void)OnVoiceClick {
    if (miType != TRecordInputType_Voice) {
        miType = TRecordInputType_Voice;
    }
    else {
        miType = TRecordInputType_Text;
    }
    [self RefreshButton];
}

- (void)OnOtherClick {
    if (miType == TRecordInputType_Text) {
        miType = TRecordInputType_Emo;
    }
    else {
        miType = TRecordInputType_Text;
    }
    [self RefreshButton];
}

- (void)RefreshButton {
   
    if (miType == TRecordInputType_Voice) {
        [mFaceBtn setImage:[UIImage imageNamed:@"chattextback.png"] forState:UIControlStateNormal];
        mTextField.hidden = YES;
        mTalkBtn.hidden = NO;
        [mTextField resignFirstResponder];
        mBotView.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 259);
        mFaceView.hidden = YES;
        [self RefreshBotBarStatus];
    }
    else if (miType == TRecordInputType_Text) {
        [mFaceBtn setImage:[UIImage imageNamed:@"chatfaceback.png"] forState:UIControlStateNormal];
        mTextField.hidden = NO;
        mTalkBtn.hidden = YES;
        [mTextField becomeFirstResponder];
        mFaceView.hidden = YES;
    }
    else if (miType == TRecordInputType_Emo) {
        [mFaceBtn setImage:[UIImage imageNamed:@"chattextback.png"] forState:UIControlStateNormal];
        mTextField.hidden = NO;
        mTalkBtn.hidden = YES;
        [mTextField resignFirstResponder];
        mBotView.frame = CGRectMake(0, self.view.frame.size.height-259, self.view.frame.size.width, 259);
        mFaceView.hidden = NO;
        [self RefreshBotBarStatus];
    }
}

- (void)HideBotBar {
    mBotView.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 259);
    [self RefreshBotBarStatus];
    mTextField.text = nil;
    [mTextField resignFirstResponder];
}

- (void)KeyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    int iHeight = keyboardSize.height;
    if (iHeight>35) {
        iHeight -= 35;
    }
    NSLog(@"keyboardWasShown%d", iHeight);
    mBotView.frame = CGRectMake(0, self.view.frame.size.height-iHeight-78, self.view.frame.size.width, 259);
    [self RefreshBotBarStatus];
}

- (void)KeyboardWillHidden:(NSNotification *) notif{
   
    if (miType == TRecordInputType_Voice) {
        mBotView.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 259);
        [self RefreshBotBarStatus];
    }
}

- (BOOL)TakePhoto:(BOOL)bCamera {
    if (!bCamera && [UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
        [AutoAlertView ShowAlert:@"提示" message:@"找不到相册"];
        return NO;
    }
    if (bCamera && [UIImagePickerController isSourceTypeAvailable:
                    UIImagePickerControllerSourceTypeCamera] == NO) {
        [AutoAlertView ShowAlert:@"提示" message:@"找不到摄像头"];
        return NO;
    }
    [self CancelPhoto];
    mPhotoManager = [[PhotoSelectManager alloc] init];
    mPhotoManager.mRootCtrl = self;
    mPhotoManager.delegate = self;
    mPhotoManager.mbEdit = NO;
    mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
    [mPhotoManager TakePhoto:bCamera];
    return YES;
}

- (NSString *)GetPhotoPath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:@"testphoto.jpg"];
}

- (void)CancelPhoto {
    if (mPhotoManager) {
        mPhotoManager.mRootCtrl = nil;
        mPhotoManager.delegate = nil;
        mPhotoManager.mDefaultName = nil;
        [mPhotoManager release];
        mPhotoManager = nil;
    }
}

- (void)OnPhotoSelect:(PhotoSelectManager *)sender {
    NSString *imagename = sender.mLocalPath;
    [[NSFileManager defaultManager] moveItemAtPath:imagename toPath:[self GetPhotoPath] error:nil];
    if ([self respondsToSelector:@selector(OnInputImageFinish:)]) {
        [self performSelector:@selector(OnInputImageFinish:) withObject:imagename];
    }
    [self CancelPhoto];
}


- (void)dealloc {
    if (mAudioRecorder) {
        [mAudioRecorder CancelPlayAudio];
        [mAudioRecorder CancelRecordAudio];
        [mAudioRecorder release];
        mAudioRecorder = nil;
    }
    [self CancelPhoto];
//    [self CancelLocation];
    [super dealloc];
}

- (void)RefreshBotBarStatus {
    if ([self respondsToSelector:@selector(OnBottomBarChange:)]) {
        [self performSelector:@selector(OnBottomBarChange:) withObject:mBotView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
