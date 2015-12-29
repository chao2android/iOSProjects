//
//  TJNoticeView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJNoticeView.h"
#import "UIImageView+WebCache.h"

@interface TJNoticeView()
{
    UITapGestureRecognizer *tapGesture;
    int  number;
    UILabel   *lblNum;
}

@end

@implementation TJNoticeView

- (instancetype)initWithFrame:(CGRect)frame withObjc:(id)Objc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        number = 3;
        tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tapGesture];
        [[tapGesture rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *tapGes){
            if ([self.delegate respondsToSelector:@selector(tapShowImageEvent:)]) {
                [self.delegate tapShowImageEvent:Objc];
            }
            
        }];
        [self buildSubView];
    }
    return self;
}

- (void)buildSubView
{

    lblNum = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - (self.frame.size.width - 90 * 3)/4 - 40,self.frame.size.height -30, 40, 25)];
    [lblNum setBackgroundColor:[UIColor blackColor]];
    [lblNum setTextColor:[UIColor whiteColor]];
    [lblNum setFont:[UIFont systemFontOfSize:12]];
    [lblNum setTextAlignment:NSTextAlignmentCenter];
    lblNum.alpha = 0.5;
    [self addSubview:lblNum];
    lblNum.hidden = YES;
    for (int i= 0; i <(number<3?number:3); i++) {
        
        TLog(@"%ld %ld",(long)number,(long)i);
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((i +1)*(self.frame.size.width - 90 * 3)/4 +90 *i,5,90,90)];
        [self addSubview:image];

        [image sd_setImageWithURL:[NSURL URLWithString:nil] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
        if (i==2) {
            lblNum.hidden = NO;
            [lblNum setText:@"共3张"];
            [self bringSubviewToFront:lblNum];
        }
        
        
    }
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
