//
//  JYGroupView.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/8.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGroupView.h"
#import "JYGroupModel.h"

@implementation JYGroupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (UIView *)groupViewWithModel:(JYGroupModel *)model andFrame:(CGRect)rect target:(id)target action:(SEL)action realData:(BOOL)isRealData{
    UIView *bgView = [[UIView alloc] initWithFrame:rect];
    
    UILabel *groupListTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 200, 20)];
    groupListTagLabel.textAlignment = NSTextAlignmentLeft;
    groupListTagLabel.backgroundColor = [UIColor clearColor];
    if (isRealData) {
        groupListTagLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    }else{
        [groupListTagLabel setTextColor:kTextColorLightGray];
    }
    groupListTagLabel.font = [UIFont systemFontOfSize:15];
    
    groupListTagLabel.text = model.title;
    [bgView addSubview:groupListTagLabel];

    //右边添加按钮 没有加入 则显示加入
    if ([model.join isEqualToString:@"0"]) {
        UIButton *addGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addGroupBtn setFrame:CGRectMake(kScreenWidth-35, groupListTagLabel.top+3, 15, 15)];
        addGroupBtn.backgroundColor = [UIColor clearColor];
        [addGroupBtn setBackgroundImage:[UIImage imageNamed:@"group_add"] forState:UIControlStateNormal];
        [addGroupBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:addGroupBtn];
    }
    
    //群组列表人数
    UILabel *groupListNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 105, groupListTagLabel.top, 60, 20)];
    groupListNumLabel.textAlignment = NSTextAlignmentRight;
    groupListNumLabel.backgroundColor = [UIColor clearColor];
    groupListNumLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    groupListNumLabel.font = [UIFont systemFontOfSize:15];
    NSString *text = ([model.total isEqualToString:@"0"] || model.total == nil) ? @"" : [NSString stringWithFormat:@"(%@人)",model.total];
//    NSLog(@"text = %@ %d",text,model.total);
    groupListNumLabel.text = text;
    [bgView addSubview:groupListNumLabel];

    UILabel  *groupListLine = [[UILabel alloc] initWithFrame:CGRectMake(0 ,  rect.size.height - 1, rect.size.width, 1)];
    groupListLine.layer.borderWidth = 1;
    groupListLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
    [bgView addSubview:groupListLine];
    return bgView;
}
@end
