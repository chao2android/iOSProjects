//
//  AZXPhotoScrollView.m
//  imAZXiPhone
//
//  Created by coder_zhang on 14-9-10.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import "JYPhotoScrollView.h"
//#import "UIImageView+WebCache.h"
#import "JYPhotoTableView.h"
#import "UIView+ViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@implementation JYPhotoScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        //让图片等比例适应图片视图的尺寸
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        //设置最大放大倍数
        self.maximumZoomScale = 2.5;
        self.minimumZoomScale = 1.0;
        
        //隐藏滚动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.delegate = self;
        
        //单击手势
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap1];
        
        
        //双击放大缩小手势
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        //双击
        tap2.numberOfTapsRequired = 2;
        //手指的数量
        tap2.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap2];
        
        //tap1、tap2两个手势同时响应时，则取消tap1手势
        [tap1 requireGestureRecognizerToFail:tap2];
    }
    return self;
}

- (void)setUrl:(NSURL *)url
{
    if (_url != url) {
        _url = url;
    }
    
    _imageView.image = nil;
    [_imageView setImageWithURL:_url];
}

#pragma mark - UIScrollView delegate
// 返回需要缩放的子视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

// 手指离开屏幕时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    // 滚动到末尾 scrollView.contentOffset.x == self.contentSize.width-self.width
    //    NSLog(@"scrollView.contentOffset.x = %f",scrollView.contentOffset.x);
    //    NSLog(@"self.contentSize.width-self.width = %f",self.contentSize.width-self.width);
    
    NSInteger nextRow = self.row;
    
    float x = scrollView.contentOffset.x - (self.contentSize.width-self.width);
    if (scrollView.contentOffset.x < -30) {  //滚动左侧末尾
        //滑到上一页
        nextRow--;
    }
    else if(x > 30) {
        //滑到下一页
        nextRow++;
    }
    //判断是否滑动到上一页、下一页，如果是，则缩回当前页
    if (self.row != nextRow && (nextRow > 0 && nextRow < _tableView.data.count)) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nextRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        [self performSelector:@selector(setZoomScale:) withObject:@1.0 afterDelay:0.3];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    
    if (tap.numberOfTapsRequired == 1) {
        //显示、隐藏导航栏
//        UINavigationBar *navigationBar = self.viewController.navigationController.navigationBar;
//        BOOL isHide = navigationBar.isHidden;
//        [self.viewController.navigationController setNavigationBarHidden:!isHide animated:YES];
        // 显示状态栏

        [self.viewController dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];
        return;
    }
    else if(tap.numberOfTapsRequired == 2) {
        
        if (self.zoomScale > 1) {
            [self setZoomScale:1 animated:YES];
        } else {
            [self setZoomScale:2 animated:YES];
        }
        
    }
}

@end
