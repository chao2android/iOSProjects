//
//  PopCommentView.m
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-19.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PopCommentView.h"
#import "AutoAlertView.h"
#import "JSON.h"

@implementation PopCommentView

@synthesize mDownManager;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self RegisterForKeyboardNotifications];
       
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        mPopView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-145, self.frame.size.width, 145)];
        mPopView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
        [self addSubview:mPopView];
                
        mTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 45, mPopView.frame.size.width-30, 75)];
        mTextView.font = [UIFont systemFontOfSize:14];
        [mPopView addSubview:mTextView];
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnClosePopClick)];
        [self addGestureRecognizer:singleTap];

        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(0, 0, 44, 44);
        [closeBtn setImage:[UIImage imageNamed:@"f_btnclose"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(OnClosePopClick) forControlEvents:UIControlEventTouchUpInside];
        [mPopView addSubview:closeBtn];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(mPopView.frame.size.width-44, 0, 44, 44);
        [selectBtn setImage:[UIImage imageNamed:@"f_btnselect"] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(OnSelectPopClick) forControlEvents:UIControlEventTouchUpInside];
        [mPopView addSubview:selectBtn];
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, mPopView.frame.size.width-100, 44)];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.font = [UIFont systemFontOfSize:16];
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.text = @"评论";
        [mPopView addSubview:lbTitle];
        
        [mTextView becomeFirstResponder];
    }
    return self;
}

- (void)RegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)KeyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    int iHeight = keyboardSize.height;
    if (iHeight>35) {
        iHeight -= 35;
    }
    NSLog(@"keyboardWasShown%d", iHeight);
    
    mPopView.frame = CGRectMake(0, self.frame.size.height-iHeight-145-20, self.frame.size.width, 145);
    [self bringSubviewToFront:mPopView];
    
    if ([self respondsToSelector:@selector(ShowBottomKeyboard)]) {
        [self performSelector:@selector(ShowBottomKeyboard)];
    }
}

- (void)KeyboardWillHidden:(NSNotification *) notif{
    
}

- (void)ShowBottomKeyboard {
    
}

- (void)OnSelectPopClick {
    [self AddComment];
}

- (void)OnClosePopClick {
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self Cancel];
}

#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)AddComment {
    if (!mTextView.text || mTextView.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入评论内容"];
        return;
    }
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnAddLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/video/comment_add", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkUserID forKey:@"u_id"];
    [dict setObject:self.mVideoID forKey:@"v_id"];
    [dict setObject:mTextView.text forKey:@"comment"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnAddLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RefreshComment object:nil];
            [AutoAlertView ShowAlert:@"提示" message:@"评论成功"];
            [self OnClosePopClick];
        }
        else {
            [AutoAlertView ShowAlert:@"提示" message:@"评论失败"];
            [self OnClosePopClick];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
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
