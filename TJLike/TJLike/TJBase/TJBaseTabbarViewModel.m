//
//  TJBaseTabbarViewModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseTabbarViewModel.h"
#define TABBAR_BUTTON_WIDTH  51.0f
#define TABBAR_BUTTON_HEIGHT 45.0f


@interface TJBaseTabbarViewModel()
{
 
}
@end

@implementation TJBaseTabbarViewModel

-(instancetype)init {
    self = [super init];
    
    if (!self) return nil;
    
    _models = [[NSArray alloc] init];
  
    return self;
}

-(UIButton *)creatItemsWithItem:(TJBaseTabbarItem *)item
{
    UIButton *itemBut = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBut.tag = item.itemTag;
    itemBut.frame = CGRectMake(0 , 0 , TABBAR_BUTTON_WIDTH, TABBAR_BUTTON_HEIGHT);
    if (_models.count) {
        itemBut.center = CGPointMake(SCREEN_WIDTH/_models.count * itemBut.tag + SCREEN_WIDTH/_models.count/2, TABBAR_HEIGHT/2);
    }
    if (item.itemImageName) {
        [itemBut setImage:[UIImage imageNamed:item.itemImageName] forState:UIControlStateNormal];
    }
    if (item.itemSelectedImageName) {
        [itemBut setImage:[UIImage imageNamed:item.itemSelectedImageName] forState:UIControlStateSelected];
    }
    
    return itemBut;
}

@end
