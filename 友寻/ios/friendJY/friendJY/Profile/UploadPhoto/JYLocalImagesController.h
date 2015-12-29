//
//  AZXLocalImagesController.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-11.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYLocalImagesController : JYBaseController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_table;
    NSMutableArray *_imageGroupArr;
//    NSMutableArray *_postImagesArr;
}

@property (nonatomic, assign) NSInteger canUploadCount;
@property (nonatomic, strong) NSMutableDictionary *currentGroupDict;
@property (nonatomic, strong) NSMutableArray *currentGroupImagesArr;

@end
