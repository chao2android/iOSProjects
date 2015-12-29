//
//  JYFeedTableViewCell.h
//  friendJY
//
//  Created by ouyang on 3/26/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYFeedModel.h"
#import "CPPhotoBrowser.h"

@interface JYFeedTableViewCell : UITableViewCell <CPPhotoBrowserDelegate,UITextViewDelegate>
@property (nonatomic, strong) JYFeedModel *feedModel;
@property (nonatomic, assign) BOOL isMyDynamicCall;//标记是我的动态列表 yes；或是首页列表no。


- (float)LoadContent;


@end

