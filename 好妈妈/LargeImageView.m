//
//  LargeImageView.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-6-18.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "LargeImageView.h"
#import "AutoAlertView.h"

@implementation LargeImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        mScrollView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        mScrollView.delegate = self;
        mScrollView.maximumZoomScale = 2.37;
        [self addSubview:mScrollView];
        
        mImageView = [[NetImageView alloc] initWithFrame:mScrollView.bounds];
        mImageView.delegate = self;
        mImageView.OnImageLoad = @selector(OnImageLoaded);
        mImageView.mImageType = TImageType_AutoSize;
        mImageView.userInteractionEnabled = NO;
        mImageView.mbActShow = YES;
        [mScrollView addSubview:mImageView];
        [mImageView release];
        
        mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        mActView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        mActView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:mActView];
        [mActView release];

        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
        tgr.numberOfTapsRequired = 1;
        tgr.numberOfTouchesRequired = 1;
        [mScrollView addGestureRecognizer:tgr];
        
        UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnDoubleClick)];
        tgr2.numberOfTapsRequired = 2;
        tgr2.numberOfTouchesRequired = 1;
        [self addGestureRecognizer: tgr2];
        [tgr requireGestureRecognizerToFail: tgr2];

        
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        backBtn.frame = self.bounds;
//        [backBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:backBtn];
    }
    return self;
}

- (void)setMMaxZoomScale:(float)value {
    mScrollView.maximumZoomScale = value;
}

- (float)mMaxZoomScale {
    return mScrollView.maximumZoomScale;
}

- (void)OnDoubleClick {
    if (mScrollView.zoomScale > mScrollView.maximumZoomScale/2) {
        mScrollView.zoomScale = 1.0;
    }
    else {
        mScrollView.zoomScale = mScrollView.maximumZoomScale;
    }
}

- (void)OnImageLoaded {
    [mActView stopAnimating];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return mImageView;
}

- (void)OnSavePhoto {
    UIImage *image = [UIImage imageWithContentsOfFile:mImageView.mLocalPath];
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [AutoAlertView ShowAlert:@"提示" message:@"成功保存至相册"];
    }
}

- (void)ShowImage:(NSString *)headimage {
    [mActView startAnimating];
    if (headimage && headimage.length>0) {
//        headimage = [NSString stringWithFormat:@"%@/data/%@", REMOTE_URL, headimage];
    }
    [mImageView GetImageByStr:headimage];
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
