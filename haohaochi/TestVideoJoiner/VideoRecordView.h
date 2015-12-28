//
//  VideoRecordView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineTimer.h"
#import "MediaSelectManager.h"
#import "MBProgressHUD.h"
#import "ZYQAssetPickerController.h"
#import "PopAlertView.h"
#import "RecordMsgLabel.h"
#import "SwitchImageView.h"
#import "TouchFocusView.h"

typedef enum {
    TVideoRecordMode_None,
    TVideoRecordMode_Record,
    TVideoRecordMode_Del,
    TVideoRecordMode_Finish,
} TVideoRecordMode;

@interface VideoRecordView : UIView<MediaSelectManagerDelegate, LineTimerDelegate, ZYQAssetPickerControllerDelegate, UINavigationControllerDelegate> {
    LineTimer *mCircularTimer;
    RecordMsgLabel *mlbTitle;
    UILabel *mlbTime;
    UIView *mRecordView;
    UIImageView *mAlbumView;
    UIButton *mBackBtn;
    SwitchImageView *mLightBtn;
    UIButton *mAlbumBtn;
    UIButton *mExchangeBtn;
    UIButton *mNextBtn;
    UIButton *mNextBtn2;
    UIButton *mDeleteBtn;
    UIButton *mRecordbtn;
    TouchFocusView *mFocusView;
    float mfRecordTime;
    BOOL mbVideoCapture;
    BOOL mbReturnTimeline;
    BOOL mbFailRecord;
    MBProgressHUD *mLoadView;
    PopAlertView *mAlertView;
    BOOL mbDelMode;
    BOOL mbFirstAnimate;
    UIImageView *mErrorView;
}

@property (nonatomic, strong) NSMutableArray *mRecordArray;
@property (nonatomic, assign) MediaSelectManager *mMediaManager;
@property (nonatomic, assign) UIViewController *mRootCtrl;
@property (nonatomic, assign) TVideoRecordMode mRecordMode;
@property (nonatomic, assign) int miIndex;
@property (nonatomic, assign) BOOL mbAppend;

- (void)reloadData:(NSArray *)array index:(int)index;

@end
