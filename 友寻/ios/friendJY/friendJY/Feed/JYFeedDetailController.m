//
//  JYFeedDetailController.m
//  friendJY
//
//  Created by ouyang on 3/31/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedDetailController.h"
#import "JYOtherProfileController.h"
#import "UIImageView+WebCache.h"
#import "JYShareData.h"
#import "JYPhoto.h"
#import "JYPhotoBrowserController.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYFeedDetailModel.h"
#import "JYFeedData.h"
#import "JYFeedTextView.h"
#import "JYProfileController.h"
#import "JYFeedCellTagView.h"

@interface JYFeedDetailController (){
    NSMutableArray * tableData;
    UIImageView *avatarImg;
    UIImageView *sexImg;
    UIImageView *rebroadcastSexImg;
    UILabel *nickLabel;
    UILabel *rebroadcastNickLabel;
    UILabel *lastLoginTimeLabel;
    UILabel *rebroadcastCtimeLabel;
    UILabel *marriageLabel;
    JYFeedTextView *dynamicContent;
    UILabel *secondFriendTitleLabel;
    UILabel *praiseLineLabel;
    UILabel *praise2LineLabel;
    UILabel *praise3LineLabel;
    UIView *bgView;
    UIView *praiseListBGImg;
    UILabel *praiseTitle;
    UILabel *rebroadcastTitle;
    UILabel *commentTitle;
    UIView *rebroadcastBg;
    UILabel * rebroadcastMarriageLabel;
    UIImageView *praiseAddOneImg;
    UIImageView *rebroadcastAddOneImg;
    NSInteger _currentKeyboardHeight;
    UIView *praiseListNick;
    UIView *rebroadcastListNick;
    UIView * dynamicPicFaterView;
    BOOL isReplyComment;
    NSString *_replayDyUid;//回复时动态的uid
    NSString *_replyUid;//回复人的uid
    NSString *_replyDyId;//动态id
    NSString *_replyCommentUid;//评论人的uid
    NSString *_replyCommentId;//评论id
    NSString *_replyNick;//被 回复的昵称
    NSString * deleteOneMessageUserTag;//删除一个用户标记时间，大于1秒，就是防止连续点击发生
    
    JYEmotionBrowser * emotion;
    
    BOOL isDeleteing;
    
    JYFeedCellTagView *tagBgView;
    UIView *dynamicContentBg;
}

@end

@implementation JYFeedDetailController


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSMutableString *urlString = [URL.absoluteString mutableCopy];
    NSRange range = [urlString rangeOfString:@"uid="];
    if (range.location != NSNotFound) {
        NSString *uid = [urlString substringFromIndex:(range.location+range.length)];
        NSString *myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        JYNavigationController *currentNav = (JYNavigationController*)[JYAppDelegate sharedAppDelegate].mainTabBarController.selectedViewController;
        if ([uid isEqualToString:myuid]) {//区分是不是自己
            JYProfileController *ctrl = [[JYProfileController alloc]init];
            [currentNav pushViewController:ctrl animated:YES];
        }else{
            JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
            _proVC.show_uid = uid;
            [currentNav pushViewController:_proVC animated:YES];
        }
        return NO;
    }
    return YES;
}

- (void)backAction{
    
    if (self.bcakBlock) {
        int num = self.bcakBlock();
        if (num == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [super backAction];
        }
    }else{
        [super backAction];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"动态"];
    
    
    emotion = [[JYEmotionBrowser alloc] init];
    emotion.delegate = self;
    
    //初始化table
    if (self.feedid != nil && self.feedModel == nil) {
        [self _getDetailUser];
        
    }else{
        [self _initTableView];
        //右上角删除动态，只有自已的才出现
        
    }
    
    
    //刷新table ui
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableListUI:) name:kDynamicListRefreshTableNotify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClickAvatarNotification:) name:kFeedDetailCellClickAvatarNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOneCommentNotification:) name:kDeleteDynamicCommentNotification object:nil];
    NSLog(@"----->%@",[self.feedModel.data objectForKey:@"content"]);
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDynamicListRefreshTableNotify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFeedDetailCellClickAvatarNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeleteDynamicCommentNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_getDetailUser{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"snsfeed" forKey:@"mod"];
    [parametersDict setObject:@"get_one_dynamic_info" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.feedid forKey:@"dy_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
//            tipsContent.text = [NSString stringWithFormat:@"新消息 %@", [responseObject objectForKey:@"data"]];
            self.feedModel  = [[JYFeedModel alloc] initWithDataDic:[responseObject objectForKey:@"data"]];
            
            [self _initTableView];
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        }
        
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        
    }];
}

//初始化tableview文件
- (void) _initTableView{
    
    NSString *myUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if ([myUid isEqualToString:self.feedModel.uid ]) {
        UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        navRightBtn.backgroundColor = [UIColor clearColor];
        [navRightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
        [navRightBtn setTitle:@"删除" forState:UIControlStateNormal];
        [navRightBtn setFrame:CGRectMake(0, 0, 35, 40)];
        [navRightBtn addTarget:self action:@selector(_clickTopButton) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn]];
    }
    
    
    self.feedDetailTable = [[JYFeedDetailTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.feedDetailTable.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight -kStatusBarHeight);
    self.feedDetailTable.rowHeight = 80;
    self.feedDetailTable.refreshFooterDelegate = self;
    self.feedDetailTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.feedDetailTable.backgroundColor = [JYHelpers setFontColorWithString:@"#edf1f4"];
    [self.view addSubview:self.feedDetailTable];
    self.feedDetailTable.isMore = YES;
    [self.feedDetailTable showOrHiddenTextView:@"" showOrHidden:YES];
    
    tableData = [NSMutableArray array];
    
    if (self.feedid) {
        [self requestDetailDate];//是消息列表进入的需要去下载数据
    }else{
        // 初始化头视图
        [self _initTableViewHeadViews];
        if ([self.feedModel.comment_num integerValue] > 0) {
            [self _addCommentList];
        }
    }
}

// 初始化头视图
- (void)_initTableViewHeadViews
{
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    
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
    avatarImg.tag = [self.feedModel.uid integerValue];
    [avatarImg sd_setImageWithURL:[NSURL URLWithString:[self.feedModel.avatars objectForKey:@"200"]]];
    [avatarImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userAvatarClick:)]];
    
   
    
    //昵称
    nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarBGImg.right + 5 , avatarBGImg.top,  bgView.right - 90, 20)];
    nickLabel.textAlignment = NSTextAlignmentLeft;
    nickLabel.userInteractionEnabled = YES;
    nickLabel.backgroundColor = [UIColor clearColor];
//    nickLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    nickLabel.font = [UIFont systemFontOfSize:14];
    nickLabel.text   = self.feedModel.nick;
    nickLabel.tag = [self.feedModel.uid integerValue];
    [bgView addSubview:nickLabel];
    [nickLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userAvatarClick:)]];
    
    //发布时间
    lastLoginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.right - 80 , nickLabel.top, 70, 20)];
    lastLoginTimeLabel.textAlignment = NSTextAlignmentRight;
    lastLoginTimeLabel.backgroundColor = [UIColor clearColor];
    lastLoginTimeLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    lastLoginTimeLabel.font = [UIFont systemFontOfSize:12];
    //lastLoginTimeLabel.text = self.feedModel.showtime;
    [bgView addSubview:lastLoginTimeLabel];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.feedModel.time integerValue]];
    lastLoginTimeLabel.text = [JYHelpers compareCurrentTime:confromTimesp];
    
    //性别
    sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(nickLabel.left, nickLabel.bottom+5, 12, 12)];
    //avatarImg.tag = 2090850;
    sexImg.backgroundColor = [UIColor clearColor];
    if ([self.feedModel.sex intValue] == 0) { //0-女，1-男
        sexImg.image = [UIImage imageNamed:@"female_12"]; //男的默认图标
        nickLabel.textColor = [JYHelpers setFontColorWithString:@"#fa544f"];
        
    }else{
        sexImg.image = [UIImage imageNamed:@"male_12"]; //男的默认图标
        nickLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    }
    [bgView addSubview:sexImg];
    
    //情感状态
    marriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexImg.right + 10, sexImg.top-3, 70, 20)];
    marriageLabel.textAlignment = NSTextAlignmentLeft;
    marriageLabel.backgroundColor = [UIColor clearColor];
    marriageLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    marriageLabel.font = [UIFont systemFontOfSize:12];
    marriageLabel.text  = [[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:self.feedModel.marriage];
    if ([marriageLabel.text isEqualToString:@"保密"]) {
        marriageLabel.hidden = YES;
    }
    else{
        marriageLabel.hidden = NO;
    }
    
    
    //转播文字，转播图片
    UILabel *rebLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.left+15, avatarBGImg.bottom+5, 70, 20)];
    rebLabel.textAlignment = NSTextAlignmentLeft;
    rebLabel.backgroundColor = [UIColor clearColor];
    rebLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    rebLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:rebLabel];
    
    //单身，500-转播文字,501-转播图片
    if([self.feedModel.type integerValue] == 500){
        rebLabel.text  = @"转播文字";
    }else if([self.feedModel.type integerValue] == 501){
        rebLabel.text  = @"转播图片";
    }else{
        rebLabel.hidden = YES;
    }
    rebLabel.text = @"转播动态";
    [bgView addSubview:marriageLabel];
   
    
    //动态内容
    if ([self.feedModel.type integerValue] == 500 || [self.feedModel.type integerValue] == 501) {
        dynamicContent = [[JYFeedTextView alloc] initWithFrame:CGRectMake(0, 0, bgView.width-50, 0)];
        
        dynamicContentBg = [[UIView alloc]initWithFrame:CGRectMake(sexImg.left, marriageLabel.bottom + 5, bgView.width-50, 0)];
    }else{
        dynamicContent = [[JYFeedTextView alloc] initWithFrame:CGRectMake(0, 0, bgView.width-70, 0)];
        
        dynamicContentBg = [[UIView alloc]initWithFrame:CGRectMake(sexImg.left, marriageLabel.bottom + 5, bgView.width-70, 0)];
    }
    dynamicContent.backgroundColor = [UIColor clearColor];

    
    
    //好友的好友标题
    secondFriendTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.left+15, dynamicContent.bottom + 10, 100, 20)];
    secondFriendTitleLabel.textAlignment = NSTextAlignmentLeft;
    secondFriendTitleLabel.backgroundColor = [UIColor clearColor];
    secondFriendTitleLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    secondFriendTitleLabel.font = [UIFont systemFontOfSize:14];
    secondFriendTitleLabel.text = @"好友的好友";
    [bgView addSubview:secondFriendTitleLabel];
    
    //如果存在链接的情况，要加上链接点击
    NSString *textStr = [self.feedModel.data objectForKey:@"content"];
    NSRange yxrange = [textStr rangeOfString:YX_HOST];
    if (yxrange.length > 0) { //存在友寻链接
        NSMutableArray *IDS = [NSMutableArray array];
        NSMutableArray *IDRanges = [NSMutableArray array];
        NSString *myLink = [textStr substringFromIndex:yxrange.location];
        NSArray * linkArr = [myLink componentsSeparatedByString:@"="];
        [IDS addObject:[[linkArr lastObject] substringToIndex:7]];
        [IDRanges addObject:[NSValue valueWithRange:[textStr rangeOfString:myLink]] ];
        dynamicContent.IDs = IDS;
        dynamicContent.IDRanges = IDRanges;
    }
    dynamicContent.imgBoundSize = CGSizeMake(14, 14);
    dynamicContent.fontColor = [UIColor blackColor];
    dynamicContent.backgroundColor = [UIColor clearColor];
    [dynamicContent setShowWidth:dynamicContent.width];
    
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
        tagArray = [tagStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"，,。."]];
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
    
    [dynamicContent layoutWithContent:textStr];
    
    CGPoint picStartPosition;
    //500和501为转播，内容显示不一样
    if ([self.feedModel.type integerValue] == 100 || [self.feedModel.type integerValue] == 101) {
        
        
        if(![JYHelpers isEmptyOfString:textStr]){
            
            dynamicContent.frame = CGRectMake(0, 0, dynamicContent.width, dynamicContent.height+5);
            
            dynamicContentBg.frame = CGRectMake(sexImg.left, marriageLabel.bottom + 5, dynamicContent.width, dynamicContent.height+5);
            
            NSInteger dynamicContentHeight = dynamicContent.height;
            if (haveTag && tagArray.count>0) {
                tagBgView.frame = CGRectMake(0, 0, bgView.width - sexImg.left -10, 0);
                float tagHeight = [tagBgView LoadContent:tagArray withWidth:bgView.width - sexImg.left -10];
                dynamicContentBg.frame = CGRectMake(sexImg.left, marriageLabel.bottom + 5, bgView.width - sexImg.left -10, dynamicContentHeight+tagHeight);
                tagBgView.frame = CGRectMake(0, dynamicContentHeight, bgView.width - sexImg.left -10, tagHeight);
                [dynamicContentBg addSubview:tagBgView];
            }else{
                
            }
            
        }else{
            dynamicContent.frame = CGRectMake(0, 0, 0, 0);
            dynamicContentBg.frame = CGRectMake(sexImg.left, marriageLabel.bottom + 5,0, 0);
        }
        
        //显示图片
        picStartPosition = CGPointMake(sexImg.left, dynamicContentBg.bottom + 10);
        
    }else{
        
        //当为500或501时，
        rebroadcastBg = [[UIView alloc] initWithFrame:CGRectMake(bgView.left+15, rebLabel.bottom + 10, bgView.width-30, 120)];
        rebroadcastBg.backgroundColor = [UIColor clearColor];
        rebroadcastBg.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
        rebroadcastBg.layer.borderWidth = 1;
        [bgView addSubview:rebroadcastBg];
        
        [bgView bringSubviewToFront:dynamicContent];
        
        
        if ([self.feedModel.data[@"status"] intValue] == -1) {//如果原文被删除
            rebroadcastBg.size = CGSizeMake(bgView.width-20, 30);
            secondFriendTitleLabel.frame =  CGRectMake(bgView.left+15, rebroadcastBg.bottom+5 , 100, 20);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5 , 0, 200, 30)];
            label.textAlignment = NSTextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"该内容已被原作者删除";
            [rebroadcastBg addSubview:label];
            
        }else{
            
            //转播时显示的原动态人昵称
            rebroadcastNickLabel = [[UILabel alloc] initWithFrame:CGRectMake(rebroadcastBg.left+10 , rebroadcastBg.top + 10, rebroadcastBg.right - 90 -rebroadcastSexImg.right, 20)];
            rebroadcastNickLabel.textAlignment = NSTextAlignmentLeft;
            rebroadcastNickLabel.userInteractionEnabled = YES;
            rebroadcastNickLabel.backgroundColor = [UIColor clearColor];
            rebroadcastNickLabel.font = [UIFont systemFontOfSize:14];
            rebroadcastNickLabel.text = [self.feedModel.data objectForKey:@"nick"];
            rebroadcastNickLabel.tag = [[self.feedModel.data objectForKey:@"uid"] integerValue];
            [bgView addSubview:rebroadcastNickLabel];
            [rebroadcastNickLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userAvatarClick:)]];
            
            
            //转播时显示的原动态人发布时间
            rebroadcastCtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(rebroadcastBg.right - 80 , rebroadcastNickLabel.top, 70, 20)];
            rebroadcastCtimeLabel.textAlignment = NSTextAlignmentRight;
            rebroadcastCtimeLabel.backgroundColor = [UIColor whiteColor];
            rebroadcastCtimeLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
            rebroadcastCtimeLabel.font = [UIFont systemFontOfSize:12];
            
            //动态原始发布的时间
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[self.feedModel.data objectForKey:@"time"] integerValue]];
            rebroadcastCtimeLabel.text = [JYHelpers compareCurrentTime:confromTimesp];
            [bgView addSubview:rebroadcastCtimeLabel];
            
            //转播时显示的原动态人性别
            rebroadcastSexImg = [[UIImageView alloc] initWithFrame:CGRectMake(rebroadcastBg.left + 10, rebroadcastNickLabel.bottom+5, 12, 12)];
            rebroadcastSexImg.backgroundColor = [UIColor clearColor];
            //动态原始人的性别
            if ([[self.feedModel.data objectForKey:@"sex"] integerValue] == 0) { //0-女，1-男
                rebroadcastSexImg.image = [UIImage imageNamed:@"female_12"]; //男的默认图标
                rebroadcastNickLabel.textColor = [JYHelpers setFontColorWithString:@"#fa544f"];
                
            }else{
                rebroadcastSexImg.image = [UIImage imageNamed:@"male_12"]; //男的默认图标
                rebroadcastNickLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
            }
            [bgView addSubview:rebroadcastSexImg];

            
            //转播时显示的原动态人情感状态
            rebroadcastMarriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(rebroadcastSexImg.right + 10, rebroadcastSexImg.top-4, 70, 20)];
            rebroadcastMarriageLabel.textAlignment = NSTextAlignmentLeft;
            rebroadcastMarriageLabel.backgroundColor = [UIColor clearColor];
            rebroadcastMarriageLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
            rebroadcastMarriageLabel.font = [UIFont systemFontOfSize:12];
            rebroadcastMarriageLabel.text = [[[JYShareData sharedInstance].profile_dict objectForKey:@"marriage"] objectForKey:[self.feedModel.data objectForKey:@"marriage"]];
            [bgView addSubview:rebroadcastMarriageLabel];
            
            if ([rebroadcastMarriageLabel.text isEqualToString:@"保密"]) {
                rebroadcastMarriageLabel.hidden = YES;
            }
            else{
                rebroadcastMarriageLabel.hidden = NO;
            }
            //动态原始人的昵称
//            rebroadcastNickLabel.text = [self.feedModel.data objectForKey:@"nick"];
//            rebroadcastNickLabel.tag = [[self.feedModel.data objectForKey:@"uid"] integerValue];
//            //动态原始人的性别
//            if ([[self.feedModel.data objectForKey:@"sex"] integerValue] == 0) { //0-女，1-男
//                rebroadcastSexImg.image = [UIImage imageNamed:@"female_12"]; //男的默认图标
//                
//            }else{
//                rebroadcastSexImg.image = [UIImage imageNamed:@"male_12"]; //男的默认图标
//            }
            
            //动态原始动态内容
            //NSString *textStr = [self.feedModel.data objectForKey:@"content"];
            if(![JYHelpers isEmptyOfString:textStr]){
                dynamicContent.frame = CGRectMake(rebroadcastSexImg.left, rebroadcastSexImg.bottom + 5, dynamicContent.width, dynamicContent.height+5);
            }else{
                dynamicContent.frame = CGRectMake(rebroadcastSexImg.left, rebroadcastSexImg.bottom + 5, 0, 0);
            }
            if(![JYHelpers isEmptyOfString:textStr]){
                
                dynamicContent.frame = CGRectMake(0, 0, dynamicContent.width, dynamicContent.height+5);
                
                dynamicContentBg.frame = CGRectMake(rebroadcastSexImg.left, rebroadcastSexImg.bottom + 5, dynamicContent.width, dynamicContent.height+5);
                
                NSInteger dynamicContentHeight = dynamicContent.height;
                if (haveTag && tagArray.count>0) {
                    tagBgView.frame = CGRectMake(0, 0, bgView.width - sexImg.left -10, 0);
                    float tagHeight = [tagBgView LoadContent:tagArray withWidth:rebroadcastBg.width-30];
                    dynamicContentBg.frame = CGRectMake(rebroadcastSexImg.left, rebroadcastSexImg.bottom + 5, dynamicContent.width, dynamicContentHeight+tagHeight);
                    tagBgView.frame = CGRectMake(0, dynamicContentHeight, bgView.width - sexImg.left -10, tagHeight);
                    [dynamicContentBg addSubview:tagBgView];
                }else{
                    
                }
                
            }else{
                dynamicContent.frame = CGRectMake(0, 0, 0, 0);
                dynamicContentBg.frame = CGRectMake(rebroadcastSexImg.left, rebroadcastSexImg.bottom + 5,0, 0);
            }
            
            //显示图片
            picStartPosition = CGPointMake(dynamicContentBg.left, dynamicContentBg.bottom + 10);
        }
    }
    if ([self.feedModel.data[@"status"] intValue] != -1) {
        [dynamicContentBg addSubview:dynamicContent];
        [bgView addSubview:dynamicContentBg];
        [self _showDynamicPic:picStartPosition];
        if (rebroadcastBg != nil) {
            rebroadcastBg.size = CGSizeMake(bgView.width-30, secondFriendTitleLabel.top -rebroadcastBg.top- 5);
        }
    }
    __weak typeof(self) myself = self;
    dynamicContent.IDsClickHandler = ^(JYFeedTextView *feedView, NSString *IDs, NSRange IDRange){
        if (![JYHelpers isEmptyOfString:IDs] ) {
            JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
            _proVC.show_uid = IDs;
            [myself.navigationController pushViewController:_proVC animated:YES];
        }
        
    };
    
    
    //赞，2转播，3评论
    praiseLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.right - 175, secondFriendTitleLabel.top, 40, 20)];
    praiseLineLabel.textAlignment = NSTextAlignmentRight;
    praiseLineLabel.backgroundColor = [UIColor clearColor];
    praiseLineLabel.font = [UIFont systemFontOfSize:14];
    praiseLineLabel.userInteractionEnabled = YES;
    [praiseLineLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toUserPraiseClick:)]];
    [bgView addSubview:praiseLineLabel];
    
    praise2LineLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.right - 125, secondFriendTitleLabel.top, 50, 20)];
    praise2LineLabel.textAlignment = NSTextAlignmentRight;
    praise2LineLabel.backgroundColor = [UIColor clearColor];
    praise2LineLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:praise2LineLabel];
    
    praise3LineLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.right - 65, secondFriendTitleLabel.top, 50, 20)];
    praise3LineLabel.textAlignment = NSTextAlignmentRight;
    praise3LineLabel.backgroundColor = [UIColor clearColor];
    praise3LineLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:praise3LineLabel];
    
    //刷上面三项的值
    [self refreshCommentAndPariseAndRebroadcast];
    //bgView.size = CGSizeMake(bgView.width, praise3LineLabel.bottom+10);
    
    //赞加1
    praiseAddOneImg.frame = CGRectMake(praiseLineLabel.left+10, praiseLineLabel.top - 15, 40, 20);
    praiseAddOneImg.hidden = YES;
    praiseAddOneImg.image = [UIImage imageNamed:@"feedAddPraise"];
    [bgView addSubview:praiseAddOneImg];
    
    //转播加1
    rebroadcastAddOneImg = [[UIImageView alloc] initWithFrame:CGRectMake(praise2LineLabel.left+10, praise2LineLabel.top - 15, 40, 20)];
    rebroadcastAddOneImg.hidden = YES;
    rebroadcastAddOneImg.image = [UIImage imageNamed:@"feedAddReboardcast"];
    [bgView addSubview:rebroadcastAddOneImg];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CellAvatarNotification:) name:kFeedCellClickAvatarNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFeedCellClickAvatarNotification object:nil
     ];
    [self dismissProgressHUDtoView:self.view];
    
}
- (void)CellAvatarNotification:(NSNotification *)noti{
    
    NSString * uid = noti.object;
    for (int index = 0 ; index < self.navigationController.viewControllers.count; index++) {
        UIViewController *vc = self.navigationController.viewControllers[index];
        
        if ([vc isKindOfClass:[JYOtherProfileController class]]) {
            
            if ([((JYOtherProfileController*)vc).show_uid isEqualToString:uid]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
    JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
    _proVC.show_uid = uid;
    [self.navigationController pushViewController:_proVC animated:YES];
}

//消息列表进入时需要去下载单条的动态数据
- (void) requestDetailDate{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"snsfeed" forKey:@"mod"];
    [parametersDict setObject:@"get_one_dynamic_info" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.feedid forKey:@"dy_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        NSLog(@"responseObject---->%@",responseObject);
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                self.feedModel = [[JYFeedModel alloc]initWithDataDic:[responseObject objectForKey:@"data"]];
                NSLog(@"self.feedModel---->%@",self.feedModel.avatars);
                
                [self _initTableViewHeadViews];
                if ([self.feedModel.comment_num integerValue] > 0) {
                    [self _addCommentList];
                }
            }else{
                NSLog(@"数据为空");
            }
            
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
        }
        
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        
    }];
}


//添加赞列表用户名
- (NSInteger) _addPraiseUser{
    
    NSInteger praiseNum = self.feedModel.praise_list.count;
    if (![self.feedModel.praise_list isKindOfClass:[NSArray class]] || praiseNum == 0) {
        return 0;
    }
    
    //赞过
    praiseTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 40, 20)];
    praiseTitle.textAlignment = NSTextAlignmentRight;
    praiseTitle.backgroundColor = [UIColor clearColor];
    praiseTitle.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    praiseTitle.font = [UIFont systemFontOfSize:14];
    praiseTitle.text = @"赞过";
    [praiseListBGImg addSubview:praiseTitle];
    
    NSInteger praiseShowNum = praiseNum;
//    if (praiseNum > 3 && !self.feedModel.praiseIsExpand) { //如果不展开状态，则只显示前3个，后面加等XX人
//        praiseShowNum = 3;
//    }
    
    //赞的人的id数组
    NSMutableArray *IDs = [NSMutableArray array];
    //赞的人的rang数组，就是从第几个字到第几个字
    NSMutableArray *IDRanges = [NSMutableArray array];
    //赞的人的人名
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
//    //大于3个，后加等多少人
//    if (praiseNum > 3 && !self.feedModel.praiseIsExpand) {
//        NSString *more = [NSString stringWithFormat:@" 等%ld人",(long)praiseNum];
//        [nickStr appendString:more];
//        [IDs addObject:@"000000"];
//        [IDRanges addObject:[NSValue valueWithRange:[nickStr rangeOfString:more]]];
//    }
    
    
    JYFeedTextView * commentUserContent = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    commentUserContent.fontColor = [JYHelpers setFontColorWithString:@"#303030"];
    commentUserContent.imgBoundSize = CGSizeMake(14, 14);
    commentUserContent.showWidth = kScreenWidth - 90;
    commentUserContent.IDs = IDs;
    commentUserContent.IDRanges = IDRanges;
    commentUserContent.userInteractionEnabled = YES;
    [commentUserContent layoutWithContent:nickStr];
    NSInteger commentTempHeight = commentUserContent.bounds.size.height ;
    [commentUserContent setFrame:CGRectMake(praiseTitle.right+5, praiseTitle.top+4, kScreenWidth - 90, commentTempHeight)];
    commentUserContent.backgroundColor = [UIColor clearColor];
    //一行时是 16
    [praiseListBGImg addSubview:commentUserContent];
    
    __weak typeof(self) myself = self;
    commentUserContent.IDsClickHandler = ^(JYFeedTextView *feedView, NSString *IDs, NSRange IDRange){
        if (![JYHelpers isEmptyOfString:IDs] ) {
            JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
            _proVC.show_uid = IDs;
            [myself.navigationController pushViewController:_proVC animated:YES];
        }
    };
    
    //return commentTempHeight;
    return commentUserContent.bottom +　15;
    
}

//添加转播列表用户名
- (NSInteger) _addRebroadcastUser{
    
    NSInteger rebroadcastNum = self.feedModel.rebroadcast_list.count;
    
    if (![self.feedModel.rebroadcast_list isKindOfClass:[NSArray class]] || rebroadcastNum == 0) {
        return 0;
    }
    
    NSInteger rebroadcasShowNum = rebroadcastNum;
//    if (rebroadcastNum > 3 && !self.feedModel.rebroadcastIsExpand) { //如果不展开状态，则只显示前3个，后面加等XX人
//        rebroadcasShowNum = 3;
//    }
    
    
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
//    //大于3个，后加等多少人
//    if (rebroadcasShowNum > 3 && !self.feedModel.praiseIsExpand) {
//        NSString *more = [NSString stringWithFormat:@" 等%ld人",(long)rebroadcastNum];
//        [nickStr appendString:more];
//        [IDs addObject:@"000000"];
//        [IDRanges addObject:[NSValue valueWithRange:[nickStr rangeOfString:more]]];
//    }
    
    
    JYFeedTextView * commentUserContent = [[JYFeedTextView alloc] initWithFrame:CGRectZero];
    commentUserContent.fontColor = [JYHelpers setFontColorWithString:@"#303030"];
    commentUserContent.imgBoundSize = CGSizeMake(14, 14);
    commentUserContent.showWidth = kScreenWidth - 90;
    commentUserContent.IDs = IDs;
    commentUserContent.IDRanges = IDRanges;
    commentUserContent.userInteractionEnabled = YES;
    [commentUserContent layoutWithContent:nickStr];
    NSInteger commentTempHeight = commentUserContent.bounds.size.height ;
    [commentUserContent setFrame:CGRectMake(rebroadcastTitle.right+5, rebroadcastTitle.top+4, kScreenWidth - 90, commentTempHeight)];
    commentUserContent.backgroundColor = [UIColor clearColor];
    [praiseListBGImg addSubview:commentUserContent];
    

    __weak typeof(self) myself = self;
    commentUserContent.IDsClickHandler = ^(JYFeedTextView *feedView, NSString *IDs, NSRange IDRange){
        if (![JYHelpers isEmptyOfString:IDs] ) {
            JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
            _proVC.show_uid = IDs;
            [myself.navigationController pushViewController:_proVC animated:YES];
        }
        
    };
    
    return commentUserContent.bottom+15;
    
}


//添加评论列表的数据，刷新table
- (void) _addCommentList{
    if (![self.feedModel.comment_list isKindOfClass:[NSArray class]] || [self.feedModel.comment_num integerValue] == 0) {
        return;
    }
    [tableData removeAllObjects];
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
    for (int i = 0; i<muArr.count; i++) {
        JYFeedDetailModel * myModel = [[JYFeedDetailModel alloc] initWithDataDic:[muArr objectAtIndex:i]];
        myModel.feedUid = self.feedModel.uid;
        myModel.feedid = self.feedModel.feedid;
        [tableData addObject:myModel];
    }
    self.feedDetailTable.data = tableData;
    [self.feedDetailTable reloadData];
}

//点击头像
- (void) _userAvatarClick:(UIGestureRecognizer *)gesture{
    NSString * myuid = [NSString stringWithFormat:@"%ld",(long)gesture.view.tag];
    for (int index = 0 ; index < self.navigationController.viewControllers.count; index++) {
        UIViewController *vc = self.navigationController.viewControllers[index];
        
        if ([vc isKindOfClass:[JYOtherProfileController class]]) {
            
            if ([((JYOtherProfileController*)vc).show_uid isEqualToString:myuid]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
            
        }
    }

    JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
    _proVC.show_uid = myuid;
    [self.navigationController pushViewController:_proVC animated:YES];
}

- (void) cellClickAvatarNotification:(NSNotification *)noti {
    NSString * uid = noti.object;
    for (int index = 0 ; index < self.navigationController.viewControllers.count; index++) {
        UIViewController *vc = self.navigationController.viewControllers[index];
        
        if ([vc isKindOfClass:[JYOtherProfileController class]]) {
            
            if ([((JYOtherProfileController*)vc).show_uid isEqualToString:uid]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
    JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
    _proVC.show_uid = uid;
    [self.navigationController pushViewController:_proVC animated:YES];
}


//循环显示图片，并调整图片的大小及位置
- (void) _showDynamicPic:(CGPoint) startPoint{
    //动态的照片内容
    //动态的图片id是否为一个数据
    CGPoint startPosition = startPoint;
    NSInteger startLeft = 0;
    NSInteger startTop = 0;
    if([[self.feedModel.data objectForKey:@"pids"] isKindOfClass:[NSDictionary class]]){
        NSDictionary * pidDic = [self.feedModel.data objectForKey:@"pids"];
        dynamicPicFaterView = [[UIView alloc] init];
        dynamicPicFaterView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:dynamicPicFaterView];
        if (pidDic.count > 0 && pidDic.count > 1) {
            NSArray *pidsValue = [pidDic allValues];
            for (int i = 0; i<pidDic.count; i++) {
                if (startLeft  >  217 ) {
                    startTop  += 80;
                    startLeft  = 0;
                }
                
                UIImageView *dynamicPic = [[UIImageView alloc] initWithFrame:CGRectMake(startLeft, startTop  , 70, 70)];
                dynamicPic.clipsToBounds = YES;
                dynamicPic.userInteractionEnabled = YES;
                dynamicPic.backgroundColor = [UIColor clearColor];
                dynamicPic.tag = 1000+i;
                dynamicPic.contentMode = UIViewContentModeScaleAspectFill;
                [dynamicPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserThisPhotoClick:)]];
                
                NSString * imgurl = [[pidsValue objectAtIndex:i] objectForKey:@"140"];
                startLeft  += 80;
                [dynamicPic sd_setImageWithURL:[NSURL URLWithString:imgurl]];
                [dynamicPicFaterView addSubview:dynamicPic];
               
            }
            dynamicPicFaterView.frame = CGRectMake(startPosition.x, startPosition.y, startLeft +80, startTop + 80 + 10);
            //显示好友的好友标题
            secondFriendTitleLabel.frame =  CGRectMake(bgView.left+5, startPosition.y +startTop + 80 + 10, 100, 20);
        }else if ( pidDic.count == 1){
            NSArray *pidsValue = [pidDic allValues];
            
            UIImageView *dynamicPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , bgView.width- startPosition.x -15, 150)];
            dynamicPic.userInteractionEnabled = YES;
            dynamicPic.clipsToBounds = YES;
            dynamicPic.backgroundColor = [UIColor clearColor];
            dynamicPic.tag = 1000;
            //dynamicPic.contentMode = UIViewContentModeScaleAspectFit;
            [dynamicPicFaterView addSubview:dynamicPic];
            [dynamicPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserThisPhotoClick:)]];
            
            NSString * imgurl = [[pidsValue objectAtIndex:0] objectForKey:@"300"];
            
            [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:imgurl] options:nil progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                dispatch_main_sync_safe(^{
                    if (image) {
                        float scale ;
                        if (image.size.height>=image.size.width) {
                            scale = image.size.height/image.size.width;
                            dynamicPic.frame = CGRectMake(0, 0, 150/scale, 150);
                        }
                        else{
                            dynamicPic.contentMode = UIViewContentModeScaleAspectFill;
                        }
                    } else {
                        
                    }
                });
            }];
            
            [dynamicPic sd_setImageWithURL:[NSURL URLWithString:imgurl]];
            
            dynamicPicFaterView.frame = CGRectMake(startPosition.x, startPosition.y, bgView.width- startPosition.x -15, 150);
            //显示好友的好友标题
            secondFriendTitleLabel.frame =  CGRectMake(bgView.left+5, startPosition.y + 160 + 10, 100, 20);
        }
    }else{
        //显示好友的好友标题
        secondFriendTitleLabel.frame =  CGRectMake(bgView.left+15, startPosition.y , 100, 20);
    }
    
    if([self.feedModel.friend intValue] == 2  && [self.feedModel.uid intValue] != [[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] intValue]){
        secondFriendTitleLabel.hidden = NO;
    }else{
        secondFriendTitleLabel.hidden = YES;
    }

}

//查看照片
- (void) browserThisPhotoClick:(UITapGestureRecognizer *)gesture{
    NSDictionary * pidDic = [self.feedModel.data objectForKey:@"pids"];
    //    NSArray *photoesValue = [pidDic allValues];
    //    NSArray *photoesKey = [pidDic allKeys];
    NSInteger photoCount = pidDic.count;
    
    NSLog(@"%ld",gesture.view.tag);
    CPPhotoBrowser *browser = [[CPPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = gesture.view.superview;// [self viewWithTag:gesture.view.tag]; // 原图的父控件
    browser.fromSelf = YES;
    browser.imageCount = photoCount; // 图片总数
    browser.currentImageIndex = (int)gesture.view.tag -1000;
    browser.delegate = self;
    [browser show];

//    CPPhotoBrowser *browser = [[CPPhotoBrowser alloc] init];
//    //browser.sourceImagesContainerView = dynamicPicFaterView;// [self viewWithTag:gesture.view.tag]; // 原图的父控件
//    browser.sourceImagesContainerView = gesture.view.superview;
//    browser.imageCount = photoCount; // 图片总数
//    browser.shareContent = [NSString stringWithFormat:@"来自%@的友寻动态",self.feedModel.nick];
//    browser.currentImageIndex = (int)gesture.view.tag -1000;
//    browser.delegate = self;
//    [browser show];
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(CPPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return ((UIImageView *)[self.view viewWithTag:1000+index]).image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(CPPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSDictionary * pidDic = [self.feedModel.data objectForKey:@"pids"];
    NSArray *photoesValue = [pidDic allValues];
    //    NSArray *photoesKey = [pidDic allKeys];
    
    NSString * urlStr = [[photoesValue objectAtIndex:index] objectForKey:@"600"];
    return [NSURL URLWithString:urlStr];
}

//返回当前图片的pid
- (NSString *)photoBrowserId:(CPPhotoBrowser *)browser pidForIndex:(NSInteger)index{
    NSDictionary * pidDic = [self.feedModel.data objectForKey:@"pids"];
    NSArray *photoesKey = [pidDic allKeys];
    
    NSString * urlStr = [photoesKey objectAtIndex:index];
    return urlStr;
}

//点击赞
- (void) _toUserPraiseClick:(UIGestureRecognizer *)gesture{
    
    //发送赞数据
    if ([self.feedModel.is_praise integerValue]!=1) {
        BOOL result = [[JYFeedData sharedInstance] sendPariseDataToHttp:self.feedModel.uid feedid:self.feedModel.feedid];
        //评论发送成功显示效果
        if (result) {
            [self _toShowPariseAddOneLable];
            praiseLineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
            //发通知出去，刷新当前table ui
            [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
        }
    }else{
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



//添加赞成功后，出现的动画
- (void) _toShowPariseAddOneLable{
  
    praiseAddOneImg.hidden = NO;
    [praiseAddOneImg setAlpha:1];
    [UIView beginAnimations:@"toShowPariseAddOneLable" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [praiseAddOneImg setAlpha:0];
    CGPoint point = praiseAddOneImg.origin;
    point.y -= praiseAddOneImg.height;
    praiseAddOneImg.origin = point;
    [UIView commitAnimations];
}


//转播
- (void) _toReboardCastClick:(UITapGestureRecognizer *)gesture{
    //如过是已经被删除的
    if ([self.feedModel.data[@"status"] intValue] == -1) {
        return;
    }
    //uid为自已，或Data里面的uid为自已，都直接返回
    NSString *myUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if([self.feedModel.uid isEqualToString:myUid] ){
        return ;
    }
    if([self.feedModel.data isKindOfClass:[NSDictionary class]]){
        if([[self.feedModel.data objectForKey:@"uid"] isEqualToString:myUid]){
            return ;
        }
    }
    
    praise2LineLabel.userInteractionEnabled = NO;
    BOOL result = [[JYFeedData sharedInstance] sendRebroadcastDataToHttp:self.feedModel.uid feedid:self.feedModel.feedid];
    if (result) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"转播成功"];
        //显示效果
        [self _toShowReboardcastAddOneLable];
        praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        
        //发通知出去，刷新当前table ui
        [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
    }else{
        //先让不可点，发送失败再放开可点
        praise2LineLabel.userInteractionEnabled = YES;
    }

}


- (void) _toShowReboardcastAddOneLable{
//    praise2LineLabel.text = [NSString stringWithFormat:@"%ld转播", [self.feedModel.rebroadcast_num integerValue]+1];
//    self.feedModel.rebroadcast_num = [NSString stringWithFormat:@"%ld", [self.feedModel.rebroadcast_num integerValue]+1];//改tableview数据源
    rebroadcastAddOneImg.hidden = NO;
    [rebroadcastAddOneImg setAlpha:1];
    [UIView beginAnimations:@"toShowreboardcastAddOneLable" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [rebroadcastAddOneImg setAlpha:0];
    CGPoint point = rebroadcastAddOneImg.origin;
    point.y -= rebroadcastAddOneImg.height;
    rebroadcastAddOneImg.origin = point;
    [UIView commitAnimations];
}



// 发送消息
- (void)JYEmotionTextFieldShouldReturn:(JYEmotionBrowser *)jyEmotion contentText:(NSString *)contentText{
    // 发送私信
    NSMutableString *mutStr = [NSMutableString stringWithString:contentText];
    NSRange range = [mutStr rangeOfString:@" "];
    while (range.location != NSNotFound) {
        [mutStr deleteCharactersInRange:range];
        range = [mutStr rangeOfString:@" "];
    }
    
    if (mutStr.length == 0) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"您没有输入任何内容哦"];
        return;
    }
    if (contentText.length == 0) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"您没有输入任何内容哦"];
        
    } else {
        [self _requestSendCommendData:contentText];
        
    }
}

// 发私信
- (void)_toUserCommendClick:(UITapGestureRecognizer *)gesture
{
    isReplyComment = NO;
    NSString *nick = self.feedModel.nick;
    
    
    emotion.showNick = nick;
    
    [emotion show];

}

- (void)refreshTableListUI:(NSNotification *)noti{
    
    [praiseListBGImg removeFromSuperview];
    [self _addCommentList];
    [self refreshCommentAndPariseAndRebroadcast];
    [self.feedDetailTable reloadData];
}

//提交评论内容到web
- (void)_requestSendCommendData:(NSString *)content{
    if (content.length < 1) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"输入的内容太短！请重新输入"];
        return;
    }
    if (isReplyComment) { //直接评论还是回复评论
        [[JYFeedData sharedInstance] sendReplyCommendDataToHttp:_replayDyUid reply_nick:_replyNick reply_uid:_replyUid dy_id:_replyDyId comment_id:_replyCommentId comment_uid:_replyCommentUid content:content];
    }else{
        [[JYFeedData sharedInstance] sendCommendDataToHttp:self.feedModel.uid sendFeedId:self.feedModel.feedid content:content];
    
    }
    
}



- (void)deleteOneCommentNotification:(NSNotification *)notification{
    if (!isDeleteing) {
        isDeleteing = YES;
        
        if ([deleteOneMessageUserTag isEqualToString:[JYHelpers currentDateTimeInterval]]) {
            return;
        }
        
        
        NSString * cid = [notification.userInfo objectForKey:@"cid"];
        DeleteSuccessCallBackBlock block = [notification.userInfo objectForKey:@"callBackBlock"];
        deleteOneMessageUserTag = [JYHelpers currentDateTimeInterval];
        
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"comment" forKey:@"mod"];
        [parametersDict setObject:@"del_comment" forKey:@"func"];
        
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:self.feedModel.feedid forKey:@"dy_id"];
        [postDict setObject:cid forKey:@"comment_id"];
        [postDict setObject:self.feedModel.uid forKey:@"dy_uid"];
        
        
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            
            if (iRetcode == 1) {
                block(); //删除成功执行动画
                
                //删除评论数据
                NSMutableArray *muArr = [self.feedModel.comment_list mutableCopy];
                
                for (int i = 0; i<self.feedModel.comment_list.count; i++) {
                    NSDictionary *commentDict = [self.feedModel.comment_list objectAtIndex:i];
                    if ([commentDict[@"id"] isEqualToString:cid]) {
                        [muArr removeObject:commentDict];
                        self.feedModel.comment_list = muArr;
                        break;
                    }
                }
                //评论数减一
                int commentNum = [self.feedModel.comment_num intValue]-1;
                self.feedModel.comment_num = [NSString stringWithFormat:@"%d",commentNum];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:nil];
                
            } else {
                [[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
            }
            isDeleteing = NO;
            
        } failure:^(id error) {
            
            NSLog(@"%@", error);
            isDeleteing = NO;
        }];
    }
    
}

- (void)_clickTopButton{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除动态?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
}
//alert代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteMyselfDynamic];
    }
}

- (void) deleteMyselfDynamic{
    BOOL result = [[JYFeedData sharedInstance] deleteOneFeed:self.feedModel.feedid];
    if (result) {
        //发送通知删除成功，动态列表做相应操作
        [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:self userInfo:nil];
        //删除自己动态发送一个通知刷新个人资料页。
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProfileInfoNotification object:nil];
        if (self.bcakBlock) {
            int num = self.bcakBlock();
            if (num == 0) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [super backAction];
            }
        }else{
            [super backAction];
        }
    }else{
        [[JYAppDelegate sharedAppDelegate] showTip:@"网络连接异常,删除失败"];
    }
}

//刷新时处理评论，赞，转播数
- (void) refreshCommentAndPariseAndRebroadcast{
    
    //显示评论数
    if ([self.feedModel.comment_num integerValue] >99) {
        praise3LineLabel.text = @"99评论";
    }else{
        praise3LineLabel.text = [NSString stringWithFormat:@"%@评论", self.feedModel.comment_num];
    }
    praise3LineLabel.userInteractionEnabled = YES;
    
    //如果已评论了，要变灰
    if([self.feedModel.is_comment integerValue] == 1){
        praise3LineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        praise3LineLabel.userInteractionEnabled = NO;
    }else{
        praise3LineLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
        [praise3LineLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toUserCommendClick:)]];
    }
    
    //显示赞的数
    if (self.feedModel.praise_list.count >99) {
        praiseLineLabel.text = @"99赞";
    }else{
        praiseLineLabel.text = [NSString stringWithFormat:@"%ld赞", self.feedModel.praise_list.count];
    }
    
    //如果已赞过了，要变灰
    if([self.feedModel.is_praise integerValue] == 1){
        praiseLineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        
    }else{
        praiseLineLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    }
    
    //显示转播的数
    if ([self.feedModel.rebroadcast_num intValue] >99) {
        praise2LineLabel.text = @"99转播";
    }else{
        praise2LineLabel.text = [NSString stringWithFormat:@"%d转播", [self.feedModel.rebroadcast_num intValue]];
    }
    praise2LineLabel.userInteractionEnabled = YES;
    
    //如果已转播了，要变灰
    NSString * myUid =[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if([self.feedModel.is_rebroadcast integerValue] == 1|| [self.feedModel.uid isEqualToString:myUid] || [self.feedModel.data[@"status"] intValue] == -1){
        praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
        praise2LineLabel.userInteractionEnabled = NO;
    }else{
        praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
        [praise2LineLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toReboardCastClick:)]];
        praise2LineLabel.userInteractionEnabled = YES;
        if ([self.feedModel.type intValue] == 500 || [self.feedModel.type intValue] == 501) {
            if ([[self.feedModel.data objectForKey:@"uid"] isEqualToString:myUid]) {
                praise2LineLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
                praise2LineLabel.userInteractionEnabled = NO;
            }
        }
    }
    
    
    // 赞，转播列表的背景
    if (self.feedModel.praise_list.count >0 ||  self.feedModel.rebroadcast_list.count >0) {
        
        // 赞，转播列表的背景
        praiseListBGImg = [[UIView alloc] initWithFrame:CGRectMake(0, secondFriendTitleLabel.bottom+5, kScreenWidth, 120)];
        praiseListBGImg.backgroundColor = [JYHelpers setFontColorWithString:@"#edf1f4"];
        [bgView addSubview:praiseListBGImg];
        
        NSInteger contentHeight = 0;
        //赞过的人
        //int positionY = 15; //初始化15的高度，因为下面三个都有可能不出现，需动态定位y值
        if ([self.feedModel.praise_num integerValue] > 0) {
            //返回了赞名字的底部加15
            contentHeight = [self _addPraiseUser];
            
        }else{
            contentHeight = 15;
            praiseTitle = nil;
        }
        
        //转播的人
        if (self.feedModel.rebroadcast_list.count > 0) {
            
            //转播
            rebroadcastTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, contentHeight, 40, 20)];
            rebroadcastTitle.textAlignment = NSTextAlignmentRight;
            rebroadcastTitle.backgroundColor = [UIColor clearColor];
            rebroadcastTitle.textColor = [JYHelpers setFontColorWithString:@"#848484"];
            rebroadcastTitle.font = [UIFont systemFontOfSize:14];
            rebroadcastTitle.text = @"转播";
            [praiseListBGImg addSubview:rebroadcastTitle];

            contentHeight = [self _addRebroadcastUser];
            
        }else{
        }
        
        praiseListBGImg.frame = CGRectMake(0, secondFriendTitleLabel.bottom+5, kScreenWidth,  contentHeight);
        bgView.size = CGSizeMake(bgView.width, praiseListBGImg.bottom);
    }else{
        bgView.size = CGSizeMake(bgView.width, praise3LineLabel.bottom+10);
    }
//    UIView * headBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.bottom, kScreenWidth, 1)];
//    headBottomLine.layer.borderColor = [[JYHelpers setFontColorWithString:@"#e2e5e7"] CGColor];
//    headBottomLine.layer.borderWidth = 1;
//    [bgView addSubview:headBottomLine];
    
    
    self.feedDetailTable.tableHeaderView = bgView;
}

//点击回复评论
- (void)didSelectRowAtIndexPath:(JYFeedDetailTableView *)tabelView indexPath:(NSIndexPath *)indexPath{
    
    isReplyComment = YES;
    JYFeedDetailModel *myModel = [tableData objectAtIndex:indexPath.row];
    
    _replayDyUid =self.feedModel.uid;
    _replyUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    _replyDyId =self.feedModel.feedid;
    _replyCommentUid = myModel.uid;
    _replyCommentId = myModel.id;
    _replyNick = myModel.nick;
    NSString *nick = [NSString stringWithFormat:@"“%@”", _replyNick];
    
    
    emotion.showNick = nick;
    [emotion show];
        
    
}
@end
