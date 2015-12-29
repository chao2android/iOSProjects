//
//  ImageArrayDetailViewController.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/24.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "PhotoScrollController.h"
#import "ASIDownManager.h"
#import "ImageDownManager.h"
#import "ReDianModel.h"
#import "DxyCustom.h"
@interface ImageArrayDetailViewController : PhotoScrollController

@property (nonatomic,copy ) NSString * titleName;
@property (nonatomic,retain) ReDianModel * model;

@property (nonatomic, strong) ASIDownManager *mDownManager;
@property (nonatomic, strong) ImageDownManager *iDownManager;
@property (nonatomic, copy) NSString * source_id;


@end
