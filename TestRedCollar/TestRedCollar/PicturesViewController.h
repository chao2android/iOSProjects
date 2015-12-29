//
//  PicturesViewController.h
//  TestRedCollar
//
//  Created by miracle on 14-8-9.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "PhotoCell.h"

@interface PicturesViewController : BaseADViewController <UITableViewDataSource, UITableViewDelegate, PhotoCellDelegate>
{
    UITableView *mTableView;
}
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSString *albumID;
@property (nonatomic, assign) SEL onSaveClick;
@end
