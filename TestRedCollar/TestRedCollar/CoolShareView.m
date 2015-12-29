//
//  CoolShareView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolShareView.h"
#import "UMSocial.h"
@interface CoolShareView ()

@end

@implementation CoolShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = self.bounds;
        [backBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-215, self.frame.size.width, 215)];
        botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        botView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        [self addSubview:botView];

        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 30)];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.font = [UIFont systemFontOfSize:17];
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.text = @"分享这个搭配";
        [botView addSubview:lbTitle];

        int iWidth = self.frame.size.width/4;
        for (int i = 0; i < 4; i ++) {
            NSString *imagename = [NSString stringWithFormat:@"f_share%02d.png", i+1];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*iWidth, 60, iWidth, 73);
            btn.tag = i+1;
            [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(OnShareClick:) forControlEvents:UIControlEventTouchUpInside];
            [botView addSubview:btn];
        }

        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(10, 160, 300, 42);
        [cancelBtn setImage:[UIImage imageNamed:@"f_cancelbtn.png"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:cancelBtn];
    }
    return self;
}

- (void)OnShareClick:(UIButton*)button {
    if (self.shareBlock) {
        NSLog(@"%d",button.tag);
        self.shareBlock(button.tag);
    }
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
//
    self.hidden = YES;
  //  [self removeFromSuperview];
}

@end
