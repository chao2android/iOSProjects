//
//  TJBaseNaviBarView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseNaviBarView.h"
#define NAVI_Button_Space_LeftEdge               8.0f
#define NAVI_Button_Space_RightEdge              5.0f
#define NAVI_Button_Space_Button                 10.0f

#define NAVI_Title_Frame                         CGRectMake(65.0f, 22.0f, 190.0f, 40.0f)
#define NAVI_Title_Size_Normal                   19.0f
#define NAVI_Title_RGB_Normal                    [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1]

#define NAVI_Button_Title_Size_Normal            17.0f
#define NAVI_Button_Title_Size_Mini              8.0f

@interface TJBaseNaviBarView ()

@property (nonatomic, readonly) UILabel *labelTitle;
@property (nonatomic, readonly) UIImageView *imgViewBg;
@property (nonatomic, readonly) UIButton *btnLeft;
@property (nonatomic, readonly) UIButton *btnRight;
@property (nonatomic, strong)   UIView *titleView;

@property (nonatomic, readonly) NSArray *leftButtonsArr;
@property (nonatomic, readonly) NSArray *rightButonsArr;
@property (nonatomic, readonly) NSArray *centerButonsArr;

@end

@implementation TJBaseNaviBarView

+ (UIButton *)createNaviBarBtnByTitle:(NSString *)strTitle imgNormal:(NSString *)strImg imgHighlight:(NSString *)strImgHighlight withFrame:(CGRect)fram
{
    return [[self class] createNaviBarBtnByTitle:strTitle imgNormal:strImg imgHighlight:strImgHighlight imgSelected:strImg withFrame:fram];
}

+ (UIButton *)createNaviBarBtnByTitle:(NSString *)strTitle imgNormal:(NSString *)strImg imgHighlight:(NSString *)strImgHighlight imgSelected:(NSString *)strImgSelected withFrame:(CGRect)fram
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (strTitle) {
        [btn setTitle:strTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:12/255.0 green:96/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:NAVI_Button_Title_Size_Normal];
    [self label:btn.titleLabel setMiniFontSize:NAVI_Button_Title_Size_Mini forNumberOfLines:1];
    
    if (strImg) {
        UIImage *imgNormal = [UIImage imageNamed:strImg];
        [btn setImage:imgNormal forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:(strImgHighlight ? strImgHighlight : strImg)] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:(strImgSelected ? strImgSelected : strImg)] forState:UIControlStateSelected];
    }
    
    
    btn.frame = fram;
    
    return btn;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _labelTitle = [[UILabel alloc] initWithFrame:self.bounds];
    _labelTitle.backgroundColor = [UIColor clearColor];
    _labelTitle.textColor = NAVI_Title_RGB_Normal;
    _labelTitle.font = [UIFont systemFontOfSize:NAVI_Title_Size_Normal];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    
    _imgViewBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _leftButtonsArr = [[NSArray alloc] init];
    _rightButonsArr = [[NSArray alloc] init];
    _centerButonsArr = [[NSArray alloc] init];
    
    [self addSubview:_imgViewBg];
    [self addSubview:_labelTitle];
    
}

+ (CGRect)titleViewFrame
{
    return NAVI_Title_Frame;
}

+ (CGSize)barSize
{
    return CGSizeMake(SCREEN_WIDTH, NAVIBAR_HEIGHT + STATUSBAR_HEIGHT);
}

- (void)setTitle:(NSString *)strTitle
{
    [_labelTitle setText:strTitle];
}

- (void)setTitleStyle:(NSDictionary *)styleDict
{
    [_labelTitle setTextColor:[styleDict objectForKey:NAVTITLE_COLOR_KEY]];
    [_labelTitle setFont:[styleDict objectForKey:NAVTITLE_FONT_KEY]];
}

-(void)setTitleView:(UIView *)view
{
    if (_titleView)
    {
        [_titleView removeFromSuperview];
        _titleView = nil;
    }else{}
    
    _titleView = view;
    if (_titleView)
    {
        _titleView.center = CGPointMake(SCREEN_WIDTH/2, NAVIBAR_HEIGHT/2);
        [self addSubview:_titleView];
    }else{}
    
}

- (void)setBackgroundImageView:(UIImageView *)imageView
{
    _imgViewBg = imageView;
}

- (void)setLeftBtn:(id )leftItem
{
    if (_btnLeft)
    {
        [_btnLeft removeFromSuperview];
        _btnLeft = nil;
    }else{}
    if (_leftButtonsArr.count) {
        for (UIView *but in _leftButtonsArr) {
            [but removeFromSuperview];
            _leftButtonsArr = nil;
        }
    }else{}
    
    _btnLeft = leftItem;
    
    if (_btnLeft)
    {
        _btnLeft.center = CGPointMake(NAVI_Button_Space_LeftEdge + _btnLeft.frame.size.width/2, NAVIBAR_HEIGHT/2);
        [self addSubview:_btnLeft];
    }else{}
}
- (void)setRightBtn:(id)rightItem
{
    if (_btnRight)
    {
        [_btnRight removeFromSuperview];
        _btnRight = nil;
    }else{}
    if (_rightButonsArr.count) {
        for (UIView *but in _rightButonsArr) {
            [but removeFromSuperview];
            _rightButonsArr = nil;
        }
    }else{}
    
    _btnRight = rightItem;
    if (_btnRight)
    {
        _btnRight.center = CGPointMake(SCREEN_WIDTH - NAVI_Button_Space_RightEdge - _btnRight.frame.size.width/2, NAVIBAR_HEIGHT/2);
        [self addSubview:_btnRight];
    }else{}
}

- (void)setLeftBtnsWithButtonArray:(NSArray *)leftButArr
{
    if (_btnLeft)
    {
        [_btnLeft removeFromSuperview];
        _btnLeft = nil;
    }else{}
    if (_leftButtonsArr.count) {
        for (UIView *but in _leftButtonsArr) {
            [but removeFromSuperview];
        }
    }else{}
    
    _leftButtonsArr = leftButArr;
    if (_leftButtonsArr.count) {
        float oriX = NAVI_Button_Space_LeftEdge;
        for (UIView *but in _leftButtonsArr) {
            but.center = CGPointMake(oriX + but.frame.size.width/2, NAVIBAR_HEIGHT/2);
            [self addSubview:but];
            oriX = but.center.x + but.frame.size.width/2 + NAVI_Button_Space_Button;
        }
    }else{}
}
- (void)setRightBtnsWithButtonArray:(NSArray *)rightButArr
{
    if (_btnRight)
    {
        [_btnRight removeFromSuperview];
        _btnRight = nil;
    }else{}
    if (_rightButonsArr.count) {
        for (UIView *but in _rightButonsArr) {
            [but removeFromSuperview];
        }
    }else{}
    
    _rightButonsArr = rightButArr;
    if (_rightButonsArr.count) {
        float oriX = SCREEN_WIDTH - NAVI_Button_Space_RightEdge;
        for (UIView *but in _rightButonsArr) {
            but.center = CGPointMake(oriX - but.frame.size.width/2, NAVIBAR_HEIGHT/2);
            [self addSubview:but];
            oriX = but.center.x - but.frame.size.width/2 - NAVI_Button_Space_Button;
        }
    }else{}
}

- (void)setCenterBtn:(NSArray *)btnLists
{
    if (_btnRight)
    {
        [_btnRight removeFromSuperview];
        _btnRight = nil;
    }else{}
    if (_centerButonsArr.count) {
        for (UIView *but in _centerButonsArr) {
            [but removeFromSuperview];
        }
    }else{}
    _centerButonsArr = btnLists;
    if (_centerButonsArr.count) {
        UIButton *btn = (UIButton *)[_centerButonsArr lastObject];
        float oriX = SCREEN_WIDTH/2 - btn.frame.size.width/2 -15;
        for (int i = 0;i< _centerButonsArr.count;i++) {
            UIView *but = [_centerButonsArr objectAtIndex:i];
            but.center = CGPointMake(oriX, NAVIBAR_HEIGHT/2);
            [self addSubview:but];
            oriX = but.center.x + but.frame.size.width/2 + 35;
        }
    }else{}
}

- (void)hideCenterBtnView
{
    if (_centerButonsArr) {
        [self setCenterBtn:nil];
    }
}


- (void)hideOriginalBarItem:(BOOL)bIsHide
{
    if (_btnLeft)
    {
        [self setLeftBtn:nil];
    }else{}
    if (_btnRight)
    {
        [self setRightBtn:nil];
    }else{}
    if (_labelTitle)
    {
        [self setTitle:@""];
    }else{}
    if (_imgViewBg)
    {
        [self setBackgroundImageView:nil];
    }else{}
    if (_leftButtonsArr) {
        [self setLeftBtnsWithButtonArray:nil];
    }else{}
    if (_rightButonsArr) {
        [self setRightBtnsWithButtonArray:nil];
    }else{}
    if (_centerButonsArr) {
        [self setCenterBtn:nil];
    }
    else{}
}

// label设置最小字体大小
+ (void)label:(UILabel *)label setMiniFontSize:(CGFloat)fMiniSize forNumberOfLines:(NSInteger)iLines
{
    if (label)
    {
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = fMiniSize/label.font.pointSize;
        
    }else{}
}
@end
