//
//  JYGroupView.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/8.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYGroupModel;
@interface JYGroupView : UIView

+ (JYGroupView *)groupViewWithModel:(JYGroupModel *)model andFrame:(CGRect)rect target:(id)target action:(SEL)action realData:(BOOL)isRealData;

@end
