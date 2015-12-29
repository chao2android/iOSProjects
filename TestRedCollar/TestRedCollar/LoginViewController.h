//
//  LoginViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import "ImageDownManager.h"

@interface LoginViewController : BaseADViewController {
    UITextField *mUserName;
    UITextField *mPassword;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;

@end
