//
//  JYProfileEditGroupCell.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileEditGroupCell.h"
#import "JYGroupModel.h"

@implementation JYProfileEditGroupCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 15 - 15 - 17 - 10, self.height)];
        [_groupNameLabel setTextColor:kTextColorGray];
        [_groupNameLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_groupNameLabel];
        
        _selectedView = [[UIImageView alloc] initWithFrame:CGRectMake(_groupNameLabel.right+10, (self.height-14)/2, 17, 14)];
        [_selectedView setImage:[UIImage imageNamed:@"set_choose"]];
        [self addSubview:_selectedView];
    }
    return self;
}
- (void)relayoutSubviewsWithData:(JYGroupModel *)data{
    if ([data.show isEqualToString:@"0"]) {
        [_selectedView setHidden:NO];
    }else{
        [_selectedView setHidden:YES];
    }
    [_groupNameLabel setText:[NSString stringWithFormat:@"%@(%@人)",data.title,data.total]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
