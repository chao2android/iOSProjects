//
//  EmoPopView.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-13.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "EmoPopView.h"

@implementation EmoPopView

@synthesize mEmoView, mlbName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"emopop.png"];
        mEmoView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-30)/2, 2, 30, 42)];
        [self addSubview:mEmoView];
        [mEmoView release];
        
        mlbName = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 12)];
        mlbName.backgroundColor = [UIColor clearColor];
        mlbName.font = [UIFont systemFontOfSize:10];
        mlbName.textAlignment = UITextAlignmentCenter;
        mlbName.textColor = [UIColor darkGrayColor];
        [self addSubview:mlbName];
        [mlbName release];
    }
    return self;
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
