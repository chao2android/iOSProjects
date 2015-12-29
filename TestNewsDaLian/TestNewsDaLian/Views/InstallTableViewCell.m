//
//  InstallTableViewCell.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/22.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "InstallTableViewCell.h"
#import "DxyCustom.h"
@implementation InstallTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self uiConfig];
    }
    return self;
}
#pragma mark - UI布局
- (void)uiConfig{
    imageView = [DxyCustom creatImageViewWithFrame:CGRectMake(15, 10, 24, 24) imageName:@""];
    [self addSubview:imageView];
    
    titleLabel = [DxyCustom creatLabelWithFrame:CGRectMake(55, 11, 220, 20) text:@"" alignment:NSTextAlignmentLeft];
    titleLabel.font = [UIFont systemFontOfSize:14.5];
    [self addSubview:titleLabel];

    //箭头
    _jiantouImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 23, 17, 6, 10)];
    _jiantouImageView.image = [UIImage imageNamed:@"rightJianTou.png"];
    [self addSubview:_jiantouImageView];
    
    _lineImageView = [DxyCustom creatImageViewWithFrame:CGRectMake(15, 44, MainScreenWidth - 30, 1) imageName:@"line.png"];
    [self addSubview:_lineImageView];
}

- (void)creatImageViewAndLabelWithImageString:(NSString*)imageName Title:(NSString *)titleName{
    imageView.image = [UIImage imageNamed:imageName];
    titleLabel.text = titleName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
