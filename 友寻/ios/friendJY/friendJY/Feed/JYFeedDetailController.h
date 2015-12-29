//
//  JYFeedDetailController.h
//  friendJY
//
//  Created by ouyang on 3/31/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYFeedDetailTableView.h"
#import "JYFeedModel.h"
#import "JYBaseFooterTableView.h"
#import "CPPhotoBrowser.h"
#import "JYEmotionBrowser.h"

typedef int (^BackAction)();

@interface JYFeedDetailController : JYBaseController<FooterTableViewDelegate,UITextFieldDelegate,CPPhotoBrowserDelegate,JYEmotionBrowserDelegate,UITextViewDelegate>

@property(nonatomic,strong) JYFeedModel * feedModel;
@property(nonatomic,strong) JYFeedDetailTableView *feedDetailTable;
@property(nonatomic,strong) NSString * feedid;
@property(nonatomic, copy) BackAction bcakBlock;

@end
