//
//  DatePickerSelectView.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-4-28.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "DatePickerSelectView.h"

@implementation DatePickerSelectView

@synthesize delegate, OnDateSelect, OnDateCancel, mDate, mDateStr, mDateView, mShortDateStr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        topBar.barStyle = UIBarStyleBlackTranslucent;
        [self addSubview:topBar];
        [topBar release];
        
        UIBarButtonItem *cancelItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(OnCancelClick)] autorelease];
        UIBarButtonItem *spaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        UIBarButtonItem *closeItem = [[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(OnSelectClick)] autorelease];
        topBar.items = [NSArray arrayWithObjects:cancelItem, spaceItem, closeItem, nil];
        
        mDateView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44)];
        [mDateView setDate:[NSDate date] animated:YES];
        mDateView.datePickerMode = UIDatePickerModeDateAndTime;
        [mDateView addTarget:self action:@selector(OnSelectDateTime:) forControlEvents:UIControlEventValueChanged ];
        [self addSubview:mDateView];
        [mDateView release];
    }
    return self;
}

- (void)OnSelectDateTime:(UIDatePicker *)sender {
    
}

- (void)OnSelectClick {
    if (delegate && OnDateSelect) {
        [delegate performSelector:OnDateSelect withObject:self];
    }
}

- (void)OnCancelClick {
    if (delegate && OnDateCancel) {
        [delegate performSelector:OnDateCancel withObject:self];
    }
}


- (NSString *)mDateStr {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:00";
    return [formatter stringFromDate:mDateView.date];
}

- (NSString *)mShortDateStr {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:mDateView.date];
}

- (NSDate *)mDate {
    return mDateView.date;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
