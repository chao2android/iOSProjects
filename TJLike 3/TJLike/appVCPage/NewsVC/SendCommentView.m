//
//  SendCommentView.m
//  TJLike
//
//  Created by MC on 15/4/7.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "SendCommentView.h"
#import "AutoAlertView.h"

@implementation SendCommentView


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
        [self addSubview:mBackView];
        
        UIImageView *textbackView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, frame.size.width-30, 103)];
        textbackView.userInteractionEnabled = YES;
        [mBackView addSubview:textbackView];
        
        mTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, textbackView.frame.size.width-10, textbackView.frame.size.height-10)];
        mTextView.backgroundColor = [UIColor whiteColor];
        mTextView.font = [UIFont systemFontOfSize:16];
        [textbackView addSubview:mTextView];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(self.frame.size.width-70, 120, 50, 25);
        [sendBtn setTitle:@"发表" forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [sendBtn setBackgroundImage:[UIImage imageNamed:@"news_bottom_发表_@2x.png"] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(OnSendClick) forControlEvents:UIControlEventTouchUpInside];
        [mBackView addSubview:sendBtn];
        
        [mTextView becomeFirstResponder];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"mTextView.text-->dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)OnSendClick {
    NSLog(@"mTextView.text-->%@",mTextView.text);
    if (mTextView.text.length == 0) {
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/AddComment"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.nid forKey:@"nid"];
    [dict setObject:UserManager.userInfor.userId forKey:@"uid"];
    [dict setObject:mTextView.text forKey:@"content"];
    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
        [AutoAlertView ShowMessage:@"评论成功"];
        [self HiddenView];
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
        //[self executeStateBlock];
    }];
}


- (void)OnCancelClick{
    [self HiddenView];
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

- (void)HiddenView{
    [UIView animateWithDuration:0.1 animations:^{
        mBackView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 155);
    } completion:^(BOOL finish) {
        [self removeFromSuperview];
    }];
}
- (void)KeyboardWillHidden:(NSNotification *) notif{
    [self HiddenView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
