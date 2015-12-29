//
//  JYFeedNewsListTableViewCell.m
//  friendJY
//
//  Created by ouyang on 4/20/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedNewsListTableViewCell.h"
#import "JYHelpers.h"
#import "UIImageView+WebCache.h"

@implementation JYFeedNewsListTableViewCell{
    UIImageView *avatarBGImg;
    UILabel *nameLabel;
    UILabel *titleLabel;
    UILabel *lastLoginTimeLabel;
    UILabel *replyNumLabel;
    UIImageView *moreImage;
    UIImageView *contentImage;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self _initFeedSubviews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)_initFeedSubviews
{
    //前面固定logo
    avatarBGImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    avatarBGImg.userInteractionEnabled = YES;
    avatarBGImg.backgroundColor = [UIColor clearColor];
    [self addSubview:avatarBGImg];
    
    //昵称
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarBGImg.right + 10 , avatarBGImg.top, 200, 40/3)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    nameLabel.font = [UIFont systemFontOfSize:11];
    //nickLabel.text   = self.feedModel.nick;
    //nickLabel.tag = [self.feedModel.uid integerValue];
    [self addSubview:nameLabel];
    
    //发布时间
    lastLoginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarBGImg.right + 10 , nameLabel.bottom, 100, 40/3)];
    lastLoginTimeLabel.textAlignment = NSTextAlignmentLeft;
    lastLoginTimeLabel.backgroundColor = [UIColor clearColor];
    lastLoginTimeLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    lastLoginTimeLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:lastLoginTimeLabel];
    
    //内容
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarBGImg.right + 10 , lastLoginTimeLabel.bottom, 200, 40/3)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    titleLabel.font = [UIFont systemFontOfSize:11];
    //nickLabel.text   = self.feedModel.nick;
    //nickLabel.tag = [self.feedModel.uid integerValue];
    [self addSubview:titleLabel];
    
    
    //原动态
    replyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 110, nameLabel.bottom , 80, 20)];
    replyNumLabel.backgroundColor = [UIColor clearColor];
    replyNumLabel.font = [UIFont systemFontOfSize:11];
    replyNumLabel.textAlignment = NSTextAlignmentRight;
    replyNumLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    [self addSubview:replyNumLabel];
    
    //向右更多箭头
    moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15, 15, 8, 13)];
    moreImage.backgroundColor = [UIColor clearColor];
    moreImage.image = [UIImage imageNamed:@"more_gray"];
    //[self addSubview:moreImage];
    
    contentImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-70, avatarBGImg.top, avatarBGImg.width, avatarBGImg.height)];
    [self addSubview:contentImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    /*
    "type","类型" 0 全部 1 系统 10 建群消息 11 申请加入群消息 12 退群消息 13 接受好友加入群 14 拒绝好友加入群 15 群主踢人 16 所有人可以邀请好友加入(一度) 17 动态被赞 18 动态被转播 19 动态被评论 20 被回复评论 21 给用户新的一度好友打标签 22 别人给我打标签 23 好友申请 24 新好友加入
     */
    NSString *titleStr = @"";
    switch ([self.feedModel.type integerValue]) {
        case 10:
            titleStr = @"建群消息";
            break;
        case 11:
            titleStr = @"申请加入群消息";
            break;
        case 12:
            titleStr = @"退群消息";
            break;
        case 13:
            titleStr = @"接受好友加入群";
            break;
        case 14:
            titleStr = @"拒绝好友加入群";
            break;
        case 15:
            titleStr = @"群主踢人";
            break;
        case 16:
            titleStr = @"所有人可以邀请好友加入";
            break;
        case 17:
            titleStr = @"赞了你的动态";
            break;
        case 18:
            titleStr = @"转播了你的动态";
            break;
        case 19:
            titleStr = @"评论了你的动态";
            break;
        case 20:
            titleStr = @"回复了你的评论";
            break;
        case 21:
            titleStr = @"给用户新的一度好友打标签";
            break;
        case 22:
            titleStr = @"别人给我打标签";
            break;
        case 23:
            titleStr = @"好友申请";
            break;
        case 24:
            titleStr = @"新好友加入";
            break;
        default:
            break;
    }
    nameLabel.text = self.feedModel.nick;
    titleLabel.text = titleStr;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.feedModel.sendtime integerValue]];
    lastLoginTimeLabel.text = [JYHelpers compareCurrentTime:confromTimesp];
//    avatarImg.tag = [self.feedModel.uid integerValue];
    [avatarBGImg sd_setImageWithURL:[NSURL URLWithString:self.feedModel.avatars]];
    
    
    
    if ([self.feedModel.fcontent isEqualToString:@"发表图片"]) {
        replyNumLabel.hidden = YES;
        contentImage.hidden = NO;
        NSString *key = self.feedModel.fpids.allKeys[0];
        NSDictionary *picDict = self.feedModel.fpids[key];
        NSString *pic140 = picDict[@"140"];
        [contentImage sd_setImageWithURL:[NSURL URLWithString:pic140]];
    }
    else{
        replyNumLabel.hidden = NO;
        contentImage.hidden = YES;
        replyNumLabel.text = self.feedModel.fcontent;
    }
//
//    nickLabel.text   = self.feedModel.nick;
//    nickLabel.tag    = [self.feedModel.uid integerValue];
//    
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.feedModel.time integerValue]];
//    lastLoginTimeLabel.text = [JYHelpers compareCurrentTime:confromTimesp];
//    
//    commentContent.text = self.feedModel.content;
    
}

@end
