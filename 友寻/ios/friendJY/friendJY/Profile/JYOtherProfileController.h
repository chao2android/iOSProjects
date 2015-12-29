//
//  JYOtherProfileController.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/21.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
@class JYCreatGroupFriendModel;

@interface JYOtherProfileController : JYBaseController<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
}

@property (nonatomic, strong) NSString *show_uid; // 用户的uid

@property (nonatomic, strong) JYCreatGroupFriendModel *friendModel;
/**
 *  是否通过单聊进入
 */
@property (nonatomic, assign) BOOL isFromChat;

@end
