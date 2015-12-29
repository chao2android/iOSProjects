//
//  CommentListView.h
//  TJLike
//
//  Created by MC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListInfo.h"

@interface CommentListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NewsListInfo *mlInfo;
- (id)initWithFrame:(CGRect)frame WithNid:(NewsListInfo *) mlInfo;
@end
