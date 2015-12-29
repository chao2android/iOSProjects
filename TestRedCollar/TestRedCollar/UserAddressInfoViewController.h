//
//  UserAddressInfoViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "ConsigneeList.h"

@interface UserAddressInfoViewController : BaseADViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIScrollView *scrollView;
    UITableView *myTableView;
}
@property (nonatomic, copy) NSString *theTitleText;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic,assign) SEL onSaveClick;

- (void)receiveConsignee:(ConsigneeList *)conlist;

@end
