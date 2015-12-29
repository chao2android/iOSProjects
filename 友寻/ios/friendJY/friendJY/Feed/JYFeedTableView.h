//
//  JYFeedTableView.h
//  friendJY
//
//  Created by ouyang on 3/25/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYBaseTableView.h"
@interface JYFeedTableView : JYBaseTableView

@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, assign) BOOL isMyDynamicCall;//标记是我的动态列表 yes；或是首页列表no。

@end
