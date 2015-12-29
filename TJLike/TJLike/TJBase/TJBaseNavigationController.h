//
//  TJBaseNavigationController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJBaseNaviBarView.h"

@interface TJBaseNavigationController : UINavigationController

/**
 *  设置默认返回按键
 点击按键返回上一页
 */
-(void)setNaviBarDefaultLeftBut_Back;
/**
 *  封装对navigation的设置
 *  设置navigation的title内容
 *  @param strTitle title内容
 */
- (void)setNaviBarTitle:(NSString *)strTitle;
/**
 *  封装对navigation的title的样式设置
 *
 *  @param styleDict title的样式
 */
- (void)setNaviBarTitleStyle:(NSDictionary *)styleDict;

/**
 *  封装对navigation的titleView的设置
 *
 *  @param view titleView
 */
-(void)setNaviBarTitleView:(UIView *)view;

/**
 *  封装对navigation的设置
 *  设置好UIButton的背景图、文字、尺寸后，直接将button赋值进来
 *  @param btn navigation的左侧按键
 */
- (void)setNaviBarLeftBtn:(id )leftItem;
/**
 *  封装对navigation的设置
 *  设置好UIButton的背景图、文字、尺寸后，直接将button赋值进来
 *  @param btn navigation的右侧按键
 */
- (void)setNaviBarRightBtn:(id )rightItem;
/**
 *  封装对navigation的设置
 *  设置好UIImageView的尺寸、图片后直接赋值进来
 *  @param imgView navigation的背景图
 */
- (void)setNaviBarBackGroundImage:(UIImageView *)imgView;

/**
 *  封装对navigation的多按键设置
 *  将按键分别设置好背景、文字、尺寸等后，放入array中赋值
 *  @param leftButArr navigation的左侧按键组成的数组
 */
- (void)setNaviBarLeftBtnsWithButtonArray:(NSArray *)leftItemArr;
/**
 *  封装对navigation的多按键设置
 *  将按键分别设置好背景、文字、尺寸等后，放入array中赋值
 *  @param rightButArr navigation的右侧按键组成的数组
 */
- (void)setNaviBarRightBtnsWithButtonArray:(NSArray *)rightItemArr;

- (void)setNaviBarCenterBtnsWithButtonArray:(NSArray *)centerItemArr;

/**
 *  封装对navigation的设置
 *  直接去除navigationBar上所有控件
 */
- (void)hideOriginalBarItems;

@end
