//
//  NewsCommentTitleCell.m
//  TJLike
//
//  Created by MC on 15/4/6.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsCommentTitleCell.h"

@interface NewsCommentTitleCell (){
    UILabel *mlbTitle;
}

@end

@implementation NewsCommentTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 30)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        
        mlbTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 30)];
        mlbTitle.backgroundColor = [UIColor clearColor];
        mlbTitle.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:mlbTitle];
        
    }
    return self;
}
- (void)LoadText:(NSString *)title{
    mlbTitle.text = title;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
