#import "RefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation RefreshTableHeaderView

@synthesize state;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        mImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-37)/2, frame.size.height-50, 37, 37)];
        mImageView.image = [UIImage imageNamed:@"f_refreshflag"];
        [self addSubview:mImageView];
        [mImageView release];
		
		[self setState:PullRefreshNormal];
    }
    return self;
}

- (void)StartLoading {
    mbLoading = YES;
    miIndex = 0;
    [self OnRotateAnimate];
}

- (void)StopLoading {
    mbLoading = NO;
    [mImageView.layer removeAllAnimations];
}

- (void)OnRotateAnimate {
    CABasicAnimation* rotation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation1.toValue = [NSNumber numberWithFloat:  M_PI * 2.0];
    rotation1.duration = 0.6;
    rotation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation1.cumulative = YES;
    rotation1.repeatCount = 1000;
    
    [mImageView.layer addAnimation:rotation1 forKey:@"ShakeAnimate"];
    
    miIndex = (miIndex+1)%4;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (mbLoading) {
        [self OnRotateAnimate];
    }
}

- (void)setCurrentDate {

}

/*
- (void)drawRect:(CGRect)rect{
	UIImage *image=[UIImage imageNamed:@"background.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
*/

- (void)setState:(PullRefreshState)aState{
	switch (aState) {
		case PullRefreshPulling:
			break;
		case PullRefreshNormal:
			if (state == PullRefreshPulling) {
                [self StopLoading];
            }
            [self StopLoading];
			break;
		case PullRefreshLoading:
            [self StartLoading];
			break;
		default:
			break;
	}
	state = aState;
}

- (void)dealloc {
    [super dealloc];
}

@end
