//
//  WriteTableViewCell.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/25.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "WriteTableViewCell.h"

@implementation WriteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self uiConfig];
    return self;
}

- (void)uiConfig{

    nameLabel = [DxyCustom creatLabelWithFrame:CGRectMake(33, 12, MainScreenWidth - 66, 12) text:@"匿名评论" alignment:NSTextAlignmentLeft];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = [UIColor colorWithRed:0/255.0 green:161/255.0 blue:224/255.0 alpha:1];
    [self addSubview:nameLabel];
    
    descriptionLabel = [DxyCustom creatLabelWithFrame:CGRectMake(33, 26, MainScreenWidth - 66, 40) text:@"那些曾经以为念念不忘的事情就在念念不忘的过程中被我们遗忘了" alignment:NSTextAlignmentLeft];
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.numberOfLines = 0;
    [self addSubview:descriptionLabel];
    
}


- (void)setUIConfigWithModel:(CommintModel *)model{
    if (model.commentInfo) {
        descriptionLabel.text = model.commentInfo;
        
        CGSize size =  [DxyCustom boundingRectWithString:model.commentInfo width:MainScreenWidth - 66 height:800 font:14];
        descriptionLabel.frame = CGRectMake(33, 26, MainScreenWidth - 66, size.height);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
