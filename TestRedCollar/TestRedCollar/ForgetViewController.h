//
//  ForgetViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import "CheckCodeButton.h"

@interface ForgetViewController : BaseADViewController<CheckCodeButtonDelegate> {
    UITextField *mUserName;
    UITextField *mCode;
    CheckCodeButton *mCodeBtn;
}

@end
