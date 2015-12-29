//
//  TJNewsImageDetailController.h
//  TJLike
//
//  Created by MC on 15-3-31.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
#import "NewsListInfo.h"
#import "PhotoScrollView.h"

@interface TJNewsImageDetailController : TJBaseViewController<UIScrollViewDelegate>

@property (nonatomic, strong)NewsListInfo *mlInfo;

@end
