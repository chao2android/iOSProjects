//
//  CommentView.h
//  TestRedCollar
//
//  Created by MC on 14-7-8.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoolCommentModel.h"
#import "CommentModel.h"
@interface CommentView : UIView


@property (retain,nonatomic)UIImageView *imgView;
@property (retain,nonatomic)UIImageView *commentView;
@property (retain,nonatomic)UILabel *nameLabel;
@property (retain,nonatomic)UILabel *dateLabel;
@property (retain,nonatomic)UILabel *commentLabel;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL didSelected;

- (void)loadContent:(CommentModel *)model;
@end
