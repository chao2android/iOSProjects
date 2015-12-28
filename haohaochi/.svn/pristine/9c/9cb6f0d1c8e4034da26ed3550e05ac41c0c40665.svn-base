//
//  TouchFocusView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-8.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "TouchFocusView.h"

@implementation TouchFocusView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mTouchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        mTouchView.image = [UIImage imageNamed:@"p_focus"];
        mTouchView.alpha = 0.0;
        [self addSubview:mTouchView];
    }
    return self;
}

- (void)dealloc {
    self.mCaptureDevice = nil;
}

- (AVCaptureDevice *)GetCurrentDevice {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (self.mPicker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        for (AVCaptureDevice *device in devices) {
            if (device.position == AVCaptureDevicePositionFront) {
                return device;
            }
        }
    }
    else {
        for (AVCaptureDevice *device in devices) {
            if (device.position == AVCaptureDevicePositionBack) {
                return device;
            }
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.mPoint = [touch locationInView:self];
    
    
    self.mCaptureDevice = [self GetCurrentDevice];
    
    [self ShowFocus];
    //先进行判断是否支持控制对焦
    if (self.mCaptureDevice.focusPointOfInterestSupported &&[self.mCaptureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        NSError *error = nil;
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
        [self.mCaptureDevice lockForConfiguration:&error];
        [self.mCaptureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        [self.mCaptureDevice setFocusPointOfInterest:CGPointMake(self.mPoint.x+40, self.mPoint.y)];
        //操作完成后，记得进行unlock。
        [self.mCaptureDevice unlockForConfiguration];
        
    }
}

- (void)ShowFocus {
    NSLog(@"ShowFocus");
    mTouchView.alpha = 1.0;
    mTouchView.center = self.mPoint;
    [UIView animateWithDuration:0.5 animations:^{
        mTouchView.alpha = 0.0;
    }];
}

@end
