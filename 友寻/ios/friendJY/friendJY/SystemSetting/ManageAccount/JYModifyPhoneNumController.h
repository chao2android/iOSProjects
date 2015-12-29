//
//  JYModifyPhoneNumController.h
//  friendJY
//
//  Created by coder_zhang on 15/4/1.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileSetRootController.h"

typedef void (^ChangeFinish)();

@interface JYModifyPhoneNumController : JYProfileSetRootController

@property (nonatomic, copy)ChangeFinish finishBlock;

@end
