//
//  TouchPhotoView.h
//  TestRedCollar
//
//  Created by miracle on 14-7-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "NetImageView.h"

@interface TouchPhotoView : NetImageView
{
	BOOL mbMove;
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
