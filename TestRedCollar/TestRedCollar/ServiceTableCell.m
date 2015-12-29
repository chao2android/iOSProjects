//
//  ServiceTableCell.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ServiceTableCell.h"
#import "NetImageView.h"
@implementation ServiceTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        mHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, 84, 67)];
        [self.contentView addSubview:mHeadView];
        
        mlbName = [[UILabel alloc] initWithFrame:CGRectMake(105, 6, self.contentView.frame.size.width-115, 20)];
        mlbName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mlbName.backgroundColor = [UIColor clearColor];
        mlbName.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:mlbName];
        
        for (int i = 0; i < 5; i ++) {
            UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(105+i*15, 35, 13, 13)];
            starView.image = [UIImage imageNamed:@"81.png"];
            [self.contentView addSubview:starView];
        }
        
        mlbAddress = [[UILabel alloc] initWithFrame:CGRectMake(105, 55, self.contentView.frame.size.width-115, 20)];
        mlbAddress.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mlbAddress.backgroundColor = [UIColor clearColor];
        mlbAddress.font = [UIFont systemFontOfSize:12];
        mlbAddress.textColor = [UIColor grayColor];
        [self.contentView addSubview:mlbAddress];
        
        mlbDistance = [[UILabel alloc] initWithFrame:CGRectMake(105, 55, self.contentView.frame.size.width-115, 20)];
        mlbDistance.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mlbDistance.backgroundColor = [UIColor clearColor];
        mlbDistance.font = [UIFont systemFontOfSize:12];
        mlbDistance.textColor = [UIColor grayColor];
        mlbDistance.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:mlbDistance];
    }
    return self;
}

- (void)LoadContent:(NSDictionary *)dict {
    NetImageView *netView = [[NetImageView alloc]initWithFrame:mHeadView.bounds];
    netView.mImageType = TImageType_CutFill;
    [mHeadView addSubview:netView];
    [netView GetImageByStr:[NSString stringWithFormat:@"%@%@",URL_HEADER,dict[@"organization_card"]]];
    
    NSLog(@"dict---->%@",dict);
    mlbName.text = [dict objectForKey:@"company_name"];

    mlbAddress.text = [NSString stringWithFormat:@"%@%@",[dict objectForKey:@"region_name"],[dict objectForKey:@"serve_address"]] ;
    //mlbDistance.text = [dict objectForKey:@"distance"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
