//
//  JYShareToMyFriendController.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYShareToMyFriendController : JYBaseController

@property (nonatomic, copy) NSString *shareContent;
//发送图片 1 文字 0
@property (nonatomic, assign) BOOL isShareImage;

@property (nonatomic, strong) UIImage *shareImage;
@end
