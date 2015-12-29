//
//  ArticleDetailViewController.h
//  TestNewsDaLian
//
//  Created by dxy on 14/12/30.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "BaseADViewController.h"
#import "ASIDownManager.h"
#import "ImageDownManager.h"
#import "NetImageView.h"
#import "CommintModel.h"
#import "WriteTableViewCell.h"
@interface ArticleDetailViewController : BaseADViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView * mBlackView;

}
@property (nonatomic, strong) ASIDownManager *mDownManager;
@property (nonatomic, strong) ImageDownManager *iDownManager;

@property (nonatomic,copy)NSString * source_id;

@property (nonatomic,copy)NSString * titleNameString;

@end
