//
//  AZXViewPhotoController.h
//  imAZXiPhone
//  查看个人相册的照片
//  Created by coder_zhang on 14-9-10.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import "JYBaseController.h"

@interface JYPhotoController : JYBaseController<UITableViewDataSource, UITableViewDelegate>

// 所有图片url
@property (nonatomic, strong) NSArray *data;  //url

// 所有图片对应的模型
@property (nonatomic, strong) NSArray *photoModels; // model

// 选中的图片索引
@property(nonatomic,assign)int index;

@property (nonatomic, strong) NSArray *photoIdArr; // 所有生活照片的photoid

@property (nonatomic, strong) NSString *u_id;

@end
