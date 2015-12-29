//
//  TJForumTableView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJBbsCatagoryModel.h"
#import "TJBBSCateSubModel.h"

typedef void(^TapFuromCell)(TJBBSCateSubModel *item);

@interface TJForumTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray  *forumTitles;
@property (nonatomic, copy) TapFuromCell tapFuromCell;
//@property (nonatomic, strong) NSArray  *

@end
