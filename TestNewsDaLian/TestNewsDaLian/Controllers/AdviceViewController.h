//
//  AdviceViewController.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/23.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "BaseADViewController.h"
#import "ASIDownManager.h"
#import "ImageDownManager.h"
#import "DxyCustom.h"
@interface AdviceViewController : BaseADViewController<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) ASIDownManager *mDownManager;

@end
