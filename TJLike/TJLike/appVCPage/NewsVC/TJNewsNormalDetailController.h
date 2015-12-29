//
//  TJNewsNormalDetailController.h
//  TJLike
//
//  Created by MC on 15-3-31.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"
#import "NewsListInfo.h"

@interface TJNewsNormalDetailController : TJBaseViewController<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)NewsListInfo *mlInfo;

@end
