//
//  JYDynamicController.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/4.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYFeedTableView.h"

@interface JYDynamicController : JYBaseController<JYBaseRefreshTableDelegate>

@property (nonatomic, copy) NSString *uid;
/**
 *  是否限制只能显示5张图片
 */
@property (nonatomic, assign) BOOL isLimited;

@property(nonatomic,strong) JYFeedTableView * feedTableView;

@end
