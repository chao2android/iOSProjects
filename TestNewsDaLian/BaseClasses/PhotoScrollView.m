//
//  PhotoScrollView.m
//  在保定
//
//  Created by Hepburn Alex on 13-12-24.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "PhotoScrollView.h"
#import "NetProgressImageView.h"

@implementation PhotoScrollView

@synthesize mArray, miPage, delegate, OnSingleClick, mThumbArray,mTextArray,mMainTextArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        miPage = 0;
        mArray = [[NSMutableArray alloc] initWithCapacity:10];
        mThumbArray=[[NSMutableArray alloc] initWithCapacity:10];
        mTextArray=[[NSMutableArray alloc] initWithCapacity:10];
        mMainTextArray=[[NSMutableArray alloc] initWithCapacity:10];
        //self.backgroundColor = [UIColor clearColor];
        // _bgImage=[UIImage imageNamed:@"scrollscanerBG.png"];
        
        UIImageView *imagebgView=[UIImageView new];
        imagebgView.frame=self.bounds;
        imagebgView.userInteractionEnabled=YES;
       // imagebgView.image=_bgImage;
        imagebgView.backgroundColor = [UIColor blackColor];
        imagebgView.alpha=0.9;
        [self addSubview:imagebgView];

        
        mScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        mScrollView.delegate = self;
        mScrollView.showsHorizontalScrollIndicator = YES;
        mScrollView.showsVerticalScrollIndicator = NO;
        mScrollView.bounces = NO;
        mScrollView.pagingEnabled = YES;
        [imagebgView addSubview:mScrollView];
        
        mPageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 20)];
        mPageCtrl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        mPageCtrl.userInteractionEnabled = NO;
        [imagebgView addSubview:mPageCtrl];
        mPageCtrl.hidden=YES;
        
    }
    return self;
}

- (void)dealloc {
    self.mThumbArray = nil;
   
}

- (void)setMArray:(NSMutableArray *)array {
    [mArray removeAllObjects];
    [mArray addObjectsFromArray:array];
    
    mScrollView.contentSize = CGSizeMake(self.frame.size.width*mArray.count, mScrollView.frame.size.height);
    mPageCtrl.numberOfPages = mArray.count;
    mPageCtrl.currentPage = miPage;
    [self ScrollToPage:miPage];
    
    if([self.delegate respondsToSelector:@selector(refreshCurPage:)])
    {
        [self.delegate  performSelector:@selector(refreshCurPage:) withObject:[NSNumber numberWithInt:miPage+1]];
    }
    
}
-(void)setMTextArray:(NSMutableArray *)_mTextArray{
    [mTextArray removeAllObjects];
    [mTextArray addObjectsFromArray:_mTextArray];
    if([self.delegate respondsToSelector:@selector(showCurPageText:mainTxt:)])
    {
        if(mTextArray.count>miPage&&mMainTextArray.count>miPage){
            [self.delegate  performSelector:@selector(showCurPageText:mainTxt:) withObject:mTextArray[miPage] withObject:mMainTextArray[miPage]];
     }
    }
}
-(void)setMMainTextArray:(NSMutableArray *)_mMainTextArray{
    [mMainTextArray removeAllObjects];
    [mMainTextArray addObjectsFromArray:_mMainTextArray];
    if([self.delegate respondsToSelector:@selector(showCurPageText:mainTxt:)])
    {
        if(mTextArray.count>miPage&&mMainTextArray.count>miPage){
            [self.delegate  performSelector:@selector(showCurPageText:mainTxt:) withObject:mTextArray[miPage] withObject:mMainTextArray[miPage]];
        }
    }
}

- (void)ScrollToPage:(int)iPage {
    
    mPageCtrl.currentPage = miPage;
    if([self.delegate respondsToSelector:@selector(refreshCurPage:)])
    {
        [self.delegate  performSelector:@selector(refreshCurPage:) withObject:[NSNumber numberWithInt:miPage+1]];
    }
    if([self.delegate respondsToSelector:@selector(showCurPageText:mainTxt:)])
    {
        if(mTextArray.count>miPage&&mMainTextArray.count>miPage){
            [self.delegate  performSelector:@selector(showCurPageText:mainTxt:) withObject:mTextArray[miPage] withObject:mMainTextArray[miPage]];
        }
    }
    int iWidth = self.frame.size.width;
    int iHeight = self.frame.size.height;
    
    for (int i = 0; i < mArray.count; i++) {
        UIScrollView *scrollView = (UIScrollView *)[mScrollView viewWithTag:i+5000];
        if (i < miPage-1 || i > miPage+1) {
            @autoreleasepool {
                [scrollView removeFromSuperview];
            }
            
            
        }
        else if (!scrollView) {
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(mScrollView.frame.size.width*i, 0, mScrollView.frame.size.width, mScrollView.frame.size.height)];
            scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
          //  scrollView.backgroundColor = [UIColor clearColor];
            scrollView.contentSize = CGSizeMake(iWidth, iHeight);
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.delegate = self;
            scrollView.minimumZoomScale = 1.0;
            scrollView.maximumZoomScale = 2.0;  //放大比例；
            scrollView.zoomScale = 1.0;
            scrollView.tag = i+5000;
            [mScrollView addSubview:scrollView];
            
            
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            [doubleTap setNumberOfTapsRequired:2];
            
            //嵌套的UIScrollView；
            UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneTap:)];
            [oneTap setNumberOfTapsRequired:1];
            
            NetProgressImageView *imageView = [[NetProgressImageView alloc] initWithFrame:scrollView.bounds];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            imageView.mImageType = TImageType_AutoSize;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:doubleTap];
            [imageView addGestureRecognizer:oneTap];
            imageView.tag = 500;
            //imageView.mbActShow = YES;
            [scrollView addSubview:imageView];
          
            
            NSString *photoname = [mArray objectAtIndex:i];
            NSString *thumbname = nil;
            if (self.mThumbArray && self.mThumbArray.count>i) {
                thumbname = [self.mThumbArray objectAtIndex:i];
            }
            [imageView GetImageByStr:photoname :thumbname];
            
                   }
    }
    mScrollView.contentOffset = CGPointMake(iWidth*miPage, 0);
}

#pragma mark-
#pragma mark- UIScrollViewDelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView != mScrollView){
        NetImageView *imageView = (NetImageView *)[scrollView viewWithTag:500];
        return imageView;
    }
    return nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == mScrollView){
        for (UIScrollView *subView in scrollView.subviews){
            if ([subView isKindOfClass:[UIScrollView class]]){
                subView.zoomScale = 1.0;
            }
        }
        miPage = round(scrollView.contentOffset.x/scrollView.frame.size.width);
        [self ScrollToPage:miPage];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //根据偏移量计算是哪个图片；
    if (scrollView == mScrollView){
        miPage = round(scrollView.contentOffset.x/scrollView.frame.size.width);
    }
}

#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
  /*  UIScrollView *scrollView = (UIScrollView*)gesture.view.superview;
    if ([scrollView isKindOfClass:[UIScrollView class]]){
        float newScale = scrollView.zoomScale * 1.5;
        CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
        [scrollView zoomToRect:zoomRect animated:YES];
    }*/
}

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)handleOneTap:(UITapGestureRecognizer*)gesture{
    if (delegate && OnSingleClick) {
        [delegate performSelector:OnSingleClick withObject:self];
    }
}


@end
