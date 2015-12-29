//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (void) photoBrowser:(SDPhotoBrowser *)browser didDeleteImage:(NSInteger)index;

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

- (NSString *)photoBrowserId:(SDPhotoBrowser *)browser pidForIndex:(NSInteger)index;

- (void) closedWindow:(SDPhotoBrowser *)browser closed:(BOOL) closed;

@end



@interface SDPhotoBrowser : UIView <UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSMutableArray *imagePraiseData;

@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;
//是否查看自己的相册 是的话可以删除
@property (nonatomic, assign) BOOL fromSelf;

//用于点赞的 fuid
@property (nonatomic, strong) NSString *fuid;
//分项数据存储模型
@property (nonatomic, copy) NSString *shareContent;
//是否为用户头像
@property (nonatomic, assign) BOOL isMyAvatar;
//@property (nonatomic, strong) JYShareContentModel *shareModel;

@property (nonatomic, strong) JYBaseController *mRootCtrl;

- (void)show;
//相当于 hide
//- (void) _navLeftTopButton;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com