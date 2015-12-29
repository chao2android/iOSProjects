//
//  JYProfileAddFriendView.m
//  friendJY
//
//  Created by chenxiangjing on 15/6/11.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYProfileAddFriendView.h"

@implementation JYProfileAddFriendView

//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
////        [self layoutSubviews];
//    }
//    return self;
//
//}
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    [_contentView removeFromSuperview];
    //大层的，容器
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self addSubview:_contentView];
    
    //黑色，80%透明
    UIView * noFriendInviteBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    noFriendInviteBg.backgroundColor = [UIColor blackColor];
    noFriendInviteBg.alpha = 0.8;
    [_contentView addSubview:noFriendInviteBg];
    
    //要显示的正文内容
    UIView * noFriendInviteShow = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-270)/2,(kScreenHeight - 330)/2,270 ,300)];
    noFriendInviteShow.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:noFriendInviteShow];
    
    //删除不显示
    UIButton *newsDelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsDelBtn setFrame:CGRectMake(noFriendInviteShow.right-20,noFriendInviteShow.top-20, 40, 40)];
    [newsDelBtn setImage:[UIImage imageNamed:@"feedGetPhoneClose"] forState:UIControlStateNormal];
    [newsDelBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:newsDelBtn];
    
    //标题蓝色背景
    UIImageView *noFriendTopBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, noFriendInviteShow.width, noFriendInviteShow.height)];
    noFriendTopBg.image = [UIImage imageNamed:@"feedExportPhoneListBg"];
    [noFriendInviteShow addSubview:noFriendTopBg];
    
    
    UIImageView *noFriendPhoneListIcon = [[UIImageView alloc] initWithFrame:CGRectMake((noFriendInviteShow.width-80)/2, 40 , 80, 80)];
    noFriendPhoneListIcon.image = [UIImage imageNamed:@"you_xun_icon"];
    [noFriendPhoneListIcon.layer setMasksToBounds:YES];
    [noFriendPhoneListIcon.layer setCornerRadius:10];
    [noFriendInviteShow addSubview:noFriendPhoneListIcon];
    
    //中间的字
    UILabel *noFriendTopContent = [[UILabel alloc] initWithFrame:CGRectMake(10, noFriendPhoneListIcon.bottom+15, noFriendInviteShow.width-20, 60)];

    noFriendTopContent.text = @"TA还不是你的好友，\n加个好友认识一下吧。";
    
    noFriendTopContent.textAlignment = NSTextAlignmentCenter;
    noFriendTopContent.textColor = kTextColorWhite;
    noFriendTopContent.font = [UIFont systemFontOfSize:14];
    noFriendTopContent.numberOfLines = 0;
    [noFriendInviteShow addSubview:noFriendTopContent];
    
    //蓝色背景-查找通讯好友按钮
    UIButton *noFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noFriendButton setBackgroundColor:[UIColor whiteColor]];
    [noFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
    
    [noFriendButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [noFriendButton setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [noFriendButton setFrame:CGRectMake(noFriendPhoneListIcon.left - 20, noFriendTopContent.bottom + 30, noFriendPhoneListIcon.width+40, 30)];
    noFriendButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    
    [noFriendButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    
    [noFriendInviteShow addSubview:noFriendButton];

}
- (void)show{
    
    [[JYAppDelegate sharedAppDelegate].window addSubview:self];

}

- (void)addFriend{
    NSLog(@"add friend");
    if (self.AddFriendBlock) {
        self.AddFriendBlock();
    }
    [self removeFromSuperview];
}

- (void)remove{
    if (self.RemoveBlock) {
        self.RemoveBlock();
    }
    
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
