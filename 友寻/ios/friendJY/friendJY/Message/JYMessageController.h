//
//  JYMessageController.h
//  friendJY
//
//  Created by 高斌 on 15/3/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYMessageTableView.h"

@interface JYMessageController : JYBaseController<UITableViewDelegate, UITableViewDataSource, FooterTableViewDelegate>
{
    JYMessageTableView *_table;
    NSInteger _pageIndex;
    NSMutableArray *_msgList;
    BOOL _isAppear;
    UILabel *newMsgLab;
}


@end
