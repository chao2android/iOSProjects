//
//  UserInfoViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "PhotoSelectManager.h"
#import "ASIDownManager.h"
#import "UserList.h"
#import "ImageDownManager.h"

@interface UserInfoViewController : BaseADViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    UITableView *mTableView;
}

@property (nonatomic, strong) PhotoSelectManager *mPhotoManager;
@property (nonatomic, strong) ASIDownManager *mDownManager;
@property (nonatomic, strong) UserList *userList;
@property (nonatomic, assign) SEL onSaveClick;
@property (nonatomic, strong) ImageDownManager *downManager;

@end
