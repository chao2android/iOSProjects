//
//  EditCategoryViewController.h
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"

typedef void (^saveData)(void);
@interface EditCategoryViewController : TJBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, copy)saveData mBlock;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end
