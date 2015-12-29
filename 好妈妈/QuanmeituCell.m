//
//  QuanmeituCell.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "QuanmeituCell.h"

@implementation QuanmeituCell

@synthesize reuseIdentifier;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      CGRect bgFrame = CGRectInset(self.bounds, 0.0f, 0.0f);
      
      _picView_ = [[AsyncImageView alloc] initWithFrame:bgFrame];
      [self addSubview: _picView_];
      _picView_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      [_picView_ release];
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
