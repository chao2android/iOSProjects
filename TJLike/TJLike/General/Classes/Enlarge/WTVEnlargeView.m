//
//  WTVEnlargeView.m
//  WTVPhotoDemo
//
//  Created by IPTV_MAC on 15/2/13.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "WTVEnlargeView.h"
#import "UIImageView+AFNetworking.h"

@interface WTVEnlargeView()<UIActionSheetDelegate,UIScrollViewDelegate>
{
    BOOL      isScreen;
    CGPoint   startPoint;
    CGFloat touchX;
    CGFloat touchY;
}

@property (nonatomic, strong) UIImageView  *largeImageView;
@property (nonatomic, strong) UIScrollView *botScrollView;
@property (nonatomic, strong) UIActionSheet *saveSheet;
@end

@implementation WTVEnlargeView

-(instancetype)initLargeImageWithStartPoint:(CGPoint)point largeImageUrl:(NSString *)largeImageUrl andPlaceholderImage:(UIImage *)showImage
{
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        
        self.backgroundColor = [UIColor clearColor];

        isScreen = NO;
        startPoint = point;
        
        _largeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH)];
        if (largeImageUrl && !StringEqual(largeImageUrl, @"")) {
            [_largeImageView setImageWithURL:[NSURL URLWithString:largeImageUrl] placeholderImage:showImage];
        } else {
            [_largeImageView setImage:showImage];
        }
        
        _botScrollView = [[UIScrollView alloc] initWithFrame:SCREEN_BOUNDS];
        _botScrollView.showsHorizontalScrollIndicator = NO;
        _botScrollView.showsVerticalScrollIndicator = NO;
        _botScrollView.delegate = self;
        _botScrollView.userInteractionEnabled = YES;
        _botScrollView.backgroundColor = [UIColor blackColor];
        _botScrollView.alpha = 0.0;
        _botScrollView.minimumZoomScale = 1.0;
        _botScrollView.maximumZoomScale = 2.0;
        [_botScrollView addSubview: _largeImageView];
        [self addSubview:_botScrollView];
        
        //点击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCurrentView:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGesture];
        //双击
        UITapGestureRecognizer *tapDoubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapDoubleCurrentView:)];
        tapDoubleGesture.numberOfTapsRequired = 2;
        tapDoubleGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapDoubleGesture];
        [tapGesture requireGestureRecognizerToFail:tapDoubleGesture];
        //长按
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongCurrentView:)];
        longGesture.minimumPressDuration = 1.0f;
        [self addGestureRecognizer:longGesture];
        
    }
    return self;
}

- (void)showLargeView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    CGSize size = self.botScrollView.bounds.size;
    
    CGAffineTransform newTransform = CGAffineTransformScale(self.botScrollView.transform, 0.01, 0.01);
    [_botScrollView setTransform:newTransform];
    _botScrollView.center = startPoint;

    [UIView animateWithDuration:0.25 animations:^{
        CGAffineTransform newTransform2 =  CGAffineTransformConcat(self.botScrollView.transform,  CGAffineTransformInvert(self.botScrollView.transform));
        [self.botScrollView setTransform:newTransform2];
        self.botScrollView.alpha = 1.0;
        self.botScrollView.center = CGPointMake(size.width/2, size.height/2);
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hideLargeView
{
    [UIView animateWithDuration:0.25 animations:^{
        
        CGAffineTransform newTransform =  CGAffineTransformScale(self.botScrollView.transform, 0.01, 0.01);
        [self.botScrollView setTransform:newTransform];
        self.botScrollView.center = CGPointMake(startPoint.x, startPoint.y);
        
    } completion:^(BOOL finished) {
        [_largeImageView removeFromSuperview];
        [_botScrollView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)handleTapCurrentView:(UITapGestureRecognizer *)tapGesture
{
    [self hideLargeView];
}

- (void)handleTapDoubleCurrentView:(UITapGestureRecognizer *)tapGesture
{
    touchX = [tapGesture locationInView:tapGesture.view].x;
    touchY = [tapGesture locationInView:tapGesture.view].y;
    
    //    @weakify(self);
    
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        //        @strongify(self);
        
        
        if (isScreen) {
            _botScrollView.zoomScale = 1;
            isScreen = NO;
        }
        else{
            
            _botScrollView.zoomScale = 2.0;
            
            [weakSelf.botScrollView setContentOffset:CGPointMake(touchX, 0)];
            
            isScreen = YES;

        }
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)handleLongCurrentView:(UILongPressGestureRecognizer *)longfGesture
{
    
    if(UIGestureRecognizerStateBegan == longfGesture.state) {
        // Called on start of gesture, do work here
        _saveSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        _saveSheet.actionSheetStyle = UIBarStyleDefault;
        
        [_saveSheet showInView:self];
    }
    
    if(UIGestureRecognizerStateChanged == longfGesture.state) {
        // Do repeated work here (repeats continuously) while finger is down
    }
    
    if(UIGestureRecognizerStateEnded == longfGesture.state) {
        // Do end work here when finger is lifted
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    [_largeImageView setCenter:CGPointMake(xcenter, ycenter)];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scale > _botScrollView.minimumZoomScale) {
        isScreen = YES;
    }
    else{
        isScreen = NO;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return _largeImageView;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(_largeImageView.image, self,selectorToCall, NULL);
    }
}

- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}

@end
