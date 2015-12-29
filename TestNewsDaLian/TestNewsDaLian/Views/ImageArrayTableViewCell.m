//
//  ImageArrayTableViewCell.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/23.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "ImageArrayTableViewCell.h"
#import "ImageModel.h"

@implementation ImageArrayTableViewCell

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
    titleLabel = [DxyCustom creatLabelWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 20) text:@"梦里花落知多少" alignment:NSTextAlignmentLeft];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:titleLabel];
    
    
    timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 73, 115, 10, 10)];
    timeImageView.image = [UIImage imageNamed:@"time.png"];
    
    [self addSubview:timeImageView];
    
    timeLabel = [DxyCustom creatLabelWithFrame:CGRectMake(MainScreenWidth - 100, 113, 90, 15 ) text:@"18个小时前" alignment:NSTextAlignmentRight];
    timeLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:timeLabel];
    
    
    
    UIImageView  * hotImageView = [DxyCustom creatImageViewWithFrame:CGRectMake(170, 116, 7, 8) imageName:@"热度.png"];
    [self addSubview:hotImageView];

    
    hotLabel = [DxyCustom creatLabelWithFrame:CGRectMake(180, 113, 30, 15) text:@"" alignment:NSTextAlignmentLeft];
    hotLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:hotLabel];
}

- (void)setUIConfigWithModel:(ReDianModel *)model{
    
    hotLabel.text = model.pv;

    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    NSArray * picturesArray = (NSArray *)model.pictures;
    for (NSDictionary * dict in picturesArray) {
        ImageModel * model = [[ImageModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [array addObject:model];
    }
    
    
    for (int i = 0; i<3; i++) {
        descriptionImageView = [[NetImageView alloc] initWithFrame:CGRectMake((MainScreenWidth - 96 * 3)/4 + (96 + (MainScreenWidth - 96 * 3)/4) * i, 35, 96, 76)];

        ImageModel * model = [array objectAtIndex:i];
        [descriptionImageView GetImageByStr:model.image];
        [self addSubview:descriptionImageView];
    }


    titleLabel.text = model.title;
    if ([DxyCustom isYestedayOrTodayWithTimeSp:model.ctime].length == 16) {
        [timeImageView setFrame:CGRectMake(MainScreenWidth - 108, 115, 10, 10)];
        
    }else if([[DxyCustom isYestedayOrTodayWithTimeSp:model.ctime] hasSuffix:@"前"]){
        [timeImageView setFrame:CGRectMake(MainScreenWidth - 68, 115, 10, 10)];
        
    }else{
        [timeImageView setFrame:CGRectMake(MainScreenWidth - 70, 115, 10, 10)];
    }
    timeLabel.text = [DxyCustom isYestedayOrTodayWithTimeSp:model.ctime];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
