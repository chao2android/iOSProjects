//
//  JYGroupSettingController.h
//  friendJY
//
//  Created by 高斌 on 15/4/16.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYMyGroupModel.h"
#import "JYGroupInfoModel.h"
#import "JYChatController.h"

@interface JYGroupSettingController : JYBaseController
{
//    NSMutableArray *_titleList;
    
    BOOL _isMyGroup;
    NSMutableArray * _imageArr;
}
@property (nonatomic, strong) JYMyGroupModel *groupModel;
@property (nonatomic, strong) NSArray *groupPrivilegeList;
@property (nonatomic, strong) JYGroupInfoModel *groupInfoModel;

@end
