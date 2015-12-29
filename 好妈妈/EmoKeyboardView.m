//
//  EmoKeyboardView.m
//  TestEmotion
//
//  Created by Hepburn Alex on 13-6-13.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "EmoKeyboardView.h"
#import "JSON.h"

@implementation EmoKeyboardView

@synthesize delegate, OnEmoSelect, OnSendClick;

- (id)initWithFrame:(CGRect)frame button:(BOOL)sender
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *emoArray = [EmoKeyboardView GetEmoArray];
        mEmoArray = [[NSArray alloc] initWithArray:emoArray];

        mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        mScrollView.delegate = self;
        mScrollView.pagingEnabled = YES;
        mScrollView.showsHorizontalScrollIndicator = NO;
        mScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:mScrollView];
        [mScrollView release];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sendBtn.frame = CGRectMake(self.frame.size.width-75, self.frame.size.height-40, 70, 38);
        sendBtn.hidden=sender;
        
        [sendBtn addTarget:self action:@selector(OnSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn setBackgroundImage:[UIImage imageNamed:@"emo_btnback.png"] forState:UIControlStateNormal];
        [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //sendBtn.hidden = YES;
        [self addSubview:sendBtn];
        
        int iWidth = mScrollView.frame.size.width/8;
        for (int i = 0; i < mEmoArray.count; i ++) {
            int iPage = i/24;
            int iXPos = (i%24)%8;
            int iYPos = (i%24)/8;
            NSDictionary *dict = [mEmoArray objectAtIndex:i];
            NSString *imagename = [dict objectForKey:@"face"];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(iXPos*iWidth+(iWidth-30)/2+iPage*mScrollView.frame.size.width, iYPos*50+27, 30, 30);
            [btn addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
            btn.tag = 200+i;
            [mScrollView addSubview:btn];
        }
        int iTotalPage = mEmoArray.count/24;
        if (mEmoArray.count%24>0) {
            iTotalPage ++;
        }
        mScrollView.contentSize = CGSizeMake(iTotalPage*mScrollView.frame.size.width, mScrollView.frame.size.height);
        
        mPointView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width, 20)];
        mPointView.numberOfPages = iTotalPage;
        mPointView.currentPage = 0;
        mPointView.userInteractionEnabled = NO;
        [self addSubview:mPointView];
        [mPointView release];
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int iPage = round(scrollView.contentOffset.x/scrollView.frame.size.width);
    mPointView.currentPage = iPage;
}

- (void)dealloc {
    [mEmoArray release];
    [super dealloc];
}

- (void)OnButtonClick:(UIButton *)sender {
    int index = sender.tag-200;
    NSDictionary *dict = [mEmoArray objectAtIndex:index];
    NSString *key = [dict objectForKey:@"tag"];
    if (delegate && OnEmoSelect) {
        [delegate performSelector:OnEmoSelect withObject:key];
    }
}

- (void)OnSendButtonClick:(UIButton *)sender {
    if (delegate && OnSendClick) {
        [delegate performSelector:OnSendClick withObject:self];
    }
}

+ (NSString *)GetEmoImage:(NSString *)name {
    NSArray *emoArray = [EmoKeyboardView GetEmoArray];
    for (int i = 0; i < emoArray.count; i ++) {
        NSString *key = [NSString stringWithFormat:@"&*%03d", i];
        if ([key isEqualToString:name]) {
            NSDictionary *dict = [emoArray objectAtIndex:i];
            NSString *imagename = [dict objectForKey:@"face"];
            return imagename;
        }
    }
    return nil;
}

+ (NSString *)FormatEmoText:(NSString *)text {
    NSMutableString *newstr = [NSMutableString stringWithString:text];

    NSArray *emoArray = [EmoKeyboardView GetEmoArray];
    for (int i = 0; i < emoArray.count; i ++) {
        NSString *key = [NSString stringWithFormat:@"&*%03d", i];
        NSDictionary *dict = [emoArray objectAtIndex:i];
        NSString *emoname = [dict objectForKey:@"tag"];
        [newstr replaceOccurrencesOfString:emoname withString:key options:NSCaseInsensitiveSearch range:NSMakeRange(0, newstr.length)];
    }
    
    return newstr;
}

+ (NSArray *)GetEmoArray {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"faces" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dict = [text JSONValue];
    return [dict objectForKey:@"faces"];
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
