//
//  TJBBSHotsCommendCellTableViewCell.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/2.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBBSHotsCommendCell.h"
#import "TJBBSCommendModel.h"

#define BtnMargeTop (10)

@interface TJBBSHotsCommendCell()

@property (nonatomic, strong) UIButton *onceBtn;
@property (nonatomic, strong) UIButton *secendBtn;
@property (nonatomic, strong) UIButton *thirdBtn;
@property (nonatomic, strong) UIButton *fourBtn;
@property (nonatomic, strong) UILabel  *lblTop;
@property (nonatomic, strong) UILabel  *lblBottom;
@property (nonatomic, strong) UILabel  *lblCenter;


@end

@implementation TJBBSHotsCommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame= CGRectMake(0, 0, SCREEN_WIDTH, 80);
        [self buildUI];
        
    }
    return self;
    
}

- (void)buildUI
{
    _onceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_onceBtn setFrame:CGRectMake(0, BtnMargeTop, SCREEN_WIDTH/2, 40)];
    _onceBtn.tag = 0;
    _onceBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    _secendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_secendBtn setFrame:CGRectMake(_onceBtn.frame.size.width, BtnMargeTop, SCREEN_WIDTH/2, 40)];
    _secendBtn.tag = 1;
     _secendBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    _thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_thirdBtn setFrame:CGRectMake(0, _onceBtn.frame.size.height + BtnMargeTop, SCREEN_WIDTH/2, 40)];
    _thirdBtn.tag = 2;
    _thirdBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    _fourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fourBtn setFrame:CGRectMake(_onceBtn.frame.size.width, _onceBtn.frame.size.height + BtnMargeTop, SCREEN_WIDTH/2, 40)];
    _fourBtn.tag = 3;
     _fourBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    _onceBtn.backgroundColor =_secendBtn.backgroundColor = _thirdBtn.backgroundColor = _fourBtn.backgroundColor = COLOR(242, 244, 248, 1);
    [_onceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [_secendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [_thirdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [_fourBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_onceBtn setTitle:@"敬请期待 >_<" forState:UIControlStateNormal];
     [_secendBtn setTitle:@"敬请期待 >_<" forState:UIControlStateNormal];
     [_thirdBtn setTitle:@"敬请期待 >_<" forState:UIControlStateNormal];
     [_fourBtn setTitle:@"敬请期待 >_<" forState:UIControlStateNormal];
    [self addSubview:_onceBtn],[self addSubview:_secendBtn],[self addSubview:_thirdBtn],[self addSubview:_fourBtn];
    
    
    
    _lblTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.5, 26)];
    [_lblTop setBackgroundColor:COLOR(207, 208, 211, 1)];
    
    _lblBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.5, 26)];
    [_lblBottom setBackgroundColor:COLOR(207, 208, 211, 1)];
    
    _lblTop.center = CGPointMake(SCREEN_WIDTH/2, self.frame.size.height/4 + BtnMargeTop);
    _lblBottom.center = CGPointMake(SCREEN_WIDTH/2, self.frame.size.height* 3/4 +BtnMargeTop);
    _lblCenter = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 +BtnMargeTop, SCREEN_WIDTH, 0.5)];
     [_lblCenter setBackgroundColor:COLOR(207, 208, 211, 1)];
    
    [self addSubview:_lblBottom];
    [self addSubview:_lblTop];
    [self addSubview:_lblCenter];
    
    [[_onceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        if ([self.delegate respondsToSelector:@selector(pressHotRecommend:)]) {
            [self.delegate pressHotRecommend:_onceBtn.tag];
        }
        
        TLog(@"Tap _onceBtn");
    }];
    [[_secendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([self.delegate respondsToSelector:@selector(pressHotRecommend:)]) {
            [self.delegate pressHotRecommend:_secendBtn.tag];
        }
        TLog(@"Tap _secendBtn");
    }];
    [[_thirdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([self.delegate respondsToSelector:@selector(pressHotRecommend:)]) {
            [self.delegate pressHotRecommend:_thirdBtn.tag];
        }
        TLog(@"Tap _thirdBtn");
    }];
    [[_fourBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([self.delegate respondsToSelector:@selector(pressHotRecommend:)]) {
            [self.delegate pressHotRecommend:_fourBtn.tag];
        }
        TLog(@"Tap _fourBtn");
    }];
    
    
}

- (void)setUpButtonHid:(NSInteger)integer
{
    switch (integer) {
        case 0:
        {
            _onceBtn.hidden = _secendBtn.hidden = _thirdBtn.hidden = _fourBtn.hidden = YES;
            _lblBottom.hidden = _lblTop.hidden = _lblCenter.hidden = YES;
        }
            break;
        case 1:
        {
            _onceBtn.hidden = NO;
            _secendBtn.hidden = _thirdBtn.hidden = _fourBtn.hidden = YES;
            _lblBottom.hidden = _lblTop.hidden = _lblCenter.hidden = YES;
        }
            break;
        case 2:
        {
            _onceBtn.hidden = _secendBtn.hidden = NO;
            _thirdBtn.hidden = _fourBtn.hidden = YES;
            _lblBottom.hidden = _lblTop.hidden = _lblCenter.hidden = NO;
        }
            break;
        case 3:
        {
            _onceBtn.hidden = _secendBtn.hidden = _thirdBtn.hidden = NO;
            _lblBottom.hidden = _lblTop.hidden = _lblCenter.hidden = NO;
            _fourBtn.hidden = YES;
        }
            break;
        case 4:
        {
            _onceBtn.hidden = _secendBtn.hidden = _thirdBtn.hidden = _fourBtn.hidden = NO;
            _lblBottom.hidden = _lblTop.hidden = _lblCenter.hidden = NO;
        }
            break;
        default:
            break;
    }
}

-(void)bindModel:(id)item
{
    NSArray *models = (NSArray *)item;
    [self setUpButtonHid:models.count];
    if (models.count == 0) {
        return;
    }
    switch (models.count) {
        case 0:
            
            break;
        case 1:
        {
            TJBBSCommendModel *modelA = [models objectAtIndex:_onceBtn.tag];
            [_onceBtn setTitle:modelA.subtitle forState:UIControlStateNormal];
        }
            
            break;
        case 2:
        {
            TJBBSCommendModel *modelA = [models objectAtIndex:_onceBtn.tag];
            TJBBSCommendModel *modelB = [models objectAtIndex:_secendBtn.tag];
            [_onceBtn setTitle:modelA.subtitle forState:UIControlStateNormal];
            [_secendBtn setTitle:modelB.subtitle forState:UIControlStateNormal];
        }
            
            break;
        case 3:
        {
            TJBBSCommendModel *modelA = [models objectAtIndex:_onceBtn.tag];
            TJBBSCommendModel *modelB = [models objectAtIndex:_secendBtn.tag];
            TJBBSCommendModel *modelC = [models objectAtIndex:_thirdBtn.tag];
            [_onceBtn setTitle:modelA.subtitle forState:UIControlStateNormal];
            [_secendBtn setTitle:modelB.subtitle forState:UIControlStateNormal];
            [_thirdBtn setTitle:modelC.subtitle forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            TJBBSCommendModel *modelA = [models objectAtIndex:_onceBtn.tag];
            TJBBSCommendModel *modelB = [models objectAtIndex:_secendBtn.tag];
            TJBBSCommendModel *modelC = [models objectAtIndex:_thirdBtn.tag];
            TJBBSCommendModel *modelD = [models objectAtIndex:_fourBtn.tag];
            [_onceBtn setTitle:modelA.subtitle forState:UIControlStateNormal];
            [_secendBtn setTitle:modelB.subtitle forState:UIControlStateNormal];
            [_thirdBtn setTitle:modelC.subtitle forState:UIControlStateNormal];
            [_fourBtn setTitle:modelD.subtitle forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
  
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
