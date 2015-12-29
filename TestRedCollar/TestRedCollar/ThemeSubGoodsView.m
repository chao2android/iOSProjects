//
//  ThemeSubGoodsView.m
//  TestRedCollar
//
//  Created by MC on 14-7-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ThemeSubGoodsView.h"
#import "NetImageView.h"
@implementation ThemeSubGoodsView
{
    UIImageView *_seleImg;
}
@synthesize delegate,didSelected,designBtnClick,seleSize,showBiao;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)createUI
{
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bg.image = [UIImage imageNamed:@"theme_detail_subgoods_bg.png"];
    bg.userInteractionEnabled = YES;
    [self addSubview:bg];
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 8, 42, 55)];
    [self addSubview:imgView];
    UIImageView *imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(-0.5, -0.5, 43, 56)];
    imgBg.image = [UIImage imageNamed:@"theme_detail_goods_nor.png"];
    [imgView addSubview:imgBg];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 230, 20)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor darkGrayColor];
    [bg addSubview:nameLabel];
    
//    desLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 25, 230, 40)];
//    desLabel.numberOfLines = -1;
//    desLabel.font = [UIFont systemFontOfSize:14];
//    desLabel.textColor = [UIColor grayColor];
//    //    _desLabel.backgroundColor = [UIColor redColor];
//    [self addSubview:desLabel];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, 150, 20)];
    priceLabel.textColor = WORDREDCOLOR;
    priceLabel.font = [UIFont systemFontOfSize:14];
    [bg addSubview:priceLabel];
    
//    _seleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _seleBtn.frame = CGRectMake(imgView.frame.origin.x-0.3, imgView.frame.origin.y-0.3, imgView.frame.size.width+0.6, imgView.frame.size.height+0.6);
//    _seleBtn.backgroundColor = [UIColor redColor];
//    _seleBtn.selected = YES;
//    [_seleBtn setBackgroundImage:[UIImage imageNamed:@"theme_detail_selected.png"] forState:UIControlStateSelected];
//    [imgView addSubview:_seleBtn];
    
    
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    touchBtn.frame = CGRectMake(0, 0, self.frame.size.width, 69);
    [touchBtn addTarget:self action:@selector(seleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    touchBtn.tag = self.tag;
    [bg addSubview:touchBtn];
    
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.frame = CGRectMake(127, 83, 63, 20);
    [cBtn setTitle:@"尺码表" forState:UIControlStateNormal];
    [cBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[cBtn setBackgroundColor:[UIColor redColor]];
    cBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cBtn addTarget:self action:@selector(ShowChiBiao) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:cBtn];
    
    UIButton *designBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    designBtn.frame = CGRectMake(self.frame.size.width-90, 80, 68, 25);
    [designBtn setBackgroundImage:[UIImage imageNamed:@"theme_Detail_designBtn.png"] forState:UIControlStateNormal];
    designBtn.tag = self.tag;
    [designBtn addTarget:self action:@selector(designBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:designBtn];
    
    self.sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, 83, 80, 18)];
    self.sizeLabel.textColor = WORDGRAYCOLOR;
    self.sizeLabel.font = [UIFont systemFontOfSize:13];
    //self.sizeLabel.text = @"165/96A";
    self.backgroundColor = [UIColor clearColor];
    [bg addSubview:self.sizeLabel];
    
    UIImageView *btnSubImg = [[UIImageView alloc]initWithFrame:CGRectMake(100, 90, 11, 6.5)];
    btnSubImg.image = [UIImage imageNamed:@"sub_img.png"];
    [bg addSubview:btnSubImg];
    
    UIButton *sizeBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sizeBgBtn setBackgroundImage:[UIImage imageNamed:@"theme_detail_sizebtn_bg.png"] forState:UIControlStateNormal];
    sizeBgBtn.frame =CGRectMake(25, 80, 96.5, 25);
    [sizeBgBtn addTarget:self action:@selector(sizeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:sizeBgBtn];
}
- (void)ShowChiBiao{
    if (delegate && showBiao) {
        [delegate performSelector:showBiao withObject:self afterDelay:0];
    }
}
- (void)sizeBtnClick:(UIButton *)btn
{
    if (delegate && seleSize) {
        [delegate performSelector:seleSize withObject:self afterDelay:0];
    }
}



- (void)designBtnClick:(UIButton *)btn
{
    if (delegate && designBtnClick) {
        [delegate performSelector:designBtnClick withObject:[NSNumber numberWithInt:self.tag] afterDelay:0];
    }
}
- (void)loadContent:(SingleListModel *)model
{
    //[imgView setImageWithURL:[NSURL URLWithString:model.image]];
    NetImageView *netImg = [[NetImageView alloc]initWithFrame:imgView.bounds];
    netImg.mImageType = TImageType_CutFill;
    [imgView addSubview:netImg];
    [netImg GetImageByStr:model.image];
    
    _seleImg = [[UIImageView alloc]initWithFrame:CGRectMake(-0.3, -0.3, imgView.frame.size.width+0.6, imgView.frame.size.height+0.6)];
    _seleImg.image = [UIImage imageNamed:@"theme_detail_selected.png"];
    [imgView addSubview:_seleImg];
    
    nameLabel.text = model.name;
    //desLabel.text = model.des;
    priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self DealPrice:model.price ]];
}
- (float)DealPrice:(NSString *)priceString{
    float price = [priceString floatValue];
    if ((int)(price * 10)%10 >= 5) {
        price = (int)price + 1;
    }
    else{
        price = (int)price;
    }
    return price;
}

- (void)seleBtnClick:(UIButton *)sender
{
    NSLog(@"选中");
    _seleImg.hidden = !_seleImg.hidden;
    if (delegate && didSelected) {
        [delegate performSelector:didSelected withObject:self afterDelay:0];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
