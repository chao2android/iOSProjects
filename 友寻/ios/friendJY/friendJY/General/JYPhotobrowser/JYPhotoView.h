//
//  AZXPhotoView.h
//  imAZXiPhone
//
//  Created by coder_zhang on 14-8-4.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYPhotoBrowserController, JYPhoto, JYPhotoView;

@protocol JYPhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(JYPhotoView *)photoView;
- (void)photoViewSingleTap:(JYPhotoView *)photoView;
- (void)photoViewDidEndZoom:(JYPhotoView *)photoView;
@end

@interface JYPhotoView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) JYPhoto *photo;
// 代理
@property (nonatomic, weak) id<JYPhotoViewDelegate> photoViewDelegate;

@property (nonatomic, assign) BOOL doubleTap;

- (void)hide;
@end
