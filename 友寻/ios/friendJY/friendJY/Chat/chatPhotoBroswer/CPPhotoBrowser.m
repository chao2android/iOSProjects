//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "CPPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "CPBrowserImageView.h"
#import "JYProfileShareView.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
//#import "JYShareContentModel.h"

//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "CPPhotoBrowserConfig.h"

//  =============================================

@implementation CPPhotoBrowser
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
    UINavigationItem * navigationBarTitle;
    UINavigationBar *navigationBar;
    JYProfileShareView *shareView;
    UIActionSheet *photoHandleSheet;
    UIActionSheet *reportUserSheet;
    UIPageControl *pageControl;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CPPhotoBrowserBackgrounColor;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)setupToolbars
{
    // 1. 序标
//    UILabel *indexLabel = [[UILabel alloc] init];
//    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
//    indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 30);
//    indexLabel.textAlignment = NSTextAlignmentCenter;
//    indexLabel.textColor = [UIColor whiteColor];
//    indexLabel.font = [UIFont boldSystemFontOfSize:20];
//    indexLabel.backgroundColor = [UIColor clearColor];
//    if (self.imageCount > 1) {
//        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
//    }
//    _indexLabel = indexLabel;
//    [self addSubview:indexLabel];
    
//    // 2.保存按钮
//    UIButton *saveButton = [[UIButton alloc] init];
//    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
//    saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
//    saveButton.layer.cornerRadius = 5;
//    saveButton.clipsToBounds = YES;
//    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    _saveButton = saveButton;
//    [self addSubview:saveButton];
    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, kNavigationBarHeight+kStatusBarHeight)];
//    
//    //创建UINavigationItem
//    navigationBarTitle = [[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"1/%ld", (long)self.imageCount]];
//    [navigationBar pushNavigationItem:navigationBarTitle animated:YES];
//    
//    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.backgroundColor = [UIColor clearColor];
//    [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
//    [leftButton setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
//    //[leftButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(_navLeftTopButton) forControlEvents:UIControlEventTouchUpInside];
//    leftButton.frame = CGRectMake(0, 0, 60, 44);
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    navigationBarTitle.leftBarButtonItem = item;
//    
//    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    navRightBtn.backgroundColor = [UIColor clearColor];
//    [navRightBtn setFrame:CGRectMake(0, 0, 50, 10)];
//    [navRightBtn setImage:[UIImage imageNamed:@"profile_tag_more"] forState:UIControlStateNormal];
//    [navRightBtn addTarget:self action:@selector(_navRightTopButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *navBarButton = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
//    navigationBarTitle.rightBarButtonItem = navBarButton;
    
    shareView = [[JYProfileShareView alloc] init];
    [shareView setFromSDBrower:self];
    [self addSubview:shareView];
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = CPPhotoBrowserSaveImageFailText;
    }   else {
        label.text = CPPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollView];
    
    [_scrollView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)]];
    
    
    for (int i = 0; i < self.imageCount; i++) {
        
        CPBrowserImageView *imageView = [[CPBrowserImageView alloc] init];
        imageView.tag = i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
    if(_imageCount > 1){
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2, kScreenHeight-10 -kTabBarViewHeight, 120, 15)];
        [pageControl setCurrentPage:0];
        pageControl.pageIndicatorTintColor = RGBACOLOR(195, 179, 163, 1);
        pageControl.currentPageIndicatorTintColor = RGBACOLOR(132, 104, 77, 1);
        pageControl.numberOfPages = _imageCount;//指定页面个数
        [pageControl setBackgroundColor:[UIColor clearColor]];
        //    pageControl.hidden = YES;
        [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [self addSubview:pageControl];
    }
}

//pagecontroll的委托方法
- (void)changePage:(id)sender
{
    NSLog(@"%ld", (long)pageControl.currentPage);
    NSInteger page = pageControl.currentPage;//获取当前pagecontroll的值
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    //[_emojiBg setContentOffset:CGPointMake(kScreenWidth * page, 0)];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    CPBrowserImageView *imageView = _scrollView.subviews[index];
    UIImage * placeholderImage = [self placeholderImageForIndex:index];
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:placeholderImage];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    
    CPBrowserImageView *currentImageView = (CPBrowserImageView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    [self hidenPhotoLayer:currentIndex];
}

- (void) hidenPhotoLayer:(NSInteger) cindex{
    _scrollView.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    CPBrowserImageView *currentImageView = _scrollView.subviews[cindex];
    UIView *sourceView;
    
    if ([self.sourceImagesContainerView isKindOfClass:[UICollectionView class]]) {
        sourceView = [((UICollectionView*)self.sourceImagesContainerView) cellForItemAtIndexPath:[NSIndexPath indexPathForItem:cindex inSection:0]];
    }else{
        sourceView = self.sourceImagesContainerView.subviews[cindex];
    }
    
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];

    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    
    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    if (currentImageView.image.size.height*(kScreenWidth/currentImageView.image.size.width) > kScreenHeight) {
        tempView.center = CGPointMake(kScreenWidth/2,currentImageView.image.size.height*(kScreenWidth/currentImageView.image.size.width)/2);
    }else{
        tempView.center = self.center;
    }
//    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    
    [self addSubview:tempView];

    _saveButton.hidden = YES;
    
    [UIView animateWithDuration:CPPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += CPPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - CPPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height - CPPhotoBrowserImageViewMargin * 2;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(CPBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = CPPhotoBrowserImageViewMargin + idx * (CPPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    _scrollView.pagingEnabled = YES;
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)showFirstImage
{
    
    
    UIView *sourceView;
    
    if ([self.sourceImagesContainerView isKindOfClass:[UICollectionView class]]) {
        sourceView = [((UICollectionView*)self.sourceImagesContainerView) cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentImageIndex inSection:0]];
    }else{
        sourceView = self.sourceImagesContainerView.subviews[_currentImageIndex];
    }
    
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImage * placeholderImage = [self placeholderImageForIndex:self.currentImageIndex];
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = placeholderImage;
    tempView.clipsToBounds = YES;
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:tempView ];
    //[tempView sendSubviewToBack:navigationBar];
//    [self addSubview:navigationBar];
    
//    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    //tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:CPPhotoBrowserShowImageAnimationDuration animations:^{
        if (placeholderImage.size.height*(kScreenWidth/placeholderImage.size.width) > kScreenHeight) {
            tempView.center = CGPointMake(kScreenWidth/2,placeholderImage.size.height*(kScreenWidth/placeholderImage.size.width)/2);
        }else{
            tempView.center = self.center;
        }
        
        tempView.bounds = (CGRect){CGPointZero, CGSizeMake(kScreenWidth, placeholderImage.size.height*(kScreenWidth/placeholderImage.size.width))};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}

- (NSString *)pidForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowserId:pidForIndex:)]) {
        return [self.delegate photoBrowserId:self pidForIndex:index];
    }
    return nil;
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    for (int i = 0; i<self.imageCount; i++) {
        if (i!=index) {
            CPBrowserImageView *imageView = _scrollView.subviews[i];
            [imageView eliminateScale];
        }
    }
    pageControl.currentPage = index;
    navigationBarTitle.title = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    [self setupImageOfImageViewForIndex:index];
}

- (void) _navLeftTopButton{
    [self hidenPhotoLayer:self.currentImageIndex];
//    _currentPhotoView.doubleTap = NO;
//    [_currentPhotoView hide];
}

- (void) _navRightTopButton{
    
    if (self.fromSelf) {
        photoHandleSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友", @"保存图片",@"删除", nil];
    }else{
        photoHandleSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友", @"保存图片",@"举报", nil];
    }
//    photoHandleSheet showFromRect:<#(CGRect)#> inView:<#(UIView *)#> animated:<#(BOOL)#>
    [photoHandleSheet showInView:self];
//    photoHandleSheet showFromTabBar:[
    
}

//弹出举报层
- (void) _reportUserClick{
    reportUserSheet = [[UIActionSheet alloc] initWithTitle:@"选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情图片", @"反动图片",@"侵权冒用",@"广告欺诈", nil];
    [reportUserSheet showInView:self];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet == photoHandleSheet) {
        switch (buttonIndex) {
            case 0:
            {
                
                [shareView setShareContent:@"分享图片"];
                [shareView setShareImageUrl:[[self highQualityImageURLForIndex:(NSInteger)self.currentImageIndex] absoluteString]];
                UIImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
                [shareView setShareImage:currentImageView.image];
                [shareView setShareTitle:_shareContent];
                [shareView setPid:[self pidForIndex:_currentImageIndex]];
                [shareView setShareUrl:[[self highQualityImageURLForIndex:(NSInteger)self.currentImageIndex] absoluteString]];
                [shareView setIsImageShare:YES];
                //弹出来的分享层
                [shareView positionAnimationIn];

                
            }
                break;
            case 1:
            {
                [self saveImage];
            }
                break;
            case 2:
            {
                if (_fromSelf) {
                    NSString *pid = [self pidForIndex:_currentImageIndex];
                    [self requestDeleteImage:pid];
                }
                else{
                  [self _reportUserClick];
                }
            }
                break;
            default:
                break;
        }
    }else if(actionSheet == reportUserSheet){
        if(buttonIndex  <4){ // 0-色情图片、1-反动图片、2-侵权冒用、3-广告欺诈
            NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
            [parametersDict setObject:@"police" forKey:@"mod"];
            [parametersDict setObject:@"report_pic" forKey:@"func"];
            
            NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
            [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
            [postDict setObject:[self pidForIndex:self.currentImageIndex]  forKey:@"pid"];
            [postDict setObject:[NSString stringWithFormat:@"%ld",(long)buttonIndex] forKey:@"type"];
            
            
            [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id  responseObject) {
                
                NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
                
                if (iRetcode == 1) {
                    
                    [[JYAppDelegate sharedAppDelegate] showTip:@"举报成功"];
                    
                } else {
                    [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
                }
                
            } failure:^(id error) {
                
                NSLog(@"%@", error);
                
            }];
        }
        
    }
    
    
}
- (void)requestDeleteImage:(NSString *)pid{
//    public void delete_useravatar(int pid)

    if (_isMyAvatar) {
        NSDictionary *paraDic = @{@"mod":@"avatar",
                                  @"func":@"delete_useravatar"
                                  };
        NSDictionary *postDic = @{
                                  @"pid":pid
                                  };
        [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            if (iRetcode == 1) {
                //do any addtion here...
                [[JYAppDelegate sharedAppDelegate] showTip:@"删除成功"];
                if ([self.delegate respondsToSelector:@selector(photoBrowser:didDeleteImage:)]) {
                    [self.delegate photoBrowser:self didDeleteImage:_currentImageIndex];
                }
            }
        } failure:^(id error) {
            
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            
        }];
    }else{
       
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"photo" forKey:@"mod"];
        [parametersDict setObject:@"delete_photo" forKey:@"func"];
        
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
        [postDict setObject:[self pidForIndex:self.currentImageIndex]  forKey:@"pid"];
        
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id  responseObject) {
            
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            
            if (iRetcode == 1) {
                
                [[JYAppDelegate sharedAppDelegate] showTip:@"删除成功"];
                if ([self.delegate respondsToSelector:@selector(photoBrowser:didDeleteImage:)]) {
                    [self.delegate photoBrowser:self didDeleteImage:_currentImageIndex];
                }
            } else {
                
            }
            
        } failure:^(id error) {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            NSLog(@"%@", error);
            
        }];

    }
    
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)ges{
    
    if(ges.state == UIGestureRecognizerStateBegan)
        
    {
        if (self.fromSelf) {
            photoHandleSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友", @"保存图片",@"删除", nil];
        }else{
            photoHandleSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友", @"保存图片",@"举报", nil];
        }
        //    photoHandleSheet showFromRect:<#(CGRect)#> inView:<#(UIView *)#> animated:<#(BOOL)#>
        [photoHandleSheet showInView:self];
    }
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com