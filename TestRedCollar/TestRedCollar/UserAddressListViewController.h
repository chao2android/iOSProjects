//
//  UserAddressListViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"
#import "ConsigneeList.h"

typedef void (^SetAddressT)(ConsigneeList *model);

typedef enum: NSUInteger {
    typeInfo = 0,
    typeBack
}SelectType;

@interface UserAddressListViewController : BaseADViewController<UITableViewDelegate,UITableViewDataSource>

@property (copy,nonatomic)SetAddressT blocksAd;
@property (nonatomic, assign) SelectType type;
@property (nonatomic,assign) SEL onSaveClick;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSString *addrID;

@end
