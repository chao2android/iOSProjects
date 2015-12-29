//
//  PhotoSelectManager.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-5-30.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIPopoverController;

@interface PhotoSelectManager : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    int miMinWidth;
    BOOL mbEdit;
    UIActivityIndicatorView *mActView;
}

@property (readonly) NSString *mLocalPath;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnPhotoSelect;
@property (nonatomic, retain) NSString *mDefaultName;
@property (nonatomic, assign) UIViewController *mRootCtrl;
@property (nonatomic, assign) int miMinWidth;
@property (nonatomic, assign) BOOL mbEdit;

@property (nonatomic, retain) UIPopoverController *popoverController;

- (BOOL)TakePhoto:(BOOL)bCamera;

@end
