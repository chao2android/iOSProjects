//
//  JYFeedTableViewCell.m
//  friendJY
//
//  Created by ouyang on 3/26/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedTableViewCell.h"
#import "JYHelpers.h"
#import "NSString+CXAHyperlinkParser.h"
#import "JYShareData.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYPhoto.h"
#import "JYPhotoBrowserController.h"
#import "UIImageView+WebCache.h"
#import "JYShareData.h"
#import "JYFeedTextView.h"
#import "JYFeedData.h"
#import "JYProfileController.h"
#import "JYOtherProfileController.h"
#import "JYFeedCellTagView.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}


@implementation JYFeedTableViewCell{
    UIImageView *avatarImg;
    UIImageView *sexImg;
    UIImageView *rebroadcastSexImg;
    UILabel *nickLabel;
    UILabel *rebroadcastNickLabel;
    UILabel *lastLoginTimeLabel;
    UILabel *rebroadcastCtimeLabel;
    UILabel *marriageLabel;
    UILabel *rebroadcastLabel;
    UILabel *rebroadcastMarriageLabel;
    UIView *dynamicContent;
    UILabel *secondFriendTitleLabel;
    UILabel *praiseLineLabel;
    UILabel *praise2LineLabel;
    UILabel *praise3LineLabel;
    UIView *bgView;
    UIImageView *praiseListBGImg;
    UILabel *praiseTitle;
    UILabel *rebroadcastTitle;
    UILabel *commentTitle;
    UIView *praiseListNick;
    UIView *rebroadcastListNick;
    UIView *commentListNickView;
    UIView *rebroadcastBg;
    UIImageView *praiseAddOneImg;
    UIImageView *rebroadcastAddOneImg;
    UILabel *praiseExpand;
    UILabel *rebroadcastExpand;
    UILabel *dynamicContentExpand;
    UIView *dynamicPicFaterView;
    JYFeedCellTagView *tagBgView;
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


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSMutableString *urlString = [URL.absoluteString mutableCopy];
    NSRange range = [urlString rangeOfString:@"uid="];
    if (range.location != NSNotFound) {
        NSString *uid = [urlString substringFromIndex:(range.location+range.length)];
        JYNavigationController *currentNav = (JYNavigationController*)[JYAppDelegate sharedAppDelegate].mainTabBarController.selectedViewController;
        JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
        _proVC.show_uid = uid;
        [currentNav pushViewController:_proVC animated:YES];
        return NO;
    }
    return NO;
}

#pragma mark - init method
- (void)_initFeedSubviews
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, kScreenWidth - 10, 210)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = [[JYHelpers setFontColorWithString:@"#e2e5e7"] CGColor];
    bgView.layer.borderWidth = 1;
    [self.contentView addSubview:bgView];
    
    // 头像背景
    UIImageView *avatarBGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 52, 52)];
    avatarBGImg.userInteractionEnabled = YES;
    avatarBGImg.backgroundColor = [UIColor clearColor];
    avatarBGImg.image = [UIImage imageNamed:@"avatar_bg_150"];
    [bgView addSubview:avatarBGImg];
    
    // 头像
    avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 50, 50)];
    avatarImg.userInteractionEnabled = YES;
    avatarImg.layer.cornerRadius = 25;
    avatarImg.layer.borderColor =[[UIColor whiteColor] CGColor];
    avatarImg.layer.borderWidth = 3;
    avatarImg.layer.masksToBounds = TRUE;
    avatarImg.clipsToBounds = YES;
    avatarImg.backgroundColor = [UIColor clearColor];
    avatarImg.image = [UIImage imageNamed:@"pic_morentouxiang_man.png"]; //男的默认图标
    [avatarBGImg addSubview:avatarImg];
    //[avatarImg setImageWithURL:[NSURL URLWithString:[[profileDataDic objectForKey:@"avatars"] objectForKey:@"200"]]];
    [avatarImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userAvatarClick:)]];
    
    
    
    //昵称
    nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarBGImg.right+5 , avatarBGImg.top, 143, 20)];
    nickLabel.textAlignment = NSTextAlignmentLeft;
    nickLabel.userInteractionEnabled = YES;
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    nickLabel.font = [UIFont systemFontOfSize:14];
    nickLabel.text = @"Angus";
    [bgView addSubview:nickLabel];
    [nickLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userAvatarClick:)]];
    
    
    //发布时间
    lastLoginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.right - 85 , nickLabel.top, 70, 20)];
    lastLoginTimeLabel.textAlignment = NSTextAlignmentRight;
    lastLoginTimeLabel.backgroundColor = [UIColor clearColor];
    lastLoginTimeLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    lastLoginTimeLabel.font = [UIFont systemFontOfSize:12];
    lastLoginTimeLabel.text = @"59分钟前";
    [bgView addSubview:lastLoginTimeLabel];
    
    //性别
    sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(avatarBGImg.right + 5, nickLabel.bottom+5, 12, 12)];
    //avatarImg.tag = 2090850;
    sexImg.backgroundColor = [UIColor clearColor];
    sexImg.image = [UIImage imageNamed:@"female_12"]; //男的默认图标
    [bgView addSubview:sexImg];
    
    
    //情感状态
    marriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexImg.right + 10, sexImg.top -2 , 70, 15)];
    marriageLabel.textAlignment = NSTextAlignmentLeft;
    marriageLabel.backgroundColor = [UIColor clearColor];
    marriageLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    marriageLabel.font = [UIFont systemFontOfSize:12];
    marriageLabel.text = [[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:self.feedModel.marriage];
    [bgView addSubview:marriageLabel];
    
    //转播动态提示
    rebroadcastLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarBGImg.left, avatarBGImg.bottom+5, 70, 20)];
    rebroadcastLabel.textAlignment = NSTextAlignmentLeft;
    rebroadcastLabel.backgroundColor = [UIColor clearColor];
    rebroadcastLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    rebroadcastLabel.font = [UIFont systemFontOfSize:14];
    rebroadcastLabel.text = @"转播动态";
    [bgView addSubview:rebroadcastLabel];
    
    //当为500或501时，
    rebroadcastBg = [[UIView alloc] initWithFrame:CGRectMake(bgView.left+5, rebroadcastLabel.bottom + 10, bgView.width-20, 120)];
    rebroadcastBg.backgroundColor = [UIColor whiteColor];
    rebroadcastBg.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    rebroadcastBg.layer.borderWidth = 1;
    rebroadcastBg.hidden = YES;
    [bgView addSubview:rebroadcastBg];
    
    
    
    
    //转播时显示的原动态人昵称
    rebroadcastNickLabel = [[UILabel alloc] initWithFrame:CGRectMake(rebroadcastBg.left + 10 , rebroadcastBg.top + 10, 143, 20)];
    rebroadcastNickLabel.textAlignment = NSTextAlignmentLeft;
    rebroadcastNickLabel.userInteractionEnabled = YES;
    rebroadcastNickLabel.backgroundColor = [UIColor clearColor];
    rebroadcastNickLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    rebroadcastNickLabel.font = [UIFont systemFontOfSize:14];
    rebroadcastNickLabel.text = @"Angus";
    rebroadcastNickLabel.hidden = YES;
    [bgView addSubview:rebroadcastNickLabel];
    [rebroadcastNickLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userAvatarClick:)]];
    
    //转播时显示的原动态人发布时间
    rebroadcastCtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(rebroadcastBg.right - 80 , rebroadcastNickLabel.top, 70, 20)];
    rebroadcastCtimeLabel.textAlignment = NSTextAlignmentRight;
    rebroadcastCtimeLabel.backgroundColor = [UIColor clearColor];
    rebroadcastCtimeLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    rebroadcastCtimeLabel.font = [UIFont systemFontOfSize:12];
    rebroadcastCtimeLabel.text = @"59分钟前";
    rebroadcastCtimeLabel.hidden = YES;
    [bgView addSubview:rebroadcastCtimeLabel];
    
    //转播时显示的原动态人性别
    rebroadcastSexImg = [[UIImageView alloc] initWithFrame:CGRectMake(rebroadcastBg.left + 10, rebroadcastNickLabel.bottom+ 5, 12, 12)];
    rebroadcastSexImg.backgroundColor = [UIColor clearColor];
    rebroadcastSexImg.image = [UIImage imageNamed:@"female_12"]; //男的默认图标
    rebroadcastSexImg.hidden = YES;
    
    [bgView addSubview:rebroadcastSexImg];
    
    //转播时显示的原动态人情感状态
    rebroadcastMarriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(rebroadcastSexImg.right + 10, rebroadcastNickLabel.bottom + 3, 70, 15)];
    rebroadcastMarriageLabel.clipsToBounds = YES;
    rebroadcastMarriageLabel.textAlignment = NSTextAlignmentLeft;
    rebroadcastMarriageLabel.backgroundColor = [UIColor clearColor];
    rebroadcastMarriageLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    rebroadcastMarriageLabel.font = [UIFont systemFontOfSize:12];
    rebroadcastMarriageLabel.text = @"单身";//@"发表动态";
    rebroadcastMarriageLabel.hidden = YES;
    [bgView addSubview:rebroadcastMarriageLabel];
    
    
    //动态内容
    dynamicContent = [[UIView alloc] initWithFrame:CGRectMake(marriageLabel.left, marriageLabel.bottom + 5, bgView.width - sexImg.left -10, 0)];
    dynamicContent.userInteractionEnabled = YES;
    dynamicContent.clipsToBounds = YES;
    dynamicContent.backgroundColor = [UIColor clearColor];
//    dynamicContent.font = [UIFont systemFontOfSize:14];
//    dynamicContent.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:dynamicContent];
    
    //动态的照片内容
    dynamicPicFaterView = [[UIView alloc] init];
    dynamicPicFaterView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:dynamicPicFaterView];
    
    //动态内容超出三行的，要收起。
    dynamicContentExpand = [[UILabel alloc] initWithFrame:CGRectZero];
    dynamicContentExpand.backgroundColor = [UIColor clearColor];
    dynamicContentExpand.font = [UIFont systemFontOfSize:14];
    dynamicContentExpand.textAlignment = NSTextAlignmentCenter;
    dynamicContentExpand.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    dynamicContentExpand.userInteractionEnabled = YES;
    dynamicContentExpand.clipsToBounds = YES;
    [bgView addSubview:dynamicContentExpand];
    [dynamicContentExpand addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dynamicContentExpandClick:)]];
    
    for (int i = 0; i<9; i++) {
        UIImageView *dynamicPic = [[UIImageView alloc] initWithFrame:CGRectZero];
        dynamicPic.clipsToBounds = YES;
        dynamicPic.userInteractionEnabled = YES;
        dynamicPic.backgroundColor = [UIColor clearColor];
        dynamicPic.tag = 1000+i;
        dynamicPic.contentMode = UIViewContentModeScaleAspectFill;
        [dynamicPicFaterView addSubview:dynamicPic];
        [dynamicPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserThisPhotoClick:)]];
    }
    
    //好友的好友标题
    secondFriendTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarImg.left, dynamicContent.bottom, 100, 20)];
    secondFriendTitleLabel.textAlignment = NSTextAlignmentLeft;
    secondFriendTitleLabel.backgroundColor = [UIColor clearColor];
    secondFriendTitleLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    secondFriendTitleLabel.font = [UIFont systemFontOfSize:14];
    secondFriendTitleLabel.text = @"好友的好友";
    secondFriendTitleLabel.userInteractionEnabled = YES;
    [bgView addSubview:secondFriendTitleLabel];
    [secondFriendTitleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_praiseMoreClickExpand)]];
    
    //赞，2转播，3评论
    praiseLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.right - 175, secondFriendTitleLabel.top, 40, 20)];
    praiseLineLabel.textAlignment = NSTextAlignmentRight;
    praiseLineLabel.backgroundColor = [UIColor clearColor];
    praiseLineLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    praiseLineLabel.font = [UIFont systemFontOfSize:14];
    praiseLineLabel.text = @"3赞";
    praiseLineLabel.userInteractionEnabled = YES;
    [bgView addSubview:praiseLineLabel];
    [praiseLineLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toUserPraiseClick:)]];
    
    praise2LineLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.right - 125, secondFriendTitleLabel.top, 50, 20)];
    praise2LineLabel.textAlignment = NSTextAlignmentRight;
    praise2LineLabel.backgroundColor = [UIColor clearColor];
    praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    praise2LineLabel.font = [UIFont systemFontOfSize:14];
    praise2LineLabel.text = @"4转播";
    praise2LineLabel.userInteractionEnabled = YES;
    [bgView addSubview:praise2LineLabel];
    [praise2LineLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toReboardCastClick:)]];
    
    praise3LineLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.right - 65, secondFriendTitleLabel.top, 50, 20)];
    praise3LineLabel.textAlignment = NSTextAlignmentRight;
    praise3LineLabel.backgroundColor = [UIColor clearColor];
    praise3LineLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    praise3LineLabel.font = [UIFont systemFontOfSize:14];
    praise3LineLabel.text = @"2评论";
    praise3LineLabel.userInteractionEnabled = YES;
    [bgView addSubview:praise3LineLabel];
    [praise3LineLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toUserCommendClick:)]];
    
    // 赞，评论列表的背景
    praiseListBGImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *img=[UIImage imageNamed:@"replyBg"];
    praiseListBGImg.image = [img stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    praiseListBGImg.userInteractionEnabled = YES;
    [bgView addSubview:praiseListBGImg];
    
    //赞过
    praiseTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 0, 0)];
    praiseTitle.textAlignment = NSTextAlignmentRight;
    praiseTitle.backgroundColor = [UIColor clearColor];
    praiseTitle.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    praiseTitle.font = [UIFont systemFontOfSize:14];
    praiseTitle.text = @"赞过";
    praiseTitle.clipsToBounds = YES;
    [praiseListBGImg addSubview:praiseTitle];
    
    //赞过的人名
    praiseListNick = [[JYFeedTextView alloc] initWithFrame:CGRectMake(praiseTitle.right+5, praiseTitle.top, 0, 0)];
    praiseListNick.backgroundColor = [UIColor clearColor];
    praiseListNick.userInteractionEnabled = YES;
    [praiseListBGImg addSubview:praiseListNick];
    
    //转播
    rebroadcastTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, praiseTitle.bottom+10, 0, 0)];
    rebroadcastTitle.textAlignment = NSTextAlignmentRight;
    rebroadcastTitle.backgroundColor = [UIColor clearColor];
    rebroadcastTitle.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    rebroadcastTitle.font = [UIFont systemFontOfSize:14];
    rebroadcastTitle.text = @"转播";
    rebroadcastTitle.clipsToBounds = YES;
    [praiseListBGImg addSubview:rebroadcastTitle];

    //转播过的人名
    rebroadcastListNick = [[UIView alloc] initWithFrame:CGRectMake(rebroadcastTitle.right+5, rebroadcastTitle.top, 0, 0)];
    rebroadcastListNick.backgroundColor = [UIColor clearColor];
    [praiseListBGImg addSubview:rebroadcastListNick];
    rebroadcastListNick.userInteractionEnabled = YES;

    
    //评论
    commentTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, rebroadcastTitle.bottom+10, 0, 0)];
    commentTitle.textAlignment = NSTextAlignmentRight;
    commentTitle.backgroundColor = [UIColor clearColor];
    commentTitle.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    commentTitle.font = [UIFont systemFontOfSize:14];
    commentTitle.text = @"评论";
    commentTitle.clipsToBounds = YES;
    [praiseListBGImg addSubview:commentTitle];
    
    //评论过的人名
    commentListNickView = [[UIView alloc] initWithFrame:CGRectMake(commentTitle.right+5, commentTitle.top, 0, 0)];
    commentListNickView.backgroundColor = [UIColor clearColor];
    [praiseListBGImg addSubview:commentListNickView];
    
    
    //赞加1
    praiseAddOneImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    praiseAddOneImg.image = [UIImage imageNamed:@"feedAddPraise"];
    [bgView addSubview:praiseAddOneImg];
    
    //转播加1
    rebroadcastAddOneImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    rebroadcastAddOneImg.image = [UIImage imageNamed:@"feedAddReboardcast"];
    [bgView addSubview:rebroadcastAddOneImg];
    //[self _addTest];
}

- (void) _testself:(UIImageView*) iv{
    CGRect rect =  CGRectMake(0, (100/78*140-100)/2, 100, 100);
    CGImageRef cgimg = CGImageCreateWithImageInRect([iv.image CGImage], rect);
    //test.image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
}


- (float) LoadContent{
    
    dynamicContent.hidden = NO;
    [avatarImg sd_setImageWithURL:[NSURL URLWithString:[self.feedModel.avatars objectForKey:@"200"]]];
    if ([self.feedModel.sex intValue] == 0) { //0-女，1-男
        sexImg.image = [UIImage imageNamed:@"female_12"]; //男的默认图标
        nickLabel.textColor = [JYHelpers setFontColorWithString:@"#fa544f"];
    }else{
        sexImg.image = [UIImage imageNamed:@"male_12"]; //男的默认图标
        nickLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    }
    
    avatarImg.tag = [self.feedModel.uid integerValue];
    
    nickLabel.text   = self.feedModel.nick;
    nickLabel.tag = [self.feedModel.uid integerValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.feedModel.time integerValue]];
    NSLog(@"---->%@",confromTimesp);
    lastLoginTimeLabel.text = [JYHelpers compareCurrentTime:confromTimesp];
    
    //单身，500-转播文字,501-转播图片
    if([self.feedModel.type integerValue] == 500){
        //marriageLabel.text  = @"转播动态";//@"转播文字";
        rebroadcastLabel.hidden = NO;
    }else if([self.feedModel.type integerValue] == 501){
        //marriageLabel.text  = @"转播动态";//@"转播图片";
        rebroadcastLabel.hidden = NO;
    }else{
        rebroadcastLabel.hidden = YES;
    }
    marriageLabel.text = [[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:self.feedModel.marriage];
    if ([marriageLabel.text isEqualToString:@"保密"]) {
        marriageLabel.hidden = YES;
    }
    else{
        marriageLabel.hidden = NO;
    }
    
    //先将所有图片设置为隐藏
    for (int i = 0; i<9; i++) {
        UIImageView * tempImg = (UIImageView *)[self viewWithTag:1000+i];
        tempImg.frame = CGRectZero;
    }
    //500和501为转播，内容显示不一样
    dynamicContentExpand.frame  = CGRectZero;
    NSString *textStr = [self.feedModel.data objectForKey:@"content"];
    [dynamicContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    JYFeedTextView * _dynamicContentCoreText = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    
    //如果存在链接的情况，要加上链接点击
    NSRange yxrange = [textStr rangeOfString:YX_HOST];
    if (yxrange.length > 0) { //存在友寻链接
        NSMutableArray *IDS = [NSMutableArray array];
        NSMutableArray *IDRanges = [NSMutableArray array];
        NSString *myLink = [textStr substringFromIndex:yxrange.location];
        NSArray * linkArr = [myLink componentsSeparatedByString:@"="];
        [IDS addObject:[[linkArr lastObject] substringToIndex:7]];
        [IDRanges addObject:[NSValue valueWithRange:[textStr rangeOfString:myLink]] ];
        _dynamicContentCoreText.IDs = IDS;
        _dynamicContentCoreText.IDRanges = IDRanges;
    }
    _dynamicContentCoreText.imgBoundSize = CGSizeMake(14, 14);
    _dynamicContentCoreText.fontColor = [UIColor blackColor];
    _dynamicContentCoreText.backgroundColor = [UIColor clearColor];
    int showExpandHeight = 0;
    dynamicContentExpand.frame = CGRectZero;
    dynamicContentExpand.clipsToBounds = YES;
    
    //判断是不是 打标签
    NSRange tagRange = [textStr rangeOfString:@"标签"];
    NSArray *tagArray = [[NSArray alloc]init];
    BOOL haveTag = NO;
    tagBgView = [[JYFeedCellTagView alloc]init];
    tagBgView.backgroundColor = [UIColor clearColor];
    if (tagRange.length > 0) {
        NSString *tagStr = @"";
        tagStr = [textStr substringFromIndex:(tagRange.location+tagRange.length+2)];
        tagStr = [tagStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        //tagArray = [tagStr componentsSeparatedByString:@","];
        tagArray = [tagStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        textStr = [textStr substringToIndex:(tagRange.location+tagRange.length+1)];
        if (tagArray.count>0) {
            tagBgView.hidden = NO;
            haveTag = YES;
        }else{
            haveTag = NO;
            tagBgView.hidden = YES;
            [tagBgView removeFromSuperview];
        }
    }else{
        tagBgView.hidden = YES;
        [tagBgView removeFromSuperview];
        haveTag = NO;
    }
    
    if ([self.feedModel.type integerValue] == 100 || [self.feedModel.type integerValue] == 101) {
        rebroadcastBg.hidden = YES;
        rebroadcastCtimeLabel.hidden = YES;
        rebroadcastMarriageLabel.hidden = YES;
        rebroadcastNickLabel.hidden = YES;
        rebroadcastSexImg.hidden = YES;
        
        if(![JYHelpers isEmptyOfString:textStr]){
            [_dynamicContentCoreText setShowWidth:(bgView.width - sexImg.left -10)];
            [_dynamicContentCoreText layoutWithContent:textStr];
//            CGSize strSize = [JYHelpers getTextWidthAndHeight:textStr fontSize:14 uiWidth:bgView.width - sexImg.left -10];
            int dynamicContentHeight = _dynamicContentCoreText.height+2;

            if(dynamicContentHeight > 58 && !self.feedModel.contentIsExpand && _dynamicContentCoreText.totalLineNumber > 3){
                dynamicContentHeight = 45.8;
                showExpandHeight = 20;
                dynamicContentExpand.text = @"展开";
                dynamicContentExpand.frame = CGRectMake(dynamicContent.left-20, dynamicContent.bottom + 5, 70, 30);
            }
            if(dynamicContentHeight > 58 && self.feedModel.contentIsExpand&& _dynamicContentCoreText.totalLineNumber > 3){
//                if (strSize.height> 1000) { //当strSize的高度大于1000时加65，其于加20. 由于strsize过大时，高度计算不准 ， 再加上我们规定最多输入1000个字。暂时先这样应对着，肯定存在问题
//                    dynamicContentHeight = strSize.height+65;
//                }else{
//                    dynamicContentHeight = strSize.height+20;
//                }
                dynamicContentHeight =  _dynamicContentCoreText.height;
                showExpandHeight = 20;
                dynamicContentExpand.text = @"收起";
                dynamicContentExpand.frame = CGRectMake(dynamicContent.left-20, dynamicContent.bottom + 5, 70, 30);
            }
            _dynamicContentCoreText.frame = CGRectMake(0, 0, _dynamicContentCoreText.width, _dynamicContentCoreText.height);
            dynamicContent.frame = CGRectMake(sexImg.left, marriageLabel.bottom + 5, bgView.width - sexImg.left -10, dynamicContentHeight+5);//strSize.height+5
            [dynamicContent addSubview:_dynamicContentCoreText];
            if (haveTag && tagArray.count>0) {
                tagBgView.frame = CGRectMake(0, 0, bgView.width - sexImg.left -10, 0);
                float tagHeight = [tagBgView LoadContent:tagArray withWidth:bgView.width - sexImg.left -10];
                dynamicContent.frame = CGRectMake(sexImg.left, marriageLabel.bottom + 5, bgView.width - sexImg.left -10, dynamicContentHeight+tagHeight);
                tagBgView.frame = CGRectMake(0, dynamicContentHeight, bgView.width - sexImg.left -10, tagHeight);
                [dynamicContent addSubview:tagBgView];
            }else{
                
            }

            if (_dynamicContentCoreText.height > 58 && _dynamicContentCoreText.totalLineNumber > 3) {
                dynamicContentExpand.frame = CGRectMake(dynamicContent.left-20, dynamicContent.bottom , 70, 30);
            }
        }else{
            dynamicContent.frame = CGRectMake(sexImg.left, marriageLabel.bottom + 5, 0, 0);
        }
        
        
        //显示图片
        CGPoint startPosition = CGPointMake(sexImg.left, dynamicContent.bottom+showExpandHeight + 10);
        [self _showDynamicPic:startPosition];
        
        
    }else{
        rebroadcastBg.hidden = NO;
        rebroadcastCtimeLabel.hidden = NO;
        rebroadcastMarriageLabel.hidden = NO;
        rebroadcastNickLabel.hidden = NO;
        rebroadcastSexImg.hidden = NO;
        dynamicContent.hidden = NO;
        if ([self.feedModel.data[@"status"] intValue] == -1) {//如果原文被删除
            rebroadcastNickLabel.text = @"该内容已被原作者删除";
            rebroadcastNickLabel.textColor = [UIColor blackColor];
            rebroadcastSexImg.hidden = YES;
            rebroadcastCtimeLabel.hidden = YES;
            rebroadcastMarriageLabel.hidden = YES;
            dynamicContent.hidden = YES;
            rebroadcastBg.size = CGSizeMake(bgView.width-20, 40);
            secondFriendTitleLabel.frame = CGRectMake(rebroadcastBg.left, rebroadcastBg.bottom+5, 100, 20);
        }else{
            //动态原始人的昵称
            rebroadcastNickLabel.text = [self.feedModel.data objectForKey:@"nick"];
            rebroadcastNickLabel.tag = [[self.feedModel.data objectForKey:@"uid"] integerValue];
            //        NSLog(@"%ld",[[self.feedModel.data objectForKey:@"uid"] integerValue]);
            //动态原始人的性别
            if ([JYHelpers integerValueOfAString:self.feedModel.data[@"sex"]] == 0) { //0-女，1-男
                rebroadcastSexImg.image = [UIImage imageNamed:@"female_12"]; //男的默认图标
                rebroadcastNickLabel.textColor = [JYHelpers setFontColorWithString:@"#fa544f"];
            }else{
                rebroadcastSexImg.image = [UIImage imageNamed:@"male_12"]; //男的默认图标
                rebroadcastNickLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
            }
            
            //动态原始发布的时间
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[self.feedModel.data objectForKey:@"time"] integerValue]];
            rebroadcastCtimeLabel.text = [JYHelpers compareCurrentTime:confromTimesp];
            NSLog(@"__%@",self.feedModel.data);
            rebroadcastMarriageLabel .text =[[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:[self.feedModel.data objectForKey:@"marriage"]];
            
            if ([rebroadcastMarriageLabel.text isEqualToString:@"保密"]) {
                rebroadcastMarriageLabel.hidden = YES;
            }
            else{
                rebroadcastMarriageLabel.hidden = NO;
            }
            if(![JYHelpers isEmptyOfString:textStr]){
                [_dynamicContentCoreText setShowWidth:rebroadcastBg.width -20];
                [_dynamicContentCoreText layoutWithContent:textStr];
//                CGSize strSize = [JYHelpers getTextWidthAndHeight:textStr fontSize:14 uiWidth:rebroadcastBg.width -20];
                int dynamicContentHeight = _dynamicContentCoreText.height+2;
                if(dynamicContentHeight > 58 && !self.feedModel.contentIsExpand&& _dynamicContentCoreText.totalLineNumber > 3){
                    dynamicContentHeight = 45;
                    showExpandHeight = 20;
                    dynamicContentExpand.text = @"展开";
                }
                
                if(dynamicContentHeight > 58 && self.feedModel.contentIsExpand&& _dynamicContentCoreText.totalLineNumber > 3){
                    
//                    if (strSize.height> 800) { //当strSize的高度大于1000时加50，其于加0. 由于strsize过大时，高度计算不准 ， 再加上我们规定最多输入1000个字。暂时先这样应对着，肯定存在问题
//                        dynamicContentHeight = strSize.height+50;
//                    }else{
//                        dynamicContentHeight = strSize.height;
//                    }
                    dynamicContentHeight = _dynamicContentCoreText.height;
                    showExpandHeight = 20;
                    dynamicContentExpand.text = @"收起";
                }
                dynamicContent.frame = CGRectMake(rebroadcastSexImg.left, rebroadcastMarriageLabel.bottom + 5, rebroadcastBg.width -20, dynamicContentHeight+5);
//                dynamicContent.text = textStr;
                _dynamicContentCoreText.frame = CGRectMake(0, 0, _dynamicContentCoreText.width, _dynamicContentCoreText.height);
                [dynamicContent addSubview:_dynamicContentCoreText];
                
                if (haveTag && tagArray.count>0) {
                    tagBgView.frame = CGRectMake(0, 0, bgView.width - sexImg.left -10, 0);
                    float tagHeight = [tagBgView LoadContent:tagArray withWidth:rebroadcastBg.width -20];
                    dynamicContent.frame = CGRectMake(rebroadcastSexImg.left, rebroadcastMarriageLabel.bottom + 5, rebroadcastBg.width -20, dynamicContentHeight+tagHeight);
                    tagBgView.frame = CGRectMake(0, dynamicContentHeight, rebroadcastBg.width -20, tagHeight);
                    [dynamicContent addSubview:tagBgView];
                }else{
                    for (int i = 0; i<tagBgView.subviews.count; i++) {
                        UIView *view = tagBgView.subviews[i];
                        [view removeFromSuperview];
                    }
                }
                
                if (_dynamicContentCoreText.height > 58 && _dynamicContentCoreText.totalLineNumber > 3) {
                    dynamicContentExpand.frame = CGRectMake(dynamicContent.left-20, dynamicContent.bottom, 70, 20);
                }
            }else{
                dynamicContent.frame = CGRectMake(rebroadcastSexImg.left, rebroadcastMarriageLabel.bottom + 5, 0, 0);
            }
            
            //显示图片
            CGPoint startPosition = CGPointMake(dynamicContent.left, dynamicContent.bottom+showExpandHeight + 10);
            [self _showDynamicPic:startPosition];
            
            rebroadcastBg.size = CGSizeMake(bgView.width-20, secondFriendTitleLabel.top -rebroadcastBg.top- 5);
        }
    }

    _dynamicContentCoreText.IDsClickHandler = ^(JYFeedTextView *feedView, NSString *IDs, NSRange IDRange){
        if (![JYHelpers isEmptyOfString:IDs] ) {
            JYNavigationController *currentNav = (JYNavigationController*)[JYAppDelegate sharedAppDelegate].mainTabBarController.selectedViewController;
            JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
            _proVC.show_uid = IDs;
            [currentNav pushViewController:_proVC animated:YES];
        }
        
    };

    //显示赞的数
    if (self.feedModel.praise_list.count >99) {
        praiseLineLabel.text = @"99赞";
    }else{
        praiseLineLabel.text = [NSString stringWithFormat:@"%ld赞", (unsigned long)self.feedModel.praise_list.count];
    }
    praiseLineLabel.origin = CGPointMake(praiseLineLabel.left, secondFriendTitleLabel.top);
    //如果已赞过了，要变灰
    if([self.feedModel.is_praise integerValue] == 1 ){
        praiseLineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    }else{
        praiseLineLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    }
    
    //显示转播的数
    if ([self.feedModel.rebroadcast_num intValue] >99) {
        praise2LineLabel.text = @"99+转播";
    }else{
        praise2LineLabel.text = [NSString stringWithFormat:@"%d转播", [self.feedModel.rebroadcast_num intValue]];
    }
    praise2LineLabel.origin = CGPointMake(praise2LineLabel.left, secondFriendTitleLabel.top);
    
    //如果已转播了，要变灰
    NSString * myUid =[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if([self.feedModel.is_rebroadcast integerValue] == 1 || [self.feedModel.uid isEqualToString:myUid] ) {
        praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        praise2LineLabel.userInteractionEnabled = NO;
    }else{
        praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
        praise2LineLabel.userInteractionEnabled = YES;
        if ([self.feedModel.type intValue] == 500 || [self.feedModel.type intValue] == 501) {
            if ([[self.feedModel.data objectForKey:@"uid"] isEqualToString:myUid] || [self.feedModel.data[@"status"] intValue] == -1) {
                praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
                praise2LineLabel.userInteractionEnabled = NO;
            }
        }
    }
//    for (int i = 0; i<self.feedModel.rebroadcast_list.count; i++) {
//        if ([self.feedModel.rebroadcast_list[i][@"uid"] isEqualToString:myUid]) {
//            NSLog(@"已经转播过了");
//            praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
//        }
//    }
    
    //显示评论数
    if ([self.feedModel.comment_num integerValue] >99) {
        praise3LineLabel.text = @"99评论";
    }else{
        praise3LineLabel.text = [NSString stringWithFormat:@"%@评论", self.feedModel.comment_num];
    }
    praise3LineLabel.origin = CGPointMake(praise3LineLabel.left, secondFriendTitleLabel.top);
    //如果已评论了，要变灰
    if([self.feedModel.is_comment integerValue] == 1){
        praise3LineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        praise3LineLabel.userInteractionEnabled = NO;
    }
    
    //删除评论里的所有子元素
    [commentListNickView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; //先删除view下面的子元素
    //删除赞里的所有子元素
    [praiseListNick.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; //先删除view下面的子元素
    //删除转播里的所有子元素
    [rebroadcastListNick.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; //先删除view下面的子元素
    
    // 赞，评论列表的背景
    if (self.feedModel.praise_list.count == 0 && [self.feedModel.comment_num integerValue] == 0 && self.feedModel.rebroadcast_list.count == 0) {
        praiseListBGImg.frame = CGRectMake(secondFriendTitleLabel.left, secondFriendTitleLabel.bottom+5, 0, 0);
        praiseTitle.frame = CGRectMake(5, 15, 0, 0);
        rebroadcastTitle.frame = CGRectMake(5, praiseTitle.bottom + 10, 0, 0);
        commentTitle.frame = CGRectMake(5, rebroadcastTitle.bottom + 10, 0, 0);
        praiseListNick.frame = CGRectMake(praiseTitle.right+5, praiseTitle.top, 0, 0);
        rebroadcastListNick.frame = CGRectMake(rebroadcastTitle.right+5, rebroadcastTitle.top, 0, 0);
    }else{
        int contentHeight = 20;
        
        //赞过的人
        int positionY = 15; //初始化15的高度，因为下面三个都有可能不出现，需动态定位y值
        if (self.feedModel.praise_list.count > 0) {
            praiseTitle.frame = CGRectMake(5, positionY, 40, 20);
            CGFloat myHeight = [self _addPraiseUser];
            positionY =praiseTitle.top + myHeight+ 10;
            contentHeight += myHeight+10;
            
        }else{
            praiseTitle.frame = CGRectMake(5, positionY, 0, 0);
            praiseListNick.frame = CGRectMake(praiseTitle.right+5, praiseTitle.top, 0, 0);
        }
        
        //转播的人
        if (self.feedModel.rebroadcast_list.count > 0) {
            rebroadcastTitle.frame = CGRectMake(5, positionY, 40, 20);
            CGFloat myHeight = [self _addRebroadcastUser];
            positionY =rebroadcastTitle.top + myHeight+ 10;
            contentHeight += myHeight+10;
        }else{
            rebroadcastTitle.frame    = CGRectMake(5, positionY, 0, 0);
            rebroadcastListNick.frame = CGRectMake(rebroadcastTitle.right+5, rebroadcastTitle.top, 0, 0);
        }
        
        //评论的人
        if ([self.feedModel.comment_num integerValue] > 0) {
            
            NSLog(@"---->%@",self.feedModel.comment_list);
            //对评论进行排序
            NSDictionary *t;
            NSMutableArray *muArr = [[NSMutableArray alloc]initWithArray:self.feedModel.comment_list];
            //muArr = self.feedModel.comment_list;
            for (int i = 0; i<[muArr count]-1; i++) {
                for (int j =0; j<[muArr count]-i-1; j++) {
                    NSInteger data1 = [muArr[j+1][@"time"]intValue];
                    NSInteger data2 = [muArr[j]  [@"time"]intValue];
                    if (data1 == MIN(data1, data2)) {
                        t = [muArr objectAtIndex:j+1];
                        //对数组里的数据逆序存放
                        [muArr exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                        [muArr replaceObjectAtIndex:j withObject:t];
                    }
                }
            }
            
            commentTitle.frame = CGRectMake(5, positionY, 40, 20);
            //最多显示三条评论
            NSInteger myCommentMun = self.feedModel.comment_list.count;
            if (myCommentMun > 3) {
                myCommentMun = 3;
            }
            
            NSInteger myCommentPos = 0;
            for (int i = 0; i< myCommentMun; i++) {
                //评论人的id数组
                NSMutableArray *IDs = [NSMutableArray array];
                //评论人的rang数组，就是从第几个字到第几个字
                NSMutableArray *IDRanges = [NSMutableArray array];
                //评论过的人名
                //
                NSMutableString * nickStr = [NSMutableString string];
                if ([[muArr objectAtIndex:i] objectForKey:@"uid"]) {
                    [nickStr appendString:[[muArr objectAtIndex:i] objectForKey:@"nick"]];
                    [IDs addObject:ToString([[muArr objectAtIndex:i] objectForKey:@"uid"])];
                    [IDRanges addObject:[NSValue valueWithRange:NSMakeRange(0, nickStr.length)] ];
                    //如果存在回复信息，要加上回复人名
                    if ([[[muArr objectAtIndex:i] objectForKey:@"reply"] isKindOfClass:[NSDictionary class]]) {
                        NSString *replyNick = [[[muArr objectAtIndex:i] objectForKey:@"reply"] objectForKey:@"nick"];
                        [IDs addObject:ToString([[[muArr objectAtIndex:i] objectForKey:@"reply"] objectForKey:@"uid"])];
                        [IDRanges addObject:[NSValue valueWithRange:NSMakeRange(nickStr.length+2, replyNick.length)] ];
                        [nickStr appendFormat:@"回复%@: ",replyNick];
                        
                    }else{
                        [nickStr appendString:@": "];
                    }
                    
                    //评论的内容
                    [nickStr appendString:[[muArr objectAtIndex:i] objectForKey:@"content"]];
                    
                    
                    JYFeedTextView * commentUserContent = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
                    commentUserContent.fontColor = [JYHelpers setFontColorWithString:@"#848484"];
                    commentUserContent.imgBoundSize = CGSizeMake(14, 14);
                    commentUserContent.showWidth = kScreenWidth -90;
                    commentUserContent.IDs = IDs;
                    commentUserContent.IDRanges = IDRanges;
                    commentUserContent.otherDic = @{@"comment_id":[[muArr objectAtIndex:i] objectForKey:@"id"],@"feedId":self.feedModel.feedid};
                    commentUserContent.userInteractionEnabled = YES;
                    [commentUserContent layoutWithContent:nickStr];
                    NSInteger commentTempHeight = commentUserContent.bounds.size.height ;
                    [commentUserContent setFrame:CGRectMake(0 , myCommentPos, kScreenWidth -90, commentTempHeight)];
                    commentUserContent.backgroundColor = [UIColor clearColor];
                    [commentListNickView addSubview:commentUserContent];
                    
                    commentUserContent.IDsClickHandler = ^(JYFeedTextView *feedView, NSString *IDs, NSRange IDRange){
                        if (![JYHelpers isEmptyOfString:IDs] ) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kFeedCellClickAvatarNotification object:IDs userInfo:nil];
                        }else{
                            NSDictionary *result = feedView.otherDic;
                            if ([result objectForKey:@"comment_id"] != nil) {
                                [self _toReplyUserCommendClick:[result objectForKey:@"comment_id"]];
                            }
                        }
                        
                    };
                    commentListNickView.height = commentTempHeight;
                    contentHeight +=  commentTempHeight;
                    myCommentPos += commentTempHeight;
                }
            }
            //如果大于三条，多一条更多显示
            if (self.feedModel.comment_list.count > 3) {
                UILabel * commentUserNickMore = [[UILabel alloc] initWithFrame:CGRectMake(0, myCommentPos, 200, 20)];
                commentUserNickMore.textAlignment = NSTextAlignmentLeft;
                commentUserNickMore.backgroundColor = [UIColor clearColor];
                commentUserNickMore.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
                commentUserNickMore.font = [UIFont systemFontOfSize:14];
                commentUserNickMore.text = [NSString stringWithFormat:@"查看全部%@条评论",self.feedModel.comment_num];
                [commentListNickView addSubview:commentUserNickMore];
                contentHeight +=  20;
                commentListNickView.frame = CGRectMake(commentTitle.right + 5, commentTitle.top+3, kScreenWidth - (commentTitle.right + 5)-40, myCommentPos+20);
            }else{
                commentListNickView.frame = CGRectMake(commentTitle.right + 5, commentTitle.top+3,  kScreenWidth - (commentTitle.right + 5)-40, myCommentPos);
            }
        }else{
            commentTitle.frame = CGRectMake(5, positionY, 0, 0);
            commentListNickView.frame = CGRectMake(commentTitle.right + 5, commentTitle.top+3, 0, 0);
        }
        praiseListBGImg.frame = CGRectMake(secondFriendTitleLabel.left, secondFriendTitleLabel.bottom+5, bgView.width-20, contentHeight);
    }
    
    //只有二度好友，显示，好友的好友
    if([self.feedModel.friend isEqualToString:@"2" ] && [self.feedModel.uid intValue] != [[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] intValue]){
        secondFriendTitleLabel.hidden = NO;
    }else{
        secondFriendTitleLabel.hidden = YES;
    }
    
    
    bgView.size = CGSizeMake(bgView.width, praiseListBGImg.bottom+10);
    //self.size = CGSizeMake(self.size.width, praiseListBGImg.bottom + 10);
    
    praiseAddOneImg.frame = CGRectMake(praiseLineLabel.left+10, praiseLineLabel.top - 15, 40, 20);
    praiseAddOneImg.hidden = YES;
    
    rebroadcastAddOneImg.frame = CGRectMake(praise2LineLabel.left+10, praise2LineLabel.top - 15, 40, 20);
    rebroadcastAddOneImg.hidden = YES;
    
    //判断是否 单身 未导入通讯录 无好友用户  不让 赞 转 评
    BOOL isUpList = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_IsUpList", [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]];
    if (!isUpList && [[[JYShareData sharedInstance].myself_profile_dict objectForKey:@"marriage"] intValue] == 1 && [[[JYShareData sharedInstance].myself_profile_dict objectForKey:@"friends_num" ] intValue]==0){
        praiseLineLabel.userInteractionEnabled = NO;
        praise2LineLabel.userInteractionEnabled = NO;
        praise3LineLabel.userInteractionEnabled = NO;
    }else{
        praiseLineLabel.userInteractionEnabled = YES;
        praise2LineLabel.userInteractionEnabled = YES;
        praise3LineLabel.userInteractionEnabled = YES;
    }
    return bgView.size.height;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self LoadContent];
   
}

//循环显示图片，并调整图片的大小及位置
- (void) _showDynamicPic:(CGPoint) startPoint{
    //动态的图片id是否为一个数据
    CGPoint startPosition = startPoint;
    NSInteger startLeft = 0;
    NSInteger startTop = 0;
    if([[self.feedModel.data objectForKey:@"pids"] isKindOfClass:[NSDictionary class]]){
        NSDictionary * pidDic = [self.feedModel.data objectForKey:@"pids"];
        
        if (pidDic.count > 0 && pidDic.count > 1) { //多张图片与单张图片，显示不一样
            NSArray *pidsValue = [pidDic allValues];
            for (int i = 0; i<pidDic.count; i++) {
                UIImageView * temp = (UIImageView *)[self viewWithTag:1000+i];
                temp.contentMode = UIViewContentModeScaleAspectFill;
                temp.hidden = NO;
                if (startLeft  >   217 ) {
                    startTop  += 80;
                    startLeft  = 0;
                }
                
                NSString * imgurl = [[pidsValue objectAtIndex:i] objectForKey:@"140"];
                [temp sd_setImageWithURL:[NSURL URLWithString:imgurl]];
                temp.frame = CGRectMake(startLeft, startTop, 70, 70);
                startLeft  += 80;
            }
            //显示好友的好友标题
            dynamicPicFaterView.frame = CGRectMake(startPosition.x, startPosition.y , bgView.width- startPosition.x -15, startPosition.y +startTop+ 80);
            secondFriendTitleLabel.frame =  CGRectMake(bgView.left+5, startPosition.y +startTop+ 80 + 10, 100, 20);
        }else if ( pidDic.count == 1){
            NSArray *pidsValue = [pidDic allValues];
            UIImageView * temp = (UIImageView *)[self viewWithTag:1000];
            temp.hidden = NO;
            
            NSString * imgurl = [[pidsValue objectAtIndex:0] objectForKey:@"300"];
            [temp sd_setImageWithURL:[NSURL URLWithString:imgurl]];
            temp.frame = CGRectMake(0, 0, bgView.width- startPosition.x -15, 150);
            
            [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:imgurl] options:nil progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                dispatch_main_sync_safe(^{
                    if (image) {
                        float scale ;
                        if (image.size.height>=image.size.width) {
                            scale = image.size.height/image.size.width;
                            temp.frame = CGRectMake(0, 0, 150/scale, 150);
                        }
                        else{
                            temp.contentMode = UIViewContentModeScaleAspectFill;
                        }
                    } else {
                        
                    }
                });
            }];
//            //调整显示的位置
//            NSArray  * tempArray= [imgurl componentsSeparatedByString:@"="];
//            if(tempArray.count >= 2){
//                NSArray *imgWH = [[tempArray objectAtIndex:tempArray.count -1] componentsSeparatedByString:@"x"];
//                if (imgWH.count == 2) {;
//                    if ([imgWH[0] intValue]>[imgWH[1] intValue]) { //宽大于高
//                        temp.frame = CGRectMake(0, 0, bgView.width- dynamicContent.left -10, 150);
//                    }else if([imgWH[0] intValue]<[imgWH[1] intValue]){
//                        temp.frame = CGRectMake(0, 0, [imgWH[0] intValue]/2, 150);
//                    }else{
//                        temp.frame = CGRectMake(0, 0, 150, 150);
//                    }
//                }
//            }
            dynamicPicFaterView.frame = CGRectMake(startPosition.x, startPosition.y , bgView.width- startPosition.x -15, 150);
            //显示好友的好友标题
            secondFriendTitleLabel.frame =  CGRectMake(bgView.left+5, startPosition.y + 160 + 10, 100, 20);
        }
        
    }else{
        //显示好友的好友标题
        secondFriendTitleLabel.frame =  CGRectMake(bgView.left+5, startPosition.y , 100, 20);
    }
}

//点击头像
- (void) _userAvatarClick:(UIGestureRecognizer *)gesture{
    NSString * myuid = [NSString stringWithFormat:@"%ld",(long)gesture.view.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFeedCellClickAvatarNotification object:myuid userInfo:nil];
}



//点击赞
- (void) _toUserPraiseClick:(UIGestureRecognizer *)gesture{
    
        if ([self.feedModel.is_praise integerValue]!=1) {
            //发送赞数据
            BOOL result = [[JYFeedData sharedInstance] sendPariseDataToHttp:self.feedModel.uid feedid:self.feedModel.feedid];
            //评论发送成功显示效果
            if (result) {
                [self _toShowPariseAddOneLable];
                praiseLineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
                //发通知出去，刷新当前table ui
                //[[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
            }
        }
        else{
            //发送取消赞数据
            BOOL result = [[JYFeedData sharedInstance] sendCancelPariseDataToHttp:self.feedModel.uid feedid:self.feedModel.feedid];
            //取消赞成功显示效果
            if (result) {
                praiseLineLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
                //发通知出去，刷新当前table ui
                [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
            }
        }
}

//点击评论
- (void) _toUserCommendClick:(UIGestureRecognizer *)gesture{
    //self.feedModel.comment_num  = [NSString stringWithFormat:@"%ld",[self.feedModel.comment_num integerValue]+1];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicSendCommentNotify object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.feedModel.nick,@"nickName",self.feedModel.uid,@"userId", self.feedModel.feedid,@"feedId",nil]];
}

//点击评论人，进行回复
- (void) _toReplyUserCommendClick:(NSString *)commentId{
    /*dy_uid - 动态发起人的uid
    reply_uid - 回复人的uid
    dy_id - 动态id
    comment_id - 评论id
    comment_uid - 评论人uid
    content - 评论的内容*/
    NSInteger comment_id = [commentId integerValue];//当前的评论id
    NSString * dy_uid = self.feedModel.uid;
    NSString * reply_uid;
    NSString * dy_id = self.feedModel.feedid;
    NSString * comment_uid;
    NSString * comment_nick;
    
    for (int i= 0; i < self.feedModel.comment_list.count; i++) { //根据评论id找到对应的人
        if ([[[self.feedModel.comment_list objectAtIndex:i] objectForKey:@"id"] integerValue] == comment_id) {
            reply_uid    = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            comment_uid  = [[self.feedModel.comment_list objectAtIndex:i] objectForKey:@"uid"];
            comment_nick = [[self.feedModel.comment_list objectAtIndex:i] objectForKey:@"nick"];
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicSendReplyCommentNotify object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:comment_nick,@"nickName",dy_uid,@"dyUid", reply_uid,@"replyUid",dy_id,@"dyId",comment_uid,@"commentUid",[NSString stringWithFormat:@"%ld",(long)comment_id],@"commentId",nil]];
}

//添加赞成功后，出现的动画
- (void) _toShowPariseAddOneLable{
    praiseAddOneImg.hidden = NO;
    [praiseAddOneImg setAlpha:1];
    [UIView beginAnimations:@"toShowPariseAddOneLable" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    [praiseAddOneImg setAlpha:0];
    CGPoint point = praiseAddOneImg.origin;
    point.y -= praiseAddOneImg.height;
    praiseAddOneImg.origin = point;
    [UIView commitAnimations];
}

- (void) _toShowReboardcastAddOneLable{

    rebroadcastAddOneImg.hidden = NO;
    [rebroadcastAddOneImg setAlpha:1];
    [UIView beginAnimations:@"toShowreboardcastAddOneLable" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    [rebroadcastAddOneImg setAlpha:0];
    CGPoint point = rebroadcastAddOneImg.origin;
    point.y -= rebroadcastAddOneImg.height;
    rebroadcastAddOneImg.origin = point;
    [UIView commitAnimations];
}


- (void)animationDidStop
{
    // 判断是哪个动画  然后执行相应操作
//    if ([animationId isEqualToString:@"ChangeColorAnimation"]) {
//        [self changeAlphaAnimation];
//    }
    //发通知出去，刷新当前table ui
    [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
    
}

//添加赞列表用户名
- (CGFloat) _addPraiseUser{
    NSInteger praiseNum = self.feedModel.praise_list.count;
    if (![self.feedModel.praise_list isKindOfClass:[NSArray class]] || praiseNum == 0) {
        return 0;
    }
    
    NSInteger praiseShowNum = praiseNum;
    if (praiseNum > 3 && !self.feedModel.praiseIsExpand) { //如果不展开状态，则只显示前3个，后面加等XX人
        praiseShowNum = 3;
    }
    
    
    //评论人的id数组
    NSMutableArray *IDs = [NSMutableArray array];
    //评论人的rang数组，就是从第几个字到第几个字
    NSMutableArray *IDRanges = [NSMutableArray array];
    //评论过的人名
    //
    NSMutableString * nickStr = [NSMutableString string];
    for (int i = 0; i < praiseShowNum; i++) {
        NSString *cNcik = [[self.feedModel.praise_list objectAtIndex:i] objectForKey:@"nick"];
        [nickStr appendString:cNcik];
        [IDs addObject:ToString([[self.feedModel.praise_list objectAtIndex:i] objectForKey:@"uid"])];
        [IDRanges addObject:[NSValue valueWithRange:[nickStr rangeOfString:cNcik]] ];
        //最后一个不要逗号
        if (i!= praiseShowNum-1) {
            [nickStr appendString:@", "];
        }
        
    }
    //大于3个，后加等多少人
    if (praiseNum > 3 && !self.feedModel.praiseIsExpand) {
        NSString *more = [NSString stringWithFormat:@" 等%ld人",(long)praiseNum];
        [nickStr appendString:more];
        [IDs addObject:@"000000"];
        [IDRanges addObject:[NSValue valueWithRange:[nickStr rangeOfString:more]]];
    }
    
    
    JYFeedTextView * commentUserContent = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    commentUserContent.fontColor = [JYHelpers setFontColorWithString:@"#303030"];
    commentUserContent.imgBoundSize = CGSizeMake(14, 14);
    commentUserContent.showWidth = kScreenWidth - 90;
    commentUserContent.IDs = IDs;
    commentUserContent.IDRanges = IDRanges;
    commentUserContent.userInteractionEnabled = YES;
    [commentUserContent layoutWithContent:nickStr];
    NSInteger commentTempHeight = commentUserContent.bounds.size.height ;
    [commentUserContent setFrame:CGRectMake(0, 0, kScreenWidth - 90, commentTempHeight)];
    commentUserContent.backgroundColor = [UIColor clearColor];
    [praiseListNick addSubview:commentUserContent];
    
    //重设praise位转置
    praiseListNick.frame = CGRectMake(praiseTitle.right+5, praiseTitle.top+3, kScreenWidth - 90, commentTempHeight);
    __weak typeof(self) myself = self;
    commentUserContent.IDsClickHandler = ^(JYFeedTextView *feedView, NSString *IDs, NSRange IDRange){
        if (![JYHelpers isEmptyOfString:IDs] ) {
            if ([IDs isEqualToString:@"000000"]) { //等于000000是，后等几人点击时展开
                [myself _praiseMoreClickExpand];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:kFeedCellClickAvatarNotification object:IDs userInfo:nil];
            }
            
        }
        
    };
    

    return commentTempHeight;
}

//添加广播列表用户名
- (CGFloat) _addRebroadcastUser{
    NSInteger rebroadcastNum = self.feedModel.rebroadcast_list.count;
    
    if (![self.feedModel.rebroadcast_list isKindOfClass:[NSArray class]] || rebroadcastNum == 0) {
        return 0;
    }
    
    NSInteger rebroadcasShowNum = rebroadcastNum;
    if (rebroadcastNum > 3 && !self.feedModel.rebroadcastIsExpand) { //如果不展开状态，则只显示前3个，后面加等XX人
        rebroadcasShowNum = 3;
    }
    
    
    //评论人的id数组
    NSMutableArray *IDs = [NSMutableArray array];
    //评论人的rang数组，就是从第几个字到第几个字
    NSMutableArray *IDRanges = [NSMutableArray array];
    //评论过的人名
    //
    NSMutableString * nickStr = [NSMutableString string];
    for (int i = 0; i < rebroadcasShowNum; i++) {
        NSString *cNcik = [[self.feedModel.rebroadcast_list objectAtIndex:i] objectForKey:@"nick"];
        [nickStr appendString:cNcik];
        [IDs addObject:ToString([[self.feedModel.rebroadcast_list objectAtIndex:i] objectForKey:@"uid"])];
        [IDRanges addObject:[NSValue valueWithRange:[nickStr rangeOfString:cNcik]] ];
        //最后一个不要逗号
        if (i!= rebroadcasShowNum-1) {
            [nickStr appendString:@", "];
        }
        
    }
    //大于3个，后加等多少人
    if (rebroadcasShowNum > 3 && !self.feedModel.praiseIsExpand) {
        NSString *more = [NSString stringWithFormat:@" 等%ld人",(long)rebroadcastNum];
        [nickStr appendString:more];
        [IDs addObject:@"000000"];
        [IDRanges addObject:[NSValue valueWithRange:[nickStr rangeOfString:more]]];
    }
    
    
    JYFeedTextView * commentUserContent = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    commentUserContent.fontColor = [JYHelpers setFontColorWithString:@"#303030"];
    commentUserContent.imgBoundSize = CGSizeMake(14, 14);
    commentUserContent.showWidth = kScreenWidth - 90;
    commentUserContent.IDs = IDs;
    commentUserContent.IDRanges = IDRanges;
    commentUserContent.userInteractionEnabled = YES;
    [commentUserContent layoutWithContent:nickStr];
    NSInteger commentTempHeight = commentUserContent.bounds.size.height ;
    [commentUserContent setFrame:CGRectMake(0, 0, kScreenWidth - 90, commentTempHeight)];
    commentUserContent.backgroundColor = [UIColor clearColor];
    [rebroadcastListNick addSubview:commentUserContent];
    
    //重设praise位转置
    rebroadcastListNick.frame = CGRectMake(rebroadcastTitle.right+5, rebroadcastTitle.top+4, kScreenWidth - 90, commentTempHeight);
    __weak typeof(self) myself = self;
    commentUserContent.IDsClickHandler = ^(JYFeedTextView *feedView, NSString *IDs, NSRange IDRange){
        if (![JYHelpers isEmptyOfString:IDs] ) {
            if ([IDs isEqualToString:@"000000"]) { //等于000000是，后等几人点击时展开
                [myself _rebroadcastMoreClickExpand];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:kFeedCellClickAvatarNotification object:IDs userInfo:nil];
            }
        }
    };
    
    
    return commentTempHeight;
    
}

//查看照片
- (void) browserThisPhotoClick:(UITapGestureRecognizer *)gesture{
    
    JYFeedModel * temp = self.feedModel;
    
    NSString *myself_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    BOOL isUpList = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_IsUpList", myself_uid]];
    
    //判断是否 单身 未导入通讯录 无好友用户
    if (!isUpList && [[[JYShareData sharedInstance].myself_profile_dict objectForKey:@"marriage"] intValue] == 1 && [[[JYShareData sharedInstance].myself_profile_dict objectForKey:@"friends_num" ] intValue]==0) {
        NSString * uid = temp.uid;
        [[NSNotificationCenter defaultCenter] postNotificationName:kFeedCellClickImageNotification object:nil userInfo:@{@"uid":uid}];
        return;
    }
    
    
    NSDictionary * pidDic = [self.feedModel.data objectForKey:@"pids"];
    NSInteger photoCount = pidDic.count;

    NSLog(@"%ld",(long)gesture.view.tag);
    CPPhotoBrowser *browser = [[CPPhotoBrowser alloc] init];
    //browser.sourceImagesContainerView = dynamicPicFaterView;// [self viewWithTag:gesture.view.tag]; // 原图的父控件
    browser.sourceImagesContainerView = gesture.view.superview;
    browser.imageCount = photoCount; // 图片总数
    browser.shareContent = [NSString stringWithFormat:@"来自%@的友寻动态",self.feedModel.nick];
    browser.currentImageIndex = (int)gesture.view.tag -1000;
    browser.delegate = self;
    [browser show];
    
}
#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(CPPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
 
    return ((UIImageView *)[self viewWithTag:1000+index]).image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(CPPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSDictionary * pidDic = [self.feedModel.data objectForKey:@"pids"];
    NSArray *photoesValue = [pidDic allValues];
    //    NSArray *photoesKey = [pidDic allKeys];
    
    NSString * urlStr = [[photoesValue objectAtIndex:index] objectForKey:@"600"];
    if ([[photoesValue objectAtIndex:index] objectForKey:@"0"]) {
        urlStr = [[photoesValue objectAtIndex:index] objectForKey:@"0"];
    }
    
    
    
    return [NSURL URLWithString:urlStr];
}

//返回当前图片的pid
- (NSString *)photoBrowserId:(CPPhotoBrowser *)browser pidForIndex:(NSInteger)index{
    NSDictionary * pidDic = [self.feedModel.data objectForKey:@"pids"];
    NSArray *photoesKey = [pidDic allKeys];
    
    NSString * urlStr = [photoesKey objectAtIndex:index];
    return urlStr;
}

//转播
- (void) _toReboardCastClick:(UITapGestureRecognizer *)gesture{
    praise2LineLabel.userInteractionEnabled = NO;
    //uid为自已，或Data里面的uid为自已，都直接返回
    NSString *myUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if([self.feedModel.uid isEqualToString:myUid] ){
        return ;
    }
    if ([self.feedModel.data[@"status"] intValue] == -1) {
        return;
    }
    
    if([self.feedModel.data isKindOfClass:[NSDictionary class]]){
        NSLog(@"---->%@",self.feedModel.rebroadcast_list);
        if([[self.feedModel.data objectForKey:@"uid"] isEqualToString:myUid]){
            return ;
        }
    }
    
    //判断已经转播过
    for (int i = 0; i<self.feedModel.rebroadcast_list.count; i++) {
        if ([self.feedModel.rebroadcast_list[i][@"uid"] isEqualToString:myUid]) {
            NSLog(@"已经转播过了");
            return;
        }
    }
    
    BOOL result = [[JYFeedData sharedInstance] sendRebroadcastDataToHttp:self.feedModel.uid feedid:self.feedModel.feedid];
    if (result) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"转播成功"];
        //显示效果
        [self _toShowReboardcastAddOneLable];
        praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        
        //先让不可点，发送失败再放开可点
        praise2LineLabel.userInteractionEnabled = NO;
        
        
    }else{
        //先让不可点，发送失败再放开可点
        praise2LineLabel.userInteractionEnabled = YES;
    }
    
}


//改变展开和收起
- (void)dynamicContentExpandClick:(UIGestureRecognizer *) gesture{
    
    if (self.feedModel.contentIsExpand) {
        self.feedModel.contentIsExpand = NO;
    }else{
        self.feedModel.contentIsExpand = YES;
    }
    //发通知出去，刷新当前table ui
    [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
    
}

//点击评论更多，展开或收起
- (void)_praiseMoreClickExpand{
    if (self.feedModel.praiseIsExpand) {
        self.feedModel.praiseIsExpand = NO;
    }else{
        self.feedModel.praiseIsExpand = YES;
    }
    //发通知出去，刷新当前table ui
    [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
    
}

//点击转播更多，展开或收起
- (void)_rebroadcastMoreClickExpand{
    if (self.feedModel.rebroadcastIsExpand) {
        self.feedModel.rebroadcastIsExpand = NO;
    }else{
        self.feedModel.rebroadcastIsExpand = YES;
    }
    //发通知出去，刷新当前table ui
    [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
    
}


- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp ||sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation ==UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown){
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x,thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}
@end
