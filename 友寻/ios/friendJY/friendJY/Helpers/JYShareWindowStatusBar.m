//
//  ShareWindowStatusBar.m
//  JiaYuan
//
//  Created by HsiuJane Sang on 10/25/11.
//  Copyright (c) 2011 JiaYuan. All rights reserved.
//

#import "JYShareWindowStatusBar.h"

//static ShareWindowStatusBar *kSharedInstance = nil;

@implementation JYShareWindowStatusBar
@synthesize actionBtn;
@synthesize showLabel;

//+(ShareWindowStatusBar *)sharedInstance
//{
//    if (!kSharedInstance) {
//		kSharedInstance = [[ShareWindowStatusBar alloc] init];
//	}
//	return kSharedInstance;
//}


-(id)init{
    if (self = [super init]) {
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        //		self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.frame = CGRectMake(0, 0, 320, 20);
        
        //        UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        //		backgroundImageView.image = [[UIImage imageNamed:@"statusbar_background.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        //		[self addSubview:backgroundImageView];
        //		[backgroundImageView release];
        self.backgroundColor = [UIColor clearColor];
        
        showLabel = [[UILabel alloc] initWithFrame:self.frame];
		showLabel.backgroundColor = [UIColor blackColor];
		showLabel.textColor = [UIColor whiteColor];
        showLabel.textAlignment = NSTextAlignmentCenter;
		showLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		[self addSubview:showLabel];
        // showLabel.hidden = YES;
        showLabel.alpha = 1.0;
        self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.frame = CGRectMake(220, 0, 100, 20);
        actionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [actionBtn setBackgroundColor:[UIColor blackColor]];
        
        [self addSubview:actionBtn];
        actionBtn.hidden = YES;
        
    }
    return self;
}

- (void) showStatusWithMessage:(NSString*) msg {
	if (!msg) return;
	showLabel.text = msg;
	self.hidden = NO;
    
    //self.alpha = 1.0;
    showLabel.alpha = 1.0;
    [UIView animateWithDuration:0.5
						  delay:5.0
						options: UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 //self.alpha = 0.0;
                         showLabel.alpha = 0.0;
					 }
					 completion:nil];
    
    //	[UIView animateWithDuration:0.5
    //						  delay: 0.0
    //						options: UIViewAnimationOptionCurveEaseInOut
    //					 animations:^{
    //						 self.alpha = 1.0;
    //					 }
    //					 completion:^(BOOL finished){
    //						 // Wait one second and then fade in the view
    //						 [UIView animateWithDuration:0.5
    //											   delay: 2.0
    //											 options:UIViewAnimationOptionCurveEaseInOut
    //										  animations:^{
    //											  self.alpha = 0.0;
    //                                              //self.hidden = YES;
    //										  }
    //										  completion:nil];
    //					 }];
    
    
	
}

-(void)showActionBtnWithMessage:(NSString*)msg{
    self.hidden = NO;
    actionBtn.hidden = NO;
    showLabel.alpha = 0.0;
    [actionBtn setTitle:msg forState:UIControlStateNormal];
    
}
-(void)hideActionBtn{
    
    showLabel.alpha = 0.0;
    actionBtn.hidden = YES;
}

- (void) hideStatus {
    
	self.hidden = YES;
}


- (void) dealloc {
}

@end
