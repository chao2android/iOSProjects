//
//  TJPictureView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJPictureView.h"



@interface TJPictureView()<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
}
@property (nonatomic, strong)NSMutableArray *imageArrs;
@property (nonatomic, strong)NSMutableArray *saveImageView;

@end

@implementation TJPictureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _saveImageView = [[NSMutableArray alloc] init];
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
//    scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:scrollView];
    UILabel *lblAlter = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 21 -20, self.frame.size.width, 21)];
    [lblAlter setText:@"最多上传9张图片"];
    [lblAlter setFont:[UIFont systemFontOfSize:14]];
    [lblAlter setTextAlignment:NSTextAlignmentCenter];
    [lblAlter setTextColor:[UIColor grayColor]];
    [lblAlter setBackgroundColor:[UIColor clearColor]];
    [self addSubview:lblAlter];
    
}
- (void)refresPictureView:(NSArray *)lists
{
    self.imageArrs = (NSMutableArray *)lists;
    int imgNum = self.imageArrs.count;
//    int imgNum = 6;
    CGFloat  viewWidth =self.frame.size.height/2;
    scrollView.contentSize = CGSizeMake((viewWidth + 20) *imgNum, 0);
    CGFloat  viewY = self.frame.size.height/8;
    CGFloat  viewHeight = self.frame.size.height/2;
    for (int i = 0 ; i < imgNum; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i + 1)*(scrollView.contentSize.width - imgNum * viewWidth)/(imgNum +1) + i *viewWidth, viewY, viewWidth, viewHeight)];
        NSData *data = [self.imageArrs objectAtIndex:i];
        [imageView setImage:[UIImage imageWithData:data]];
        imageView.tag = 100 +i;
        [scrollView addSubview:imageView];
        [_saveImageView addObject:imageView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(viewWidth - 10, -10, 20, 20)];
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn.layer setMasksToBounds:YES];
        btn.layer.cornerRadius = 10;
        [btn setTitle:@"X" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = i;
        [imageView addSubview:btn];
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
            @strongify(self)
            
            [self.imageArrs removeObjectAtIndex:button.tag];
            UIImageView *imgView = (UIImageView *)[self.saveImageView objectAtIndex:button.tag];
            [imgView removeFromSuperview];
            [self.saveImageView removeObjectAtIndex:button.tag];
            if ([self.delegate respondsToSelector:@selector(removeImageView:)]) {
                [self.delegate removeImageView:button.tag];
            }
        }];
        
        
       
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
