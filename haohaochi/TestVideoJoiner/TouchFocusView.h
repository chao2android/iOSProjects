//
//  TouchFocusView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-8.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TouchFocusView : UIView {
    UIImageView *mTouchView;
}

@property (nonatomic, assign) UIImagePickerController *mPicker;
@property (nonatomic, assign) AVCaptureDevice *mCaptureDevice;
@property (nonatomic, assign) CGPoint mPoint;

@end
