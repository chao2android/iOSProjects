//
//  CommentBottom.h
//  TJLike
//
//  Created by MC on 15-4-2.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentBottom : UIView

@property (nonatomic, assign) id mDelegate;
@property (nonatomic, assign) SEL onGoComment;
@property (nonatomic, assign) SEL OnSendClick;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *commentNum;
@property (nonatomic, strong) UILabel *showContent;
@property (nonatomic, assign) int comment;

@end
