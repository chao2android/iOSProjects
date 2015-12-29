//
//  GrassWantGoTableViewCell.h
//  TestVideoJoiner
//
//  Created by MC on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"

@interface GrassWantGoTableViewCell : UITableViewCell

@property (nonatomic,retain) UIImageView *picView;
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *addressLabel;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnDelete;
@property (nonatomic, assign) SEL OnAddHave;

- (void)loadView:(VideoListModel *)model;

@end