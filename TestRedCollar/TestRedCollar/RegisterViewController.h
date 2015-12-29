//
//  RegisterViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import "ImageDownManager.h"

@interface RegisterViewController : BaseADViewController
{
    UITextField *mMobile;
    UITextField *mPassword;
    UITextField *mPassword2;
    UITextField *mSMSCode;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSString *mCode;

@end
