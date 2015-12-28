//
//  PopSearchView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PopSearchView.h"

@implementation PopSearchView

@synthesize delegate, OnSearchText;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, IOS_7?65:44)];
        topView.userInteractionEnabled = YES;
        topView.image = [UIImage imageNamed:IOS_7?@"topbar7.png":@"topbar.png"];
        [self addSubview:topView];
        
        float fWidth = frame.size.width-28;
        float fHeight = fWidth/11.67;
        
        UIImageView *backView =[[UIImageView alloc] initWithFrame:CGRectMake(14, topView.frame.size.height-44+(44-fHeight)/2, fWidth, fHeight)];
        backView.userInteractionEnabled = YES;
        backView.image = [UIImage imageNamed:@"p_commentback"];
        [topView addSubview:backView];
        
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fHeight*0.57, fHeight*0.57)];
        flagView.center = CGPointMake(backView.frame.size.width-fHeight*1.1/2, fHeight/2);
        flagView.image = [UIImage imageNamed:@"p_searchflag"];
        [backView addSubview:flagView];

        mTextField = [[UITextField alloc] initWithFrame:CGRectMake(fHeight, 0, backView.frame.size.width-fHeight*2, fHeight)];
        mTextField.delegate = self;
        mTextField.backgroundColor = [UIColor clearColor];
        mTextField.font = [UIFont fontWithName:kDefault_FontName size:16];
        mTextField.textAlignment = NSTextAlignmentCenter;
        mTextField.textColor = [UIColor grayColor];
        mTextField.placeholder = @"输入你想了解的餐厅名字";
        mTextField.returnKeyType = UIReturnKeySearch;
        [backView addSubview:mTextField];

        [mTextField becomeFirstResponder];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, topView.frame.size.height, self.frame.size.width, self.frame.size.height-topView.frame.size.height);
        backBtn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        backBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [backBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        backBtn.alpha = 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            backBtn.alpha = 1.0;
        }];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!textField.text || textField.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入餐厅名字"];
        return NO;
    }
    if (delegate && OnSearchText) {
        SafePerformSelector([delegate performSelector:OnSearchText withObject:textField.text]);
    }
    [self removeFromSuperview];
    return YES;
}

@end
