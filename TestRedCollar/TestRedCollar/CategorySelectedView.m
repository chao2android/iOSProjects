//
//  CategorySelectedView.m
//  TestRedCollar
//
//  Created by MC on 14-8-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CategorySelectedView.h"
#import "TouchView.h"

@implementation CategorySelectedView

@synthesize mArray, miIndex, delegate, OnTypeSelect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)reloadColor{
    self.backgroundColor = self.Color;
}
- (void)dealloc {
    self.mArray = nil;
}

- (void)reloadData {
    if (mArray && mArray.count>0) {
        int iCount = mArray.count>5?5:mArray.count;
        int iWidth = self.frame.size.width/iCount;
        
        mLineView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, iWidth-10, self.frame.size.height-10)];
        mLineView.image = [UIImage imageNamed:@"category_sele_bg.png"];
        [self addSubview:mLineView];
        
        for (int i = 0; i < mArray.count; i ++) {
            TouchView *touchView = [[TouchView alloc] initWithFrame:CGRectMake(iWidth*i, 0, iWidth, self.frame.size.height)];
            touchView.delegate = self;
            touchView.tag = i+100;
            touchView.OnViewClick = @selector(OnBtnSelect:);
            [self addSubview:touchView];
            
            UILabel *lbText = [[UILabel alloc] initWithFrame:touchView.bounds];
            lbText.backgroundColor = [UIColor clearColor];
            lbText.font = [UIFont systemFontOfSize:12];
            lbText.textAlignment = UITextAlignmentCenter;
            lbText.textColor = [UIColor blackColor];
            lbText.text = [mArray objectAtIndex:i];
            lbText.tag = 1400;
            [touchView addSubview:lbText];
        }
        self.contentSize = CGSizeMake(iWidth*mArray.count, self.frame.size.height);
        int iLeft = miIndex*iWidth;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(iLeft, 0);
        if (iLeft+self.frame.size.width>self.contentSize.width) {
            iLeft = self.contentSize.width-self.frame.size.width;
        }
        self.contentOffset = CGPointMake(iLeft, 0);
        mLineView.transform = transform;
        [self RefreshView:miIndex];
    }
}

- (void)OnBtnSelect:(TouchView *)sender
{
    int index = sender.tag-100;
    [UIView animateWithDuration:0.2 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(sender.frame.origin.x, 0);
        mLineView.transform = transform;
    }];
    if (index != miIndex) {
    }
    miIndex = index;
    [self RefreshView:miIndex];
    if (delegate && OnTypeSelect) {
        [delegate performSelector:OnTypeSelect withObject:self];
    }
}

- (void)SelectType:(int)index {
    TouchView *touchView = (TouchView *)[self viewWithTag:index+100];
    if (touchView) {
        [self OnBtnSelect:touchView];
    }
}

- (void)RefreshView:(int)index {
    for (TouchView *view in self.subviews) {
        if ([view isKindOfClass:[TouchView class]]) {
            UILabel *lbText = (UILabel *)[view viewWithTag:1400];
            if (lbText) {
                lbText.textColor = (view.tag == index+100)?[UIColor whiteColor]:[UIColor darkGrayColor];
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
