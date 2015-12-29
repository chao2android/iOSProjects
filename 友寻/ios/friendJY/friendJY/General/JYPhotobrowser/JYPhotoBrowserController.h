//
//  AZXPhotoBrowserController.h
//  imAZXiPhone
//
//  Created by coder_zhang on 14-8-4.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import "JYPhotoView.h"

@protocol JYPhotoBrowserDelegate;
@interface JYPhotoBrowserController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate>
// 代理
@property (nonatomic, weak) id<JYPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

// 当前展示的图片view
@property (nonatomic, strong) JYPhotoView *currentPhotoView;

// 显示
- (void)show;


// zhang
//   是否已经点赞
@property (nonatomic, strong) NSString *is_prase;
//   点赞的数量
@property (nonatomic, strong) NSString *praseNumber;
//   点赞的动态
@property (nonatomic, strong) NSDictionary *infoDic;
// 查看大头像
@property (nonatomic, assign) BOOL is_avatar;
//   判断是动态主页 还是别人的主页中的 动态页
@property (nonatomic, assign) BOOL is_profile;
@property (nonatomic, assign) BOOL is_recomendProfile;

@property (nonatomic, strong) NSArray *imgModels; // 照片的model
@property (nonatomic, assign) BOOL isViewPhoto; //
@property (nonatomic, strong) NSArray *photoIdArr;
@property (nonatomic, strong) NSString *u_id;

@end

@protocol JYPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
- (void)photoBrowser:(JYPhotoBrowserController *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

@end
