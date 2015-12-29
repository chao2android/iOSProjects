//
//  AZXPhotoBrowserController.m
//  imAZXiPhone
//
//  Created by coder_zhang on 14-8-4.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import "JYPhotoBrowserController.h"
#import <QuartzCore/QuartzCore.h>
#import "JYPhoto.h"
#import "SDWebImageManager.h"
#import "JYPhotoToolbar.h"
#import "JYProfileShareView.h"
#import "JYAppDelegate.h"
#import "JYHttpServeice.h"

#define kPadding 0
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface JYPhotoBrowserController ()<JYPhotoViewDelegate>
{
    UINavigationItem * navigationBarTitle;
    // 滚动的view
	UIScrollView *_photoScrollView;
    // 所有的图片view
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    JYPhotoToolBar *_toolbar;
    
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
    
    JYProfileShareView *shareView;
    
    UIActionSheet *photoHandleSheet;
    UIActionSheet *reportUserSheet;
    UIView *saveImgSuccess;
}

@end

@implementation JYPhotoBrowserController

#pragma mark - Lifecycle
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [JYHelpers setFontColorWithString:@"#edf1f4"];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, kNavigationBarHeight+kStatusBarHeight)];
    
    //创建UINavigationItem
    navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"照片"];
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    
    [self.view addSubview: navigationBar];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
    [leftButton setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    //[leftButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(_navLeftTopButton) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 60, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    navigationBarTitle.leftBarButtonItem = item;
    
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.backgroundColor = [UIColor clearColor];
    [navRightBtn setFrame:CGRectMake(0, 0, 20, 10)];
    [navRightBtn setImage:[UIImage imageNamed:@"profile_tag_more"] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(_navRightTopButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navBarButton = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    navigationBarTitle.rightBarButtonItem = navBarButton;
    
    
    // 1.创建UIScrollView
    [self createScrollView];
    
    if (!_is_avatar) {
        
        // 2.创建工具条
        [self createToolbar];
    }
    
    shareView = [[JYProfileShareView alloc] init];
    [self.view addSubview:shareView];
    
    saveImgSuccess = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-130)/2, (kScreenHeight-50)/2, 130, 50)];
    saveImgSuccess.backgroundColor = [UIColor clearColor];
    saveImgSuccess.hidden = YES;
    [self.view addSubview:saveImgSuccess];
    
    UIView *saveImgSuccessBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, saveImgSuccess.width, saveImgSuccess.height)];
    saveImgSuccessBg.backgroundColor = [UIColor whiteColor];
    saveImgSuccessBg.alpha = 0.7;
    [saveImgSuccess addSubview:saveImgSuccessBg];
    
    UIImageView *saveImgSuccessCorrect = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 30, 20)];
    saveImgSuccessCorrect.userInteractionEnabled = YES;
    saveImgSuccessCorrect.backgroundColor = [UIColor clearColor];
    saveImgSuccessCorrect.image = [UIImage imageNamed:@"saveOk"];
    [saveImgSuccess addSubview:saveImgSuccessCorrect];
    
    UILabel *saveImgSuccessLabel = [[UILabel alloc] initWithFrame:CGRectMake(saveImgSuccessCorrect.right + 12 , saveImgSuccessCorrect.top-5, 80, 30)];
    saveImgSuccessLabel.textAlignment = NSTextAlignmentLeft;
    saveImgSuccessLabel.backgroundColor = [UIColor clearColor];
    saveImgSuccessLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    saveImgSuccessLabel.font = [UIFont systemFontOfSize:15];
    saveImgSuccessLabel.text = @"保存成功";
    [saveImgSuccess addSubview:saveImgSuccessLabel];
    
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    
    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
}

- (void) dealloc{
    [shareView removeFromSuperview];
    shareView = nil;
}

#pragma mark - 私有方法
#pragma mark 创建工具条
- (void)createToolbar
{
//    CGFloat barHeight = 54;
//    CGFloat barY = self.view.frame.size.height - barHeight;
//    _toolbar = [[JYPhotoToolBar alloc] init];
//    _toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
//    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _toolbar.is_prase = _is_prase;
//    _toolbar.praseNumber = _praseNumber;
//    _toolbar.infoDic = _infoDic;
//    _toolbar.photos = _photos;
//    _toolbar.is_profile = self.is_profile;
//    _toolbar.is_recomendProfile = self.is_recomendProfile;
//    
//    _toolbar.imgModels = self.imgModels;
//    _toolbar.isViewPhoto = self.isViewPhoto;
//    _toolbar.photoIdArr = self.photoIdArr;
//    _toolbar.u_id = self.u_id;
//    
////    _toolbar.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_toolbar];
//    
//    [self updateTollbarState];
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
	_photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationBarHeight+5, kScreenWidth, kScreenHeight - kStatusBarHeight-kNavigationBarHeight)];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
	[self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        JYPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        JYPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - AZXPhotoView Delegate代理
- (void)photoViewSingleTap:(JYPhotoView *)photoView
{
    NSLog(@"photoViewSingleTap");
    
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    
    // 移除工具条
    [_toolbar removeFromSuperview];
}

- (void)photoViewDidEndZoom:(JYPhotoView *)photoView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)photoViewImageFinishLoad:(JYPhotoView *)photoView
{
    //_toolbar.currentPhotoIndex = _currentPhotoIndex;
}

- (void) _navLeftTopButton{
    NSLog(@"navlefttopbutton");
    _currentPhotoView.doubleTap = NO;
    [_currentPhotoView hide];
}

- (void) _navRightTopButton{
    photoHandleSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友", @"保存图片",@"举报", nil];
    [photoHandleSheet showInView:self.view];
}

//弹出举报层
- (void) _reportUserClick{
    reportUserSheet = [[UIActionSheet alloc] initWithTitle:@"选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情图片", @"反动图片",@"侵权冒用",@"广告欺诈", nil];
    [reportUserSheet showInView:self.view];
}

//保存图片到相册
- (void) saveImageToAlbum{
    JYPhoto *photo = _photos[_currentPhotoIndex];
    if (photo.save) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"该照片已保存"];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JYPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"保存失败"];
    } else {
        JYPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        //_saveImageBtn.enabled = NO;
        //[[JYAppDelegate sharedAppDelegate] showTip:@"成功保存到相册"];
        
        [UIView beginAnimations:@"ChangeAlphaAnimation" context:NULL];
        [UIView setAnimationDuration:2.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [saveImgSuccess setAlpha:0];
        //[UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == photoHandleSheet) {
        switch (buttonIndex) {
            case 0:
            {
                [shareView setShareContent:((JYPhoto*)[_photos objectAtIndex:_currentPhotoIndex]).url.absoluteString];
                [shareView setShareTitle:@"title"];
                [shareView setShareUrl:((JYPhoto*)[_photos objectAtIndex:_currentPhotoIndex]).url.absoluteString];
                [shareView setIsImageShare:YES];
                //弹出来的分享层
                [shareView positionAnimationIn];
                
            }
                break;
            case 1:
            {
                [saveImgSuccess setHidden:NO];
                [self saveImageToAlbum];
            }
                break;
            case 2:
            {
                [self _reportUserClick];
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
            [postDict setObject:self.u_id forKey:@"uid"];
            [postDict setObject:((JYPhoto *)[self.photos objectAtIndex:self.currentPhotoIndex]).pid forKey:@"pid"];
            [postDict setObject:[NSString stringWithFormat:@"%ld",buttonIndex] forKey:@"type"];
            
            
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

#pragma mark 显示照片
- (void)showPhotos
{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
	NSInteger firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	NSInteger lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (JYPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
    
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	
	for (NSInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(int)index
{
    JYPhotoView *photoView = [self dequeueReusablePhotoView];
    
    if (!photoView) { // 添加新的图片view
        photoView = [[JYPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    _currentPhotoView = photoView;
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    JYPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(int)index
{
    if (index > 0) {
        JYPhoto *photo = _photos[index - 1];
        [[SDWebImageManager sharedManager] downloadImageWithURL:photo.url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        }];
   
    }
    
    if (index < _photos.count - 1) {
        JYPhoto *photo = _photos[index + 1];
        [[SDWebImageManager sharedManager] downloadImageWithURL:photo.url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
        }];
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index
{
	for (JYPhotoView *photoView in _visiblePhotoViews) {
		if (kPhotoViewIndex(photoView) == index) {
            return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (JYPhotoView *)dequeueReusablePhotoView
{
    JYPhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    //_toolbar.currentPhotoIndex = _currentPhotoIndex;
    navigationBarTitle.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.photos.count];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self showPhotos];
    [self updateTollbarState];
}
@end
