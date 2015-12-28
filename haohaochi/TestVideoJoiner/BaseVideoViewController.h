//
//  BaseVideoViewController.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabViewController.h"
#import "ShareMethod.h"
#import "RefreshTableView.h"
#import "VideoListTableViewCell.h"

@interface BaseVideoViewController : BaseTabViewController<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate, UIActionSheetDelegate, ShareMethodDelegate> {
    RefreshTableView *_mTableView;
    int miPage;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)OnHeadClick:(VideoListTableViewCell *)sender;
- (void)OnVideoClick:(VideoListTableViewCell *)sender;
- (void)OnMoreClick:(VideoListTableViewCell *)sender;
- (void)OnHaveGoClick:(VideoListTableViewCell *)sender;
- (void)OnXingClick:(VideoListTableViewCell *)sender;
- (void)OnLocationClick:(VideoListTableViewCell *)sender;
- (void)OnSearchClick;

- (void)CheckPlayer:(VideoListTableViewCell *)sender;

@end