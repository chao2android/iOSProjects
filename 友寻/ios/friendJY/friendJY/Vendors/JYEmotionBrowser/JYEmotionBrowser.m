//
//  JYEmotionBrowser.m
//  friendJY
//
//  Created by ouyang on 5/4/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYEmotionBrowser.h"
#import "JYShareData.h"
#import "JYAppDelegate.h"
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

typedef enum {
    JYChatStyle, // 聊天时的输入样式
    JYFeedCommentStyle // 动态发评论样式
} JYEmotionStyle;


@implementation JYEmotionBrowser{
    UIButton *_faceBtn;
    UIScrollView *_emojiBg;
    NSInteger currentKeyboardHeight;
    UIPageControl *pageControl;
    UIView * sendView;
    UIView *_emojiView;
    UITextView *_inputTextView;
    UILabel *placeholderLabel;
    UIButton * _faceSendBtn;
    UIButton *cancleBtn;
    UIImageView *imgView;
    BOOL isShowEmoji;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.backgroundColor = [UIColor clearColor];
        cancleBtn.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [cancleBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        
        sendView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 55)];
        sendView.backgroundColor = [UIColor whiteColor];
        [self addSubview:sendView];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, kScreenWidth-60, 30)];
        //imgView.image = [UIImage imageNamed:@"bg_tuijian_shurukuang.png"];
        UIImage *img=[UIImage imageNamed:@"feedTalkBg"];
        imgView.image = [img stretchableImageWithLeftCapWidth:100 topCapHeight:10];
        
        [sendView addSubview:imgView];
        
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(25, 15, kScreenWidth - 75, 20.5)];
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.delegate = self;
        _inputTextView.enablesReturnKeyAutomatically = YES;
        _inputTextView.showsHorizontalScrollIndicator = NO;
        //_inputTextView.textContainerInset = UIEdgeInsetsMake(5, _inputTextView.textContainerInset.left, 5, _inputTextView.textContainerInset.right);
        _inputTextView.layoutManager.allowsNonContiguousLayout = NO;
        _inputTextView.font = [UIFont systemFontOfSize:17];
        [sendView addSubview:_inputTextView];
        [_inputTextView becomeFirstResponder];
        
        placeholderLabel = [[UILabel alloc]initWithFrame:_inputTextView.frame];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        [sendView addSubview:placeholderLabel];
        
        //表情
        _faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceBtn setImage:[UIImage imageNamed:@"msg_emoji.png"] forState:UIControlStateNormal];
        [_faceBtn setImage:[UIImage imageNamed:@"msg_keyboard.png"] forState:UIControlStateSelected];
        [_faceBtn setFrame:CGRectMake(imgView.right, 5, 40, 40)];
        _faceBtn.backgroundColor = [UIColor clearColor];
        [_faceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sendView addSubview:_faceBtn];
        
        
        
        //表情键盘
        _emojiView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth, kEmojiKeyboardHeight)];
        [self addSubview:_emojiView];
        
        _emojiBg = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kEmojiKeyboardHeight)];
        _emojiBg.delegate = self;
        [_emojiBg setBackgroundColor:[JYHelpers setFontColorWithString:@"#F2F2F2"]];
        [_emojiBg setUserInteractionEnabled:YES];
        [_emojiBg setContentSize:CGSizeMake(4*kScreenWidth, kEmojiKeyboardHeight)];
        [_emojiBg setPagingEnabled:YES];
        [_emojiBg setShowsHorizontalScrollIndicator:NO];
        [_emojiBg setShowsVerticalScrollIndicator:NO];
        [_emojiView addSubview:_emojiBg];
        
        [self initEmotion];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)show
{
    cancleBtn.enabled = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:cancleBtn];
    [window addSubview:self];
    [_inputTextView becomeFirstResponder];
    _inputTextView.text = nil;
    NSString * defText ;
    if (self.showNick == nil) {
        defText = @"你想对TA说什么";
    }else{
        defText = [NSString stringWithFormat:@"你想对%@说什么",self.showNick];
    }
    placeholderLabel.text = defText;
    placeholderLabel.hidden = NO;
}
- (void)hide{
    cancleBtn.enabled = NO;
    [_inputTextView resignFirstResponder];
    _emojiView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }completion:^(BOOL finished) {
        [sendView setOrigin:CGPointMake(0, kScreenHeight)];
        [cancleBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (void)initEmotion
{
    CGFloat horizontalPadding = (kScreenWidth-24*7)/8.0f;
    CGFloat verticalPadding = (kEmojiKeyboardHeight-24*3)/6.0f;
    
    for (int i=0; i<4; i++) {
        
        UIImageView *pageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kEmojiKeyboardHeight)];
        [pageView setUserInteractionEnabled:YES];
        [_emojiBg addSubview:pageView];
        
        for (int j=0; j<3; j++) {
            for (int k=0; k<7; k++)
            {
                
                if (j*7+k == 20)
                {
                    //删除按钮
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [deleteBtn setFrame:CGRectMake(horizontalPadding+6*(24+horizontalPadding), verticalPadding+2*(24+verticalPadding)-10, 36, 44)];
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"chat_btn_delete_normal.png"] forState:UIControlStateNormal];
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"chat_btn_delete_pressed.png"] forState:UIControlStateHighlighted];
                    [deleteBtn addTarget:self action:@selector(deleteFaceBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [pageView addSubview:deleteBtn];
                }
                else
                {
                    if (i*20+j*7+k < 80)
                    {
                        //表情
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalPadding+k*(24+horizontalPadding), verticalPadding+j*(24+verticalPadding), 24, 24)];
                        [imageView setUserInteractionEnabled:YES];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emojiTap:)];
                        [imageView addGestureRecognizer:tap];
                        NSString *imageName = [[JYShareData sharedInstance].emoji_array objectAtIndex:i*20+j*7+k];
                        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", imageName]]];
                        [imageView setTag:1000+i*20+j*7+k];
                        [pageView addSubview:imageView];
                    }
                    
                }
            }
        }
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2, _emojiBg.bottom-40, 120, 15)];
    [pageControl setCurrentPage:0];
    pageControl.pageIndicatorTintColor = RGBACOLOR(195, 179, 163, 1);
    pageControl.currentPageIndicatorTintColor = RGBACOLOR(132, 104, 77, 1);
    pageControl.numberOfPages = 4;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    //    pageControl.hidden = YES;
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [_emojiView addSubview:pageControl];
    
    _faceSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _faceSendBtn.backgroundColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    [_faceSendBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_faceSendBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_faceSendBtn setTitle:@"发  送" forState:UIControlStateNormal];
    [_faceSendBtn setFrame:CGRectMake(_emojiBg.right - 100, _emojiBg.bottom-40, 100, 40)];
    [_faceSendBtn addTarget:self action:@selector(faceSendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_emojiView addSubview:_faceSendBtn];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //通过滚动的偏移量来判断目前页面所对应的小白点
    int page = sender.contentOffset.x/kScreenWidth;
    //pagecontroll响应值的变化
    pageControl.currentPage = page;
}

- (void) faceSendBtnClick:(UIButton *)btn{
    //判断是不是全是空格
    if (![self isAllSpace:_inputTextView.text]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"您没有输入任何内容哦"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(JYEmotionTextFieldShouldReturn:contentText:)])
    {
        [self.delegate JYEmotionTextFieldShouldReturn:self contentText:_inputTextView.text];
        [self hide];
    }
}
//pagecontroll的委托方法
- (void)changePage:(id)sender
{
    NSLog(@"%ld", (long)pageControl.currentPage);
    NSInteger page = pageControl.currentPage;//获取当前pagecontroll的值
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [_emojiBg setContentOffset:CGPointMake(kScreenWidth * page, 0)];
}

- (void)deleteFaceBtnClick
{
    NSString *text = _inputTextView.text;
    NSLog(@"%ld",text.length);
    [self deleteBtnClick:_inputTextView.text.length-1];
}

- (BOOL)deleteBtnClick:(NSUInteger)location
{
    if (_inputTextView.text.length > 0 ) {
        NSString *text ;
        //如果最后一个字符为]，就可能是一个表情。查找最后一个[位置，从字典比对是为表情标记，如果是整体删除这一个表情，而不是一个单一字符。
        if([[_inputTextView.text substringWithRange:NSMakeRange(location, 1)] isEqualToString:@"]"]){
            //            BOOL isMatchSccuss = NO;
            for (NSInteger i = location-3; i>=0; i--) {
                NSString *temp = [_inputTextView.text substringWithRange:NSMakeRange(i, 1)];
                if([temp isEqualToString:@"["]){
                    
                    NSString *emotionText = [_inputTextView.text substringWithRange:NSMakeRange(i, location-i+1)];
                    
                    
                    NSInteger index = [[JYShareData sharedInstance].emoji_array indexOfObject:emotionText];
                    
                    if (index>=0 && index<=79) {
                        text = [_inputTextView.text stringByReplacingCharactersInRange:NSMakeRange(i, location-i+1) withString:@""];
                        [_inputTextView setText:text];
                        _inputTextView.selectedRange=NSMakeRange(i,0);
                        return NO;
                        //                        isMatchSccuss = YES;
                    }
                    
                    //                    if(isMatchSccuss) break;
                }
            }
            //            //没有找到对应的表情，则删除单个字符
            //            if(!isMatchSccuss){
            //                text = [_inputTextView.text stringByReplacingCharactersInRange:NSMakeRange(location, 0) withString:@""];
            //                [_inputTextView setText:text];
            //            }
            placeholderLabel.hidden = _inputTextView.text.length>0;
        }
    }
    return  YES;
//    if (_inputTextView.text.length > 0 ) {
//        NSString *text ;
//        //如果最后一个字符为]，就可能是一个表情。查找最后一个[位置，从字典比对是为表情标记，如果是整体删除这一个表情，而不是一个单一字符。
//        if([[_inputTextView.text substringWithRange:NSMakeRange(_inputTextView.text.length-1, 1)] isEqualToString:@"]"]){
//            BOOL isMatchSccuss = NO;
//            for (int i = _inputTextView.text.length-3; i>=0; i--) {
//                NSString *temp = [_inputTextView.text substringWithRange:NSMakeRange(i, 1)];
//                if([temp isEqualToString:@"["]){
//                    
//                    NSString *emotionText = [_inputTextView.text substringWithRange:NSMakeRange(i, _inputTextView.text.length-i)];
//                    
//                    
//                    NSInteger index = [[JYShareData sharedInstance].emoji_array indexOfObject:emotionText];
//                    
//                    if (index>=0 && index<=79) {
//                        text = [_inputTextView.text substringWithRange:NSMakeRange(0, i)];
//                        [_inputTextView setText:text];
//                        isMatchSccuss = YES;
//                    }
//                    
//                    if(isMatchSccuss) break;
//                }
//            }
//            //没有找到对应的表情，则删除单个字符
//            if(!isMatchSccuss){
//                text = [_inputTextView.text substringWithRange:NSMakeRange(0, _inputTextView.text.length-1)];
//                [_inputTextView setText:text];
//            }
//        } else {
//            text = [_inputTextView.text substringWithRange:NSMakeRange(0, _inputTextView.text.length-1)];
//            [_inputTextView setText:text];
//        }
//        
//        placeholderLabel.hidden = _inputTextView.text.length>0;
//    }
}

#pragma mark - 表情按钮响应
- (void)faceBtnClick:(UIButton *)btn
{
    if (btn.selected) {
        //显示键盘
        isShowEmoji = NO;
        [_inputTextView becomeFirstResponder];
        [btn setSelected:NO];
        _emojiView.hidden = YES;
    } else {
        //显示表情键盘
        isShowEmoji = YES;
        [_inputTextView resignFirstResponder];
        _emojiView.hidden = NO;
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            
            [sendView setOrigin:CGPointMake(0, kScreenHeight-(kEmojiKeyboardHeight+ 49))];
            
            [_emojiView setOrigin:CGPointMake(0, kScreenHeight-kEmojiKeyboardHeight)];
            
        } completion:^(BOOL finished) {
            
            //nothing
        }];
        
        [btn setSelected:YES];
        
    }
}


#pragma mark - 点击表情
- (void)emojiTap:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag-1000;
    NSString *emojiStr = [[JYShareData sharedInstance].emoji_array objectAtIndex:tag];
    [_inputTextView setText:[NSString stringWithFormat:@"%@%@", _inputTextView.text, emojiStr]];
    
    //[_inputTextView setContentOffset:CGPointMake(0, _inputTextView.contentSize.height-20.5)];
    
    placeholderLabel.hidden = YES;
    //
    
    [_inputTextView scrollRangeToVisible:NSMakeRange(_inputTextView.text.length-5, 5)];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    [_faceBtn setSelected:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!isShowEmoji) {
        [self hide];
    }
    [_faceBtn setSelected:YES];
    NSLog(@"keyboardWillHide");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    [super touchesBegan:touches withEvent:event];
    [self hide];
}



- (BOOL)isAllSpace:(NSString *)string{
    int num = 0;
    for (int i = 0; i<string.length; i++) {
        NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];
        if ([subString isEqualToString:@" "]) {
            num++;
        }
    }
    // 全是空格 返回no  不是返回yes
    return num != string.length;
}
#pragma mark - UITextField delegate
- (void)textViewDidChange:(UITextView *)textView{
    NSString *content = textView.text;
    if (!content) {
        content = @"";
    }
    placeholderLabel.hidden = content.length > 0;
    
    CGPoint offset = textView.contentOffset;
    [textView setContentOffset:offset];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //判断是不是全是空格
    if (![self isAllSpace:textField.text]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"您没有输入任何内容哦"];
        return NO;
    }
    if ([self.delegate respondsToSelector:@selector(JYEmotionTextFieldShouldReturn:contentText:)])
    {
         [self.delegate JYEmotionTextFieldShouldReturn:self contentText:textField.text];
        [self hide];
    }
    return YES;
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 键盘的高度
    NSValue* aValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGFloat keyboardHeight = keyboardRect.size.height;
    currentKeyboardHeight  = keyboardHeight;
    
    sendView.frame = CGRectMake(0, kScreenHeight-keyboardHeight-49, kScreenWidth, keyboardHeight+49);

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //判断是不是回车
    if ([text isEqualToString:@"\n"]) {
        //判断是不是全是空格
        if (![self isAllSpace:textView.text]) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"您没有输入任何内容哦"];
            return NO;
        }
        if ([self.delegate respondsToSelector:@selector(JYEmotionTextFieldShouldReturn:contentText:)])
        {
            [self.delegate JYEmotionTextFieldShouldReturn:self contentText:textView.text];
            [self hide];
        }
        return NO;
    }
    
    //如果是删除钮，直接跳转到删除方法
    if ([text isEqualToString:@""]) {
        return [self deleteBtnClick:range.location];
    }
    if (textView.text.length >100) {
        //        [[AppDelegate sharedAppDelegate] showTip:@"您的输入已达到最大限制！"];
        [JYHelpers showAlertWithTitle:@"您的输入已达到最大限制！"];
        return NO;
    }
    
    
    return YES;
}

@end
