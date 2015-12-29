//
//  RootTableViewCell.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/23.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "RootTableViewCell.h"

@implementation RootTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self uiConfig];
    return self;
}

#pragma mark - UI布局
- (void)uiConfig{
    titleImageView = [[NetImageView alloc] initWithFrame:CGRectMake(8, 10, 76, 60)];
    titleImageView.mImageView.image = [UIImage imageNamed:@"39.png"];
    [self addSubview:titleImageView];
    
    titleLabel = [DxyCustom creatLabelWithFrame:CGRectMake(93, 10, MainScreenWidth - 103, 40) text:@"梦里花落知多少" alignment:NSTextAlignmentLeft];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.numberOfLines = 2;
    [self addSubview:titleLabel];
    
    //详情删掉了
    descriptionLabel = [DxyCustom creatLabelWithFrame:CGRectMake(93, 32, MainScreenWidth - 103, 40) text:@"我喜欢林岚，喜欢顾小北，我喜欢那里面每一个人物" alignment:NSTextAlignmentLeft];
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.numberOfLines = 2;
    descriptionLabel.textColor = [UIColor darkGrayColor];
    //[self addSubview:descriptionLabel];
    
    timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 108, 57, 10, 10)];
    timeImageView.image = [UIImage imageNamed:@"time.png"];
    [self addSubview:timeImageView];
    
    timeLabel = [DxyCustom creatLabelWithFrame:CGRectMake(MainScreenWidth - 100, 55, 90, 15 ) text:@"18个小时前" alignment:NSTextAlignmentRight];
    timeLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:timeLabel];
    
    audioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 37, 19, 19)];
    audioImageView.image = [UIImage imageNamed:@"audio.png"];
    [titleImageView addSubview:audioImageView];
    
    
    UIImageView  * hotImageView = [DxyCustom creatImageViewWithFrame:CGRectMake(170, 57, 7, 8) imageName:@"热度.png"];
    [self addSubview:hotImageView];
    
    hotLabel = [DxyCustom creatLabelWithFrame:CGRectMake(180, 55, 30, 15) text:@"" alignment:NSTextAlignmentLeft];
    hotLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:hotLabel];
    
}

- (void)setUIConfigWithModel:(ReDianModel *)model{
    
    [titleImageView GetImageByStr:model.thumb];
    if ([model.source_type isEqualToString:@"video"]) {
        audioImageView.hidden = NO;
    }else{
        audioImageView.hidden = YES;
    }
    hotLabel.text = model.pv;
    titleLabel.text = model.title;
    
    CGSize size =  [DxyCustom boundingRectWithString:model.title width:MainScreenWidth - 103 height:18000 font:16];
    titleLabel.frame = CGRectMake(93, 10, MainScreenWidth - 103, size.height);
    
    if (model.tags.length>25) {
        descriptionLabel.text = [NSString stringWithFormat:@"%@...",[model.tags substringToIndex:24]];
    }else{
        descriptionLabel.text = model.tags;
    }

    if ([DxyCustom isYestedayOrTodayWithTimeSp:model.ctime].length == 16) {
        [timeImageView setFrame:CGRectMake(MainScreenWidth - 108, 57, 10, 10)];

    }else if([[DxyCustom isYestedayOrTodayWithTimeSp:model.ctime] hasSuffix:@"前"]){
        [timeImageView setFrame:CGRectMake(MainScreenWidth - 68, 57, 10, 10)];
    
    }else{
        [timeImageView setFrame:CGRectMake(MainScreenWidth - 70, 57, 10, 10)];
    }    
    timeLabel.text = [DxyCustom isYestedayOrTodayWithTimeSp:model.ctime];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
