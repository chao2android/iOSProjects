//
//  TJBaseNaviBarView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Navi_LeftBut_Back_Image              @"navi_back.png"
#define Navi_RightBut_User_Image             @"operation_Icon.png"

#define Navi_But_Logo_Frame              CGRectMake(0, 0, 131, 44)
#define Navi_But_Normal_Frame             CGRectMake(0, 0, 44, 44)
#define NAVI_But_Back_Frame           CGRectMake(0, 0, 60, 45)

@interface TJBaseNaviBarView : UIView

/**
 *  创建一个带文字、背景、高光、尺寸的按键
 *
 *  @param strTitle        按键的title
 *  @param strImg          背景图
 *  @param strImgHighlight 高光背景图
 *  @param fram            按键尺寸
 *
 *  @return navigation上的按键
 */
+ (UIButton *)createNaviBarBtnByTitle:(NSString *)strTitle imgNormal:(NSString *)strImg imgHighlight:(NSString *)strImgHighlight withFrame:(CGRect)fram;

/**
 *  创建一个带文字、背景、高光、选中、尺寸的按键
 *
 *  @param strTitle        按键的title
 *  @param strImg          背景图
 *  @param strImgHighlight 高光背景图
 *  @param strImgSelected  选中状态的背景图
 *  @param fram            按键尺寸
 *
 *  @return navigation上的按键
 */
+ (UIButton *)createNaviBarBtnByTitle:(NSString *)strTitle imgNormal:(NSString *)strImg imgHighlight:(NSString *)strImgHighlight imgSelected:(NSString *)strImgSelected withFrame:(CGRect)fram;


- (void)setCenterBtn:(NSArray *)btnLists;
/**
 *  设置navigation左按键
 *  按键需通过上面类方法创建后直接赋值
 *  @param btn 待添加到navigation上的按键
 */
- (void)setLeftBtn:(id )leftItem;
/**
 *  设置navigation右按键
 *  按键需通过上面类方法创建后直接赋值
 *  @param btn 待添加到navigation上的按键
 */
- (void)setRightBtn:(id )rightItem;
/**
 *  设置navigation上的title
 *
 *  @param strTitle title
 */
- (void)setTitle:(NSString *)strTitle;
/**
 *  设置navigation上的title的样式
 *
 *  @param styleDict style
 */
- (void)setTitleStyle:(NSDictionary *)styleDict;

/**
 *  设置navigation的titleView
 *
 *  @param view titleView
 */
-(void)setTitleView:(UIView *)view;

/**
 *  设置navigation的背景图
 *  imageView需通过上面类方法创建后直接赋值
 *  @param imageView 背景图
 */
- (void)setBackgroundImageView:(UIImageView *)imageView;

/**
 *  设置navigation左侧多个按键
 *  按键需通过上面类方法创建后，从左至右先后放入数组，数组直接赋值
 *  @param leftButArr 按键数组
 */
- (void)setLeftBtnsWithButtonArray:(NSArray *)leftItemArr;

/**
 *  设置navigation右侧多个按键
 *  按键需通过上面类方法创建后，从右至左先后放入数组，数组直接赋值
 *  @param rightButArr 按键数组
 */
- (void)setRightBtnsWithButtonArray:(NSArray *)rightItemArr;

/**
 *  移除所有navigation上控件
 *
 *  @param bIsHide 是否隐藏
 */
- (void)hideOriginalBarItem:(BOOL)bIsHide;

/**
 *  label设置最小字体大小
 *
 *  @param label     label实例
 *  @param fMiniSize 字体最小字号
 *  @param iLines    label的行数
 */
+ (void)label:(UILabel *)label setMiniFontSize:(CGFloat)fMiniSize forNumberOfLines:(NSInteger)iLines;

@end
