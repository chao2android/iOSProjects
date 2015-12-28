//
//  RecordMsgLabel.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "RecordMsgLabel.h"

@implementation RecordMsgLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        
        mBackView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:mBackView];
        
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, mBackView.frame.size.height)];
        leftView.image = [UIImage imageNamed:@"f_msgback01"];
        [mBackView addSubview:leftView];
        
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(mBackView.frame.size.width-10, 0, 10, mBackView.frame.size.height)];
        rightView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        rightView.image = [UIImage imageNamed:@"f_msgback02"];
        [mBackView addSubview:rightView];
        
        UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, mBackView.frame.size.width-20, mBackView.frame.size.height)];
        centerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        centerView.image = [UIImage imageNamed:@"f_msgback03"];
        [mBackView addSubview:centerView];
        
        mlbTitle = [[UILabel alloc] initWithFrame:self.bounds];
        mlbTitle.backgroundColor = [UIColor clearColor];
        mlbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        mlbTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        mlbTitle.textAlignment = NSTextAlignmentCenter;
        mlbTitle.textColor = [UIColor whiteColor];
        [self addSubview:mlbTitle];
    }
    return self;
}

- (NSString *)text {
    return mlbTitle.text;
}

- (void)setText:(NSString *)text {
    BOOL bFirst = (!mlbTitle.text || mlbTitle.text.length == 0);
    if (!bFirst && [text isEqualToString:mlbTitle.text]) {
        return;
    }
    mlbTitle.text = text;
    float fWidth = MAX(KscreenHeigh, KscreenWidth)-100;
    NSDictionary *attribute = @{ NSFontAttributeName:mlbTitle.font };
    CGSize size = [mlbTitle.text boundingRectWithSize:CGSizeMake(fWidth, 35) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    if (!bFirst) {
        [UIView animateWithDuration:0.2 animations:^{
            mBackView.frame = CGRectMake((self.frame.size.width-size.width-40)/2, (self.frame.size.height-35)/2, size.width+40, 35);
        }];
    }
    else {
        mBackView.frame = CGRectMake((self.frame.size.width-size.width-40)/2, (self.frame.size.height-35)/2, size.width+40, 35);
    }
}

@end
