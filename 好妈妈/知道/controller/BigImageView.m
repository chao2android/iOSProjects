//
//  BigImageView.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "BigImageView.h"

@implementation BigImageView

#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)





@synthesize imageView;

- (id)initWithFrame:(CGRect)frame image :(UIImage *)ima{
  self = [super initWithFrame:frame];
  if (self) {
    lastDistance=0;
    self.rect = frame;
    self.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight+(KUIOS_7(0)));
    
    CGFloat wid = ima.size.width;
    CGFloat hei = ima.size.height;
    
    imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.center = self.center;
    imageView.image = ima;

    
    if (wid > MRScreenWidth) {
      hei = MRScreenWidth*hei/wid;
      wid = MRScreenWidth;
    }
    
    if (hei >MRScreenHeight) {
      wid = MRScreenHeight *wid/hei;
      hei = MRScreenHeight;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
      imageView.frame = CGRectMake((MRScreenWidth -wid)/2, (MRScreenHeight - hei)/2, wid, hei);
//      imageView.center = self.center;

    }];

    
    
    imgStartWidth=imageView.frame.size.width;
    imgStartHeight=imageView.frame.size.height;
    
    
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [imageView release];
    
    UITapGestureRecognizer * doubleTapGesture1= [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleDoubleTap1:)];
    [doubleTapGesture1 setNumberOfTapsRequired:1];
    
    [self addGestureRecognizer:doubleTapGesture1];
    [doubleTapGesture1 release];

  }
  return self;
  
  
}
- (void)handleDoubleTap1:(UIGestureRecognizer *)gesture
{
  
  
  [UIView animateWithDuration:0.3 animations:^{
//    imageView.frame =CGRectZero;
    self.alpha = 0;
  }];

  [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(remView) userInfo:nil repeats:NO];
}
-(void)remView{
  
 [self removeFromSuperview];
}
#pragma mark - Zoom methods

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	CGPoint p1;
	CGPoint p2;
	CGFloat sub_x;
	CGFloat sub_y;
	CGFloat currentDistance;
	CGRect imgFrame;
	
	NSArray * touchesArr=[[event allTouches] allObjects];
	
  NSLog(@"手指个数%d",[touchesArr count]);
  //    NSLog(@"%@",touchesArr);
	
	if ([touchesArr count]>=2) {
		p1=[[touchesArr objectAtIndex:0] locationInView:self];
		p2=[[touchesArr objectAtIndex:1] locationInView:self];
		
		sub_x=p1.x-p2.x;
		sub_y=p1.y-p2.y;
		
		currentDistance=sqrtf(sub_x*sub_x+sub_y*sub_y);
		
		if (lastDistance>0) {
			
			imgFrame=imageView.frame;
			
			if (currentDistance>lastDistance+2) {
				NSLog(@"放大");
				
				imgFrame.size.width+=10;
				if (imgFrame.size.width>1000) {
					imgFrame.size.width=1000;
				}
				
				lastDistance=currentDistance;
			}
			if (currentDistance<lastDistance-2) {
				NSLog(@"缩小");
				
				imgFrame.size.width-=10;
				
				if (imgFrame.size.width<50) {
					imgFrame.size.width=50;
				}
				
				lastDistance=currentDistance;
			}
			
			if (lastDistance==currentDistance) {
				imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
        
        float addwidth=imgFrame.size.width-imageView.frame.size.width;
        float addheight=imgFrame.size.height-imageView.frame.size.height;
        
				imageView.frame=CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
			}
			
		}else {
			lastDistance=currentDistance;
		}
    
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	lastDistance=0;
}


@end
