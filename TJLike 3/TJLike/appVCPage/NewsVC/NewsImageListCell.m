//
//  NewsImageListCell.m
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsImageListCell.h"
#import "UIImageView+WebCache.h"
@implementation NewsImageListCell
{
    UILabel *mlbTitle;
    UILabel *mlbNums;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 154.5, SCREEN_WIDTH-20, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lineView];
        
        mlbTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 41.5)];
        mlbTitle.textAlignment = NSTextAlignmentLeft;
        mlbTitle.backgroundColor = [UIColor clearColor];
        mlbTitle.font = [UIFont systemFontOfSize:15.5];
        [self.contentView addSubview:mlbTitle];
        
        mlbNums = [[UILabel alloc]initWithFrame:CGRectMake(10, 118, SCREEN_WIDTH-20, 37)];
        mlbNums.textAlignment = NSTextAlignmentRight;
        mlbNums.backgroundColor = [UIColor clearColor];
        mlbNums.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:mlbNums];
    }
    return self;
}
- (void)LoadContent:(NewsListInfo *)info{
    mlbTitle.text = info.title;
    mlbNums.text = [NSString stringWithFormat:@"%d图  %d评",info.nums,info.comment];
    float iWidth = (SCREEN_WIDTH-32)/3;
    for (int i = 0; i<(info.nums<3?info.nums:3); i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*(iWidth+6), 41.5, iWidth, 76.5)];
        [self.contentView addSubview:image];
        [image sd_setImageWithURL:[NSURL URLWithString:info.tuwen[i][@"pic"]]];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
