//
//  TJBaseViewController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJBaseNavigationController.h"


@interface TJBaseViewController : UIViewController

/**
 *  当前页面所在的navigationController实例
 */
@property (nonatomic, strong) TJBaseNavigationController  *naviController;



@end
