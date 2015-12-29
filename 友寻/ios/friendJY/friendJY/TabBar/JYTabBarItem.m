//
//  AZXTabBarItem.m
//  imAZXiPhone
//
//  Created by 高 斌 on 14-7-21.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYTabBarItem.h"

@implementation JYTabBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (id)initWithFrame:(CGRect)frame
        normalImage:(NSString *)normalImage
   highlightedImage:(NSString *)highlightedImage
              title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        _itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_itemImage setImage:[UIImage imageNamed:normalImage]];
        [_itemImage setHighlightedImage:[UIImage imageNamed:highlightedImage]];
        [self addSubview:_itemImage];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [_itemImage setHighlighted:YES];
    } else {
        [_itemImage setHighlighted:NO];
    }
    
}

@end
