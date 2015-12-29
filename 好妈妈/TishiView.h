//
//  TishiView.h
//  好妈妈
//
//  Created by iHope on 13-10-11.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TishiView : UIView
- (void)StartMenth;
+(TishiView *)tishiViewMenth;
- (void)StopMenth;
@property (retain,nonatomic)UIActivityIndicatorView * activity;
@property (retain,nonatomic)UILabel * titlelabel;
@end
