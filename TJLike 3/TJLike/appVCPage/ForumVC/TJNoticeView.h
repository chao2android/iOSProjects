//
//  TJNoticeView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJNoticeViewDelegate <NSObject>
- (void)tapShowImageEvent:(id)sender;

@end

@interface TJNoticeView : UIView
@property (nonatomic, weak) id<TJNoticeViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withObjc:(id)Objc;

@end
