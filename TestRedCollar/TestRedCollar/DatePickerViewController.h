//
//  DatePickerViewController.h
//  TestRedCollar
//
//  Created by MC on 14-8-18.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
typedef void (^saveDate)(NSString *date);
@interface DatePickerViewController : BaseADViewController

@property (copy, nonatomic)saveDate block;
@end
