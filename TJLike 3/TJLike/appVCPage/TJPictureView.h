//
//  TJPictureView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJPictureViewDelegate <NSObject>

- (void)removeImageView:(int)index;

@end

@interface TJPictureView : UIView
@property (nonatomic, weak) id<TJPictureViewDelegate> delegate;

- (void)refresPictureView:(NSArray *)lists;

@end
