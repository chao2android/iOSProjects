//
//  WTVAlertView.h
//  WiseTV
//
//  Created by littlezl on 15/2/12.
//  Copyright (c) 2015年 tjgdMobilez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTVAlertView;
@protocol WTVAlertViewDelegate

-(void)wtvAlertView:(WTVAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)wtvAlertViewCancel:(WTVAlertView *)alertView;
-(void)wtvAlertView:(WTVAlertView *)alertView textFieldArray:(NSArray *)textArray;
@end


@interface WTVAlertView : UIView

@property (nonatomic, assign)id <WTVAlertViewDelegate>delegate;

/**
 *  程序内弹窗,按键类型
 *
 *  @param title            弹窗title
 *  @param message          弹窗message
 *  @param delegate         WTVAlertViewDelegate
 *  @param buttonTitles     按键下方显示名称 组成的数组
 *  @param buttonImageNames 按键图片名称 组成的数组
 *
 *  @return 弹窗
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<WTVAlertViewDelegate>*/)delegate buttonTitles:(NSArray *)buttonTitles buttonImageNames:(NSArray *)buttonImageNames;

/**
 *  程序内弹窗,输入框类型
 *
 *  @param title        弹窗title
 *  @param message      弹窗message
 *  @param delegate     WTVAlertViewDelegate
 *  @param placeholders 输入框的占位文字
 *  @param specialLines 需要加密显示的输入框的index值
 *  @param cancelTitle  取消按键的title
 *  @param otherTitle   确认按键的title
 *  @return 弹窗
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<WTVAlertViewDelegate>*/)delegate textFieldPlaceholders:(NSArray *)placeholders specialLine:(NSArray *)specialLines limits:(NSArray *)limits cancelButton:(NSString *)cancelTitle otherButton:(NSString *)otherTitle;

/**
 *  弹窗显示
 */
-(void)show;
@end
