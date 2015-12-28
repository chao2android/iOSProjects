//
//  TypeSelectView.m
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "TypeSelectView.h"
#import "NewsPartInfo.h"
@implementation TypeSelectView

@synthesize mArray, miIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
    self.mArray = nil;
}

- (void)reloadData {
    @autoreleasepool {
        for (UIView *view in self.subviews) {
            if (view) {
                [view removeFromSuperview];
            }
        }
    }
    if (mArray && mArray.count>0) {
        int iCount = 0;
        if (mArray.count==5) {
            iCount = 5;
        }
        else if(mArray.count>5){
            iCount=6;
        }
        int iWidth = (SCREEN_WIDTH-SCREEN_WIDTH/6)/5;
        
        mLineView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 30, iWidth, 24)];
        mLineView.image = [UIImage imageNamed:@"news_top_1_108x45_@2x.png"];
        [self addSubview:mLineView];
        
        for (int i = 0; i < mArray.count; i ++) {
            NewsPartInfo *info = [NewsPartInfo CreateWithDict:mArray[i]];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+i*iWidth, 20, iWidth, 44);
            btn.tag = i+100;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(OnBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[NSString stringWithFormat:@"%@",info.name] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:btn];
        }
        self.contentSize = CGSizeMake(iWidth*mArray.count, self.frame.size.height);
        int iLeft = miIndex*iWidth;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(iLeft, 0);
//        if (iLeft+self.frame.size.width>self.contentSize.width) {
//            iLeft = self.contentSize.width-self.frame.size.width;
//        }
        self.contentOffset = CGPointMake(iLeft, 0);
        mLineView.transform = transform;
        [self RefreshView:miIndex];
    }
}

- (void)OnBtnSelect:(UIButton *)sender
{
    int index = sender.tag-100;
    [UIView animateWithDuration:0.2 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(sender.frame.origin.x-11, 0);
        mLineView.transform = transform;
    }];
    if (index != miIndex) {
        
    }
    NewsPartInfo *info = [NewsPartInfo CreateWithDict:mArray[index]];
    miIndex = index;
    [self.mDelegate TypeSelectViewSelectType:miIndex WithId:info.cid];
    [self RefreshView:miIndex];
}

- (void)SelectType:(int)index {
    UIButton *touchView = (UIButton *)[self viewWithTag:index+100];
    if (touchView) {
        [self OnBtnSelect:touchView];
    }
}

- (void)RefreshView:(int)index {
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn) {
                btn.selected = (btn.tag == index+100)?YES:NO;
            }
        }
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
