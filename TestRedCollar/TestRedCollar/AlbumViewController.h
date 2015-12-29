//
//  AlbumViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "PhotoCell.h"
#import "RefreshTableView.h"

@interface AlbumViewController : BaseADViewController <UITableViewDataSource, UITableViewDelegate, PhotoCellDelegate, UIActionSheetDelegate, RefreshTableViewDelegate>
{
    RefreshTableView *mTableView;
}

@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) SEL onSaveClick;
@end
