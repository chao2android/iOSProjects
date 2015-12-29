//
//  BigImageView.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigImageView : UIView
{
  UIImageView *imageView;
  
  CGFloat lastDistance;
	
	CGFloat imgStartWidth;
	CGFloat imgStartHeight;

}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic) CGRect rect;

- (id)initWithFrame:(CGRect)frame image :(UIImage *)ima;

@end
