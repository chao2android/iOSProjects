//
//  JYFindController.h
//  friendJY
//
//  Created by 高斌 on 15/3/9.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYFindController : JYBaseController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_table;
}
@end
