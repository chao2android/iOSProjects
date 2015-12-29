//
//  PickerSelectView.m
//  TestHebei
//
//  Created by Isaac on 14-6-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PickerSelectView.h"

@implementation PickerSelectView {
    UIPickerView *mPickerView;
}

@synthesize delegate, OnPickerCancel, OnPickerSelect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)reloadData:(NSArray *)array
{
    if (!array || array.count == 0) {
        return;
    }
    self.mPickArray = array;
    
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    topBar.barStyle = UIBarStyleBlackTranslucent;
    if (IOS_7) {
        topBar.tintColor = [UIColor whiteColor];
    }
    [self addSubview:topBar];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(OnCancelClick)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(OnSelectClick)];
    topBar.items = [NSArray arrayWithObjects:cancelItem, spaceItem, closeItem, nil];
    
    mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44)];
    // 显示选中框
    mPickerView.showsSelectionIndicator=YES;
    mPickerView.dataSource = self;
    mPickerView.delegate = self;
    mPickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mPickerView];
    
    self.mSelectStr = [self.mPickArray objectAtIndex:0];
}

- (void)OnSelectClick {
    if (delegate && OnPickerSelect) {
        SafePerformSelector(
                            [delegate performSelector:OnPickerSelect withObject:self];
                            );
    }
}

- (void)OnCancelClick {
    if (delegate && OnPickerCancel) {
        SafePerformSelector(
                            [delegate performSelector:OnPickerCancel withObject:self];
                            );
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.mPickArray.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.mPickArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.mSelectStr = [self.mPickArray objectAtIndex:row];
}

- (void)dealloc {
}

@end
