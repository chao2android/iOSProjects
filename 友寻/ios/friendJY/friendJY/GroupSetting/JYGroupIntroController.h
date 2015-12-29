//
//  JYGroupIntroController.h
//  friendJY
//
//  Created by 高斌 on 15/4/17.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYGroupInfoModel.h"
#import "JYMyGroupModel.h"

typedef void(^editFinish) (NSString *content);

@interface JYGroupIntroController : JYBaseController
{
    UITextView *_nameTV;
}
@property (nonatomic, strong) JYGroupInfoModel *infoModel;
@property (nonatomic, strong) JYMyGroupModel *groupModel;

@property (nonatomic, copy) editFinish finishBlick;

@end
