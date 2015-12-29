//
//  CommentListCell.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CommentListCell.h"

@implementation CommentListCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mHeadView = [[NetImageView alloc] initWithFrame:CGRectMake(15, 7, 35, 35)];
        mHeadView.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
        mHeadView.layer.masksToBounds = YES;
        mHeadView.layer.cornerRadius = mHeadView.frame.size.width/2;
        [self.contentView addSubview:mHeadView];
        
        mlbName = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, self.contentView.frame.size.width-70, 20)];
        mlbName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mlbName.backgroundColor = [UIColor clearColor];
        mlbName.font = [UIFont systemFontOfSize:14];
        mlbName.textColor = [UIColor blackColor];
        mlbName.text = @"接盘侠";
        [self.contentView addSubview:mlbName];
        
        mlbDesc = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, self.contentView.frame.size.width-70, 20)];
        mlbDesc.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mlbDesc.backgroundColor = [UIColor clearColor];
        mlbDesc.font = [UIFont systemFontOfSize:12];
        mlbDesc.textColor = [UIColor blackColor];
        mlbDesc.text = @"呵呵呵额呵呵呵呵呵呵呵呵呵呵额额呵呵呵";
        [self.contentView addSubview:mlbDesc];
    }
    return self;
}

- (void)LoadContent:(CommentListModel *)model {
    [mHeadView GetImageByStr:model.avater];
    mlbName.text = model.nickname;
    mlbDesc.text = model.comment;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
