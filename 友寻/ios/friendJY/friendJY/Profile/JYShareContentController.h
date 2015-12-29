//
//  JYShareContentController.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/24.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import <ShareSDK/ShareSDK.h>
@interface JYShareContentController : JYBaseController

//@property (nonatomic, assign) ShareType type;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *imageUrl;

@end
