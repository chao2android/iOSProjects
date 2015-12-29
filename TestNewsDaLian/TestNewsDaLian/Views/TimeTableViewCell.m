//
//  TimeTableViewCell.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/23.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "TimeTableViewCell.h"

@implementation TimeTableViewCell

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
    
    descriptionLabel = [DxyCustom creatLabelWithFrame:CGRectMake(93, 10, MainScreenWidth - 103, 40) text:@"我喜欢林岚，喜欢顾小北，我喜欢那里面每一个人物" alignment:NSTextAlignmentLeft];
    descriptionLabel.font = [UIFont systemFontOfSize:15];
    descriptionLabel.numberOfLines = 2;
    descriptionLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:descriptionLabel];

    UIImageView * timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 79, 48, 79, 19)];
    timeImageView.image = [UIImage imageNamed:@"blueBack.png"];
    [self addSubview:timeImageView];
    
    timeLabel = [DxyCustom creatLabelWithFrame:CGRectMake(20, 0, 60, 19) text:@"16:56" alignment:NSTextAlignmentLeft];
    timeLabel.textColor = [UIColor whiteColor];
    [timeImageView addSubview:timeLabel];
    
    audioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 37, 19, 19)];
    audioImageView.image = [UIImage imageNamed:@"audio.png"];
    [titleImageView addSubview:audioImageView];


}

- (void)setUIConfigWithModel:(ReDianModel *)model{
    
    [titleImageView GetImageByStr:model.thumb];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSArray * picturesArray = (NSArray *)model.pictures;
    for (NSDictionary * dict in picturesArray) {
        ImageModel * model = [[ImageModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [array addObject:model];
    }

    if ([model.source_type isEqualToString:@"picture"]) {
        ImageModel * model = [array firstObject];
        [titleImageView GetImageByStr:model.image];
    }
    if ([model.source_type isEqualToString:@"video"]) {
        audioImageView.hidden = NO;
    }else{
        audioImageView.hidden = YES;
    }

    
    descriptionLabel.text = model.title;
    CGSize size =  [DxyCustom boundingRectWithString:model.title width:MainScreenWidth - 103 height:18000 font:15];
    descriptionLabel.frame = CGRectMake(93, 10, MainScreenWidth - 103, size.height);
    

    timeLabel.text = [[DxyCustom getTimeWithTimeSp:model.ctime] substringFromIndex:11];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
