//
//  JYEmotionBrowser.h
//  friendJY
//
//  Created by ouyang on 5/4/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYEmotionBrowser;

@protocol JYEmotionBrowserDelegate <NSObject>

@required

- (void)JYEmotionTextFieldShouldReturn:(JYEmotionBrowser *)jyEmotion contentText:(NSString *)contentText;

@optional

//- (NSURL *)photoBrowser:(JYEmotionBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
//
//- (NSString *)photoBrowserId:(JYEmotionBrowser *)browser pidForIndex:(NSInteger)index;

@end

@interface JYEmotionBrowser : UIView <UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate>

//@property (nonatomic, weak) UIView *sourceImagesContainerView;
//@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, strong) NSString *showNick;

@property (nonatomic, weak) id<JYEmotionBrowserDelegate> delegate;

- (void)show;

@end
