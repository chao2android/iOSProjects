//
//  DatePickerSelectView.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-4-28.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerSelectView : UIView {
    UIDatePicker *mDateView;
}

@property (nonatomic, assign) UIDatePicker *mDateView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnDateSelect;
@property (nonatomic, assign) SEL OnDateCancel;
@property (readonly, assign) NSString *mDateStr;
@property (readonly, assign) NSString *mShortDateStr;
@property (readonly, assign) NSDate *mDate;

@end
