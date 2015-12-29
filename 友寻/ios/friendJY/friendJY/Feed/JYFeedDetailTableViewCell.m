//
//  JYFeedDetailTableViewCell.m
//  friendJY
//
//  Created by ouyang on 4/7/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JYHttpServeice.h"
#import "JYFeedTextView.h"


@implementation JYFeedDetailTableViewCell{
    UIImageView * avatarImg;
    JYFeedTextView *nickLabel;
    UILabel *lastLoginTimeLabel;
    JYFeedTextView * commentContent;
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
    // 头像背景
    UIImageView *avatarBGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 27, 27)];
    avatarBGImg.userInteractionEnabled = YES;
    avatarBGImg.backgroundColor = [UIColor clearColor];
    avatarBGImg.image = [UIImage imageNamed:@"avatar_bg_150"];
    [self addSubview:avatarBGImg];
    
    // 头像
    avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 25, 25)];
    avatarImg.userInteractionEnabled = YES;
    avatarImg.layer.cornerRadius = 12.5;
    avatarImg.layer.borderColor =[[UIColor whiteColor] CGColor];
    avatarImg.layer.borderWidth = 3;
    avatarImg.layer.masksToBounds = TRUE;
    avatarImg.clipsToBounds = YES;
    
    avatarImg.backgroundColor = [UIColor clearColor];
    avatarImg.image = [UIImage imageNamed:@"pic_morentouxiang_man.png"]; //男的默认图标
    [avatarBGImg addSubview:avatarImg];
    //avatarImg.tag = [self.feedModel.uid integerValue];
    //[avatarImg sd_setImageWithURL:[NSURL URLWithString:[self.feedModel.avatars objectForKey:@"200"]]];
    [avatarImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userAvatarClick:)]];
    
    
    //昵称
//    nickLabel = [[UIView alloc] initWithFrame:CGRectMake(avatarBGImg.right + 10 , 10, 200, 20)];
//    nickLabel.userInteractionEnabled = YES;
//    nickLabel.backgroundColor = [UIColor clearColor];
//    //nickLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
//    [self addSubview:nickLabel];
//    [nickLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userAvatarClick:)]];
    
    //发布时间
    lastLoginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100 , nickLabel.top+8, 90, 20)];
    lastLoginTimeLabel.textAlignment = NSTextAlignmentRight;
    lastLoginTimeLabel.backgroundColor = [UIColor whiteColor];
    lastLoginTimeLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    lastLoginTimeLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:lastLoginTimeLabel];
    
    
    //评论内容
//    commentContent = [[UILabel alloc] initWithFrame:CGRectMake(nickLabel.left, nickLabel.bottom + 5, kScreenWidth-nickLabel.left-20, 20)];
//    commentContent.backgroundColor = [UIColor clearColor];
//    commentContent.font = [UIFont systemFontOfSize:14];
//    commentContent.textAlignment = NSTextAlignmentLeft;
//    commentContent.lineBreakMode = NSLineBreakByWordWrapping;
//    commentContent.numberOfLines = 0;
//    [self addSubview:commentContent];
    
    
}
- (void)LoadContent{
    avatarImg.tag = [self.feedModel.uid integerValue];
    [avatarImg sd_setImageWithURL:[NSURL URLWithString:[self.feedModel.avatar objectForKey:@"200"]]];
    
    //    nickLabel.text   = self.feedModel.nick;
    //    nickLabel.tag    = [self.feedModel.uid integerValue];
    
    //评论人的id数组
    NSMutableArray *IDs = [NSMutableArray array];
    //评论人的rang数组，就是从第几个字到第几个字
    NSMutableArray *IDRanges = [NSMutableArray array];
    //评论过的人名
    //
    NSMutableString * nickStr = [NSMutableString string];
    [nickStr appendString:self.feedModel.nick];
    [IDs addObject:ToString(self.feedModel.uid)];
    [IDRanges addObject:[NSValue valueWithRange:NSMakeRange(0, nickStr.length)] ];
    //如果存在回复信息，要加上回复人名
    if ([self.feedModel.reply isKindOfClass:[NSDictionary class]]) {
        NSString *replyNick = [self.feedModel.reply objectForKey:@"nick"];
        [IDs addObject:ToString([self.feedModel.reply objectForKey:@"uid"])];
        [IDRanges addObject:[NSValue valueWithRange:NSMakeRange(nickStr.length+2, replyNick.length)] ];
        [nickStr appendFormat:@"回复%@: ",replyNick];
        
    }else{
        [nickStr appendString:@": "];
    }
    
    
    [nickLabel removeFromSuperview];
    nickLabel = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    nickLabel.fontColor = [JYHelpers setFontColorWithString:@"#848484"];
    nickLabel.imgBoundSize = CGSizeMake(14, 14);
    nickLabel.showWidth = kScreenWidth -115;
    nickLabel.IDs = IDs;
    nickLabel.IDRanges = IDRanges;
    //nickLabel.userInteractionEnabled = YES;
    nickLabel.isSuperResponse = NO;
    [nickLabel layoutWithContent:nickStr];
    NSInteger commentTempHeight = nickLabel.bounds.size.height ;
    [nickLabel setFrame:CGRectMake(avatarImg.right + 15 , 12, kScreenWidth -115, commentTempHeight)];
    nickLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:nickLabel];
    
    nickLabel.IDsClickHandler = ^(JYFeedTextView *feedView, NSString *IDs, NSRange IDRange){
        if (![JYHelpers isEmptyOfString:IDs] ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFeedCellClickAvatarNotification object:IDs userInfo:nil];
        }
    };
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.feedModel.time integerValue]];
    lastLoginTimeLabel.text = [JYHelpers compareCurrentTime:confromTimesp];
    
    [commentContent removeFromSuperview];
    commentContent = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    commentContent.fontColor = [JYHelpers setFontColorWithString:@"#848484"];
    commentContent.imgBoundSize = CGSizeMake(14, 14);
    commentContent.backgroundColor = [UIColor clearColor];
    //commentContent.userInteractionEnabled = YES;
    commentContent.isSuperResponse = YES;
    commentContent.showWidth = kScreenWidth-nickLabel.left-20;
    [commentContent layoutWithContent:self.feedModel.content];
    
    int height = nickLabel.bottom;
    if (commentContent.height>20) {
        height +=10;
    }
    commentTempHeight = commentContent.bounds.size.height > 20?commentContent.bounds.size.height:20;
    [commentContent setFrame:CGRectMake(nickLabel.left, height, kScreenWidth-nickLabel.left-20, commentTempHeight)];
    [self addSubview:commentContent];
}

/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    avatarImg.tag = [self.feedModel.uid integerValue];
    [avatarImg sd_setImageWithURL:[NSURL URLWithString:[self.feedModel.avatar objectForKey:@"200"]]];
    
//    nickLabel.text   = self.feedModel.nick;
//    nickLabel.tag    = [self.feedModel.uid integerValue];
    
    //评论人的id数组
    NSMutableArray *IDs = [NSMutableArray array];
    //评论人的rang数组，就是从第几个字到第几个字
    NSMutableArray *IDRanges = [NSMutableArray array];
    //评论过的人名
    //
    NSMutableString * nickStr = [NSMutableString string];
    [nickStr appendString:self.feedModel.nick];
    [IDs addObject:ToString(self.feedModel.uid)];
    [IDRanges addObject:[NSValue valueWithRange:NSMakeRange(0, nickStr.length)] ];
    //如果存在回复信息，要加上回复人名
    if ([self.feedModel.reply isKindOfClass:[NSDictionary class]]) {
        NSString *replyNick = [self.feedModel.reply objectForKey:@"nick"];
        [IDs addObject:ToString([self.feedModel.reply objectForKey:@"uid"])];
        [IDRanges addObject:[NSValue valueWithRange:NSMakeRange(nickStr.length+2, replyNick.length)] ];
        [nickStr appendFormat:@"回复%@: ",replyNick];
        
    }else{
        [nickStr appendString:@": "];
    }
    
   
    [nickLabel removeFromSuperview];
    nickLabel = [[JYFeedTextView alloc] initWithFrame:CGRectMake(avatarImg.right + 15 , 12, kScreenWidth -90, 14)];
    nickLabel.fontColor = [JYHelpers setFontColorWithString:@"#848484"];
    nickLabel.imgBoundSize = CGSizeMake(14, 14);
    nickLabel.showWidth = 200;
    nickLabel.IDs = IDs;
    nickLabel.IDRanges = IDRanges;
    nickLabel.userInteractionEnabled = YES;
    [nickLabel layoutWithContent:nickStr];
    NSInteger commentTempHeight = nickLabel.bounds.size.height ;
    [nickLabel setFrame:CGRectMake(avatarImg.right + 15 , 12, kScreenWidth -90, commentTempHeight)];
    nickLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:nickLabel];
    
    nickLabel.IDsClickHandler = ^(JYFeedTextView *feedView, NSString *IDs, NSRange IDRange){
        if (![JYHelpers isEmptyOfString:IDs] ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFeedCellClickAvatarNotification object:IDs userInfo:nil];
        }
    };
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.feedModel.time integerValue]];
    lastLoginTimeLabel.text = [JYHelpers compareCurrentTime:confromTimesp];
    
    [commentContent removeFromSuperview];
    commentContent = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    commentContent.fontColor = [JYHelpers setFontColorWithString:@"#848484"];
    commentContent.imgBoundSize = CGSizeMake(14, 14);
    commentContent.backgroundColor = [UIColor clearColor];
    commentContent.userInteractionEnabled = YES;
    commentContent.isSuperResponse = YES;
    commentContent.showWidth = kScreenWidth-nickLabel.left-20;
    [commentContent layoutWithContent:self.feedModel.content];
    
    int height = nickLabel.bottom;
    if (commentContent.height>20) {
        height +=10;
    }
    commentTempHeight = commentContent.bounds.size.height > 20?commentContent.bounds.size.height:20;
    [commentContent setFrame:CGRectMake(nickLabel.left, height, kScreenWidth-nickLabel.left-20, commentTempHeight)];
    [self addSubview:commentContent];
}
 */

//点击头像
- (void) _userAvatarClick:(UIGestureRecognizer *)gesture{
    NSString * myuid = [NSString stringWithFormat:@"%ld",gesture.view.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFeedDetailCellClickAvatarNotification object:myuid userInfo:nil];
}
@end
