//
//  InputGrowView.m
//  好妈妈
//
//  Created by Hepburn Alex on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "InputGrowView.h"
#import <QuartzCore/QuartzCore.h>

@implementation InputGrowView

@synthesize mWeight, mHeight, delegate, OnInputGrow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [NSArray arrayWithObjects:@"身高(cm)", @"体重(kg)", nil];
        NSArray *array2 = [NSArray arrayWithObjects:@"身高", @"体重", nil];
        for (int i = 0; i < 2; i ++) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10+60*i, self.frame.size.width-20, 48)];
            backView.backgroundColor = [UIColor whiteColor];
            backView.layer.borderWidth = 1;
            backView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;
            [self addSubview:backView];
            [backView release];
            
            UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, backView.frame.size.height)];
            lbName.backgroundColor = [UIColor clearColor];
            lbName.font = [UIFont systemFontOfSize:16];
            lbName.textColor = [UIColor grayColor];
            lbName.text = [NSString stringWithFormat:@"%@：", [array objectAtIndex:i]];
            [backView addSubview:lbName];
            [lbName release];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, backView.frame.size.width-80, backView.frame.size.height)];
            textField.backgroundColor = [UIColor clearColor];
            textField.font = [UIFont systemFontOfSize:16];
            textField.textColor = [UIColor grayColor];
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.placeholder = [NSString stringWithFormat:@"请输入宝宝今日%@", [array2 objectAtIndex:i]];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [backView addSubview:textField];
            [textField release];
            if (i == 1) {
                mWeight = textField;
            }
            else {
                mHeight = textField;
            }
        }
       UIImage *image = [[UIImage imageNamed:@"004_钮.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:18];
      
      UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      commitBtn.frame = CGRectMake(90, 130, 130, 40);
        [commitBtn setBackgroundImage:image forState:UIControlStateNormal];
        [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [commitBtn addTarget:self action:@selector(OnButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commitBtn];
    }
    return self;
}

- (void)OnButtonClick {
    if (!mHeight.text || mHeight.text.length == 0) {
        [self AutoAlert:@"提示" msg:@"请填写宝宝身高"];
        return;
    }
    if (!mWeight.text || mWeight.text.length == 0) {
        [self AutoAlert:@"提示" msg:@"请填写宝宝体重"];
        return;
    }
    if (delegate && OnInputGrow) {
        [delegate performSelector:OnInputGrow withObject:self];
    }
}

- (void)AutoAlert:(NSString *)title msg:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
