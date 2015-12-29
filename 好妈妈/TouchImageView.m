//
//  TouchImageView.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-5-22.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "TouchImageView.h"

@implementation TouchImageView

@synthesize delegate, OnViewClick, OnViewMove, OnLongPressStart, OnLongPressEnd, mStartPoint, mEndPoint;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = YES;
		
		UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongPressed:)];
        longPressGR.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPressGR];
        [longPressGR release];
    }
    return self;
}

- (void)OnLongPressed:(UIGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateEnded) {
		if (delegate && OnLongPressEnd) {
			[delegate performSelector:OnLongPressEnd withObject:self];
		}
	}
	else {
		if (delegate && OnLongPressStart) {
			[delegate performSelector:OnLongPressStart withObject:self];
		}
	}
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	mStartPoint = [touch locationInView:self];
	mbMove = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mbMove = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	mEndPoint = [touch locationInView:self];
	if (mbMove) {
		if (delegate && OnViewMove) {
			[delegate performSelector:OnViewMove withObject:self];
		}
	}
	else {
		if (delegate && OnViewClick) {
			[delegate performSelector:OnViewClick withObject:self];
		}
	}
}

@end
