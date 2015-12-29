//
//  CheckGoodsListCell.m
//  TestRedCollar
//
//  Created by MC on 14-7-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CheckGoodsListCell.h"
#import "NetImageView.h"
@implementation CheckGoodsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 90)];
    [self.contentView addSubview:img];
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 20)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:nameLabel];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 75, 120, 20)];
    priceLabel.textColor = WORDREDCOLOR;
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textAlignment = UITextAlignmentRight;
    [self.contentView addSubview:priceLabel];
    
    linkLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 45, 205, 20)];
    linkLabel.font = [UIFont systemFontOfSize:14];
    linkLabel.textColor = [UIColor darkGrayColor];
    linkLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:linkLabel];
    
    numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 75, 150, 20)];
    numberLabel.font = [UIFont systemFontOfSize:14];
    numberLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:numberLabel];
    
    
}
- (void)loadContent:(ShoppingCarModel *)model
{
    NetImageView *netView = [[NetImageView alloc]initWithFrame:img.bounds];
    netView.mImageType = TImageType_CutFill;
    [img addSubview:netView];
    [netView GetImageByStr:model.goods_image];
    
    nameLabel.text = model.goods_name;
    if ([model.is_diy intValue]==0) {
        linkLabel.text = [NSString stringWithFormat:@"尺码:%@",model.specification];
    }else{
        linkLabel.text = [NSString stringWithFormat:@"面料:%@",model.fabric];
    }
    
    numberLabel.text = [NSString stringWithFormat:@"数量: %d",model.quantity];
    
    float price = [model.price floatValue]*model.quantity;
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
