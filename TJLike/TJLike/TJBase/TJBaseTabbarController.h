//
//  TJBaseTabbarController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJBaseTabbarViewModel.h"

@protocol TJTabbarSelectDelegate <NSObject>
- (void)selectBaseTabbarItem:(NSInteger)itemIndex;
@end

@interface TJBaseTabbarController : UITabBarController
@property (nonatomic, weak) id<TJTabbarSelectDelegate>  selectDelegate;
/**
 *  BaseTabbar viewModel实例
 */
@property (nonatomic, strong)TJBaseTabbarViewModel *tabbarViewModel;
/**
 *  当前所选index值
 */
@property (nonatomic, assign)NSInteger currentSelectedIndex;

-(void)reSelectCurrentItem;

@end
