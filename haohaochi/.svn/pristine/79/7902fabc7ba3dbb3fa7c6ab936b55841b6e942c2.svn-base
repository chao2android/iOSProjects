//
//  IfGownBtn.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "IfGownBtn.h"
#import "AutoAlertView.h"

@implementation IfGownBtn
{
    UILabel *mLabel;
    UIImageView *mView;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        mLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 53, 66)];
        //mLabel.userInteractionEnabled = YES;
        mLabel.textColor = [UIColor darkGrayColor];
        mLabel.textAlignment = NSTextAlignmentLeft;
        mLabel.font = [UIFont boldSystemFontOfSize:20];
        mLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:mLabel];
        
        mView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20, 26, 26)];
        [self addSubview:mView];
        
    }
    return self;
}

- (void)loadView:(NSString *)image :(NSString *)title :(BOOL)left {
    if (left) {
        mView.frame = CGRectMake(15, (self.frame.size.height-45)/2, 45, 45);
        mLabel.frame = CGRectMake(70, 0, self.frame.size.width-67, self.frame.size.height);
        mLabel.textAlignment = NSTextAlignmentLeft;
    }
    else {
        mView.frame = CGRectMake(self.frame.size.width-15-45, (self.frame.size.height-45)/2, 45, 45);
        mLabel.frame = CGRectMake(0, 0, self.frame.size.width-70, self.frame.size.height);
        mLabel.textAlignment = NSTextAlignmentRight;
    }
    mView.image = [UIImage imageNamed:image];
    mLabel.text = title;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
