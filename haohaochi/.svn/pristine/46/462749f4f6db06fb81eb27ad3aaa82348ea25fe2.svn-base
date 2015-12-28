//
//  ZYQTapAssetView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-26.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ZYQTapAssetView.h"

@interface ZYQTapAssetView ()

@property (nonatomic, retain) UIImageView *selectView;

@end

@implementation ZYQTapAssetView

static UIImage *checkedIcon;
static UIColor *selectedColor;
static UIColor *disabledColor;

+ (void)initialize
{
    checkedIcon     = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"f_selecticon"]]];
    selectedColor   = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.7];
    disabledColor   = [UIColor colorWithWhite:1 alpha:0.9];
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        _selectView=[[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-checkedIcon.size.width)/2, (frame.size.height-checkedIcon.size.height)/2, checkedIcon.size.width, checkedIcon.size.height)];
        [self addSubview:_selectView];
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_disabled) {
        return;
    }
    
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(shouldTap)]) {
        if (![_delegate shouldTap]&&!_selected) {
            return;
        }
    }
    
    if ((_selected=!_selected)) {
        self.backgroundColor=selectedColor;
        [_selectView setImage:checkedIcon];
        
        self.alpha = 0.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1.0;
            self.mImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.0;
            self.mImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL bFinish) {
            self.backgroundColor=[UIColor clearColor];
            [_selectView setImage:nil];
            self.alpha = 1.0;
        }];
    }
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(touchSelect:)]) {
        [_delegate touchSelect:_selected];
    }
}

-(void)setDisabled:(BOOL)disabled{
    _disabled=disabled;
    if (_disabled) {
        self.backgroundColor=disabledColor;
    }
    else{
        self.backgroundColor=[UIColor clearColor];
    }
}

-(void)setSelected:(BOOL)selected{
    if (_disabled) {
        self.backgroundColor=disabledColor;
        [_selectView setImage:nil];
        return;
    }
    
    _selected=selected;
    if (_selected) {
        self.backgroundColor=selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else{
        self.backgroundColor=[UIColor clearColor];
        [_selectView setImage:nil];
    }
}

@end

