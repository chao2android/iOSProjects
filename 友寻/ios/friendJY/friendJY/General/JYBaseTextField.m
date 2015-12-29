//
//  JYBaseTextField.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/11.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseTextField.h"
#import "JYAppDelegate.h"
#import "Toast+UIView.h"

@implementation JYBaseTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setBaseDelegate:(id<JYBaseTextFieldDelegate>)baseDelegate{
    _baseDelegate = baseDelegate;
    self.delegate = baseDelegate;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(TextFieldDidChangeText) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
- (void)TextFieldDidChangeText{
    
    if (_limitedLength == 0) {
        return;
    }
    
    bool isChinese;//判断当前输入法是否是中文
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    NSString *str = [self.text stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSLog(@"汉字 %@",self.text);
            if ( str.length>=(_limitedLength+1)) {
//                [[JYAppDelegate sharedAppDelegate] showTip:[NSString stringWithFormat:@"最多输入%ld个汉字",(long)_limitedLength]];
                NSString *strNew = [NSString stringWithString:str];
                [self setText:[strNew substringToIndex:_limitedLength]];
                NSLog(@"newStr --> %@",self.text);
                [[JYAppDelegate sharedAppDelegate] showPromptTip:[NSString stringWithFormat:@"最多输入%ld个汉字",(long)_limitedLength] withTipCenter:CGPointMake(kScreenWidth/2,kScreenHeight/2-30)];

            }
        }
        else
        {
            NSLog(@"输入的英文还没有转化为汉字的状态");
            
        }
    }else{
        NSLog(@"str=%@; 本次长度=%d",str,[str length]);
        if ([str length]>=(_limitedLength+1)) {
            if ([self.baseDelegate respondsToSelector:@selector(showPromptTip:)]) {
                [self.baseDelegate showPromptTip:[NSString stringWithFormat:@"最多输入%ld个汉字",(long)_limitedLength]];
            }else{
                [self makeToast:[NSString stringWithFormat:@"最多输入%ld个汉字",(long)_limitedLength] duration:1 position:[NSValue valueWithCGPoint:CGPointMake(self.width/2, 14)]];
            }
            NSString *strNew = [NSString stringWithString:str];
            [self setText:[strNew substringToIndex:_limitedLength]];
        }
    }
}

@end
