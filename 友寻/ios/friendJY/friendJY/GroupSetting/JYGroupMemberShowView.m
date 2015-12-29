//
//  JYGroupMemberShowView.m
//  friendJY
//
//  Created by aaa on 15/6/3.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYGroupMemberShowView.h"
#import "UIImageView+WebCache.h"

@implementation JYGroupMemberShowView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)LoadContent:(NSArray *)headArray{
    
    @autoreleasepool {
        for (UIView *view in self.subviews) {
            if (view && [view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    
    float gap = self.frame.size.width/5;
    float width = 28;
    
//    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (headArray.count > 0) {
        for (int i = 0; i< headArray.count; i++) {
            if (i>4) {
                break;
            }
            if ([[headArray objectAtIndex:i] objectForKey:@"uid"]) {
                NSDictionary * temp = [[headArray objectAtIndex:i] objectForKey:@"avatars"] ;
                if(![JYHelpers isEmptyOfString:[temp objectForKey:@"150"]]){
                    UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*gap, 8, width, width)];
                    iv.clipsToBounds = YES;
                    iv.layer.masksToBounds = YES;
                    iv.layer.cornerRadius = width/2;
                    [iv sd_setImageWithURL:[NSURL URLWithString:[temp objectForKey:@"150"]]];
                    [self addSubview:iv];
                }
            }
            
            
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
