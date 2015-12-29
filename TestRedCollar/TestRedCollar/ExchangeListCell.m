//
//  ExchangeListCell.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ExchangeListCell.h"

@implementation ExchangeListCell

- (void)awakeFromNib
{
    UITapGestureRecognizer *tTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoClick:)];
    [_theOneView addGestureRecognizer:tTap];
    
    tTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoClick:)];
    [_theOneView addGestureRecognizer:tTap];
    [_theTwoView addGestureRecognizer:tTap];
    
    tTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoClick:)];
    [_theOneView addGestureRecognizer:tTap];
    [_theThreeView addGestureRecognizer:tTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)infoClick:(UIGestureRecognizer*)aTapGes{
    NSInteger iTag=aTapGes.view.tag;
    
    if (_delegate && _onInfoClick) {

        [_delegate performSelector:_onInfoClick withObject:[NSNumber numberWithInteger:iTag]];
        
    }
}

- (IBAction)exchangeButtonClick:(id)sender {
    UIButton *tButton=(UIButton*)sender;
    UIView *tView=tButton.superview;
    
    if (_delegate && _onButtonClick) {
        [_delegate performSelector:_onButtonClick withObject:[NSNumber numberWithInteger:tView.tag]];
    }
}

-(void)resetInfoIndex:(NSInteger)aIndex list:(NSMutableArray*)aList{
    NSDictionary *dict=aList[aIndex];
    _theOneView.tag=aIndex;
    _theOneImageView.image=[UIImage imageNamed:dict[@"logo"]];
    _theOneNameLabel.text=dict[@"name"];
    _theOneCountLabel.text=dict[@"money"];
    if ([dict[@"isOver"] integerValue] != 0) {
        //可兑换
        [_theOneButton setImage:[UIImage imageNamed:@"147"] forState:UIControlStateNormal];
        _theOneButton.userInteractionEnabled=YES;
    }else{
        //兑换完了
        [_theOneButton setImage:[UIImage imageNamed:@"146"] forState:UIControlStateNormal];
        _theOneButton.userInteractionEnabled=NO;
    }
    
    aIndex++;
    if (aIndex <= aList.count-1) {
        _theTwoView.alpha=1.0;
    }else{
        _theTwoView.alpha=0.0;
        return;
    }
    dict=aList[aIndex];
    _theTwoView.tag=aIndex;
    _theTwoImageView.image=[UIImage imageNamed:dict[@"logo"]];
    _theTwoNameLabel.text=dict[@"name"];
    _theTwoCountLabel.text=dict[@"money"];
    if ([dict[@"count"] integerValue] != 0) {
        //可兑换
        [_theTwoButton setImage:[UIImage imageNamed:@"147"] forState:UIControlStateNormal];
        _theTwoButton.userInteractionEnabled=YES;
    }else{
        //兑换完了
        [_theTwoButton setImage:[UIImage imageNamed:@"146"] forState:UIControlStateNormal];
        _theTwoButton.userInteractionEnabled=NO;
    }
    
    aIndex++;
    if (aIndex <= aList.count-1) {
        _theThreeView.alpha=1.0;
    }else{
        _theThreeView.alpha=0.0;
        return;
    }
    dict=aList[aIndex];
    _theThreeView.tag=aIndex;
    _theThreeImageView.image=[UIImage imageNamed:dict[@"logo"]];
    _theThreeNameLabel.text=dict[@"name"];
    _theThreeCountLabel.text=dict[@"money"];
    if ([dict[@"count"] integerValue] != 0) {
        //可兑换
        [_theThreeButton setImage:[UIImage imageNamed:@"147"] forState:UIControlStateNormal];
        _theThreeButton.userInteractionEnabled=YES;
    }else{
        //兑换完了
        [_theThreeButton setImage:[UIImage imageNamed:@"146"] forState:UIControlStateNormal];
        _theThreeButton.userInteractionEnabled=NO;
    }
    
}

@end
