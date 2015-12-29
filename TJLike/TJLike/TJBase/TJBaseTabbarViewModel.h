//
//  TJBaseTabbarViewModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJBaseTabbarItem.h"

@interface TJBaseTabbarViewModel : NSObject
/**
 *  之前选中的bar上的按键
 */
@property (nonatomic, strong) UIButton *previousBut;
/**
 *  之前选中的bar上的按键item
 */
@property (nonatomic, strong) TJBaseTabbarItem *preItem;
/**
 *  tabbar上显示的数据信息列表
 */
@property (nonatomic, strong) NSArray *models;

/**
 *  根据数据信息创建一个tabbar上的按键
 *
 *  @param item tabbar上按键信息的实例
 *
 *  @return tabbar的按键
 */
-(UIButton *)creatItemsWithItem:(TJBaseTabbarItem *)item;

@end
