//
//  JYFeedController.m
//  friendJY
//
//  Created by 高斌 on 15/3/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYFeedController.h"
#import "JYOtherProfileController.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYFeedModel.h"
#import "UIImageView+AFNetworking.h"
#import "JYFeedEditController.h"
#import "JYFeedDetailController.h"
#import "JYShareData.h"
#import "NSDictionary+Additions.h"
#import "JYFeedNewsListController.h"
#import "JYFeedPromissionController.h"
#import <AddressBook/AddressBook.h>
#import "JYFeedData.h"
#import "JYProfileController.h"
#import "JYProfileModel.h"
#import "JYFeedTableViewCell.h"

@interface JYFeedController ()

@end

@implementation JYFeedController{
    NSString *lastDynamicId;
    //int recommendPage; //推荐 用户的页码
    NSArray * recommendData; //存放，推荐用户返回数据
    UIScrollView *headUserAvatar;//推荐用户头像ui
    UIView *baseBGView;
    UIView *sendView ;
    UIView *maskView;
    UIImageView * leftTopViewBg;
    UIButton *leftTopViewBgBtn;
    NSString * showSingleOrShowAll; //0-全部，1-单身
    BOOL leftTopSelectLayerIsHide; //左上角，筛选层显示与隐藏 yes-隐藏，no-显示
    //UIView * noFriendInviteBox;//大层的，容器,没有好友时，显的去邀请好友
    NSString * _sendfeedid;
    NSString * _sendoid;
    NSString * myself_uid;
    BOOL isUpList;
    UILabel *tipsContent;
    UIView *newsLayerView;//全局的通顶，信息提示
    UIView *noFriendTipsView; //没有好友时顶弹出的消息提示
    NSInteger currentRowLoad; //滚动一半时自动加载数，只记录最后一次的数
    BOOL isReplyComment;//0是直接发送评论，1为回复某人评论
    
    NSString *_replayDyUid;//回复时动态的uid
    NSString *_replyUid;//回复人的uid
    NSString *_replyDyId;//动态id
    NSString *_replyCommentUid;//评论人的uid
    NSString *_replyCommentId;//评论id
    NSString *_replyNick;//被 回复的昵称
    
    JYEmotionBrowser * emotion;//输入框
    
    UILabel * showAllDynamicLabel;
    UILabel * showSignalOnlyLabel;
    
    UIButton *otisBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"熟人圈"];
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 给用户发私信
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendCommentNotify:) name:kDynamicSendCommentNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendReplyCommentNotify:) name:kDynamicSendReplyCommentNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageClickNotify:) name:kFeedCellClickImageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClickAvatarNotification:) name:kFeedCellClickAvatarNotification object:nil];
    //上传通讯录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upMobileListSuccessNotification:) name:kRegisterAndUpMobileListSuccessNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self dismissProgressHUDtoView:self.view];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDynamicSendCommentNotify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDynamicSendReplyCommentNotify object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFeedCellClickAvatarNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFeedCellClickImageNotification object:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    lastDynamicId = @"0"; //取动态列表的id，从0开始
    leftTopSelectLayerIsHide = YES;
    showSingleOrShowAll = @"0";
    currentRowLoad = 0; //第一次加载，为第5个数据。
    
    myself_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    isUpList = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_IsUpList", myself_uid]];
    
    emotion = [[JYEmotionBrowser alloc] init];
    emotion.delegate = self;
    
    /*第一次进入的时候从数据库读取feedlist的数据*/
    /*
     写在 JYFeedData 的 sharedInstance 里  
     */
    
    
    otisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otisBtn.frame = CGRectMake(60, 100, kScreenWidth-120, 60);
    [otisBtn setBackgroundColor:[UIColor clearColor]];
    [otisBtn addTarget:self action:@selector(_showInviteFriendLayer) forControlEvents:UIControlEventTouchUpInside];
    otisBtn.hidden = YES;
    [self.view addSubview:otisBtn];
    
    UILabel *otis1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth-120, 20)];
    otis1.textAlignment = NSTextAlignmentCenter;
    otis1.font = [UIFont systemFontOfSize:12];
    otis1.textColor = [UIColor grayColor];
    otis1.text = @"您还没有好友，赶快";
    otis1.backgroundColor = [UIColor clearColor];
    [otisBtn addSubview:otis1];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:@"导入通讯录，看看好友在干什么"];
    [attriString addAttribute:NSForegroundColorAttributeName value:[JYHelpers setFontColorWithString:@"#2695ff"] range:NSMakeRange(0, 5)];
    
    UILabel *otis2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth-120, 20)];
    otis2.textAlignment = NSTextAlignmentCenter;
    otis2.font = [UIFont systemFontOfSize:12];
    otis2.textColor =  [UIColor grayColor];
    otis2.backgroundColor = [UIColor clearColor];
    [otis2 setAttributedText:attriString];
    [otisBtn addSubview:otis2];
    
    
    //左上角筛选图标
    UIButton *navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navLeftBtn.backgroundColor = [UIColor clearColor];
    [navLeftBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [navLeftBtn setImage:[UIImage imageNamed:@"feedLeftTopBtn"] forState:UIControlStateNormal];
    [navLeftBtn addTarget:self action:@selector(_clickLeftTopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navLeftBtn]];
    
    //右上角添加动态
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.backgroundColor = [UIColor clearColor];
    [navRightBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [navRightBtn setImage:[UIImage imageNamed:@"feedAddBtn"] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(_clickRightTopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn]];
    
    //初始化table
    [self _initTableView];
    
    //从网络加载动态列表
    [self formHttpGetDynamicList:@"0" isSingle:@"0" upOrDown:0];

    //从网络加载推荐用户列表
    [self _recommendUser];
    

    //当没有好友时，显示好友邀请提示
    if(!isUpList && [([JYShareData sharedInstance].myself_profile_model).callno_upload  isEqualToString:@"0"]){
        [self _initNoFriendDataTips];
        //table要在没有好友提示下面
    }
    
    //初始化消息通知栏
    [self _initNewsLayer];

    //初始化左上角，筛选ui
    [self _initLeftTopView];
    
    
    //刷新table ui
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableListUI:) name:kDynamicListRefreshTableNotify object:nil];
    
    //注册消息推送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushServiceNotification:) name:kPushServiceDealSocketNotification object:nil];
//
    [self performSelector:@selector(gotoSystemSettring) withObject:nil afterDelay:3];
//
    [[JYShareData sharedInstance] setContactsList:[JYHelpers readAllPeoples]];
//    //刷新未读数
    [self _getNewDynamicNumber];
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDynamicListRefreshTableNotify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPushServiceDealSocketNotification object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapHeadViewGesture:(UIGestureRecognizer *)gesture
{
    [self.feedTableView doneLoadingTableViewData];
}

- (void)_clickLeftTopButton{
    if (leftTopSelectLayerIsHide) {
        leftTopViewBgBtn.hidden = NO;
        leftTopSelectLayerIsHide = NO;
        leftTopViewBg.hidden = NO;
        leftTopViewBg.frame = CGRectMake(8, 0, 107, 74);
    }else{
        leftTopViewBgBtn.hidden = YES;
        leftTopSelectLayerIsHide = YES;
        leftTopViewBg.hidden = YES;
        leftTopViewBg.frame = CGRectZero;
    }
    
}

- (void)_clickRightTopButton{
    JYFeedEditController * _editVC = [[JYFeedEditController alloc] init];
    _editVC.formId = 1;
    _editVC.refreshFeedListBlock = ^(JYFeedModel *mFeedModel){
        [[JYFeedData sharedInstance].feedListArr insertObject:mFeedModel atIndex:0];
        self.feedTableView.data = [JYFeedData sharedInstance].feedListArr;
        [self.feedTableView reloadData];
        [[JYAppDelegate sharedAppDelegate] showTip:@"发布成功"];
    };
    [self.navigationController pushViewController:_editVC animated:YES];
}

- (void) _initLeftTopView{
    
    leftTopViewBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftTopViewBgBtn.backgroundColor = [UIColor clearColor];
    leftTopViewBgBtn.frame = self.view.bounds;
    leftTopViewBgBtn.hidden = YES;
    [leftTopViewBgBtn addTarget:self action:@selector(_clickLeftTopButton) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:leftTopViewBgBtn];
    
    leftTopViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 107, 74)];
    leftTopViewBg.image = [UIImage imageNamed:@"feedLeftMenu"];
    leftTopViewBg.hidden = YES;
    leftTopViewBg.userInteractionEnabled = YES;
    [leftTopViewBgBtn addSubview:leftTopViewBg];
    
    showAllDynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 107, 20)];
    showAllDynamicLabel.textAlignment = NSTextAlignmentCenter;
    showAllDynamicLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    showAllDynamicLabel.font = [UIFont systemFontOfSize:14];
    showAllDynamicLabel.text = @"全部";
    showAllDynamicLabel.userInteractionEnabled = YES;
    [leftTopViewBg addSubview:showAllDynamicLabel];
    [showAllDynamicLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dynamicShowAll)]];
    
    showSignalOnlyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, showAllDynamicLabel.bottom+10, 107, 20)];
    showSignalOnlyLabel.textAlignment = NSTextAlignmentCenter;
    showSignalOnlyLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    showSignalOnlyLabel.font = [UIFont systemFontOfSize:14];
    showSignalOnlyLabel.text = @"只显示单身";
    showSignalOnlyLabel.userInteractionEnabled = YES;
    [leftTopViewBg addSubview:showSignalOnlyLabel];
    [showSignalOnlyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dynamicShowSignle)]];
}

- (void)_dynamicShowAll{
    showAllDynamicLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    showSignalOnlyLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    showSingleOrShowAll = @"0";
    [self formHttpGetDynamicList:lastDynamicId isSingle:showSingleOrShowAll upOrDown:0];
    [self.feedTableView setContentOffset:CGPointZero animated:YES];
    [self _clickLeftTopButton];
}

- (void)_dynamicShowSignle{
    showAllDynamicLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    showSignalOnlyLabel.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    showSingleOrShowAll = @"1";
    [self formHttpGetDynamicList:lastDynamicId isSingle:showSingleOrShowAll upOrDown:0];
    [self.feedTableView setContentOffset:CGPointZero animated:YES];
    [self _clickLeftTopButton];
}


//新消息时出现在顶部的通知层
- (void) _initNewsLayer{
    //没有好友的提示信息
    newsLayerView = [[UIView alloc] initWithFrame:CGRectZero];
    newsLayerView.backgroundColor = [JYHelpers setFontColorWithString:@"#fa544f"];
    newsLayerView.hidden = YES;
    newsLayerView.tag = 5000;
    [self.view addSubview:newsLayerView];
    
    tipsContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 20)];
    //noFriendTipsLeft.backgroundColor = [UIColor yellowColor];
    tipsContent.text = @"新消息";
    tipsContent.textColor = [UIColor whiteColor];
    tipsContent.textAlignment = NSTextAlignmentCenter;
    tipsContent.font = [UIFont systemFontOfSize:14];
    [newsLayerView addSubview:tipsContent];
    [newsLayerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_goToNewsList)]];
    
    //删除不显示
    UIButton *newsDelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsDelBtn setFrame:CGRectMake(kScreenWidth - 50, 0, 50, 40)];
    [newsDelBtn addTarget:self action:@selector(newsDelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [newsLayerView addSubview:newsDelBtn];
    UIImageView *btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    btnImage.image = [UIImage imageNamed:@"feedNewsTipsDelete"];
    [newsDelBtn addSubview:btnImage];
}

//当没有好友时，提示没有数据
- (void) _initNoFriendDataTips{
    //没有好友的提示信息
    noFriendTipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    noFriendTipsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noFriendTipsView];
    
    UILabel *noFriendTipsLeft = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth, 20)];
    //noFriendTipsLeft.backgroundColor = [UIColor yellowColor];
    noFriendTipsLeft.text = @"导入通讯录，看看好友在做什么";
    noFriendTipsLeft.font = [UIFont systemFontOfSize:12];
    [noFriendTipsView addSubview:noFriendTipsLeft];
    
    UILabel *noFriendTipsRight = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 10, 40, 20)];
    //noFriendTipsRight.backgroundColor = [UIColor redColor];
    noFriendTipsRight.textAlignment = NSTextAlignmentRight;
    noFriendTipsRight.text = @"邀请";
    noFriendTipsRight.userInteractionEnabled = YES;
    noFriendTipsRight.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    noFriendTipsRight.font = [UIFont systemFontOfSize:12];
    [noFriendTipsView addSubview:noFriendTipsRight];
    [noFriendTipsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_showInviteFriendLayer)]];
    
    self.feedTableView.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight - kNavigationBarHeight -kStatusBarHeight -kTabBarViewHeight-40);

}

//初始化tableview文件
- (void) _initTableView{
    self.feedTableView = [[JYFeedTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.feedTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight -kStatusBarHeight -kTabBarViewHeight);
    //self.feedTableView.rowHeight = 220;
    self.feedTableView.refreshDelegate = self;
    self.feedTableView.data = [JYFeedData sharedInstance].feedListArr;
    self.feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.feedTableView.backgroundColor = [JYHelpers setFontColorWithString:@"#edf1f4"];
    [self.view addSubview:self.feedTableView];
    
    [self _initTableViewHeadViews];
}



// 初始化头视图
- (void)_initTableViewHeadViews
{
    
    //推荐 好友5个
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    headView.backgroundColor = [UIColor clearColor];
    headView.clipsToBounds = YES;
    self.feedTableView.tableHeaderView = headView;
    
    UIView * headViewBg = [[UIView alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-10, 120)];
    headViewBg.backgroundColor = [UIColor whiteColor];
    headViewBg.layer.borderColor = [[JYHelpers setFontColorWithString:@"#e2e5e7"] CGColor];
    headViewBg.layer.borderWidth = 1;
    [headView addSubview:headViewBg];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , 15, 150, 20)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"推荐给你的好友";
    [headViewBg addSubview:titleLabel];
    
    //点击换一批
    /*
    UILabel *changFiveUserClick = [[UILabel alloc] initWithFrame:CGRectMake(headViewBg.right -65 , titleLabel.top, 50, 20)];
    changFiveUserClick.textAlignment = NSTextAlignmentRight;
    changFiveUserClick.userInteractionEnabled = YES;
    changFiveUserClick.backgroundColor = [UIColor clearColor];
    changFiveUserClick.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    changFiveUserClick.font = [UIFont systemFontOfSize:14];
    changFiveUserClick.text = @"换一批";
    [headViewBg addSubview:changFiveUserClick];
    [changFiveUserClick addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_recommendUser)]];
     */
    
    headUserAvatar = [[UIScrollView alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+5, kScreenWidth - 30, 75)];
    headUserAvatar.backgroundColor = [UIColor clearColor];
    headUserAvatar.showsHorizontalScrollIndicator = NO;
    [headViewBg addSubview:headUserAvatar];
    
}

- (void) _showInviteFriendLayer{
    JYGuideIntoAddressBookView *noFriendInviteBox =[[JYGuideIntoAddressBookView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //大层的，容器
    noFriendInviteBox.oitsBtn = otisBtn;
    [[JYAppDelegate sharedAppDelegate].window addSubview:noFriendInviteBox];
}

- (void) _userAvatarClick:(UIGestureRecognizer *)gesture{
    JYOtherProfileController * _profileVC = [[JYOtherProfileController alloc] init];
    _profileVC.show_uid = [NSString stringWithFormat:@"%ld",(long)gesture.view.tag];
    [self.navigationController pushViewController:_profileVC animated:YES];
}



/****
取动态列表
isSingle 是否单身 0-否 1-是
upOrDown 是向上刷新还是向下刷新 0-向下 1-向上
 ***/
- (void) formHttpGetDynamicList:(NSString *) d_id isSingle:(NSString *) isSingle upOrDown:(int) upOrDown{
    
    if (upOrDown == 0) {
        [self showProgressHUD:@"加载中..." toView:self.view];
    }
    
    [[JYFeedData sharedInstance] getFeedList:d_id isSingle:isSingle isUp:upOrDown andFinishBlock:^(BOOL hasMore){
        NSLog(@"--->%@",d_id);
        if (upOrDown == 0) {
            [self dismissProgressHUDtoView:self.view];
        }
        self.feedTableView.data = [JYFeedData sharedInstance].feedListArr;
        currentRowLoad = self.feedTableView.data.count-10;//滚动到一半的判断条件需重置0
        [self.feedTableView reloadData];
        [self.feedTableView doneLoadingTableViewData];
        if (!hasMore) {
            [self.feedTableView setNoMoreData];
        }
        if (self.feedTableView.data.count == 0) {
            [self.feedTableView performSelector:@selector(setNoFriend) withObject:nil afterDelay:0.3];
        }
        
        if(!isUpList && [([JYShareData sharedInstance].myself_profile_model).callno_upload  isEqualToString:@"0"] && self.feedTableView.data.count == 0){
            [self.view bringSubviewToFront:otisBtn];
            otisBtn.hidden = NO;
            //table要在没有好友提示下面
            self.feedTableView.tableFooterView.hidden = YES;
        }else{
            otisBtn.hidden = YES;
            self.feedTableView.tableFooterView.hidden = NO;
        }
        
        
    }andFaileBlock:^{
        [self dismissProgressHUDtoView:self.view];
        
        [self.feedTableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
    }];
}

- (void) cellClickAvatarNotification:(NSNotification *)noti {
    NSString * uid = noti.object;
    JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
    _proVC.show_uid = uid;
    [self.navigationController pushViewController:_proVC animated:YES];
}

//加载推荐的好友
- (void) _recommendUser{

    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"recommend" forKey:@"mod"];
    [parametersDict setObject:@"get_recommend_new_users" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"1" forKey:@"page"];
    [postDict setObject:@"10" forKey:@"pagesize"];

    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        recommendData = [responseObject objectForKey:@"data"];
        if (iRetcode == 1 && [recommendData isKindOfClass:[NSArray class]]) {
            
            if ( recommendData.count > 0) {
                int iGap = (headUserAvatar.frame.size.width*2-52*10)/9;
                [headUserAvatar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i = 0; i<recommendData.count; i++) {
                    NSDictionary * temp = [recommendData objectAtIndex:i];
                    // 头像背景
                    UIImageView *avatarBGImg = [[UIImageView alloc] initWithFrame:CGRectMake((52+iGap)*i, 0, 52, 52)];
                    avatarBGImg.userInteractionEnabled = YES;
                    avatarBGImg.backgroundColor = [UIColor clearColor];
                    avatarBGImg.image = [UIImage imageNamed:@"avatar_bg_150"];
                    [headUserAvatar addSubview:avatarBGImg];
                    
                    // 头像
                    UIImageView *avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 50, 50)];
                    avatarImg.userInteractionEnabled = YES;
                    avatarImg.layer.cornerRadius = 25;
                    avatarImg.layer.borderColor =[[UIColor whiteColor] CGColor];
                    avatarImg.layer.borderWidth = 3;
                    avatarImg.layer.masksToBounds = TRUE;
                    avatarImg.clipsToBounds = YES;
                    avatarImg.tag = [[temp objectForKey:@"uid"] integerValue];
                    avatarImg.backgroundColor = [UIColor clearColor];
                    avatarImg.image = [UIImage imageNamed:@"pic_morentouxiang_man.png"]; //男的默认图标
                    [avatarBGImg addSubview:avatarImg];
                    if ([[temp objectForKey:@"avatar"]  isKindOfClass:[NSDictionary class]]) {
                        [avatarImg setImageWithURL:[NSURL URLWithString:[[temp objectForKey:@"avatar"] objectForKey:@"200"]]];
                    }
                    
                    [avatarImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userAvatarClick:)]];
                    
                    UILabel *userNickLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarBGImg.left , avatarBGImg.bottom+5, 52, 20)];
                    userNickLabel.textAlignment = NSTextAlignmentCenter;
                    userNickLabel.backgroundColor = [UIColor clearColor];
                    userNickLabel.textColor = [JYHelpers setFontColorWithString:@"#303030"];
                    userNickLabel.font = [UIFont systemFontOfSize:10];
                    userNickLabel.text = [temp objectForKey:@"nick"];
                    [headUserAvatar addSubview:userNickLabel];
                }
                int page = 1;
                if (recommendData.count>5) {
                    page = 2;
                }
                headUserAvatar.contentSize = CGSizeMake(page*headUserAvatar.frame.size.width, 55);
                headUserAvatar.pagingEnabled = YES;
                
            }else{
                //没有数据时，高宽设为0
                self.feedTableView.tableHeaderView= nil;
                [self.feedTableView reloadData];
            }
            
        } else {
            //没有数据时，高宽设为0
            self.feedTableView.tableHeaderView=nil;
            [self.feedTableView reloadData];
        }
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        
    }];
}



- (void)JYEmotionTextFieldShouldReturn:(JYEmotionBrowser *)jyEmotion contentText:(NSString *)contentText{
    // 发送私信
    if (contentText.length == 0) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"您没有输入任何内容哦"];
    } else {
        [self _requestSendCommendData:contentText];
    }
}

//单身无好友未上传通讯录事点击图片
- (void)imageClickNotify:(NSNotification *)notify{
    NSString * uid = notify.userInfo[@"uid"];
    if ([uid isEqualToString:myself_uid]) {//区分是不是自己
        JYProfileController *ctrl = [[JYProfileController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else{
        JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
        _proVC.show_uid = uid;
        [self.navigationController pushViewController:_proVC animated:YES];
    }
}

// 发私信
- (void)sendCommentNotify:(NSNotification *)notify
{
    isReplyComment = NO;
    NSDictionary *dic = notify.userInfo;
    _sendoid = dic[@"userId"];
    _sendfeedid = dic[@"feedId"];
    NSString *nick = [NSString stringWithFormat:@"“%@”", dic[@"nickName"]];
    
    
    emotion.showNick = nick;
    [emotion show];
}

// 回复评论
- (void)sendReplyCommentNotify:(NSNotification *)notify
{
    
    isReplyComment = YES;
    NSDictionary *dic = notify.userInfo;
    _replayDyUid = dic[@"dyUid"];
    _replyUid = dic[@"replyUid"];
    _replyDyId =dic[@"dyId"];
    _replyCommentUid = dic[@"commentUid"];
    _replyCommentId = dic[@"commentId"];
    _replyNick = dic[@"nickName"];
    NSString *nick = [NSString stringWithFormat:@"“%@”", _replyNick];
    
    emotion.showNick = nick;
    [emotion show];
}

//提交评论内容到web
- (void)_requestSendCommendData:(NSString *) content{
   // send_comment(对方uid oid, 动态id dy_id, 评论内容 content)
    if (content.length < 1) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"输入的内容太短！请重新输入"];
        return;
    }
    if (isReplyComment) { //直接评论还是回复评论
        [[JYFeedData sharedInstance] sendReplyCommendDataToHttp:_replayDyUid reply_nick:_replyNick reply_uid:_replyUid dy_id:_replyDyId comment_id:_replyCommentId comment_uid:_replyCommentUid content:content];
    }else{
        [[JYFeedData sharedInstance] sendCommendDataToHttp:_sendoid sendFeedId:_sendfeedid content:content];
    }
}





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) pullUp:(JYBaseTableView *)tableView{
    NSLog(@"fuck pull up");
    JYFeedModel *fmodel = [self.feedTableView.data lastObject];
    NSString *fe_id = @"0";
    if (fmodel != nil) {
        fe_id = fmodel.feedid;
    }
    [self formHttpGetDynamicList:fe_id isSingle:showSingleOrShowAll upOrDown:1];
}

- (void) pullDown:(JYBaseTableView *)tableView{
    NSLog(@"fuck pull down");
    [self formHttpGetDynamicList:@"0" isSingle:showSingleOrShowAll upOrDown:0];
}


//点击进入动态详情
- (void)didSelectRowAtIndexPath:(JYBaseTableView *)tabelView indexPath:(NSIndexPath *)indexPath{
    id cell = [self.feedTableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[JYFeedTableViewCell class]]) {
        JYFeedModel * temp = (JYFeedModel *)[self.feedTableView.data objectAtIndex:indexPath.row];
        
        myself_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        isUpList = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_IsUpList", myself_uid]];
        
        //判断是否 单身 未导入通讯录 无好友用户
        if (!isUpList && [[JYShareData sharedInstance].myself_profile_model.marriage intValue] == 1 && [[JYShareData sharedInstance].myself_profile_model.friends_num intValue]==0) {
            //        NSString *myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSString * uid = temp.uid;
            
            JYOtherProfileController * _proVC = [[JYOtherProfileController alloc] init];
            _proVC.show_uid = uid;
            [self.navigationController pushViewController:_proVC animated:YES];
            
            return;
        }
        
        
        JYFeedDetailController * _profileVC = [[JYFeedDetailController alloc] init];
        _profileVC.feedModel = temp;
        [self.navigationController pushViewController:_profileVC animated:YES];
    }
    else{
        JYGuideIntoAddressBookView *noFriendInviteBox =[[JYGuideIntoAddressBookView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        //大层的，容器
        noFriendInviteBox.oitsBtn = otisBtn;
        [[JYAppDelegate sharedAppDelegate].window addSubview:noFriendInviteBox];
    }
}

- (void)refreshTableListUI:(NSNotification *)noti{
   
    self.feedTableView.data = [JYFeedData sharedInstance].feedListArr;
    [self.feedTableView reloadData];
    [self.feedTableView doneLoadingTableViewData]; //数据返回，则收起加载
}

- (void)upMobileListSuccessNotification:(NSNotification *)noti{
    
    NSIndexPath *guideCellPath = [NSIndexPath indexPathForRow:GuideToAddressBookIndexpath5 inSection:0];
    if ([self.feedTableView.data objectAtIndex:GuideToAddressBookIndexpath5] && [self.feedTableView cellForRowAtIndexPath:guideCellPath] && [[self.feedTableView cellForRowAtIndexPath:guideCellPath] isKindOfClass:[JYGuideToAddressBookCell class]]) {
        //收到通知如果有提示cell 才执行
        [self.feedTableView.data removeObjectAtIndex:GuideToAddressBookIndexpath5];
        [self.feedTableView deleteRowsAtIndexPaths:@[guideCellPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    guideCellPath = [NSIndexPath indexPathForRow:GuideToAddressBookIndexpath15 inSection:0];
    if (self.feedTableView.data.count>15) {
        if ([self.feedTableView.data objectAtIndex:GuideToAddressBookIndexpath15] && [self.feedTableView cellForRowAtIndexPath:guideCellPath] && [[self.feedTableView cellForRowAtIndexPath:guideCellPath] isKindOfClass:[JYGuideToAddressBookCell class]]) {
            //收到通知如果有提示cell 才执行
            [self.feedTableView.data removeObjectAtIndex:GuideToAddressBookIndexpath15];
            [self.feedTableView deleteRowsAtIndexPaths:@[guideCellPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    guideCellPath = [NSIndexPath indexPathForRow:GuideToAddressBookIndexpath25 inSection:0];
    if (self.feedTableView.data.count>25) {
        if ([self.feedTableView.data objectAtIndex:GuideToAddressBookIndexpath25] && [self.feedTableView cellForRowAtIndexPath:guideCellPath] && [[self.feedTableView cellForRowAtIndexPath:guideCellPath] isKindOfClass:[JYGuideToAddressBookCell class]]) {
            //收到通知如果有提示cell 才执行
            [self.feedTableView.data removeObjectAtIndex:GuideToAddressBookIndexpath25];
            [self.feedTableView deleteRowsAtIndexPaths:@[guideCellPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    
    [noFriendTipsView removeFromSuperview];
    otisBtn.hidden = YES;
    //table恢复到顶部
    self.feedTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight -kStatusBarHeight -kTabBarViewHeight);
    
    [self _recommendUser];
    [self formHttpGetDynamicList:lastDynamicId isSingle:showSingleOrShowAll upOrDown:1];
}

//当是赞，转播，评论，回复评论时处理
- (void)pushServiceNotification:(NSNotification *)noti{
    NSDictionary *msgDic = noti.userInfo;
    NSUInteger type = [msgDic getIntegerValueForKey:@"cmd" defaultValue:0];
    
    //收到聊天消息
    switch (type) {
        case 311://动态被赞
        case 312://转播你的动态
        case 313://评论了你的动态
        case 314://回复你的评论
        {
            [self _getNewDynamicNumber];
        }
            break;
    }
}

- (void)newsDelBtnClick:(UIButton *)btn{
    newsLayerView.hidden = YES;
    newsLayerView.frame = CGRectZero;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarRedTipShowOrHideNotification object:nil userInfo:@{@"unreadFeedNumber":@"0"}];
}

- (void)_goToNewsList{
    //tabbar，动态右上角显示红点
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarRedTipShowOrHideNotification object:nil userInfo:@{@"unreadFeedNumber":@"0"}];
    
    newsLayerView.hidden = YES;
    newsLayerView.frame = CGRectZero;
    JYFeedNewsListController * _newsListVC = [[JYFeedNewsListController alloc] init];
    [self.navigationController pushViewController:_newsListVC animated:YES];
}

- (void)_getNewDynamicNumber{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"notice" forKey:@"mod"];
    [parametersDict setObject:@"new_dynamic" forKey:@"func"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] intValue] > 0) {
            if ([[responseObject objectForKey:@"data"] intValue] > 0) {
                NSString *context = nil;
                if ([[responseObject objectForKey:@"data"] intValue]>99) {
                    context = @"新消息 99+";
                }else{
                    context = [NSString stringWithFormat:@"新消息 %@", [responseObject objectForKey:@"data"]];
                }
                tipsContent.text = context;
                //返回数据，显示通栏
                newsLayerView.hidden = NO;
                newsLayerView.frame = CGRectMake(0, 0, kScreenWidth, 40);
                
                //tabbar，动态右上角显示红点
                [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarRedTipShowOrHideNotification object:nil userInfo:@{@"unreadFeedNumber":[responseObject objectForKey:@"data"]}];
            }
        }else{
            //[[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
        }
        
        
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        
    }];
}

- (void) didScrollViewDidScroll:(JYBaseTableView *)scrollView{
    
    /*此方法会在异步下载完成tableData数据更新前 可能多次调用*/
    if (self.feedTableView.currentRow == self.feedTableView.data.count - 5 && currentRowLoad == [JYFeedData sharedInstance].feedListArr.count-10) {
        currentRowLoad += 10;
        JYFeedModel *fmodel = [self.feedTableView.data lastObject];
        [self formHttpGetDynamicList:fmodel.feedid isSingle:showSingleOrShowAll upOrDown:1];
    }
}
- (void)didScrollViewDidEndDragging:(JYBaseTableView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //需求： 引导层延迟弹出，当用户浏览滚动一屏后，再弹出。当用户确认开启设置后，自动上传通讯录。引导层每天只弹一次
    //解决 取得授权状态
    ABAuthorizationStatus authStatus =
    ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized){
        //判断滚动过一瓶
        if (scrollView.contentOffset.y > kScreenHeight) {
            
            //判断时间间隔是否大于1天 大于一天提示并更新最后一次提示时间
            //最后提示时间
            NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastOtisDate"];
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastDate];
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastOtisDate"] || interval>24*3600) {
                //需要提示
                
                [self _initNoFriendDataTips];
                
                //更新时间
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastOtisDate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                //时间范围内 不需要提示
                
            }
            NSLog(@"interval---->%f",interval);
        }
    }
}


//去系统设置，开启读电本功能
-(void) gotoSystemSettring{
    //取得授权状态,当没有好友时，显示好友邀请提示
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        JYAddressBookAuthorityView *view = [[JYAddressBookAuthorityView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    }
}

@end
