//
//  LineLabelView.m
//  好妈妈
//
//  Created by Hepburn Alex on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "LineLabelView.h"

@implementation LineLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int iWidth = frame.size.width/3;
        
        for (int i = 0; i < 6; i ++) {
            int iXPos = i%3;
            int iYPos = i/3;
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(iXPos*iWidth, iYPos*14+6, 30, 2)];
            lineView.backgroundColor = [UIColor redColor];
            lineView.tag = 1000+i;
            [self addSubview:lineView];
            [lineView release];
            
            UILabel *lbText = [[UILabel alloc] initWithFrame:CGRectMake(iXPos*iWidth+35, iYPos*14, iWidth-35, 14)];
            lbText.backgroundColor = [UIColor clearColor];
            lbText.font = [UIFont systemFontOfSize:12];
            lbText.text = @"标签";
            lbText.tag = 2000+i;
            [self addSubview:lbText];
            [lbText release];
            [self ClearAllLabels];
        }
    }
    return self;
}

- (void)ClearAllLabels {
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
}

- (void)ShowLineLabel:(int)index name:(NSString *)name color:(UIColor *)color {
    UIView *lineView = [self viewWithTag:index+1000];
    UILabel *lbText = (UILabel *)[self viewWithTag:index+2000];
    if (lineView && lbText) {
        lineView.hidden = NO;
        lbText.hidden = NO;
        lineView.backgroundColor = color;
        lbText.textColor = color;
        lbText.text = name;
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
