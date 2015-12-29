//
//  TJTopicHeadViewCell.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJTopicHeadViewCell.h"
#import "TJBBSCateSubModel.h"
#import "UIImageView+WebCache.h"


@interface TJTopicHeadViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;
@property (nonatomic, weak) IBOutlet UILabel     *topicTitle;
@property (nonatomic, weak) IBOutlet UILabel     *noteCount;
@property (nonatomic, weak) IBOutlet UIButton    *btnNotice;
@property (nonatomic, weak) TJBBSCateSubModel *item;


@end

@implementation TJTopicHeadViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)bindModel:(id)model
{
    _item = (TJBBSCateSubModel *)model;
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:_item.pic] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
    [self.topicTitle setText:_item.name];
    [self.noteCount setText:_item.count];

}
- (IBAction)pressTapNotice:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tapBoticeEvent:)]) {
        [self.delegate tapBoticeEvent:_item.subID];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
