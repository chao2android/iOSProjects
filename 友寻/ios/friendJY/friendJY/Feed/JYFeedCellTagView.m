//
//  JYFeedCellTagView.m
//  friendJY
//
//  Created by aaa on 15/6/16.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYFeedCellTagView.h"

@implementation JYFeedCellTagView



- (float)LoadContent:(NSArray *)tagArray withWidth:(int) width{
    //去空
    NSMutableArray *mTagArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<tagArray.count; i++) {
        NSString *tag = tagArray[i];
        if (![JYHelpers isEmptyOfString:tag]) {
            [mTagArray addObject:tag];
        }
    }
    float iHeight = 0;//位置
    float iWidth = 0;//位置
    float allWidth = 0;//算是否越界
    for (int i = 0; i<mTagArray.count; i++) {
        NSString *tagStr = mTagArray[i];
        CGSize strSize = [JYHelpers getTextWidthAndHeight:tagStr fontSize:14 uiWidth:width];
        
        allWidth += strSize.width+30;
        
        if (allWidth>width) {
            iWidth = 0;
            iHeight += 35;
            allWidth = strSize.width+30;
        }
        
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(iWidth, iHeight, strSize.width+20, 30)];
        tagLabel.font = [UIFont systemFontOfSize:14];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.backgroundColor = [JYHelpers setFontColorWithString:@"#2695ff"];
        tagLabel.text = tagStr;
        [self addSubview:tagLabel];
        
        iWidth += strSize.width+30;
    }
    return iHeight+35;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
