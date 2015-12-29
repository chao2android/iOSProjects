//
//  BottomDetailView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BottomDetailView.h"
#import "FansInfoViewController.h"
#import "CustomDetailViewController.h"

@implementation BottomDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.image = [UIImage imageNamed:@"f_botdetail"];
        self.userInteractionEnabled = YES;
        
        for (int i = 0; i < 6; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(52*i+5, 18, 50, 45);
            [btn addTarget:self action:@selector(OnUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15, 110+i*55, 50, 50);
            [btn addTarget:self action:@selector(OnUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(70, 110+i*55, self.frame.size.width-85, 50);
            [btn addTarget:self action:@selector(OnCustomBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        for (int i = 0; i < 4; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 260+i*45, 40, 40);
            [btn addTarget:self action:@selector(OnUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}


- (void)OnUserBtnClick {
    FansInfoViewController *ctrl = [[FansInfoViewController alloc] init];
    ctrl.isAdded = YES;
    NSLog(@"OnUserBtnClick");
    [self.mRootCtrl.navigationController pushViewController:ctrl animated:YES];
}

- (void)OnCustomBtnClick {
    CustomDetailViewController *ctrl = [[CustomDetailViewController alloc] init];
    NSLog(@"OnCustomBtnClick");
    [self.mRootCtrl.navigationController pushViewController:ctrl animated:YES];
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
