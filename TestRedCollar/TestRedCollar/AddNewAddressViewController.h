//
//  AddNewAddressViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"

@interface AddNewAddressViewController : BaseADViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIScrollView *scrollView;
    UITableView *myTableView;
}
@property (nonatomic, copy) NSString *theTitleText;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic,assign) SEL onSaveClick;

@end
