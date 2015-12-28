#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,	
} PullRefreshState;

@interface RefreshTableHeaderView : UIView {
	PullRefreshState state;
    UIImageView *mImageView;
    int miIndex;
    BOOL mbLoading;
}

@property(nonatomic,assign) PullRefreshState state;

- (void)setCurrentDate;
- (void)setState:(PullRefreshState)aState;

@end
