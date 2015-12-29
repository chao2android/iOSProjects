//
//  VideoDetialViewController.h
//  TestVideoJoiner
//
//  Created by MC on 14-12-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "MapDisplayView.h"
#import "VideoListModel.h"

@interface VideoDetialViewController : BaseADViewController<UIScrollViewDelegate>
{
    MapDisplayView *mMapView;
}

@property (nonatomic, strong) VideoListModel *mVideoModel;

@end
