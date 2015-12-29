//
//  FansInfoViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "RefreshTableView.h"
#import "ProjectCell.h"

@interface FansInfoViewController : BaseADViewController <UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate, ProjectCellDelegate>
{
    RefreshTableView *mTableView;
    UILabel *theNameLabel;
    UIButton *mSelectBtn;
    int iCurType;
}

@property (nonatomic, assign) BOOL isAdded;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, assign) SEL onSaveClick;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic,strong) NSString *userID;

@end
