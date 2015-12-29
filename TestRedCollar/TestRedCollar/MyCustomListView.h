//
//  MyCustomListView.h
//  TestRedCollar
//
//  Created by MC on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseListView.h"
@interface MyCustomListView : BaseListView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mTableView;
    UIButton *mSelectBtn;
}

- (void)LoadCustomList;
@end
