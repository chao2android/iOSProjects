//
//  TJTopNoticeViewCell.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJTopNoticeViewCell.h"
#import "TJBBSTopTieBaModel.h"

@interface TJTopNoticeViewCell()

@property (nonatomic, weak) IBOutlet UILabel   *lblTop;
@property (nonatomic, weak) IBOutlet UILabel   *lblTitle;

@end

@implementation TJTopNoticeViewCell

- (void)awakeFromNib {
    // Initialization code
    [_lblTop.layer setMasksToBounds:YES];
    [_lblTop.layer setBorderWidth:1];
    [_lblTop.layer setBackgroundColor:COLOR(32, 141, 230, 1).CGColor];
    [_lblTop.layer setCornerRadius:10];
}

- (void)bindModel:(id)model
{
    TJBBSTopTieBaModel *item = (TJBBSTopTieBaModel *)model;
    [self.lblTitle setText:item.title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
