//
//  AZXBasePictureTableView.h
//  imAZXiPhone
//
//  Created by coder_zhang on 14-7-24.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import "JYAppDelegate.h"

@interface JYBasePictureTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *data;
// 当前选中的单元格IndexPath
@property(nonatomic,strong) NSIndexPath *selectedInexPath;

@property (nonatomic, assign) float edge;

@end
