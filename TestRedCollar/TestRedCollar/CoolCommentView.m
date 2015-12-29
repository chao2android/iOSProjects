//
//  CoolCommentView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolCommentView.h"
@implementation CoolCommentView

@synthesize delegate,sendClick;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self RegisterForKeyboardNotifications];
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = self.bounds;
        [backBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        mBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-155, frame.size.width, 155)];
        mBackView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        mBackView.userInteractionEnabled = YES;
        //mBackView.hidden = YES;
        [self addSubview:mBackView];
//
        UIImageView *textbackView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 47, frame.size.width-20, 103)];
        textbackView.image = [UIImage imageNamed:@"f_textback.png"];
        textbackView.userInteractionEnabled = YES;
        [mBackView addSubview:textbackView];
//
        mTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, textbackView.frame.size.width-10, textbackView.frame.size.height-10)];
        mTextView.delegate = self;
        mTextView.backgroundColor = [UIColor clearColor];
        mTextView.font = [UIFont systemFontOfSize:16];
        [textbackView addSubview:mTextView];
        
        mlbDesc = [[UILabel alloc] initWithFrame:CGRectMake(8, 7, 100, 20)];
        mlbDesc.backgroundColor = [UIColor clearColor];
        mlbDesc.font = [UIFont systemFontOfSize:16];
        mlbDesc.textColor = [UIColor grayColor];
        mlbDesc.text = @"说点什么..";
        [textbackView addSubview:mlbDesc];
        
        mTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, textbackView.frame.size.width-10, textbackView.frame.size.height-10)];
        mTextView.delegate = self;
        //mTextView.backgroundColor = [UIColor clearColor];
        mTextView.font = [UIFont systemFontOfSize:16];
        [textbackView addSubview:mTextView];
//
       
//
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(self.frame.size.width-40, 10, 30, 30);
        [sendBtn setImage:[UIImage imageNamed:@"send_btn.png"] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(OnSendClick) forControlEvents:UIControlEventTouchUpInside];
        [mBackView addSubview:sendBtn];
        
        UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-60, 10, 120, 25)];
        mLabel.backgroundColor = [UIColor clearColor];
        mLabel.text = @"写评论";
        mLabel.textAlignment = UITextAlignmentCenter;
        [mBackView addSubview:mLabel];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(10, 10, 30, 30);
        [cancelBtn setImage:[UIImage imageNamed:@"textView_cancel.png"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(OnCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [mBackView addSubview:cancelBtn];


        [mTextView becomeFirstResponder];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)OnSendClick {
    NSLog(@"mTextView.text-->%@",mTextView.text);
    if (delegate && sendClick) {
        [delegate performSelector:sendClick withObject:mTextView.text afterDelay:0];
    }
    [self removeFromSuperview];
}


- (void)OnCancelClick{

    [self removeFromSuperview];
}
- (void)textViewDidChange:(UITextView *)textView {
    mlbDesc.hidden = (textView.text && textView.text.length>0);
}

- (void)RegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)KeyboardWillShow:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    int iHeight = keyboardSize.height;
//    if (iHeight>35) {
//        iHeight -= 35;
//    }
    NSLog(@"keyboardWasShown%d", iHeight);
    mBackView.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
         mBackView.frame = CGRectMake(0, self.frame.size.height-iHeight-155, self.frame.size.width, 155);
    } completion:nil];
   
}

- (void)KeyboardWillHidden:(NSNotification *) notif{
    
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
