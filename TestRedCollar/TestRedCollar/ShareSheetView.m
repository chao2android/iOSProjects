//
//  ShareSheetView.m
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-18.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShareSheetView.h"
#import "AutoAlertView.h"

static ShareSheetView *gShareSheet = nil;

#define LL(x) x

@implementation ShareSheetView

@synthesize mImage, mContent, delegate, OnShareFinish;

- (id)initWithFrame:(CGRect)frame
{
    if (gShareSheet) {
        self = gShareSheet;
        if (self) {
            self.hidden = NO;
        }
        return self;
    }
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"ShareSheetView alloc");
        gShareSheet = self;
        self.mPlatforms = @[UMShareToSina, UMShareToTencent, UMShareToWechatSession, UMShareToWechatTimeline];
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
        [self addGestureRecognizer:tapGesture];
        
        [self shareViewAnimation];
    }
    return self;
}

- (void)removeFromSuperview {
    NSLog(@"ShareSheetView removeFromSuperview");
    gShareSheet = nil;
    [super removeFromSuperview];
}

- (void)dealloc {
    self.mImage = nil;
    self.mContent = nil;
}

- (void)OnThirdClick:(UIButton *)sender
{
    NSString *content = self.mContent;
    if (!content) {
        content = @"";
    }
    if (content.length>85) {
        content = [content substringToIndex:100];
        content = [content stringByAppendingString:@"… "];
    }
    if (self.mShareUrl) {
        NSString *urlstr = [self.mShareUrl stringByReplacingOccurrencesOfString:@"//" withString:@"//"];
        content = [content stringByAppendingFormat:@" %@", urlstr];
    }
    [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:self.mImage socialUIDelegate:self];
    
    int index = sender.tag-1300;
    NSString *platform = [self.mPlatforms objectAtIndex:index];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platform];
    snsPlatform.snsClickHandler(self.mRootCtrl,[UMSocialControllerService defaultControllerService],YES);
    self.hidden = YES;
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if (response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        [AutoAlertView ShowAlert:@"提示" message:@"分享成功"];
        if (delegate && OnShareFinish) {
            SafePerformSelector(
                                [delegate performSelector:OnShareFinish withObject:nil]
                                );
        }
    }
    else if (response.responseCode != UMSResponseCodeCancel) {
        [AutoAlertView ShowAlert:@"提示" message:@"分享失败"];
    }
    //[self removeFromSuperview];
}

- (NSArray *)GetIconList {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (NSString *name in self.mPlatforms) {
        if ([name isEqualToString:UMShareToSina]) {
            [array addObject:@"sina"];
        }
        else if ([name isEqualToString:UMShareToTencent]) {
            [array addObject:@"tencent"];
        }
        else if ([name isEqualToString:UMShareToRenren]) {
            [array addObject:@"renren"];
        }
        else if ([name isEqualToString:UMShareToQzone]) {
            [array addObject:@"qzone"];
        }
        else if ([name isEqualToString:UMShareToWechatSession]) {
            [array addObject:@"wx"];
        }
        else if ([name isEqualToString:UMShareToWechatTimeline]) {
            [array addObject:@"wxgroup"];
        }
        else if ([name isEqualToString:UMShareToQQ]) {
            [array addObject:@"qq"];
        }
        else if ([name isEqualToString:UMShareToLWSession]) {
            [array addObject:@"laiwang"];
        }
        else if ([name isEqualToString:UMShareToFacebook]) {
            [array addObject:@"facebook"];
        }
        else if ([name isEqualToString:UMShareToTwitter]) {
            [array addObject:@"twitter"];
        }
    }
    return array;
}

- (NSArray *)GetNameList {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (NSString *name in self.mPlatforms) {
        if ([name isEqualToString:UMShareToSina]) {
            [array addObject:LL(@"新浪微博")];
        }
        else if ([name isEqualToString:UMShareToTencent]) {
            [array addObject:LL(@"腾讯微博")];
        }
        else if ([name isEqualToString:UMShareToRenren]) {
            [array addObject:LL(@"人人网")];
        }
        else if ([name isEqualToString:UMShareToQzone]) {
            [array addObject:LL(@"QQ空间")];
        }
        else if ([name isEqualToString:UMShareToWechatSession]) {
            [array addObject:LL(@"微信")];
        }
        else if ([name isEqualToString:UMShareToWechatTimeline]) {
            [array addObject:LL(@"朋友圈")];
        }
        else if ([name isEqualToString:UMShareToQQ]) {
            [array addObject:LL(@"QQ")];
        }
        else if ([name isEqualToString:UMShareToLWSession]) {
            [array addObject:LL(@"来往")];
        }
        else if ([name isEqualToString:UMShareToFacebook]) {
            [array addObject:LL(@"Facebook")];
        }
        else if ([name isEqualToString:UMShareToTwitter]) {
            [array addObject:LL(@"Twitter")];
        }
    }
    return array;
}

- (void)shareViewAnimation
{
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-230, self.frame.size.width, 230)];
    shareView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    shareView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    [self addSubview:shareView];
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 30)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont systemFontOfSize:17];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.text = @"分享这个搭配";
    [shareView addSubview:lbTitle];
    
    int iTop = 30;
    int iWidth = 70;
    int iHeight = 104;
    
    int iOffset = (shareView.frame.size.width-iWidth*4)/5;
    int iLeft = iOffset;
    NSArray *array = [self GetIconList];
    NSArray *namearray = [self GetNameList];

    for (int i = 0; i < array.count; i ++) {
        NSString *imagename = [NSString stringWithFormat:@"shareicon_%@.png", [array objectAtIndex:i]];
        UIButton *sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebtn.frame = CGRectMake(iLeft, iTop, iWidth, iHeight);
        [sharebtn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        sharebtn.tag = i+1300;
        [sharebtn addTarget:self action:@selector(OnThirdClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:sharebtn];
        
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, sharebtn.frame.size.height-15, sharebtn.frame.size.width, 15)];
        lbName.backgroundColor = [UIColor clearColor];
        lbName.font = [UIFont systemFontOfSize:12];
        lbName.textAlignment = UITextAlignmentCenter;
        lbName.textColor = [UIColor darkGrayColor];
        lbName.text = [namearray objectAtIndex:i];
        [sharebtn addSubview:lbName];
        
        iLeft += (iWidth+iOffset);
        if (i == 3) {
            iLeft = iOffset;
            iTop += iHeight;
        }
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, shareView.frame.size.height-60, 300, 42);
    [cancelBtn setImage:[UIImage imageNamed:@"f_cancelbtn.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelBtn];
    [self MoveFromBottom:shareView duration:0.25];
}

- (void)MoveFromBottom:(UIView *)view duration:(float)duration {
    //根据i算时间
    CATransition *transition = [CATransition animation];
    transition.duration = duration;         /* 间隔时间*/
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; /* 动画的开始与结束的快慢*/
    transition.type = @"moveIn"; /* 各种动画效果*/
    transition.subtype = kCATransitionFromTop;
    [view.layer addAnimation:transition forKey:nil];
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
