//
//  ShopCarCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShopCarCell.h"
#import "NetImageView.h"
@implementation ShopCarCell
{
    UIButton *_addBtn;
    float _price;
}
@synthesize delegate,onDelete,onDesign,cutBtnClick,addBtnClick;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 110)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"3_14"];
        [self.contentView addSubview:backgroundImage];
        
        for (int i = 0; i < 2; i++)
        {
            UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 109*i, self.frame.size.width, 1)];
            lineImage.backgroundColor = [UIColor clearColor];
            lineImage.image = [UIImage imageNamed:@"51"];
            [backgroundImage addSubview:lineImage];
        }
        
        _sImage = [[UIImageView alloc] init];
        _sImage.frame = CGRectMake(15, 10, 70, 90);
        //_sImage.image = [UIImage imageNamed:@"my_17.png"];
        //_sImage.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_sImage];
        
        _sName = [[UILabel alloc] init];
        _sName.frame = CGRectMake(100, 10, 200, 20);
        _sName.font = [UIFont systemFontOfSize:14];
        //_sName.backgroundColor = [UIColor redColor];
        _sName.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_sName];
        
        _sPrice = [[UILabel alloc] init];
        _sPrice.frame = CGRectMake(240, 50, 80, 20);
        _sPrice.font = [UIFont systemFontOfSize:14.5];
        _sPrice.textColor = WORDREDCOLOR;
        _sPrice.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_sPrice];
        
        _sLining = [[UILabel alloc] init];
        _sLining.frame = CGRectMake(100, 30, 205, 20);
        _sLining.font = [UIFont systemFontOfSize:14];
        _sLining.backgroundColor = [UIColor clearColor];
        _sLining.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_sLining];
        
        UILabel *numberLaber = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 35, 20)];
        numberLaber.font = [UIFont systemFontOfSize:14];
        //numberLaber.backgroundColor = [UIColor redColor];
        numberLaber.text = @"数量:";
        numberLaber.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:numberLaber];
        
        
        _cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cutBtn setBackgroundImage:[UIImage imageNamed:@"cutBtn.png"] forState:UIControlStateSelected];
        [_cutBtn setBackgroundImage:[UIImage imageNamed:@"cutBtn_Sele.png"] forState:UIControlStateNormal];
        _cutBtn.frame = CGRectMake(138, 52, 20, 20);
        [_cutBtn addTarget:self action:@selector(CutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cutBtn];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"addBtn.png"] forState:UIControlStateNormal];
        _addBtn.frame = CGRectMake(180, 52, 20, 20);
        [_addBtn addTarget:self action:@selector(AddBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addBtn];
        
        
        _sNumber = [[UILabel alloc] init];
        _sNumber.frame = CGRectMake(165, 50, 150, 20);
        _sNumber.font = [UIFont systemFontOfSize:14];
        _sNumber.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_sNumber];
        
        _designBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _designBtn.frame = CGRectMake(100, 80, 65, 24.5);
        _designBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_designBtn setBackgroundImage:[UIImage imageNamed:@"car_design_.png"] forState:UIControlStateNormal];
        [_designBtn addTarget:self action:@selector(designGoods) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_designBtn];
        
        _deleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _deleBtn.frame = CGRectMake(180, 80, 65, 24.5);
        _deleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deleBtn setBackgroundImage:[UIImage imageNamed:@"car_dele.png"] forState:UIControlStateNormal];
        [_deleBtn addTarget:self action:@selector(deleteGoods) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleBtn];
    }
    return self;
}
- (void)CutBtnClick
{
    if (delegate&&cutBtnClick) {
        int value = [_sNumber.text intValue];
        if (value==2) {
            _cutBtn.selected = NO;
        }
        if (value==1) {
            return;
        }
        _sNumber.text = [NSString stringWithFormat:@"%d",value-1];
        _sPrice.text = [NSString stringWithFormat:@"￥%.2f",_price*[_sNumber.text intValue]];
        [delegate performSelectorOnMainThread:cutBtnClick withObject:self waitUntilDone:NO];
    }
}
- (void)AddBtnClick
{
    if (delegate&&addBtnClick) {
        [delegate performSelectorOnMainThread:addBtnClick withObject:self waitUntilDone:NO];
        int value = [_sNumber.text intValue];
        _sNumber.text = [NSString stringWithFormat:@"%d",value+1];
        _sPrice.text = [NSString stringWithFormat:@"￥%.2f",_price*[_sNumber.text intValue]];
        _cutBtn.selected = YES;
    }
}
- (void)designGoods
{
    if (delegate&&onDesign) {
        [delegate performSelectorOnMainThread:onDesign withObject:self waitUntilDone:NO];
    }
}
- (void)deleteGoods
{
    
    if (delegate&&onDelete) {
        [delegate performSelector:onDelete withObject:self afterDelay:0];
    }
}
- (void)LoadContent:(ShoppingCarModel *)model
{
    _sName.text = model.goods_name;
    _sPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    _sNumber.text = [NSString stringWithFormat:@"%d",model.quantity];
    if ([model.is_diy intValue]==0) {
        _sLining.text = [NSString stringWithFormat:@"尺码:%@",model.specification];
    }else{
        _sLining.text = [NSString stringWithFormat:@"面料:%@",model.fabric];
    }
    NetImageView *netImg = [[NetImageView alloc]initWithFrame:_sImage.bounds];
    netImg.mImageType = TImageType_CutFill;
    [_sImage addSubview:netImg];
    [netImg GetImageByStr:model.goods_image];
    _price = [model.price floatValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
