//
//  PopView.m
//  TestRedCollar
//
//  Created by MC on 14-7-25.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PopView.h"

@implementation PopView

@synthesize delegate,OnPopSelect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = self.bounds;
        backBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [backBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
    }
    return self;
}
- (void)loadContent:(NSArray *)dataArray withFrame:(CGRect)frame
{
    UIImageView *popView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 80, 25*dataArray.count)];
    popView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    popView.userInteractionEnabled = YES;
    [self addSubview:popView];
    
    for (int i =0; i<dataArray.count; i++) {
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, i*25, 70, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
        [popView addSubview:line];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5+i*25, 70, 20)];
        contentLabel.text = dataArray[i];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.tag = i;
        //contentLabel.backgroundColor = [UIColor redColor];
        [popView addSubview:contentLabel];
        contentLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnSelected:)];
        tap.view.tag = i;
        [contentLabel addGestureRecognizer:tap];
    }
}
- (void)OnSelected:(UITapGestureRecognizer *)sender
{
    if (delegate && OnPopSelect) {
        [delegate performSelectorOnMainThread:OnPopSelect withObject:[NSNumber numberWithInt:sender.view.tag] waitUntilDone:0];
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
