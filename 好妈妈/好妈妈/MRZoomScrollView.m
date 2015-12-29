//
//  MRZoomScrollView.m
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import "MRZoomScrollView.h"



@interface MRZoomScrollView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation MRZoomScrollView

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame viewImage:(UIImage *)aimage heti:(int)aHeti
{
    self = [super initWithFrame:frame];
    if (self) {
        heig=aHeti;
        aRect=CGRectMake(frame.origin.x, frame.origin.y+44, frame.size.width, frame.size.height);
//        [UIView animateWithDuration:1 animations:^{
        
            self.frame=CGRectMake(0, 0, Screen_Width, Screen_Height);
//        }];
        self.delegate = self;
        [self initImageView:aimage];
    }
    return self;
}

- (void)initImageView:(UIImage *)aImage
{
    
    CGFloat wid = aImage.size.width;
    CGFloat hei = aImage.size.height;
    
    imageView = [[UIImageView alloc]initWithFrame:aRect];
    imageView.image = aImage;

    if (wid > Screen_Width) {
        hei = Screen_Width*hei/wid;
        wid = Screen_Width;
    }
    
    if (hei >Screen_Height-40) {
        wid = (Screen_Height-40) *wid/hei;
        hei = (Screen_Height-40);
    }
    if (wid<Screen_Width&&hei<Screen_Height-40) {
        hei = Screen_Width*hei/wid;
        wid=Screen_Width;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        if (ISIPAD) {
            imageView.frame = CGRectMake((Screen_Width -wid)/2, (Screen_Height - hei)/2, wid, hei);

        }
        else
        {
        imageView.frame = CGRectMake((Screen_Width -wid)/2, (Screen_Height - hei)/2, wid*2.5, hei*2.5);
        }
        
    }];


    imageView.image=aImage;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView release];
   
    ImageBool=NO;
      UITapGestureRecognizer * doubleTapGesture1= [[UITapGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(handleDoubleTap1:)];
    [doubleTapGesture1 setNumberOfTapsRequired:1];

    [self addGestureRecognizer:doubleTapGesture1];
    [doubleTapGesture1 release];

    // Add gesture,double tap zoom imageView.
    if (ISIPAD) {
        
    }
    else
    {
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleDoubleTap:)];
    [doubleTapGesture1 requireGestureRecognizerToFail:doubleTapGesture];

    [doubleTapGesture setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
    }
   
    
    float minimumScale = self.frame.size.width / imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];
}
- (void)handleDoubleTap1:(UIGestureRecognizer *)gesture
{
    self.backgroundColor=[UIColor clearColor];
    
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"%d  %f",heig,aRect.origin.y);
        if (heig) {
            imageView.frame=CGRectMake(aRect.origin.x, aRect.origin.y-heig, aRect.size.width, aRect.size.height);

        }
        else
        {
            imageView.frame=aRect;
        }
    } completion:^(BOOL finished){
        for (int i=0; [[self subviews] count]; i++) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wohidse" object:nil];
        [self removeFromSuperview];}];
   

}

#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{    
    float newScale;
     if (ImageBool) {
         imageView.frame=CGRectMake(imageView.frame.origin.x,(KUIOS_7(Screen_Height-20)-imageView.frame.size.height/2.5)/2, imageView.frame.size.width, imageView.frame.size.height);

         newScale = self.zoomScale * 0.1;
    }
    else
    {
        imageView.frame=CGRectMake(imageView.frame.origin.x, 0, imageView.frame.size.width, imageView.frame.size.height);
        newScale = self.zoomScale * 3;
    }
    ImageBool=!ImageBool;
    
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    NSLog(@"%f  %f  %f  %f",zoomRect.size.width,zoomRect.size.height,zoomRect.origin.x,zoomRect.origin.y);
    [self zoomToRect:zoomRect animated:YES];
    
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    NSLog(@"%f",scale);
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark - View cycle
- (void)dealloc
{
    [super dealloc];
}

@end
