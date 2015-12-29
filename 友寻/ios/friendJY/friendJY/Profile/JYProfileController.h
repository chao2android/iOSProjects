//
//  ViewController.h
//  profileTableView
//
//  Created by XU on 15/2/28.
//  Copyright (c) 2015年 XU. All rights reserved.
//


#import "JYBaseController.h"

@interface JYProfileController : JYBaseController<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *show_uid; // 用户的uid

@end

