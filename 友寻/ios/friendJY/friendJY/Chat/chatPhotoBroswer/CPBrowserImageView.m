//
//  SDBrowserImageView.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-6.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "CPBrowserImageView.h"
#import "UIImageView+WebCache.h"
#import "CPPhotoBrowserConfig.h"

@implementation CPBrowserImageView
{
    CPWaitingView *_waitingView;
    BOOL _didCheckSize;
    UIScrollView *_scroll;
    UIImageView *_scrollImageView;
    UIScrollView *_zoomingScroolView;
    UIImageView *_zoomingImageView;
    CGFloat _totalScale;
    
    int scaleOfWH;//宽高比
}


- (id)initWithFrame:(CGRect)frame
{ 
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _totalScale = 1.0;
        

    }
    return self;
}

- (BOOL)isScaled
{
    return  1.0 != _totalScale;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _waitingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scroll.backgroundColor = [UIColor whiteColor];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.delegate = self;
    
    _scroll.minimumZoomScale = 1.0;
    _scroll.maximumZoomScale = 2.0;
    
    _scroll.contentSize = CGSizeMake(kScreenWidth, self.image.size.height*(kScreenWidth/self.image.size.width));
    [self addSubview:_scroll];
    
    scaleOfWH = self.image.size.width/self.image.size.height;
    
    NSLog(@"---->%f----->%f",self.image.size.width/kScreenWidth,self.image.size.height);
    NSInteger postTop = 0;
    if (self.image.size.height*(kScreenWidth/self.image.size.width) < kScreenHeight) {
        postTop = (kScreenHeight - self.image.size.height*(kScreenWidth/self.image.size.width))/2;
    }
    if(self.image.size.width == 0 || self.image.size.height*(kScreenWidth/self.image.size.width) <kScreenHeight){
       _scrollImageView= [[UIImageView alloc]initWithFrame:self.bounds];
        _scrollImageView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
       _scrollImageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, postTop, kScreenWidth, self.image.size.height*(kScreenWidth/self.image.size.width))];
    }
    
    _scrollImageView.image = self.image;
//    _scrollImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scroll addSubview:_scrollImageView];
}



- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _waitingView.progress = progress;

}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    CPWaitingView *waiting = [[CPWaitingView alloc] init];
    waiting.bounds = CGRectMake(0, 0, 100, 100);
    waiting.mode = CPWaitingViewProgressMode;
    _waitingView = waiting;
    [self addSubview:waiting];
    
    
    __weak CPBrowserImageView *imageViewWeak = self;

    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        imageViewWeak.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [imageViewWeak removeWaitingView];
        
        if (error) {
            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, 160, 30);
            label.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
            label.text = @"图片加载失败";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [imageViewWeak addSubview:label];
        }
   
    }];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
//    if (self.image.size.height*(kScreenWidth/self.image.size.width) > kScreenHeight) {
//        _scrollImageView.center = CGPointMake(kScreenWidth/2, self.image.size.height*(kScreenWidth/self.image.size.width)/2);
//    }else{
//        _scrollImageView.center = _scroll.center;
//    }
    
    //NSLog(@"scrollViewDidZoom");
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //NSLog(@"viewForZoomingInScrollView");
    return _scrollImageView;
}


// 清除缩放
- (void)eliminateScale
{
     NSLog(@"--------");
    _scroll.zoomScale = 1.0;
}

- (void)removeWaitingView
{
    [_waitingView removeFromSuperview];
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com