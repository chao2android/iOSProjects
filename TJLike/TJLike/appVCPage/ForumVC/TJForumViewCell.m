//
//  TJForumViewCell.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJForumViewCell.h"
#import "TJBbsCatagoryModel.h"
#import "TJBBSCateSubModel.h"
#import "UIImageView+WebCache.h"

@interface TJForumViewCell()

@property (nonatomic, weak) IBOutlet UIImageView  *posterImageView;
@property (nonatomic, weak) IBOutlet UILabel      *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel      *lblWord;


@end

@implementation TJForumViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindModel:(id)obj
{
    TJBBSCateSubModel *model = (TJBBSCateSubModel *)obj;
    [self.lblTitle setText:model.name];
    [self.lblWord setText:model.word];
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

@end
