//
//  VideoRecordView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoRecordView.h"
#import "VideoListManager.h"
#import "UIDevice+Orientation.h"
#import "AnimateButton.h"

@implementation VideoRecordView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnOrientationError) name:kMsg_OrientationError object:nil];
        
        mbFirstAnimate = YES;
        mbReturnTimeline = NO;
        mbVideoCapture = NO;
        mbFailRecord = NO;
        mbDelMode = NO;
        self.mbAppend = NO;
        self.miIndex = 0;
        mfRecordTime = 0;
        self.mRecordArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        mlbTitle = [[RecordMsgLabel alloc] initWithFrame:CGRectMake(40, 0, self.frame.size.width-140, 40)];
        //mlbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:mlbTitle];
        
        mFocusView = [[TouchFocusView alloc] initWithFrame:CGRectMake(40, 0, self.frame.size.width-140, self.frame.size.height)];
        mFocusView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:mFocusView];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, self.frame.size.height)];
        leftView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        leftView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [self addSubview:leftView];
        [self sendSubviewToBack:leftView];
        
        mBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mBackBtn.frame = CGRectMake(0, 0, 40, 40);
        [mBackBtn setImage:[UIImage imageNamed:@"p_backbtn"] forState:UIControlStateNormal];
        [mBackBtn addTarget:self action:@selector(OnCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:mBackBtn];
        
        mLightBtn = [[SwitchImageView alloc] initWithFrame:CGRectMake(0, (leftView.frame.size.height-40)/2, 40, 40)];
        mLightBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        mLightBtn.delegate = self;
        mLightBtn.OnLightChange = @selector(OnLightClick);
        mLightBtn.mbLightOn = NO;
        [leftView addSubview:mLightBtn];
        
        mExchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mExchangeBtn.frame = CGRectMake(0, leftView.frame.size.height-40, 40, 40);
        mExchangeBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [mExchangeBtn setImage:[UIImage imageNamed:@"p_exchangebtn"] forState:UIControlStateNormal];
        [mExchangeBtn addTarget:self action:@selector(OnExchangeClick) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:mExchangeBtn];

        self.mRecordMode = TVideoRecordMode_None;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-100, 0, 100, self.frame.size.height)];
        backView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        backView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [self addSubview:backView];
        [self sendSubviewToBack:backView];
        
        mlbTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, backView.frame.size.width-10, 40)];
        mlbTime.backgroundColor = [UIColor clearColor];
        mlbTime.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        mlbTime.text = @"0:00";
        mlbTime.textAlignment = NSTextAlignmentCenter;
        mlbTime.textColor = [UIColor whiteColor];
        [backView addSubview:mlbTime];
        
        mAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mAlbumBtn.frame = CGRectMake((backView.frame.size.width-40-10)/2+10, backView.frame.size.height-80, 40, 40);
        mAlbumBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin||UIViewAutoresizingFlexibleLeftMargin;
        [mAlbumBtn setImage:[UIImage imageNamed:@"f_albumbtn"] forState:UIControlStateNormal];
        [mAlbumBtn addTarget:self action:@selector(OnAlbumClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:mAlbumBtn];
        
        mAlbumView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -5, 50, 50)];
        mAlbumView.backgroundColor = [UIColor blackColor];
        [mAlbumBtn addSubview:mAlbumView];
        
        mNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mNextBtn.frame = mAlbumBtn.frame;
        mNextBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [mNextBtn setImage:[UIImage imageNamed:@"p_nextbtn2"] forState:UIControlStateNormal];
        [mNextBtn addTarget:self action:@selector(OnNextClick) forControlEvents:UIControlEventTouchUpInside];
        mNextBtn.hidden = YES;
        [backView addSubview:mNextBtn];
        
        mDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mDeleteBtn.frame = CGRectMake((backView.frame.size.width-40-10)/2+10, 40, 40, 40);
        mDeleteBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [mDeleteBtn setBackgroundImage:[UIImage imageNamed:@"p_delbtn01"] forState:UIControlStateNormal];
        [mDeleteBtn addTarget:self action:@selector(OnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
        mDeleteBtn.hidden = YES;
        mDeleteBtn.delegate = self;
        mDeleteBtn.OnImageFinish = @selector(OnImageFinish:);
        [backView addSubview:mDeleteBtn];
        
        mRecordView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-80, (self.frame.size.height-70)/2, 70, 70)];
        mRecordView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:mRecordView];
        
        UIImageView *circleView = [[UIImageView alloc] initWithFrame:CGRectMake((mRecordView.frame.size.width-70)/2, (mRecordView.frame.size.height-70)/2, 70, 70)];
        circleView.image = [UIImage imageNamed:@"p_circle"];
        [mRecordView addSubview:circleView];
        
        mRecordbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mRecordbtn.frame = CGRectMake((mRecordView.frame.size.width-53)/2, (mRecordView.frame.size.height-53)/2, 53, 53);
        [mRecordbtn setBackgroundImage:[UIImage imageNamed:@"p_bluebtn"] forState:UIControlStateNormal];
        [mRecordbtn addTarget:self action:@selector(OnStartRecordClick) forControlEvents:UIControlEventTouchDown];
        [mRecordbtn addTarget:self action:@selector(OnStopRecordClick) forControlEvents:UIControlEventTouchUpInside];
        [mRecordbtn addTarget:self action:@selector(OnStopRecordClick) forControlEvents:UIControlEventTouchUpOutside];
        mRecordbtn.adjustsImageWhenHighlighted = NO;
        [mRecordView addSubview:mRecordbtn];
        
        mAlertView = [[PopAlertView alloc] initWithFrame:CGRectMake((mRecordView.frame.size.width-80)/2, -75, 80, 75)];
        [mRecordView addSubview:mAlertView];
        
        [mAlertView ShowAlert:@"长按录制"];
        
        mCircularTimer = [[LineTimer alloc] initWithFrame:CGRectMake(1, 0, 10, backView.frame.size.height)];
        mCircularTimer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        mCircularTimer.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        mCircularTimer.delegate = self;
        mCircularTimer.activeColor = kDefault_Color2;
        mCircularTimer.defaultColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        mCircularTimer.mlbTime = mlbTime;
        //mCircularTimer.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        [backView addSubview:mCircularTimer];

        mNextBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        mNextBtn2.frame = mRecordView.frame;
        mNextBtn2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [mNextBtn2 setBackgroundImage:[UIImage imageNamed:@"p_nextbtn"] forState:UIControlStateNormal];
        [mNextBtn2 addTarget:self action:@selector(OnNextClick) forControlEvents:UIControlEventTouchUpInside];
        mNextBtn2.hidden = YES;
        mNextBtn2.delegate = self;
        mNextBtn2.OnScaleFinish = @selector(OnScaleFinish:);
        mNextBtn2.OnImageFinish = @selector(OnImageFinish:);
        [self addSubview:mNextBtn2];
        
        [self RefreshTimeRange];
        [self ShowTitle];
        
        self.userInteractionEnabled = NO;
        
        [self performSelector:@selector(DelayEnableView) withObject:nil afterDelay:1.5];
    }
    return self;
}

- (void)OnOrientationError {
    if (!mErrorView) {
        float fWidth = MAX(KscreenHeigh, KscreenWidth);
        float fHeight = MIN(KscreenWidth, KscreenHeigh);
        UIImage *image = [UIImage imageNamed:@"p_rotatealert"];
        
        mErrorView = [[UIImageView alloc] initWithFrame:CGRectMake((fWidth-image.size.width)/2, (fHeight-image.size.height)/2, image.size.width, image.size.height)];
        mErrorView.image = image;
        [self addSubview:mErrorView];
        
        [UIView animateWithDuration:1.0 animations:^{
            mErrorView.alpha = 0.0;
        } completion:^(BOOL bFinish) {
            @autoreleasepool {
                if (mErrorView) {
                    [mErrorView removeFromSuperview];
                    mErrorView = nil;
                }
            }
        }];
    }
}

- (void)DelayEnableView {
    self.userInteractionEnabled = YES;
    [_mMediaManager GetAlbumThumb:mAlbumView];
    mFocusView.mPicker = _mMediaManager.mPicker;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.mRecordArray = nil;
}

- (void)ShowTitle {
    
    float fWidth = [UIScreen mainScreen].bounds.size.width;
    float fHeight = [UIScreen mainScreen].bounds.size.height;
    float fNewWidth = MAX(fWidth, fHeight);

    mlbTitle.text = [self GetRecordTitle];
    mlbTitle.transform = CGAffineTransformMakeScale(1.0, 1.0);
    if (mbFirstAnimate) {
        mbFirstAnimate = NO;
        
        mlbTitle.center = CGPointMake((fNewWidth-140)/2+40, -20);
        
        [self performSelector:@selector(DelayAnimateLabel) withObject:nil afterDelay:0.3];
    }
}

- (void)DelayAnimateLabel {
    CGPoint center = mlbTitle.center;
    [UIView animateWithDuration:0.5 animations:^{
        mlbTitle.center = CGPointMake(center.x, center.y+40);
    }];
}

- (void)OnCancelClick {
    NSDictionary *userinfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.miIndex] forKey:@"index"];

    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RefreshTimeline object:nil userInfo:userinfo];
    NSLog(@"OnCancelClick:%@", userinfo);
    [_mMediaManager CancelVideo];
}

- (void)OnLightClick {
    _mMediaManager.mbLightOff = !mLightBtn.mbLightOn;
}

- (void)OnExchangeClick {
    NSLog(@"OnCameraClick");
    
    [mExchangeBtn.layer removeAllAnimations];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.4;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    
    [mExchangeBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [_mMediaManager ExchangeCamera];
}

- (void)OnAlbumClick {
    NSLog(@"OnAlbumClick");
    
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    if (self.miIndex == 1 || self.miIndex == 3) {
        picker.maximumNumberOfSelection = 5-self.mRecordArray.count;
    }
    else {
        picker.maximumNumberOfSelection = 1;
    }
    picker.assetsFilter = [ALAssetsFilter allVideos];
    if (self.miIndex == 0 || self.miIndex == 2 || self.miIndex == 4) {
        picker.selectionFilter = [NSPredicate predicateWithFormat:@"duration>=%f and landscape != 0", mCircularTimer.miMinTime];
    }
    else if (self.miIndex == 1 || self.miIndex == 3) {
        picker.selectionFilter = [NSPredicate predicateWithFormat:@"duration>=%f and landscape != 0", mCircularTimer.miSepTime];
    }
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    
    [self.mRootCtrl presentViewController:picker animated:YES completion:NULL];

    //[_mMediaManager CancelVideo];
}

- (void)OnNextClick {
    [[VideoListManager Share] AddVideoToList:self.mRecordArray index:self.miIndex];
    
    if (self.miIndex == 1 || self.miIndex == 3) {
        NSDictionary *userinfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.miIndex] forKey:@"index"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ShowSubTimeline object:nil userInfo:userinfo];
    }
    self.miIndex ++;
    [self OnCancelClick];
}

- (void)reloadData:(NSArray *)array index:(int)index {
    if (array && array.count > 0) {
        mbReturnTimeline = YES;
    }
    self.miIndex = index;
    [self.mRecordArray addObjectsFromArray:array];
    float fRecordTime = 0;
    for (NSDictionary *dict in self.mRecordArray) {
        float fTime = [[dict objectForKey:@"time"] floatValue];
        fRecordTime += fTime;
    }
    mfRecordTime = fRecordTime;
    [self RefreshRecordTime];
    [self ShowTitle];
}

- (void)RefreshRecordTime {
    [self RefreshTimeRange];
    [mCircularTimer RefreshLines:self.mRecordArray];
    //mCircularTimer.mfRunTime = mfRecordTime;
    [self RefreshRecordMode];
}

- (void)RefreshRecordMode {
    if (self.mRecordArray.count == 0) {
        self.mRecordMode = TVideoRecordMode_None;
    }
    else if (mfRecordTime >= mCircularTimer.miTotalTime) {
        self.mRecordMode = TVideoRecordMode_Finish;
    }
    else {
        self.mRecordMode = TVideoRecordMode_Record;
    }
}

- (void)RefreshTimeRange {
    if (self.miIndex == 0) {
        mCircularTimer.miTotalTime = 9;
        mCircularTimer.miMinTime = 6;
        mCircularTimer.miSepTime = 0;
    }
    else if (self.miIndex == 1) {
        mCircularTimer.miTotalTime = 15;
        mCircularTimer.miMinTime = 3;
        mCircularTimer.miSepTime = 3;
    }
    else if (self.miIndex == 2) {
        mCircularTimer.miTotalTime = 15;
        mCircularTimer.miMinTime = 9;
        mCircularTimer.miSepTime = 0;
    }
    else if (self.miIndex == 3) {
        mCircularTimer.miTotalTime = 15;
        mCircularTimer.miMinTime = 3;
        mCircularTimer.miSepTime = 3;
    }
    else if (self.miIndex == 4) {
        mCircularTimer.miTotalTime = 9;
        mCircularTimer.miMinTime = 6;
        mCircularTimer.miSepTime = 0;
    }
    [mCircularTimer RefreshBackView];
}

- (void)OnDeleteClick {
    [mDeleteBtn StopShakeAnimate];
    if (self.mRecordMode == TVideoRecordMode_Record || self.mRecordMode == TVideoRecordMode_Finish) {
        self.mRecordMode = TVideoRecordMode_Del;
        mCircularTimer.mbEnableDel = YES;
    }
    else {
        NSDictionary *dict = [self.mRecordArray lastObject];
        float fTime = [[dict objectForKey:@"time"] floatValue];
        mfRecordTime -= fTime;
        [self.mRecordArray removeLastObject];
        [self RefreshRecordTime];
    }
}

- (void)setMRecordMode:(TVideoRecordMode)value {
    _mRecordMode = value;
    mRecordView.hidden = NO;
    mNextBtn2.hidden = YES;
    if (value == TVideoRecordMode_None) {
        mAlbumBtn.hidden = NO;
        mDeleteBtn.hidden = YES;
        mNextBtn.hidden = YES;
    }
    else if (value == TVideoRecordMode_Finish) {
        mRecordView.hidden = YES;
        mAlbumBtn.hidden = YES;
        mDeleteBtn.hidden = NO;
        mNextBtn.hidden = YES;
        
        BOOL bNextHidden = mNextBtn2.hidden;
        mNextBtn2.hidden = NO;
        if (bNextHidden) {
            [mNextBtn2 setBackgroundImage:[UIImage imageNamed:@"p_bluebtn"] forState:UIControlStateNormal];
            [mNextBtn2 StartScaleAnimate];
        }
        
        if (self.miIndex == 4) {
            mlbTitle.text = @"大功告成，去看看效果！";
        }
        else {
            mlbTitle.text = @"完美，去拍下一章吧！";
        }
    }
    else {
        mAlbumBtn.hidden = YES;
        mDeleteBtn.hidden = NO;
        if (mCircularTimer.mfRunTime<mCircularTimer.miMinTime) {
            mNextBtn.hidden = YES;
        }
        else {
            BOOL bHidden = mNextBtn.hidden;
            NSLog(@"setMRecordMode:%d", bHidden);
            if (bHidden) {
                mNextBtn.hidden = NO;
                mNextBtn.transform = CGAffineTransformMakeScale(0.1, 0.1);
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    mNextBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:nil];
                
                if (self.miIndex == 4) {
                    mlbTitle.text = @"大功告成，去看看效果！";
                }
                else if (self.miIndex != 1 && self.miIndex != 3) {
                    mlbTitle.text = @"完美，去拍下一章吧！";
                }
            }
        }
        
        if (self.miIndex == 1 || self.miIndex == 3) {
            if (self.mbAppend) {
                mAlbumBtn.hidden = NO;
                mNextBtn.hidden = YES;
            }
        }
        BOOL bDelMode = (value == TVideoRecordMode_Del);

        if (mbDelMode != bDelMode) {
            NSMutableArray *images = [NSMutableArray arrayWithCapacity:10];
            if (bDelMode) {
                for (int i = 1; i <= 4; i ++) {
                    NSString *imagename = [NSString stringWithFormat:@"p_delbtn%02d", i];
                    [images addObject:[UIImage imageNamed:imagename]];
                }
                [mDeleteBtn setBackgroundImage:[UIImage imageNamed:@"p_delbtn05"] forState:UIControlStateNormal];
            }
            else {
                for (int i = 4; i >= 1; i --) {
                    NSString *imagename = [NSString stringWithFormat:@"p_delbtn%02d", i];
                    [images addObject:[UIImage imageNamed:imagename]];
                }
                [mDeleteBtn setBackgroundImage:[UIImage imageNamed:@"p_delbtn01"] forState:UIControlStateNormal];
            }
            [mDeleteBtn AddAnimates:images :0.1];
            [mDeleteBtn StartImageAnimate];
        }
        mbDelMode = bDelMode;
    }
}

- (void)OnScaleFinish:(UIButton *)sender {
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 6; i ++) {
        NSString *imagename = [NSString stringWithFormat:@"p_hook%02d", i+1];
        [images addObject:[UIImage imageNamed:imagename]];
    }
    [mNextBtn2 setBackgroundImage:[UIImage imageNamed:@"p_hook07"] forState:UIControlStateNormal];
    [mNextBtn2 AddAnimates:images :0.2];
    [mNextBtn2 StartImageAnimate];
}

- (void)OnImageFinish:(UIButton *)sender {
    if (sender == mDeleteBtn) {
        if (self.mRecordMode == TVideoRecordMode_Del) {
            [mDeleteBtn StartShakeAnimate];
        }
    }
}

- (void)AnimateDisplayButton:(BOOL)bShow {
    [UIView animateWithDuration:0.4 animations:^{
        if (!bShow) {
            mBackBtn.alpha = 1.0;
            mLightBtn.alpha = 1.0;
            mExchangeBtn.alpha = 1.0;
            mAlbumBtn.alpha = 1.0;
            mDeleteBtn.alpha = 1.0;
            //mNextBtn.alpha = 1.0;
        }
        else {
            mBackBtn.alpha = 0.0;
            mLightBtn.alpha = 0.0;
            mExchangeBtn.alpha = 0.0;
            mAlbumBtn.alpha = 0.0;
            mDeleteBtn.alpha = 0.0;
            //mNextBtn.alpha = 0.0;
        }
    }];
}

- (void)OnStartRecordClick {
    if (mAlertView) {
        [mAlertView removeFromSuperview];
        mAlertView = nil;
    }
    if ([[MDeviceOrientation Share] isPortrait]) {
        [self showMsg:@"请横屏拍摄"];
        return;
    }
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        mRecordbtn.transform = CGAffineTransformMakeScale(0.86, 0.86);
    } completion:nil];
    TVideoRecordMode lastMode = self.mRecordMode;
    self.mRecordMode = TVideoRecordMode_Record;
    
    mbVideoCapture = YES;
    NSLog(@"startVideoCapture");
    [mCircularTimer StartTimer:mfRecordTime];
    [_mMediaManager.mPicker startVideoCapture];
    [mDeleteBtn StopShakeAnimate];
    if (lastMode == TVideoRecordMode_None) {
        mDeleteBtn.alpha = 0.0;
    }
    [self AnimateDisplayButton:YES];
}

- (void)OnStopRecordClick {
    if (mbFailRecord) {
        mbFailRecord = NO;
        return;
    }
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        mRecordbtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    
    if (mbVideoCapture) {
        NSLog(@"stopVideoCapture");
        mbVideoCapture = NO;
        [mCircularTimer StopTimer];
        [_mMediaManager.mPicker stopVideoCapture];
        [self AnimateDisplayButton:NO];
        
        self.userInteractionEnabled = NO;
        
        if (self.miIndex != 1 && self.miIndex != 3) {
            if (self.mRecordMode != TVideoRecordMode_Finish && mCircularTimer.mfRunTime<mCircularTimer.miMinTime) {
                mlbTitle.text = [NSString stringWithFormat:@"这里至少需要%d秒钟哦！", (int)mCircularTimer.miMinTime];
            }
        }
    }
}

- (void)LineTimerOverMinTime:(LineTimer *)sender {
    self.mRecordMode = TVideoRecordMode_Record;
}

- (void)LineTimerOverSepTime:(LineTimer *)sender {
    [self OnStopRecordClick];
}

- (void)LineTimerDidFinish:(LineTimer *)sender {
    self.mRecordMode = TVideoRecordMode_Finish;
    [self OnStopRecordClick];
}

- (void)MediaSelectManager:(MediaSelectManager *)manager DidSelectVideo:(NSURL *)url {
    
    self.userInteractionEnabled = YES;
    float fTime = mCircularTimer.mfRunTime;
    NSLog(@"miRunTime:%f", fTime);
    if (self.miIndex == 1 || self.miIndex == 3) {
        if (self.mRecordMode != TVideoRecordMode_Finish && fTime-mfRecordTime<mCircularTimer.miSepTime) {
            mlbTitle.text = [NSString stringWithFormat:@"每段需要%d秒钟哦！", (int)mCircularTimer.miSepTime];
            mCircularTimer.mfRunTime = mfRecordTime;
            [self RefreshRecordMode];
            return;
        }
    }
    
    float fRecordTime = fTime-mfRecordTime;
    mfRecordTime = fTime;
    
    [self AddToRecordList:url :fRecordTime :nil];
    
    if (self.mRecordMode != TVideoRecordMode_Finish) {
        [self RefreshRecordMode];
    }
    if (self.mbAppend) {
        [self OnNextClick];
    }
}

- (NSString *)GetRecordTitle {
    NSArray *array = @[@"来，看着镜头大声告诉我们，你要去哪吃？", @"餐厅的环境怎么样呢？多拍几段吧！", @"看你吃东西的样子……我也好饿……", @"五段美食特写，快快快！", @"终于等到你，做个大总结吧！"];
    if (self.miIndex < array.count) {
        return [array objectAtIndex:self.miIndex];
    }
    return nil;
}

- (void)showMsg:(NSString *)msg
{
    mLoadView = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:mLoadView];
    
    mLoadView.mode = MBProgressHUDModeCustomView;
    mLoadView.labelText = msg;
    [mLoadView show:YES];
    [mLoadView hide:YES afterDelay:1];
    mLoadView = nil;
}

#pragma mark - ZYQAssetPickerController Delegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.mbAppend) {
            [self performSelectorOnMainThread:@selector(DisableButtons:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:YES];
        }
        else {
            
        }
        for (ALAsset *asset in assets) {
            
            [self performSelectorOnMainThread:@selector(RefreshAlbumTime:) withObject:asset waitUntilDone:YES];
        }
        if (self.miIndex == 1 || self.miIndex == 3) {
            [self performSelectorOnMainThread:@selector(OnNextClick) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(DisableButtons:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
        }
    });
}

- (void)DisableButtons:(NSNumber *)value {
    self.userInteractionEnabled = [value boolValue];
}

- (void)RefreshAlbumTime:(ALAsset *)asset {
    if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
        NSURL *url = [asset defaultRepresentation].url;
        NSNumber *duration = [asset valueForProperty:ALAssetPropertyDuration];
        NSLog(@"assetPickerController:%@", url);
        float fRecordTime = [duration floatValue];
        if (fRecordTime>mCircularTimer.miTotalTime) {
            fRecordTime = mCircularTimer.miTotalTime;
        }
        
        if (self.miIndex == 1 || self.miIndex == 3) {
            if (self.mRecordMode != TVideoRecordMode_Finish && fRecordTime<mCircularTimer.miSepTime) {
                mlbTitle.text = [NSString stringWithFormat:@"每段需要%d秒钟哦！", (int)mCircularTimer.miSepTime];
                return;
            }
            else {
                fRecordTime = mCircularTimer.miSepTime;
            }
        }
        else {
            if (self.mRecordMode != TVideoRecordMode_Finish && fRecordTime<mCircularTimer.miMinTime) {
                mlbTitle.text = [NSString stringWithFormat:@"这里至少需要%d秒钟哦！", (int)mCircularTimer.miMinTime];
                return;
            }
        }
        mfRecordTime += fRecordTime;
        
        NSString *exportname = [NSString stringWithFormat:@"albumvideo-%d.mov",arc4random() % 1000];
        NSString *exportPath = [kDocumentPath stringByAppendingPathComponent:exportname];
        NSURL *newurl = [NSURL fileURLWithPath:exportPath];
        
        NSError *error = nil;
        [self createFileAtPath:exportPath asset:asset];
        
        NSLog(@"error:%@", error);
        
        [self AddToRecordList:newurl :fRecordTime :duration];
        [self RefreshRecordTime];
    }
}

- (void)AddToRecordList:(NSURL *)url :(float)fRecordTime :(NSNumber *)fullTime {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:url forKey:@"url"];
    [dict setObject:[NSNumber numberWithFloat:fRecordTime] forKey:@"time"];
    [dict setObject:[NSNumber numberWithFloat:mCircularTimer.miMinTime] forKey:@"mintime"];
    [dict setObject:[NSNumber numberWithFloat:mCircularTimer.miSepTime] forKey:@"septime"];
    [dict setObject:[NSNumber numberWithFloat:mCircularTimer.miTotalTime] forKey:@"maxtime"];
    if (fullTime) {
        float fTime = [fullTime floatValue];
        if (self.miIndex == 1 || self.miIndex == 3) {
            float fStartTime = (fTime-mCircularTimer.miSepTime)/2;
            [dict setObject:[NSNumber numberWithFloat:fStartTime] forKey:@"starttime"];
        }
    }
    [self.mRecordArray addObject:dict];
    if (self.miIndex == 1 || self.miIndex == 3) {
        if (self.mRecordArray.count == 2) {
            mlbTitle.text = (self.miIndex == 1)?@"重新拍摄可以点击2次右侧删除按钮":@"你也可以从相册选择已经录好的片段";
        }
        else if (self.mRecordArray.count == 4) {
            mlbTitle.text = @"最后一段了，加油！";
        }
    }
}

- (BOOL)createFileAtPath:(NSString *)path asset:(ALAsset *)result {
    if (!result) {
        NSLog(@"Nil can not create a file.");
        return NO;
    }
    
    NSLog(@"Writing data to file with path ------> %@",path);

    ALAssetRepresentation *assetRep = [result defaultRepresentation];
    NSUInteger size = [assetRep size];
    NSError *err = nil;
    //
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [outputStream open];
    NSInteger avgSize = 1024*1024*10;//If file big than write data to file each 10MB
    NSInteger totalCount = 0;
    if (avgSize >= size) {
        totalCount = 1;
        avgSize = size;
    }
    else {
        totalCount = size/avgSize + 1;
    }
    for (int i=1; i<= totalCount; i++) {
        
        NSLog(@"size/avgSizey(Total count) : ------------> %ld; The number is: ------------> %d",totalCount, i);
        NSInteger bytesWrittenSize = i != totalCount ? avgSize : size - (i-1)*(avgSize) ;
        NSLog(@"Bytes written size : --------------------> %ld",bytesWrittenSize);
        uint8_t * datatemp=malloc(bytesWrittenSize);
        
        NSUInteger gotByteCount = [assetRep getBytes:datatemp
                                          fromOffset:(i-1)*(avgSize)
                                              length:bytesWrittenSize
                                               error:&err];
        NSLog(@"Got byte count : ------------------------> %ld",gotByteCount);
        //
        NSInteger dataLength = bytesWrittenSize;
        NSInteger bytesWrittenSoFar = 0;
        do {
            NSInteger bytesWritten = [outputStream write:&datatemp[bytesWrittenSoFar]
                                     maxLength:dataLength - bytesWrittenSoFar];
            assert(bytesWritten != 0);
            if (bytesWritten == -1) {
                NSLog(@"File write error");
                return NO;
            }
            else {
                bytesWrittenSoFar += bytesWritten;
            }
        } while (bytesWrittenSoFar != dataLength);
        free(datatemp);
    }
    [outputStream close];
    NSLog(@"Create file successfully.");
    return YES;
}

@end
