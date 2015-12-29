//
//  AmendPasswordViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-8-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "BaseADViewController.h"
#import "ImageDownManager.h"

@interface AmendPasswordViewController : BaseADViewController
{
    UITextField *mPassword;
    UITextField *mPassword2;
    UITextField *mPassword3;
}
@property (nonatomic, strong) ImageDownManager *mDownManager;

@end
