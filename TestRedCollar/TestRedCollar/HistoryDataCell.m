//
//  HistoryDataCell.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "HistoryDataCell.h"

@implementation HistoryDataCell

@synthesize mImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.contentView.frame.size.width-20, 62)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        imageView.image = [UIImage imageNamed:@"68.png"];
        [self.contentView addSubview:imageView];
        
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, imageView.frame.size.width-40, 25)];
        lbName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lbName.backgroundColor = [UIColor clearColor];
        lbName.font = [UIFont systemFontOfSize:14];
        lbName.text = @"2014-03-03量体数据";
        [imageView addSubview:lbName];
        
        UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, imageView.frame.size.width-40, 25)];
        lbDesc.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lbDesc.backgroundColor = [UIColor clearColor];
        lbDesc.font = [UIFont systemFontOfSize:14];
        lbDesc.text = @"身高：172cm、体重：63kg、肩宽：46cm";
        [imageView addSubview:lbDesc];
        
        mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.size.width-30, 23, 15, 15)];
        mImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        mImageView.image = [UIImage imageNamed:@"53.png"];
        mImageView.hidden = YES;
        [imageView addSubview:mImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
