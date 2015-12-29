//
//  JYProfileEditTagsController.h
//  friendJY
//
//  Created by ouyang on 3/19/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYProfileEditTagsController : JYBaseController<UIAlertViewDelegate>
@property (nonatomic, strong) NSString *show_uid; // 用户的uid
@property (nonatomic, strong) NSMutableDictionary *tagDic; //标签字典
@end
