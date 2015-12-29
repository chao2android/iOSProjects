//
//  JYFeedController.h
//  friendJY
//
//  Created by 高斌 on 15/3/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYFeedTableView.h"
#import "JYEmotionBrowser.h"

@interface JYFeedController : JYBaseController<JYBaseRefreshTableDelegate,UITextFieldDelegate,JYEmotionBrowserDelegate>

@property(nonatomic,strong) JYFeedTableView * feedTableView;

@property(nonatomic,strong) NSString * testxxx;

@end
