//
//  UpLoadPhotoViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ASIDownManager.h"
#import "PhotoSelectManager.h"

@interface UpLoadPhotoViewController : BaseADViewController <UIActionSheetDelegate, UITextViewDelegate>

@property (nonatomic, copy) NSString *theTitleText;
@property (nonatomic, strong) ASIDownManager *mDownManager;
@property (nonatomic, strong) PhotoSelectManager *mPhotoManager;
@property (nonatomic, strong) NSString *mFilePath1;
@property (nonatomic, strong) NSString *mFilePath2;
@property (nonatomic, strong) NSString *mFilePath3;
@property (nonatomic, assign) SEL onSaveClick;
@end
