//
//  FansListCell.h
//  TestRedCollar
//
//  Created by miracle on 14-7-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"

@interface FansListCell : UITableViewCell
{
    NetImageView *_aImageView;
    UILabel *_aTextLabel;
    UILabel *_aDetailLabel;
}

@property (nonatomic, retain) NetImageView *aImageView;
@property (nonatomic, retain) UILabel *aTextLabel;
@property (nonatomic, retain) UILabel *aDetailLabel;
@property (nonatomic, retain) UIButton *cancelAttBtn;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL onButtonClick;

@end
