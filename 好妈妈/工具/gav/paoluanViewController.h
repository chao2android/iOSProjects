//
//  paoluanViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerSelectView.h"

@interface paoluanViewController : UIViewController<UITextFieldDelegate> {
    UITextField *mMensesDate;
    UITextField *mMensesLength;
    DatePickerSelectView *mDateView;
}

@property (nonatomic, retain) NSDate *mDate;

@end
