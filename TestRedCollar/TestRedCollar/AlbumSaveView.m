//
//  AlbumSaveView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AlbumSaveView.h"

@implementation AlbumSaveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = self.bounds;
        [backBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-235, self.frame.size.width-20, 235)];
        botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:botView];
        
        NSArray *array = @[@"48.png", @"49.png", @"49.png", @"50.png"];
        NSArray *names = @[@"", @"新建相册", @"默认相册", @"我创建的相册"];
        for (int i = 0; i < 4; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45*i, botView.frame.size.width, 45)];
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageNamed:[array objectAtIndex:i]];
            [botView addSubview:imageView];
            if (i == 0) {
                UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, imageView.frame.size.width, 34)];
                lbTitle.backgroundColor = [UIColor clearColor];
                lbTitle.font = [UIFont systemFontOfSize:16];
                lbTitle.textAlignment = UITextAlignmentCenter;
                lbTitle.text = @"添加到相册";
                [imageView addSubview:lbTitle];
            }
            else {
                UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, 1)];
                lineView.image = [UIImage imageNamed:@"51.png"];
                [imageView addSubview:lineView];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = imageView.bounds;
                [btn addTarget:self action:@selector(OnSaveClick:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:btn];
                
                UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 5, 34, 34)];
                flagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", 53+i]];
                [imageView addSubview:flagView];
                
                UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, imageView.frame.size.width-80, 34)];
                lbTitle.backgroundColor = [UIColor clearColor];
                lbTitle.font = [UIFont systemFontOfSize:16];
                lbTitle.text = [names objectAtIndex:i];
                [imageView addSubview:lbTitle];
                
                flagView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.size.width-17, (imageView.frame.size.height-12)/2, 7, 12)];
                flagView.image = [UIImage imageNamed:@"52.png"];
                [imageView addSubview:flagView];
            }
        }
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 185, botView.frame.size.width, 44);
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"47.png"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [botView addSubview:cancelBtn];
    }
    return self;
}

- (void)OnSaveClick:(UIButton *)sender {
    [self removeFromSuperview];
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
