//
//  JYGroupPrivilegeController.h
//  friendJY
//
//  Created by 高斌 on 15/4/17.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYGroupInfoModel.h"
#import "JYMyGroupModel.h"

@interface JYGroupPrivilegeController : JYBaseController
{
    UIImageView *_selectedImageV;
    NSInteger _selectedIndex;
}
@property (nonatomic, strong) JYGroupInfoModel *infoModel;
@property (nonatomic, strong) JYMyGroupModel *groupModel;
@property (nonatomic, strong) NSArray *privilegeList;

@end
