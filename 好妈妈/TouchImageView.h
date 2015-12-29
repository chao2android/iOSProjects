//
//  TouchImageView.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-5-22.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"

@interface TouchImageView : NetImageView {
	BOOL mbMove;
	id delegate;
	SEL OnViewClick;
	SEL OnViewMove;
	SEL OnLongPressStart;
	SEL OnLongPressEnd;
	CGPoint mStartPoint;
	CGPoint mEndPoint;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnViewClick;
@property (nonatomic, assign) SEL OnViewMove;
@property (nonatomic, assign) SEL OnLongPressStart;
@property (nonatomic, assign) SEL OnLongPressEnd;
@property (nonatomic, assign) CGPoint mStartPoint;
@property (nonatomic, assign) CGPoint mEndPoint;

@end
