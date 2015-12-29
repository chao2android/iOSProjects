//
//  CommentListView.m
//  TestRedCollar
//
//  Created by MC on 14-9-2.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CommentListView.h"

@implementation CommentListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.commentLabel.numberOfLines = -1;
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
