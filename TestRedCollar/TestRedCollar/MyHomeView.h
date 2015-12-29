//
//  MyHomeView.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseListView.h"
#import "ImageDownManager.h"

@interface MyHomeView : BaseListView<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *theFansCount;
    UILabel *theAttentionCount;
    UILabel *theNameLabel;
    UIImageView *theLogoImageView;
    
    UIButton *mSelectBtn;
    UITableView *_theTable;
    int iCurType;
    UIScrollView *mScrollView;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;

- (void)refreshHomeView;

@end
