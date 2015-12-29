//
//  NewCommentView.h
//  TestRedCollar
//
//  Created by dreamRen on 14-7-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoolCommentModel.h"

@interface NewCommentView : UIView{
    UIButton *_headButton;
}

@property (retain, nonatomic) UIImageView *imgView;
@property (retain, nonatomic) UIImageView *commentView;
@property (retain, nonatomic) UILabel *nameLabel;
@property (retain, nonatomic) UILabel *dateLabel;
@property (retain, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) CoolCommentModel *mModel;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL didSelected;

- (void)loadCoolCommentContent:(CoolCommentModel *)model;

@end
