//
//  JYProfileShareView.h
//  friendJY
//
//  Created by ouyang on 3/24/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYBaseController,SDPhotoBrowser;


@interface JYProfileShareView : UIView

@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareImageUrl;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) id fromSDBrower;
@property (nonatomic, assign) BOOL isImageShare;
@property (nonatomic, copy) NSString *shareSingleContent;
@property (nonatomic, strong) NSDictionary *profileDataDic;

- (void)positionAnimationIn;

@end
