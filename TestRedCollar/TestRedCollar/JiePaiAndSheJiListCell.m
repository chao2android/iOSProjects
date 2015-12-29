//
//  JiePaiAndSheJiListCell.m
//  TestRedCollar
//
//  Created by dreamRen on 14-7-27.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "JiePaiAndSheJiListCell.h"
#import "NetImageView.h"
@implementation JiePaiAndSheJiListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}
- (void)createUI{
    _leftView = [[JiePaiAndSheJiView alloc]initWithFrame:CGRectMake(5, 0, 153, 192)];
    _leftView.delegate = self;
    _leftView.OnViewClick = @selector(buttonClick:);
    // _leftView.frame = CGRectMake(5, 0, 153, 192);
   // [ _leftView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
     _leftView.tag = 1;
    [self.contentView addSubview: _leftView];
    
    NSLog(@"home = %@",NSHomeDirectory());
    _rightView = [[JiePaiAndSheJiView alloc]initWithFrame:CGRectMake(163, 0, 153, 192)];
    _rightView.delegate = self;
    _rightView.OnViewClick = @selector(buttonClick:);
    //[_rightView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightView.tag = 2;
    [self.contentView addSubview:_rightView];
    
    

}
- (void)configCell:(CoolListModel *)leftModel And:(CoolListModel *)rightModel{
    
    @autoreleasepool {
        UIView *view = [_leftView viewWithTag:3];
        if (view) {
            [view removeFromSuperview];
        }
        UIView *view2 = [_rightView viewWithTag:4];
        if (view2) {
            [view removeFromSuperview];
        }
    }
    
        NetImageView *netImage = [[NetImageView alloc]initWithFrame: _leftView.bounds] ;
        netImage.mImageType = TImageType_CutFill;
        netImage.tag = 3;
    
        [netImage GetImageByStr:leftModel.url];
        [_leftView addSubview:netImage];
    
        NetImageView *rightImage = [[NetImageView alloc]initWithFrame:_rightView.bounds];
        rightImage.tag = 4;
        [rightImage GetImageByStr:rightModel.url];
        //[self.contentView addSubview:rightImage];
  
        [_rightView addSubview:rightImage];
    
}
- (void)buttonClick:(JiePaiAndSheJiView*)view {
    if (self.blockButtonClick) {
        self.blockButtonClick(view);
    }
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
