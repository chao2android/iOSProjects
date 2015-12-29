//
//  MaterialSelectView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MaterialSelectView.h"
#import "TouchView.h"

@implementation MaterialSelectView

@synthesize delegate, miIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        miIndex = 0;
        mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:mScrollView];
        
        int iWidth = 60;
        int iHeight = 38;
        
        CGPoint point = CGPointZero;
        NSArray *images = @[@"43.png", @"44.png", @"45.png", @"46.png"];
        for (int i = 0; i < 4; i ++) {
            NSString *imagename = [images objectAtIndex:i];
            TouchView *touchView = [[TouchView alloc] initWithFrame:CGRectMake(12+(iWidth+18)*i, (frame.size.height-iHeight)/2, iWidth, iHeight)];
            touchView.delegate = self;
            touchView.OnViewClick = @selector(OnMaterialSelect:);
            touchView.image = [UIImage imageNamed:imagename];
            touchView.tag = i+1000;
            [self addSubview:touchView];
            if (i == 0) {
                point = touchView.center;
            }
        }
        
        mCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 43)];
        mCoverView.center = CGPointMake(point.x+2, point.y+1);
        mCoverView.image = [UIImage imageNamed:@"42.png"];
        [self addSubview:mCoverView];
        
        mPopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 40)];
        mPopView.center = CGPointMake(point.x, -17);
        mPopView.image = [UIImage imageNamed:@"41.png"];
        [self addSubview:mPopView];
        
        UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, mPopView.frame.size.width-10, mPopView.frame.size.height-5)];
        lbDesc.backgroundColor = [UIColor clearColor];
        lbDesc.numberOfLines = 0;
        lbDesc.textColor = [UIColor whiteColor];
        lbDesc.font = [UIFont systemFontOfSize:7];
        lbDesc.text = @"编号：ZN_20056\r\n颜色：藏蓝\r\n价格：￥800";
        [mPopView addSubview:lbDesc];
    }
    return self;
}

- (void)OnMaterialSelect:(TouchView *)sender {
    miIndex = sender.tag-1000;
    CGPoint point = sender.center;
    mCoverView.center = CGPointMake(point.x+2, point.y+1);
    mPopView.center = CGPointMake(point.x, -17);
    mPopView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        mPopView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    if (delegate && [delegate respondsToSelector:@selector(OnMaterialSelect:)]) {
        [delegate OnMaterialSelect:self];
    }
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
