//
//  TJTopicViewCell.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/2.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJTopicViewCell.h"
#import "TJBBSHotListModel.h"
#import "UIImageView+WebCache.h"

@interface TJTopicViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *posterImage;
@property (nonatomic, weak) IBOutlet UILabel     *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel     *lblContent;
@property (nonatomic, weak) IBOutlet UILabel     *lblDiscuss;

@end

@implementation TJTopicViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)bindModel:(id)item
{
    TJBBSHotListModel *model = (TJBBSHotListModel *)item;
    [self.posterImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
    [self.lblTitle setText:model.subtitle];
    [self.lblContent setText:model.font];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
