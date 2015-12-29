//
//  NewsBannerCell.h
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPagingView.h"
#import "TJBaseViewController.h"

@interface NewsBannerCell : UITableViewCell<GCPagingViewDelegate>

@property (nonatomic, assign) TJBaseViewController *mRootCtrl;

- (void)LoadContent:(NSMutableArray *)mArray;

@end
