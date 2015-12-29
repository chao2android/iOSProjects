//
//  MyCustomTableCell.m
//  TestRedCollar
//
//  Created by MC on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MyCustomTableCell.h"
@implementation MyCustomTableCell

@synthesize delegate, OnCustomSelect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
        //self.contentView.backgroundColor = [UIColor redColor];
        [self createUI];
    }
    return self;
}
- (void)createUI{
    _imgView1  = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, (self.contentView.frame.size.width-15)/2, 280-8)];
    _imgView1.userInteractionEnabled = YES;
    _imgView1.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imgView1];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnLeftClick)];
    [_imgView1 addGestureRecognizer:tap];
    
    _imgBg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _imgView1.frame.size.width, _imgView1.frame.size.height-95)];
    [_imgView1 addSubview:_imgBg1];
    
    _nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(8,_imgBg1.frame.size.height+3, _imgBg1.frame.size.width-16, 20)];
    _nameLabel1.backgroundColor = [UIColor clearColor];
    _nameLabel1.font = [UIFont systemFontOfSize:14.5];
    _nameLabel1.textColor = [UIColor darkGrayColor];
    [_imgView1 addSubview:_nameLabel1];
    
    _desLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(5, _imgBg1.frame.size.height+3+20, _imgView1.frame.size.width-10, 35)];
    _desLabel1.numberOfLines = -1;
    _desLabel1.backgroundColor = [UIColor clearColor];
    _desLabel1.font = [UIFont systemFontOfSize:12];
    _desLabel1.textColor = WORDGRAYCOLOR;
    [_imgView1 addSubview:_desLabel1];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, _desLabel1.frame.origin.y+_desLabel1.frame.size.height+3, 143, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    [_imgView1 addSubview:line1];
    
    UIImageView *favoriteView = [[UIImageView alloc]initWithFrame:CGRectMake(10, line1.frame.origin.y+line1.frame.size.height+5, 17, 17)];
    favoriteView.image = [UIImage imageNamed:@"s8_12.png"];
    [_imgView1 addSubview:favoriteView];
    
    _favLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30, line1.frame.origin.y+line1.frame.size.height+5, 50, 18)];
    _favLabel1.font = [UIFont systemFontOfSize:13];
    _favLabel1.textColor = WORDGRAYCOLOR;
    _favLabel1.backgroundColor = [UIColor clearColor];
    [_imgView1 addSubview:_favLabel1];
    
    _voluLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(80, line1.frame.origin.y+line1.frame.size.height+5, 65, 18)];
    _voluLabel1.font = [UIFont systemFontOfSize:13];
    _voluLabel1.textColor = WORDGRAYCOLOR;
    _voluLabel1.backgroundColor = [UIColor clearColor];
    [_imgView1 addSubview:_voluLabel1];
    
    _imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-15)/2+10, 5, (self.frame.size.width-15)/2, 280-8)];
    _imgView2.userInteractionEnabled = YES;
    _imgView2.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imgView2];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnRightClick)];
    [_imgView2 addGestureRecognizer:tap];
    
    _imgBg2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _imgView1.frame.size.width, _imgView1.frame.size.height-95)];
    [_imgView2 addSubview:_imgBg2];
    
    _nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(8, _imgBg2.frame.size.height+3, _imgBg2.frame.size.width-16, 20)];
    _nameLabel2.font = [UIFont systemFontOfSize:14.5];
    _nameLabel2.textColor = [UIColor darkGrayColor];
    _nameLabel2.backgroundColor = [UIColor clearColor];
    [_imgView2 addSubview:_nameLabel2];
    
    _desLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(5, _imgBg2.frame.size.height+3+20, _imgView2.frame.size.width-10, 35)];
    _desLabel2.numberOfLines = -1;
    _desLabel2.font = [UIFont systemFontOfSize:12];
    _desLabel2.textColor = WORDGRAYCOLOR;
    _desLabel2.backgroundColor = [UIColor clearColor];
    [_imgView2 addSubview:_desLabel2];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, _desLabel2.frame.origin.y+_desLabel2.frame.size.height+3, 143, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    [_imgView2 addSubview:line2];
    
    favoriteView = [[UIImageView alloc]initWithFrame:CGRectMake(10, line2.frame.origin.y+line1.frame.size.height+5, 17, 17)];
    favoriteView.image = [UIImage imageNamed:@"s8_12.png"];
    [_imgView2 addSubview:favoriteView];
    
    _favLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30, line2.frame.origin.y+line2.frame.size.height+5, 50, 18)];
    _favLabel2.font = [UIFont systemFontOfSize:13];
    _favLabel2.textColor = WORDGRAYCOLOR;
    _favLabel2.backgroundColor = [UIColor clearColor];
    [_imgView2 addSubview:_favLabel2];
    
    _voluLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(80, line2.frame.origin.y+line2.frame.size.height+5, 65, 18)];
    _voluLabel2.font = [UIFont systemFontOfSize:13];
    _voluLabel2.textColor = WORDGRAYCOLOR;
    _voluLabel2.backgroundColor = [UIColor clearColor];
    [_imgView2 addSubview:_voluLabel2];
    
    _netImg1 = [[NetImageView alloc]initWithFrame:CGRectMake(0, 0, _imgView1.frame.size.width, _imgView1.frame.size.height-95)];
    [_imgBg1 addSubview:_netImg1];
    
    _netImg2 = [[NetImageView alloc]initWithFrame:CGRectMake(0, 0, _imgView1.frame.size.width, _imgView1.frame.size.height-95)];
    [_imgBg2 addSubview:_netImg2];
}

- (void)OnLeftClick {
    self.miIndex = 0;
    if (delegate && OnCustomSelect) {
        SafePerformSelector(
                            [delegate performSelector:OnCustomSelect withObject:self]);
    }
}

- (void)OnRightClick {
    self.miIndex = 1;
    if (delegate && OnCustomSelect) {
        SafePerformSelector(
                            [delegate performSelector:OnCustomSelect withObject:self]);
    }
}

- (void)loadContent:(NSArray *)array
{
    if (array.count == 1) {
        [self loadContent1:array[0]];
    }
    else if (array.count == 2){
        GoodsListModel *model = array[0];
        [_netImg1 GetImageByStr:model.cst_image];
        
        _nameLabel1.text = model.cst_name;
        _desLabel1.text = model.cst_description;
        _favLabel1.text = model.cst_likes;
        _voluLabel1.text = [NSString stringWithFormat:@"限量:%@",model.cst_store];
        
        model = array[1];
        [_netImg2 GetImageByStr:model.cst_image];
        
        _nameLabel2.text = model.cst_name;
        _desLabel2.text = model.cst_description;
        _favLabel2.text = model.cst_likes;
        _voluLabel2.text = [NSString stringWithFormat:@"限量:%@",model.cst_store];
    }
}
- (void)loadContent1:(GoodsListModel *)model{
    [_netImg1 GetImageByStr:model.cst_image];
    
    _nameLabel1.text = model.cst_name;
    _desLabel1.text = model.cst_description;
    _favLabel1.text = model.cst_likes;
    _voluLabel1.text = [NSString stringWithFormat:@"限量:%@",model.cst_store] ;
}
- (void)loadContent2:(GoodsListModel *)model{
    [_netImg2 GetImageByStr:model.cst_image];
    
    _nameLabel2.text = model.cst_name;
    _desLabel2.text = model.cst_description;
    _favLabel2.text = model.cst_likes;
    _voluLabel2.text = [NSString stringWithFormat:@"限量:%@",model.cst_store];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
