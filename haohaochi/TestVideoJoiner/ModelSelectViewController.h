//
//  ModelSelectViewController.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-7.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import "MediaSelectManager.h"

@interface ModelSelectViewController : BaseADViewController {
    UIScrollView *mScrollView;
    UIButton *mStopBtn;
}

@property (nonatomic, strong) MediaSelectManager *mMediaManager;
@property (nonatomic, strong) NSArray *mVideoArray;

@end
