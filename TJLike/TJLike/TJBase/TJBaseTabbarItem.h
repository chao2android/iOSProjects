//
//  TJBaseTabbarItem.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJBaseTabbarItem : NSObject
//按键图片
@property (nonatomic, strong) NSString *itemImageName;
//按键选中状态图片
@property (nonatomic, strong) NSString *itemSelectedImageName;
//按键文字
@property (nonatomic, strong) NSString *itemTitle;
//按键Tag值
@property (nonatomic) NSInteger itemTag;
//按键是否可点（再次点击当前已经选中的按键不触发事件）
@property (nonatomic) BOOL itemEnable;

@end
