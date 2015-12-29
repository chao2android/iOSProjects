//
//  UpLoadProjectViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-27.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ASIDownManager.h"
#import "PhotoSelectManager.h"

@interface UpLoadProjectViewController : BaseADViewController <UIActionSheetDelegate, UITextViewDelegate>
@property (nonatomic, copy) NSString *theTitleText;
@property (nonatomic, strong) ASIDownManager *mDownManager;
@property (nonatomic, strong) PhotoSelectManager *mPhotoManager;
@property (nonatomic, strong) NSString *mFilePath;
@property (nonatomic, assign) SEL onSaveClick;
@end
