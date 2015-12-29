//
//  AttentionViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "RefreshTableView.h"

@interface AttentionViewController : BaseADViewController <UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate>
{
    RefreshTableView *mTableView;
}

@property (nonatomic, copy) NSString *theTitleText;
@property (nonatomic, assign) BOOL isAdded;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) SEL onSaveClick;
@property (nonatomic, assign) int pageIndex;

@end
