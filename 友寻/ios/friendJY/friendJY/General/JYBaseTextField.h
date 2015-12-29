//
//  JYBaseTextField.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/11.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYBaseTextFieldDelegate <UITextFieldDelegate>

- (void)showPromptTip:(NSString*)tip;

@end

@interface JYBaseTextField : UITextField

@property (nonatomic, assign) id<JYBaseTextFieldDelegate>baseDelegate;
//限制输入长度
@property (nonatomic, assign) NSInteger limitedLength;

@end
