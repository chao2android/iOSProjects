//
//  VideoDetailViewController.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/26.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "BaseADViewController.h"
#import "ASIDownManager.h"
#import "ImageDownManager.h"
#import "ALMoviePlayerController.h"
#import "ServiceHelper.h"

@interface VideoDetailViewController : BaseADViewController<ServiceHelperDelegate,ALMoviePlayerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ServiceHelper *helper;
    UIView * mBlackView;


}
@property (nonatomic, strong) ASIDownManager *mDownManager;
@property (nonatomic, strong) ImageDownManager *iDownManager;

@property (nonatomic, copy) NSString * source_id;
@property (nonatomic,copy)NSString * titleNameString;
@end
