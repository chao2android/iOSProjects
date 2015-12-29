//
//  VideoListTableViewCell.h
//  TestVideoJoiner
//
//  Created by MC on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"
#import "FriendVideoModel.h"
#import "TouchView.h"
#import "NetImageView.h"

@interface VideoListTableViewCell : UITableViewCell {
    UILabel *mlbName;
    UILabel *mlbCount;
    UIImageView *mNameView;
    NetImageView *mHeadView;
    UIButton *mWantGoBtn;
    UIButton *mHaveGoBtn;
}

@property (nonatomic, assign) NetImageView *mVideoView;
@property (nonatomic, retain) VideoListModel *mVideoModel;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL moreCLick;
@property (nonatomic, assign) SEL haveGoClick;
@property (nonatomic, assign) SEL xingClick;
@property (nonatomic, assign) SEL locationClick;
@property (nonatomic, assign) SEL videoClick;
@property (nonatomic, assign) SEL headClick;

- (void)loadView:(VideoListModel *)model;
- (void)loadFView:(FriendVideoModel *)model;

@end
