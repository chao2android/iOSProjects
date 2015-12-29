//
//  CareViewController.h
//  TestVideoJoiner
//
//  Created by MC on 14-12-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"

@interface CareViewController : BaseADViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *uId;
@end
